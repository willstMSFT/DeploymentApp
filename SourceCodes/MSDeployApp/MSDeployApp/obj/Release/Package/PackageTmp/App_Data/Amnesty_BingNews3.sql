SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_FullDocumentTopics]
AS
    SELECT documenttopics.documentId					AS [Document Id],
           documenttopics.topicId						AS [Topic Id],
           documenttopics.batchId						AS [Batch Id],
           documenttopics.documentDistance				AS [Document Distance],
           documenttopics.topicScore					AS [Topic Score],
           documenttopics.topicKeyPhrase				AS [Topic Key Phrase],
           documenttopicimages.imageUrl1				AS [Image URL 1],
           documenttopicimages.imageUrl2				AS [Image URL 2],
           documenttopicimages.imageUrl3				AS [Image URL 3],
           documenttopicimages.imageUrl4				AS [Image URL 4],
           ((1-DocumentTopics.documentDistance)*100)	AS [Weight],
		   CASE
		      WHEN documents.imageUrl = documenttopicimages.imageUrl1 THEN 0.0001
		      WHEN documents.imageUrl = documenttopicimages.imageUrl2 THEN 0.0002
		      WHEN documents.imageUrl = documenttopicimages.imageUrl3 THEN 0.0003
		      WHEN documents.imageUrl = documenttopicimages.imageUrl4 THEN 0.0004
			  ELSE documenttopics.documentDistance
		   END AS [Document Distance With Topic Image]
    FROM   bpst_news.documenttopics
    LEFT OUTER JOIN documenttopicimages	ON documenttopics.topicid = documenttopicimages.topicid
    INNER JOIN bpst_news.documents documents ON documenttopics.documentid = documents.id;
GO
/****** Object:  Table [bpst_news].[entities]    Script Date: 20-12-2018 03:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[entities](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[documentId] [nchar](64) NOT NULL,
	[entityType] [nvarchar](30) NOT NULL,
	[entityValue] [nvarchar](max) NULL,
	[offset] [int] NOT NULL,
	[offsetDocumentPercentage] [float] NOT NULL,
	[length] [int] NOT NULL,
	[entityType_id] [int] NULL,
	[entityType_id1] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[userdefinedentities]    Script Date: 20-12-2018 03:06:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[userdefinedentities](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[documentId] [nchar](64) NOT NULL,
	[entityType] [nvarchar](30) NOT NULL,
	[entityValue] [nvarchar](max) NULL,
	[offset] [int] NOT NULL,
	[offsetDocumentPercentage] [float] NOT NULL,
	[length] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[typedisplayinformation]    Script Date: 20-12-2018 03:06:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[typedisplayinformation](
	[entityType] [nvarchar](30) NOT NULL,
	[icon] [nvarchar](30) NOT NULL,
	[color] [nvarchar](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [bpst_news].[vw_FullEntities]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [bpst_news].[vw_FullEntities]
AS
SELECT        documentId AS [Document Id], entityType AS [Entity Type], entityValue AS [Entity Value], 
			 offset AS [Offset], offsetDocumentPercentage AS [Offset Document Percentage], 
			 [length] AS [Lenth], 
			 entityType + entityValue AS [Entity Id], 
             CASE WHEN entityType_id = 8 THEN 'fa fa-certificate' 
			 WHEN entityType_id = 4 THEN 'fa fa-certificate'
			 WHEN entityType_id = 1 THEN 'fa fa-male' 
			  WHEN entityType_id = 5 THEN 'fa fa-male'
			  WHEN entityType_id = 3 THEN 'fa fa-sitemap' 
			  WHEN entityType_id = 7 THEN 'fa fa-sitemap' 
			  WHEN entityType_id = 2 THEN 'fa fa-globe' 
			  WHEN entityType_id = 6 THEN 'fa fa-globe'
			   ELSE NULL END [Entity Class], 
              
			  CASE WHEN entityType_id = 8 THEN '#FFFFFF'
			   WHEN entityType_id = 4 THEN '#FFFFFF'
			    WHEN entityType_id = 1 THEN '#1BBB6A' 
				WHEN entityType_id = 5 THEN '#1BBB6A' 
				WHEN entityType_id = 3 THEN '#FF001F' 
				WHEN entityType_id = 7 THEN '#FF001F'
				WHEN entityType_id = 2 THEN '#FF8000' 
				WHEN entityType_id = 6 THEN '#FF8000' 
				ELSE NULL END [Entity Color]
FROM            bpst_news.entities

	
UNION ALL
SELECT        [entities].documentId AS [Document Id], [entities].entityType AS [Entity Type], [entities].entityValue AS [Entity Value], [entities].offset AS [Offset], [entities].offsetDocumentPercentage AS [Offset Document Percentage], 
                         [entities].[length] AS [Lenth], [entities].entityType + [entities].entityValue AS [Entity Id], [types].icon AS [Entity Class], [types].color AS [Entity Color]
FROM            bpst_news.userdefinedentities AS entities INNER JOIN
                         bpst_news.typedisplayinformation AS [types] ON [entities].entityType = [types].entityType;
GO
/****** Object:  View [bpst_news].[vw_EntityRankings]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_EntityRankings] AS
    WITH DocCounts AS
    (
        SELECT  count(DISTINCT documentId)	AS [Document Count],
                entityType					AS [Entity Type],
                entityValue					AS [Entity Value]
        FROM bpst_news.Entities
        GROUP BY entityType, entityValue
    )
    SELECT ROW_NUMBER() OVER
        (PARTITION BY [Entity Type] ORDER BY [Document Count] DESC) AS [Entity Value Rank],
        [Entity Type] + [Entity Value]								AS [Entity Id],
        [Entity Type],
        [Entity Value],
        [Document Count]
    FROM DocCounts;
GO
/****** Object:  Table [bpst_news].[documentkeyphrases]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documentkeyphrases](
	[documentid] [nchar](64) NOT NULL,
	[phrase] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [bpst_news].[vw_DocumentKeyPhrases]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_DocumentKeyPhrases]
AS
    SELECT documentid			AS [Document Id],
           phrase				AS [Phrase]
    FROM bpst_news.documentkeyphrases;
GO
/****** Object:  View [bpst_news].[vw_DocumentSentimentScores]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_DocumentSentimentScores]
AS
    SELECT id		AS [Id],
           score	AS [Score]
    FROM bpst_news.documentsentimentscores;
GO
/****** Object:  View [bpst_news].[vw_DocumentCompressedEntities]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_DocumentCompressedEntities]
as
	SELECT [id] AS [Document Id],
	COALESCE((
		SELECT TOP 160 [Entity Type] AS entityType
			,[Entity Value] AS entityValue
			,[Offset] AS offset
			,[Offset Document Percentage] AS offsetPercentage
			,[Lenth] AS [length]
			,[Entity Id] AS [entityId]
			,[Entity Class] AS [cssClass]
			,[Entity Color] AS [cssColor]
		FROM [bpst_news].[vw_FullEntities]
		where [document id] = docs.id
		FOR JSON AUTO
	), '[]') AS [Compressed Entities Json] FROM
	bpst_news.documents AS docs;
GO
/****** Object:  Table [bpst_news].[topickeyphrases]    Script Date: 20-12-2018 03:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[topickeyphrases](
	[topicId] [int] NULL,
	[KeyPhrase] [varchar](6004) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [bpst_news].[vw_TopicKeyPhrases]    Script Date: 20-12-2018 03:06:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_TopicKeyPhrases]
AS
	SELECT topicId			AS [Topic Id],
           KeyPhrase		AS [Key Phrase]
	FROM   bpst_news.topickeyphrases;
GO
/****** Object:  Table [bpst_news].[Keywords]    Script Date: 20-12-2018 03:06:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[Keywords](
	[KeyID] [int] IDENTITY(1,1) NOT NULL,
	[Keyword] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[KeyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[MySettings]    Script Date: 20-12-2018 03:06:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[MySettings](
	[MySettings_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organization_Name] [varchar](50) NULL,
	[AreaOfConcern] [varchar](255) NULL,
	[Brand_image_URL] [varchar](255) NULL,
	[Keywords] [varchar](255) NULL,
	[Synonyms] [varchar](255) NULL,
	[NewsInput] [varchar](255) NULL,
	[Region] [varchar](100) NULL,
	[MarketCode] [varchar](10) NULL,
	[LCL] [float] NULL,
	[UCL] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[MySettings_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[RegionLang]    Script Date: 20-12-2018 03:06:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[RegionLang](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Region] [varchar](255) NULL,
	[MarketCode] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[stg_documentcompressedentities]    Script Date: 20-12-2018 03:06:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[stg_documentcompressedentities](
	[documentId] [nchar](64) NOT NULL,
	[compressedEntitiesJson] [nvarchar](max) NULL,
 CONSTRAINT [pk_documentcompressedentities] PRIMARY KEY CLUSTERED 
(
	[documentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[stg_documenttopicimages]    Script Date: 20-12-2018 03:06:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[stg_documenttopicimages](
	[topicId] [nchar](36) NOT NULL,
	[imageUrl1] [nvarchar](max) NULL,
	[imageUrl2] [nvarchar](max) NULL,
	[imageUrl3] [nvarchar](max) NULL,
	[imageUrl4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[stg_documenttopics]    Script Date: 20-12-2018 03:06:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[stg_documenttopics](
	[documentId] [nchar](64) NOT NULL,
	[topicId] [nchar](36) NOT NULL,
	[batchId] [nvarchar](40) NULL,
	[documentDistance] [float] NOT NULL,
	[topicScore] [int] NOT NULL,
	[topicKeyPhrase] [nvarchar](2000) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[stg_entities]    Script Date: 20-12-2018 03:06:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[stg_entities](
	[documentId] [nchar](64) NOT NULL,
	[entityType] [nvarchar](30) NOT NULL,
	[entityValue] [nvarchar](max) NULL,
	[offset] [int] NOT NULL,
	[offsetDocumentPercentage] [float] NOT NULL,
	[length] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[Synonyms]    Script Date: 20-12-2018 03:06:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[Synonyms](
	[Syn_ID] [int] IDENTITY(1,1) NOT NULL,
	[Syn_Description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Syn_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[userdefinedentitydefinitions]    Script Date: 20-12-2018 03:06:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[userdefinedentitydefinitions](
	[regex] [nvarchar](200) NOT NULL,
	[entityType] [nvarchar](30) NOT NULL,
	[entityValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO