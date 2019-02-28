/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects] ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
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

/****** Object:  Table [bpst_news].[documents] ******/
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

/****** Object:  Table [bpst_news].[documentpublishedtimes]  ******/
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

/****** Object:  Table [bpst_news].[documentingestedtimes]  ******/
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

/****** Object:  Table [bpst_news].[documentsentimentscores]  ******/
CREATE TABLE [bpst_news].[documentsentimentscores](
	[id] [nchar](64) NOT NULL,
	[score] [float] NOT NULL,
 CONSTRAINT [pk_documentsentimentscores] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[documentsearchterms]  ******/
CREATE TABLE [bpst_news].[documentsearchterms](
	[documentId] [nchar](64) NULL,
	[searchterms] [nvarchar](130) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[documenttopics]  ******/
CREATE TABLE [bpst_news].[documenttopics](
	[documentId] [nchar](64) NOT NULL,
	[topicId] [nchar](36) NOT NULL,
	[batchId] [nvarchar](40) NULL,
	[documentDistance] [float] NOT NULL,
	[topicScore] [int] NOT NULL,
	[topicKeyPhrase] [nvarchar](2000) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[documenttopicimages]  ******/
CREATE TABLE [bpst_news].[documenttopicimages](
	[topicId] [nchar](36) NOT NULL,
	[imageUrl1] [nvarchar](max) NULL,
	[imageUrl2] [nvarchar](max) NULL,
	[imageUrl3] [nvarchar](max) NULL,
	[imageUrl4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[entities] ******/
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

/****** Object:  Table [bpst_news].[userdefinedentities] ******/
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

/****** Object:  Table [bpst_news].[typedisplayinformation] ******/
CREATE TABLE [bpst_news].[typedisplayinformation](
	[entityType] [nvarchar](30) NOT NULL,
	[icon] [nvarchar](30) NOT NULL,
	[color] [nvarchar](7) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[documentkeyphrases] ******/
CREATE TABLE [bpst_news].[documentkeyphrases](
	[documentid] [nchar](64) NOT NULL,
	[phrase] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[topickeyphrases] ******/
CREATE TABLE [bpst_news].[topickeyphrases](
	[topicId] [int] NULL,
	[KeyPhrase] [varchar](6004) NOT NULL
) ON [PRIMARY]
GO


/****** Object:  Table [bpst_news].[MySettings] ******/
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

/****** Object:  Table [bpst_news].[RegionLang] ******/
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

/****** Object:  Table [bpst_news].[stg_documentcompressedentities] ******/
CREATE TABLE [bpst_news].[stg_documentcompressedentities](
	[documentId] [nchar](64) NOT NULL,
	[compressedEntitiesJson] [nvarchar](max) NULL,
 CONSTRAINT [pk_documentcompressedentities] PRIMARY KEY CLUSTERED 
(
	[documentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[stg_documenttopicimages] ******/
CREATE TABLE [bpst_news].[stg_documenttopicimages](
	[topicId] [nchar](36) NOT NULL,
	[imageUrl1] [nvarchar](max) NULL,
	[imageUrl2] [nvarchar](max) NULL,
	[imageUrl3] [nvarchar](max) NULL,
	[imageUrl4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[stg_documenttopics] ******/
CREATE TABLE [bpst_news].[stg_documenttopics](
	[documentId] [nchar](64) NOT NULL,
	[topicId] [nchar](36) NOT NULL,
	[batchId] [nvarchar](40) NULL,
	[documentDistance] [float] NOT NULL,
	[topicScore] [int] NOT NULL,
	[topicKeyPhrase] [nvarchar](2000) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[stg_entities] ******/
CREATE TABLE [bpst_news].[stg_entities](
	[documentId] [nchar](64) NOT NULL,
	[entityType] [nvarchar](30) NOT NULL,
	[entityValue] [nvarchar](max) NULL,
	[offset] [int] NOT NULL,
	[offsetDocumentPercentage] [float] NOT NULL,
	[length] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[Synonyms] ******/
CREATE TABLE [bpst_news].[Synonyms](
	[Syn_ID] [int] IDENTITY(1,1) NOT NULL,
	[Syn_Description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Syn_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [bpst_news].[userdefinedentitydefinitions] ******/
CREATE TABLE [bpst_news].[userdefinedentitydefinitions](
	[regex] [nvarchar](200) NOT NULL,
	[entityType] [nvarchar](30) NOT NULL,
	[entityValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




