SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_documentkeyphrases_documentid] ******/
CREATE NONCLUSTERED INDEX [idx_documentkeyphrases_documentid] ON [bpst_news].[documentkeyphrases]
(
	[documentid] ASC
)
INCLUDE ( 	[phrase]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_entityType_Id] ******/
CREATE NONCLUSTERED INDEX [IX_entityType_Id] ON [bpst_news].[entities]
(
	[entityType_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_typedisplayinformation_entityType] ******/
CREATE NONCLUSTERED INDEX [idx_typedisplayinformation_entityType] ON [bpst_news].[typedisplayinformation]
(
	[entityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [UK_principal_name] ******/
ALTER TABLE [dbo].[sysdiagrams] ADD  CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [bpst_news].[configuration] ADD  DEFAULT ((0)) FOR [visible]
GO

/****** Object:  StoredProcedure [bpst_news].[sp_clean_stage_tables] ******/
-- Description:	Truncates all batch process tables so batch processes can be run
CREATE PROCEDURE  [bpst_news].[sp_clean_stage_tables]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- These tables are populated by AzureML batch processes.
    TRUNCATE TABLE bpst_news.stg_entities;
    TRUNCATE TABLE bpst_news.stg_documenttopics;
    TRUNCATE TABLE bpst_news.stg_documenttopicimages;
    TRUNCATE TABLE bpst_news.stg_documentcompressedentities;
END;
GO

/****** Object:  StoredProcedure [bpst_news].[sp_create_topic_key_phrase] ******/
CREATE PROCEDURE  [bpst_news].[sp_create_topic_key_phrase]
AS
BEGIN
/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @KeyPhraseFrequency TABLE
(
	documentId CHAR(64),
	phrase VARCHAR(2000),
	phraseFrequency INT
);

-- Compute Document Key Phrase Frequency
INSERT @KeyPhraseFrequency
select 
	documentId,
	phrase,
	(totalLength - textWithoutPhrase) / phraseLength AS phraseFrequency
FROM 
(
	SELECT [documentId]
      ,[phrase]
	  ,len(convert(VARCHAR(MAX), t1.cleanedText)) totalLength
	  ,len(replace(convert(VARCHAR(MAX), t1.cleanedText), LEFT(phrase, 1000), '')) textWithoutPhrase
	  ,len(t0.phrase) phraseLength
	FROM bpst_news.documentkeyphrases t0
	INNER JOIN bpst_news.documents t1 ON t0.documentId = t1.id
) innerTable
WHERE phraseLength != 0;

-- Compute the score for each phrase.  Score = documentDistance * phraseFrequency
-- Sum each unique topic/phrase combination to get the total score for each phrase within a topic
DECLARE @DocumentTopicPhraseScore TABLE
(
	topicId INT,
	phrase VARCHAR(2000),
	phraseScore FLOAT
);

INSERT @DocumentTopicPhraseScore
SELECT topicId, phrase, SUM(phraseScore) AS PhraseScore FROM
(
	SELECT topicId, phrase, documentDistance * phraseFrequency AS phraseScore
	FROM bpst_news.documenttopics t0
	INNER JOIN @KeyPhraseFrequency t1 ON t0.documentId = t1.documentId
) t1
GROUP BY topicId, phrase

-- Drop the table if it exists
IF object_id(N'bpst_news.topickeyphrases', 'U') IS NOT NULL
	DROP TABLE bpst_news.topickeyphrases

-- Compute the final key phrase as the top three document key phrases
SELECT topicId, CONCAT([1], COALESCE(', ' + [2], ''), COALESCE(', ' + [3], '')) KeyPhrase
INTO bpst_news.topickeyphrases
FROM
(
	SELECT topicId, phrase, [rank] FROM
	(
		SELECT topicId, phrase, ROW_NUMBER() OVER (PARTITION BY topicId ORDER BY phraseScore DESC) [Rank]
		FROM @DocumentTopicPhraseScore
	) t0 WHERE [Rank] <= 3
) t1
PIVOT
(
	MAX(phrase) FOR [Rank] IN ([1], [2], [3])
) AS PivotTable

END;
GO

/****** Object:  StoredProcedure [bpst_news].[sp_get_prior_content] ******/
CREATE PROCEDURE [bpst_news].[sp_get_prior_content] AS
BEGIN
    SET NOCOUNT ON;

    SELECT Count(*) AS ExistingObjectCount
    FROM   INFORMATION_SCHEMA.TABLES
    WHERE  ( table_schema = 'bpst_news' AND
             table_name IN ('configuration', 'date', 'documents', 'documentpublishedtimes', 'documentingestedtimes', 'documentkeyphrases', 'documentsentimentscores', 'documenttopics', 'documenttopicimages', 'entities', 'stg_documenttopics', 'stg_documenttopicimages', 'stg_entities')
           );
END;
GO

/****** Object:  StoredProcedure [bpst_news].[sp_get_pull_status] ******/
CREATE PROCEDURE [bpst_news].[sp_get_pull_status]
AS
BEGIN
		
	--InitialPullComplete statuses
	-- -1 -> Initial State
	-- 1 -> Data is present but not complete (Not applicable for twitter - declare success when we see one tweet)
	-- 2 -> Data pull is complete
	-- 3 -> No data is present
	DECLARE @StatusCode int;
	SET @StatusCode = -1;
	SET NOCOUNT ON;
	DECLARE @DeploymentTimestamp datetime2;
	SET @DeploymentTimestamp = CAST((SELECT [value] from bpst_news.[configuration] config
								WHERE config.configuration_group = 'SolutionTemplate' AND config.configuration_subgroup = 'Notifier' AND config.[name] = 'DeploymentTimestamp') AS datetime2)
	DECLARE @NumberOfArticles int;
	SET @NumberOfArticles = (SELECT COUNT(*) AS [Count]
				   FROM bpst_news.documenttopics)
			
	IF (@NumberOfArticles > 0 )
		SET @StatusCode = 2 --Data pull is complete
	
	
	IF (@NumberOfArticles = 0  AND DATEDIFF(HOUR, @DeploymentTimestamp, CURRENT_TIMESTAMP) > 24)
	SET @StatusCode = 3 --No data is present
	
	DECLARE @ASDeployment bit;	 
	SET @ASDeployment = 0;
	IF EXISTS (SELECT * FROM bpst_news.[configuration] 
			   WHERE [configuration].configuration_group = 'SolutionTemplate' AND 
					 [configuration].configuration_subgroup = 'Notifier' AND 
					 [configuration].[name] = 'ASDeployment' AND
					 [configuration].[value] ='true')
	SET @ASDeployment = 1;
	UPDATE bpst_news.[configuration] 
	SET [configuration].[value] = @StatusCode
	WHERE [configuration].configuration_group = 'SolutionTemplate' AND [configuration].configuration_subgroup = 'Notifier' AND [configuration].[name] = 'DataPullStatus'
END;
GO

/****** Object:  StoredProcedure [bpst_news].[sp_get_replication_counts] ******/
CREATE PROCEDURE [bpst_news].[sp_get_replication_counts] AS
BEGIN
    SET NOCOUNT ON;

    SELECT UPPER(LEFT(ta.name, 1)) + LOWER(SUBSTRING(ta.name, 2, 100)) AS EntityName, SUM(pa.[rows]) AS [Count]
    FROM sys.tables ta INNER JOIN sys.partitions pa ON pa.[OBJECT_ID] = ta.[OBJECT_ID]
                        INNER JOIN sys.schemas sc ON ta.[schema_id] = sc.[schema_id]
    WHERE
        sc.name='bpst_news' AND ta.is_ms_shipped = 0 AND pa.index_id IN (0,1) AND
        ta.name IN ('documents', 'documentpublishedtimes', 'documentingestedtimes', 'documentkeyphrases','documentsentimentscores', 'documenttopics', 'documenttopicimages', 'entities')
    GROUP BY ta.name
END;
GO

/****** Object:  StoredProcedure [bpst_news].[sp_KeywordsUpdate] ******/
CREATE PROC [bpst_news].[sp_KeywordsUpdate] AS
  DECLARE @Keyword VARCHAR(255)  
  SELECT @Keyword = COALESCE(@Keyword + ', ', '') + Keyword FROM bpst_news.Keywords
UPDATE bpst_news.MySettings SET Keywords = @Keyword;
GO

CREATE PROCEDURE  [bpst_news].[sp_mergedata]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    TRUNCATE TABLE bpst_news.entities;
    INSERT INTO bpst_news.entities WITH (TABLOCK) 
	(documentId, entityType, entityValue, offset, offsetDocumentPercentage, [length], entityType_id)
        SELECT documentId, 
		entityType, 
		entityValue,
		 offset, 
		 offsetDocumentPercentage, 
		 [length] ,
		 Case 
			WHEN entityType = 'PER' THEN 1
			WHEN entityType = 'LOC'  then 2
			WHEN entityType = 'ORG' THen 3
			WHEN entityType = 'Title' THen 4
			
			WHEN entityType = 'Person' THEN 5
			WHEN entityType = 'Location'  then 6
			WHEN entityType = 'Organization' THen 7
			WHEN entityType = 'TIL' THen 8

		END entityType_id
		 FROM bpst_news.stg_entities;

    TRUNCATE TABLE bpst_news.documenttopics;
    INSERT INTO bpst_news.documenttopics WITH (TABLOCK) (documentId, topicId, batchId, documentDistance, topicScore, topicKeyPhrase)
        SELECT documentId, topicId, batchId, documentDistance, topicScore, topicKeyPhrase FROM bpst_news.stg_documenttopics;

    TRUNCATE TABLE bpst_news.documenttopicimages;
    INSERT INTO bpst_news.documenttopicimages WITH (TABLOCK) (topicId, imageUrl1, imageUrl2, imageUrl3, imageUrl4)
        SELECT topicId, imageUrl1, imageUrl2, imageUrl3, imageUrl4 FROM bpst_news.stg_documenttopicimages;
END;
GO

/****** Object:  StoredProcedure [bpst_news].[sp_SynonymsUpdate] ******/
CREATE PROC [bpst_news].[sp_SynonymsUpdate] AS
  DECLARE @Synonym VARCHAR(255)  
  SELECT @Synonym = COALESCE(@Synonym + ', ', '') + Syn_Description FROM bpst_news.Synonyms
UPDATE bpst_news.MySettings SET Synonyms = @Synonym;
GO
/****** Object:  StoredProcedure [bpst_news].[sp_write_document] ******/
CREATE PROCEDURE [bpst_news].[sp_write_document]
	-- Document parameters
	@docid NCHAR(64),
	@text NVARCHAR(max) NULL,
	@textLength INT NULL,
	@cleanedText NVARCHAR(max) NULL,
	@cleanedTextLength int NULL,
	@title NVARCHAR(2000) NULL,
	@sourceUrl NVARCHAR(2000) NULL,
	@sourceDomain NVARCHAR(1000) NULL,
	@category NVARCHAR(150) NULL,
	@imageUrl NVARCHAR(max) = NULL,
	@imageWidth INT = NULL,
	@imageHeight INT = NULL,
	@abstract NVARCHAR(4000) NULL,

	-- Published Timestamp
	@publishedTimestamp datetime,
	@publishedMonthPrecision datetime,
	@publishedWeekPrecision datetime,
	@publishedDayPrecision datetime,
	@publishedHourPrecision datetime,
	@publishedMinutePrecision datetime,

	-- Ingest Timestamp
	@ingestTimestamp NVARCHAR(100),

	@ingestMonthPrecision datetime,
	@ingestWeekPrecision datetime,
	@ingestDayPrecision datetime,
	@ingestHourPrecision datetime,
	@ingestMinutePrecision datetime,

	-- Sentiment
	@sentimentScore float,

	-- Key Phrases
	@keyPhraseJson NVARCHAR(max),

	-- User Defined Entities
	@userDefinedEntities NVARCHAR(max)
AS
BEGIN

	DECLARE @tmp DATETIME
     SET @tmp = GETDATE()

	 Set @ingestTimestamp  = @tmp;


	set @ingestMonthPrecision = @tmp;
	Set @ingestWeekPrecision = @tmp;
	Set @ingestDayPrecision = @tmp;
	Set @ingestHourPrecision = @tmp;
	Set @ingestMinutePrecision = @tmp;
	DECLARE @list varchar(8000)
	DECLARE @pos INT
	DECLARE @len INT
	DECLARE @value varchar(8000)
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Set XACT_ABORT to roll back any open transactions for most errors
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRANSACTION

	BEGIN TRY

		DELETE FROM [bpst_news].[documents] WHERE id = @docid;
		INSERT INTO [bpst_news].[documents] 
		( id, text, textLength,	cleanedText, cleanedTextLength, abstract, title, sourceUrl, sourceDomain, category, imageUrl, imageWidth, imageHeight )
		VALUES
		( @docid, @text, @textLength, @cleanedText, @cleanedTextLength, @abstract, @title, @sourceUrl, @sourceDomain, @category, @imageUrl, @imageWidth, @imageHeight );

		DELETE FROM [bpst_news].[documentpublishedtimes] WHERE id = @docid;
		INSERT INTO [bpst_news].[documentpublishedtimes]
		( id, "timestamp", monthPrecision, weekPrecision, dayPrecision, hourPrecision, minutePrecision )
		VALUES
		( @docId, @publishedTimestamp, @publishedMonthPrecision, @publishedWeekPrecision, @publishedDayPrecision, @publishedHourPrecision, @publishedMinutePrecision );

		DELETE FROM [bpst_news].[documentingestedtimes] WHERE id = @docid;
		INSERT INTO [bpst_news].[documentingestedtimes]
		( id, "timestamp", monthPrecision, weekPrecision, dayPrecision, hourPrecision, minutePrecision )
		VALUES
		( @docId, CONVERT(DATETIME, left(@ingestTimestamp,23)), @ingestMonthPrecision, @ingestWeekPrecision, @ingestDayPrecision, @ingestHourPrecision, @ingestMinutePrecision );

		
		Declare @LCL float;
		Declare @UCL float;

		SELECT @LCL = LCL, @UCL = UCL,@list = Keywords from [bpst_news].MySettings order by MySettings_ID Asc;
		
		if(@sentimentScore >= @LCL and @sentimentScore <= @UCL)
		BEGIN
		  DELETE FROM [bpst_news].[documentsentimentscores] WHERE id = @docid;
		  INSERT INTO [bpst_news].[documentsentimentscores] (id, score) VALUES ( @docid, @sentimentScore );
		END

		DELETE FROM [bpst_news].[documentkeyphrases] WHERE documentId = @docid;

		INSERT INTO [bpst_news].[documentkeyphrases] (documentId, phrase)
		SELECT @docid AS documentId, value AS phrase
		FROM OPENJSON(@keyPhraseJson);


		set @pos = 0
		set @len = 0
		SET @list = @list + ',';
		WHILE CHARINDEX(',', @list, @pos+1)>0
		BEGIN
			set @len = CHARINDEX(',', @list, @pos+1) - @pos
			set @value = SUBSTRING(@list, @pos, @len)
            
			   
			if CHARINDEX(@value,@title) > 0
			BEGIN
				DELETE FROM [bpst_news].[documentsearchterms] WHERE documentId = @docid;
				insert into  [bpst_news].[documentsearchterms](documentId,searchterms) 
				select @docid,@value;
			END
			--DO YOUR MAGIC HERE

		   set @pos = CHARINDEX(',', @list, @pos+@len) +1
		END


		DELETE FROM [bpst_news].[userdefinedentities] WHERE documentId = @docid;
		INSERT INTO [bpst_news].[userdefinedentities] (documentId, entityType, entityValue, offset, offsetDocumentPercentage, [length])
		SELECT @docid AS documentId, *
		FROM OPENJSON(@userDefinedEntities)
		WITH (
			entityType nvarchar(30) '$.type',
		    entityValue nvarchar(max) '$.value',
			offset int '$.position',
			offsetDocumentPercentage float '$.positionDocumentPercentage',
			[length] int '$.lengthInText'
		)

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		DECLARE @msg nvarchar(2048) = error_message()
		RAISERROR (@msg, 16, 1)
	END CATCH
END;
GO

/****** Object:  StoredProcedure [bpst_news].[spClearExistingData] ******/
CREATE PROCEDURE [bpst_news].[spClearExistingData]
AS
BEGIN
	TRUNCATE TABLE bpst_news.documents;
	TRUNCATE TABLE bpst_news.documentpublishedtimes;
	TRUNCATE TABLE bpst_news.documentkeyphrases;
	TRUNCATE TABLE bpst_news.documentingestedtimes;
	TRUNCATE TABLE bpst_news.documentsearchterms;
	TRUNCATE TABLE bpst_news.documentsentimentscores;
	TRUNCATE TABLE bpst_news.documenttopicimages;
	TRUNCATE TABLE bpst_news.documenttopics;
	TRUNCATE TABLE bpst_news.entities;
	TRUNCATE TABLE bpst_news.topickeyphrases;

    TRUNCATE TABLE bpst_news.stg_entities;
    TRUNCATE TABLE bpst_news.stg_documenttopics;
    TRUNCATE TABLE bpst_news.stg_documenttopicimages;
    TRUNCATE TABLE bpst_news.stg_documentcompressedentities;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_alterdiagram] ******/
	CREATE PROCEDURE [dbo].[sp_alterdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO

/****** Object:  StoredProcedure [dbo].[sp_creatediagram] ******/
	CREATE PROCEDURE [dbo].[sp_creatediagram]
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO

/****** Object:  StoredProcedure [dbo].[sp_dropdiagram] ******/
	CREATE PROCEDURE [dbo].[sp_dropdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO

/****** Object:  StoredProcedure [dbo].[sp_helpdiagramdefinition] ******/
	CREATE PROCEDURE [dbo].[sp_helpdiagramdefinition]
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO

/****** Object:  StoredProcedure [dbo].[sp_helpdiagrams] ******/
	CREATE PROCEDURE [dbo].[sp_helpdiagrams]
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO

/****** Object:  StoredProcedure [dbo].[sp_renamediagram] ******/
	CREATE PROCEDURE [dbo].[sp_renamediagram]
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO

/****** Object:  StoredProcedure [dbo].[sp_upgraddiagrams] ******/
	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO

/****** Object:  StoredProcedure [bpst_news].[sp_write_document] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [bpst_news].[sp_write_document]
	-- Document parameters
	@docid NCHAR(64),
	@text NVARCHAR(max) NULL,
	@textLength INT NULL,
	@cleanedText NVARCHAR(max) NULL,
	@cleanedTextLength int NULL,
	@title NVARCHAR(2000) NULL,
	@sourceUrl NVARCHAR(2000) NULL,
	@sourceDomain NVARCHAR(1000) NULL,
	@category NVARCHAR(150) NULL,
	@imageUrl NVARCHAR(max) = NULL,
	@imageWidth INT = NULL,
	@imageHeight INT = NULL,
	@abstract NVARCHAR(4000) NULL,

	-- Published Timestamp
	@publishedTimestamp datetime,
	@publishedMonthPrecision datetime,
	@publishedWeekPrecision datetime,
	@publishedDayPrecision datetime,
	@publishedHourPrecision datetime,
	@publishedMinutePrecision datetime,

	-- Ingest Timestamp

	@ingestTimestamp NVARCHAR(100),

	@ingestMonthPrecision datetime,
	@ingestWeekPrecision datetime,
	@ingestDayPrecision datetime,
	@ingestHourPrecision datetime,
	@ingestMinutePrecision datetime,

	-- Sentiment
	@sentimentScore float,

	-- Key Phrases
	@keyPhraseJson NVARCHAR(max),

	-- User Defined Entities
	@userDefinedEntities NVARCHAR(max)
AS
BEGIN

	DECLARE @tmp DATETIME
     SET @tmp = GETDATE()

	 Set @ingestTimestamp  = @tmp;


	set @ingestMonthPrecision = @tmp;
	Set @ingestWeekPrecision = @tmp;
	Set @ingestDayPrecision = @tmp;
	Set @ingestHourPrecision = @tmp;
	Set @ingestMinutePrecision = @tmp;
	DECLARE @list varchar(8000)
	DECLARE @pos INT
	DECLARE @len INT
	DECLARE @value varchar(8000)
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Set XACT_ABORT to roll back any open transactions for most errors
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRANSACTION

	BEGIN TRY
		DELETE FROM [bpst_news].[documents] WHERE id = @docid;

		INSERT INTO [bpst_news].[documents] 
		( id, text, textLength,	cleanedText, cleanedTextLength, abstract, title, sourceUrl, sourceDomain, category, imageUrl, imageWidth, imageHeight )
		VALUES
		( @docid, @text, @textLength, @cleanedText, @cleanedTextLength, @abstract, @title, @sourceUrl, @sourceDomain, @category, @imageUrl, @imageWidth, @imageHeight );

		DELETE FROM [bpst_news].[documentpublishedtimes] WHERE id = @docid;
		INSERT INTO [bpst_news].[documentpublishedtimes]
		( id, "timestamp", monthPrecision, weekPrecision, dayPrecision, hourPrecision, minutePrecision )
		VALUES
		( @docId, @publishedTimestamp, @publishedMonthPrecision, @publishedWeekPrecision, @publishedDayPrecision, @publishedHourPrecision, @publishedMinutePrecision );

		DELETE FROM [bpst_news].[documentingestedtimes] WHERE id = @docid;
		INSERT INTO [bpst_news].[documentingestedtimes]
		( id, "timestamp", monthPrecision, weekPrecision, dayPrecision, hourPrecision, minutePrecision )
		VALUES
		( @docId, CONVERT(DATETIME, left(@ingestTimestamp,23)), @ingestMonthPrecision, @ingestWeekPrecision, @ingestDayPrecision, @ingestHourPrecision, @ingestMinutePrecision );

		
		Declare @LCL float;
		Declare @UCL float;

		SELECT @LCL = LCL, @UCL = UCL,@list = Keywords from [bpst_news].MySettings order by MySettings_ID Asc;
		
		if(@sentimentScore >= @LCL and @sentimentScore <= @UCL)
		BEGIN
		  DELETE FROM [bpst_news].[documentsentimentscores] WHERE id = @docid;
		  INSERT INTO [bpst_news].[documentsentimentscores] (id, score) VALUES ( @docid, @sentimentScore );
		END

		DELETE FROM [bpst_news].[documentkeyphrases] WHERE documentId = @docid;

		INSERT INTO [bpst_news].[documentkeyphrases] (documentId, phrase)
		SELECT @docid AS documentId, @keyPhraseJson AS phrase
		--FROM OPENJSON(@keyPhraseJson);


		set @pos = 0
		set @len = 0
		SET @list = @list + ',';
		WHILE CHARINDEX(',', @list, @pos+1)>0
		BEGIN
			set @len = CHARINDEX(',', @list, @pos+1) - @pos
			set @value = SUBSTRING(@list, @pos, @len)
            
			   
			if CHARINDEX(@value,@title) > 0
			BEGIN
				DELETE FROM [bpst_news].[documentsearchterms] WHERE documentId = @docid;
				insert into  [bpst_news].[documentsearchterms](documentId,searchterms) 
				select @docid,@value;
			END
			--DO YOUR MAGIC HERE

		   set @pos = CHARINDEX(',', @list, @pos+@len) +1
		END


		DELETE FROM [bpst_news].[userdefinedentities] WHERE documentId = @docid;
		INSERT INTO [bpst_news].[userdefinedentities] (documentId, entityType, entityValue, offset, offsetDocumentPercentage, [length])
		SELECT @docid AS documentId, *
		FROM OPENJSON(@userDefinedEntities)
		WITH (
			entityType nvarchar(30) '$.type',
		    entityValue nvarchar(max) '$.value',
			offset int '$.position',
			offsetDocumentPercentage float '$.positionDocumentPercentage',
			[length] int '$.lengthInText'
		)

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		DECLARE @msg nvarchar(2048) = error_message()
		RAISERROR (@msg, 16, 1)
	END CATCH
END;