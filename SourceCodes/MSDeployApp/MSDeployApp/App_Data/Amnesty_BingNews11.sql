SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_documentkeyphrases_documentid]    Script Date: 20-12-2018 03:08:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_documentkeyphrases_documentid] ON [bpst_news].[documentkeyphrases]
(
	[documentid] ASC
)
INCLUDE ( 	[phrase]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_entityType_Id]    Script Date: 20-12-2018 03:08:29 PM ******/
CREATE NONCLUSTERED INDEX [IX_entityType_Id] ON [bpst_news].[entities]
(
	[entityType_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_typedisplayinformation_entityType]    Script Date: 20-12-2018 03:08:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_typedisplayinformation_entityType] ON [bpst_news].[typedisplayinformation]
(
	[entityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_principal_name]    Script Date: 20-12-2018 03:08:29 PM ******/
ALTER TABLE [dbo].[sysdiagrams] ADD  CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bpst_news].[configuration] ADD  DEFAULT ((0)) FOR [visible]
GO
/****** Object:  StoredProcedure [bpst_news].[sp_clean_stage_tables]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [bpst_news].[sp_create_topic_key_phrase]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [bpst_news].[sp_get_prior_content]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [bpst_news].[sp_get_pull_status]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [bpst_news].[sp_get_replication_counts]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [bpst_news].[sp_KeywordsUpdate]    Script Date: 20-12-2018 03:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [bpst_news].[sp_KeywordsUpdate] AS
  DECLARE @Keyword VARCHAR(255)  
  SELECT @Keyword = COALESCE(@Keyword + ', ', '') + Keyword FROM bpst_news.Keywords
UPDATE bpst_news.MySettings SET Keywords = @Keyword;
GO
