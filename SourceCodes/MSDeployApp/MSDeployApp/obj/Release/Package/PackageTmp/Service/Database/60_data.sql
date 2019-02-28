SET ANSI_NULLS              ON;
SET ANSI_PADDING            ON;
SET ANSI_WARNINGS           ON;
SET ANSI_NULL_DFLT_ON       ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER       ON;
GO


/************************************
* Configuration values              *
*************************************/
INSERT bpst_news.[configuration] (configuration_group, configuration_subgroup, [name], [value],[visible])
    VALUES (N'SolutionTemplate', N'News', N'version', N'1.0', 0),
		   (N'SolutionTemplate', N'News', N'versionImage', N'https://bpstservice.azurewebsites.net/api/telemetry/Microsoft-NewsTemplate', 1);
GO


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

