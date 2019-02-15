SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[configuration](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[configuration_group] [nvarchar](150) NOT NULL,
	[configuration_subgroup] [nvarchar](150) NOT NULL,
	[name] [nvarchar](150) NOT NULL,
	[value] [nvarchar](max) NULL,
	[visible] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [bpst_news].[vw_configuration]    Script Date: 20-12-2018 03:06:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ConfigurationView
CREATE VIEW [bpst_news].[vw_configuration]
AS
    SELECT [id],
            configuration_group    AS [configuration group],
            configuration_subgroup AS [configuration subgroup],
            [name]                 AS [name],
            [value]                AS [value]
    FROM	bpst_news.[configuration]
    WHERE  visible = 1;
GO
/****** Object:  Table [bpst_news].[documents]    Script Date: 20-12-2018 03:06:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documents](
	[id] [nchar](64) NOT NULL,
	[text] [nvarchar](max) NULL,
	[textLength] [int] NULL,
	[cleanedText] [nvarchar](max) NULL,
	[cleanedTextLength] [int] NULL,
	[abstract] [nvarchar](4000) NULL,
	[title] [nvarchar](2000) NULL,
	[sourceUrl] [nvarchar](2000) NULL,
	[sourceDomain] [nvarchar](1000) NULL,
	[category] [nvarchar](150) NULL,
	[imageUrl] [nvarchar](max) NULL,
	[imageWidth] [int] NULL,
	[imageHeight] [int] NULL,
 CONSTRAINT [pk_documents] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[documentpublishedtimes]    Script Date: 20-12-2018 03:06:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documentpublishedtimes](
	[id] [nchar](64) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[monthPrecision] [datetime] NOT NULL,
	[weekPrecision] [datetime] NOT NULL,
	[dayPrecision] [datetime] NOT NULL,
	[hourPrecision] [datetime] NOT NULL,
	[minutePrecision] [datetime] NOT NULL,
 CONSTRAINT [pk_documentpublishedtimes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[documentingestedtimes]    Script Date: 20-12-2018 03:06:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documentingestedtimes](
	[id] [nchar](64) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[monthPrecision] [datetime] NOT NULL,
	[weekPrecision] [datetime] NOT NULL,
	[dayPrecision] [datetime] NOT NULL,
	[hourPrecision] [datetime] NOT NULL,
	[minutePrecision] [datetime] NOT NULL,
 CONSTRAINT [pk_documentingestedtimes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[documentsentimentscores]    Script Date: 20-12-2018 03:06:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documentsentimentscores](
	[id] [nchar](64) NOT NULL,
	[score] [float] NOT NULL,
 CONSTRAINT [pk_documentsentimentscores] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [bpst_news].[vw_FullDocument]    Script Date: 20-12-2018 03:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_FullDocument]
AS
    SELECT documents.id								AS [Id],
           documents.abstract						AS [Abstract],
           documents.title							AS [Title],
           documents.sourceUrl						AS [Source URL],
           documents.sourceDomain					AS [Source Domain],
           documents.category						AS [Category],
           documents.imageUrl						AS [Image URL],
           documents.imageWidth						AS [Image Width],
           documents.imageHeight					AS [Image Height],
           documentsentimentscores.score			AS [Sentiment Score],
           documentpublishedtimes.[timestamp]		AS [PublishedTimestamp],
           documentpublishedtimes.monthPrecision	AS [Published Month Precision],
           documentpublishedtimes.weekPrecision		AS [Published Week Precision],
           documentpublishedtimes.dayPrecision		AS [Published Day Precision],
           documentpublishedtimes.hourPrecision		AS [Published Hour Precision],
           documentpublishedtimes.minutePrecision	AS [Minute Precision],
           documentingestedtimes.[timestamp]		AS [Ingested Timestamp],
           documentingestedtimes.monthPrecision		AS [Ingested Month Precision],
           documentingestedtimes.weekPrecision		AS [Ingested Week Precision],
           documentingestedtimes.dayPrecision		AS [Ingested Day Precision],
           documentingestedtimes.hourPrecision		AS [Ingested Hour Precision],
           documentingestedtimes.minutePrecision	AS [Ingested Minute Precision]
    FROM   bpst_news.documents documents LEFT OUTER JOIN documentpublishedtimes 	ON documents.id = documentpublishedtimes.id
                                         LEFT OUTER JOIN documentingestedtimes		ON documents.id = documentingestedtimes.id
                                         LEFT OUTER JOIN documentsentimentscores 	ON documents.id=documentsentimentscores.id;
GO
/****** Object:  Table [bpst_news].[documentsearchterms]    Script Date: 20-12-2018 03:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documentsearchterms](
	[documentId] [nchar](64) NULL,
	[searchterms] [nvarchar](130) NULL
) ON [PRIMARY]
GO
/****** Object:  View [bpst_news].[vw_DocumentSearchTerms]    Script Date: 20-12-2018 03:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bpst_news].[vw_DocumentSearchTerms]
AS
    SELECT documentsearchterms.[documentId]			AS [Document Id],
           documentsearchterms.[searchterms]		AS [Search Terms]
FROM bpst_news.documentsearchterms;
GO
/****** Object:  Table [bpst_news].[documenttopics]    Script Date: 20-12-2018 03:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documenttopics](
	[documentId] [nchar](64) NOT NULL,
	[topicId] [nchar](36) NOT NULL,
	[batchId] [nvarchar](40) NULL,
	[documentDistance] [float] NOT NULL,
	[topicScore] [int] NOT NULL,
	[topicKeyPhrase] [nvarchar](2000) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [bpst_news].[documenttopicimages]    Script Date: 20-12-2018 03:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bpst_news].[documenttopicimages](
	[topicId] [nchar](36) NOT NULL,
	[imageUrl1] [nvarchar](max) NULL,
	[imageUrl2] [nvarchar](max) NULL,
	[imageUrl3] [nvarchar](max) NULL,
	[imageUrl4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO