SET IDENTITY_INSERT [bpst_news].[entities] OFF
SET IDENTITY_INSERT [bpst_news].[Keywords] ON 

INSERT [bpst_news].[Keywords] ([KeyID], [Keyword]) VALUES (2, N'Death Penalty')
INSERT [bpst_news].[Keywords] ([KeyID], [Keyword]) VALUES (4, N'Honor Killing')
SET IDENTITY_INSERT [bpst_news].[Keywords] OFF
SET IDENTITY_INSERT [bpst_news].[MySettings] ON 

INSERT [bpst_news].[MySettings] ([MySettings_ID], [Organization_Name], [AreaOfConcern], [Brand_image_URL], [Keywords], [Synonyms], [NewsInput], [Region], [MarketCode], [LCL], [UCL]) VALUES (1, N'Oxfam International', N'Social Injustice', N'https://www.greenwichmarket.london/assets/ugc/images/_medium/Oxfam_2013.jpg', N'Death Penalty, Honor Killing', N'Executions, Death Row, Life in Prison, Honor Killing, Capital punishment', NULL, N'United States', N'es-US', 0.002, 0.8)
SET IDENTITY_INSERT [bpst_news].[MySettings] OFF
SET IDENTITY_INSERT [bpst_news].[RegionLang] ON 

INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (1, N'Denmark', N'da-DK')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (2, N'Austria', N'de-AT')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (3, N'Switzerland', N'de-CH')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (4, N'Germany', N'de-DE')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (5, N'Australia', N'en-AU')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (6, N'Canada', N'en-CA')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (7, N'United Kingdom', N'en-GB')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (8, N'Indonesia', N'en-ID')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (9, N'Ireland', N'en-IE')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (10, N'India', N'en-IN')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (11, N'Malaysia', N'en-MY')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (12, N'New Zealand', N'en-NZ')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (13, N'Republic of the Philippines', N'en-PH')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (14, N'Singapore', N'en-SG')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (15, N'United States', N'en-US')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (16, N'English', N'en-WW')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (17, N'English', N'en-XA')
GO
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (18, N'South Africa', N'en-ZA')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (19, N'Argentina', N'es-AR')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (20, N'Chile', N'es-CL')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (21, N'Spain', N'es-ES')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (22, N'Mexico', N'es-MX')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (23, N'United States', N'es-US')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (24, N'Spanish', N'es-XL')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (25, N'Finland', N'fi-FI')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (26, N'France', N'fr-BE')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (27, N'Canada', N'fr-CA')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (28, N'Belgium', N'nl-BE')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (29, N'Switzerland', N'fr-CH')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (30, N'France', N'fr-FR')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (31, N'Italy', N'it-IT')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (32, N'Hong Kong SAR', N'zh-HK')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (33, N'Taiwan', N'zh-TW')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (34, N'Japan', N'ja-JP')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (35, N'Korea', N'ko-KR')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (36, N'Netherlands', N'nl-NL')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (37, N'People republic of China', N'zh-CN')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (38, N'Brazil', N'pt-BR')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (39, N'Russia', N'ru-RU')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (40, N'Sweden', N'sv-SE')
INSERT [bpst_news].[RegionLang] ([ID], [Region], [MarketCode]) VALUES (41, N'Turkey', N'tr-TR')
SET IDENTITY_INSERT [bpst_news].[RegionLang] OFF

/****** Object:  StoredProcedure [bpst_news].[sp_mergedata]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [bpst_news].[sp_SynonymsUpdate]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [bpst_news].[sp_SynonymsUpdate] AS
  DECLARE @Synonym VARCHAR(255)  
  SELECT @Synonym = COALESCE(@Synonym + ', ', '') + Syn_Description FROM bpst_news.Synonyms
UPDATE bpst_news.MySettings SET Synonyms = @Synonym;
GO
/****** Object:  StoredProcedure [bpst_news].[sp_write_document]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
/****** Object:  StoredProcedure [bpst_news].[spClearExistingData]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [bpst_news].[spClearExistingData]
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
