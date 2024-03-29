USE [master]
GO
/****** Object:  Database [Blog ]    Script Date: 1/31/2024 9:48:59 AM ******/
CREATE DATABASE [Blog ]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Blog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Blog .mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Blog _log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Blog _log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Blog ] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Blog ].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Blog ] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Blog ] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Blog ] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Blog ] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Blog ] SET ARITHABORT OFF 
GO
ALTER DATABASE [Blog ] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Blog ] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Blog ] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Blog ] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Blog ] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Blog ] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Blog ] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Blog ] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Blog ] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Blog ] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Blog ] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Blog ] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Blog ] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Blog ] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Blog ] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Blog ] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Blog ] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Blog ] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Blog ] SET  MULTI_USER 
GO
ALTER DATABASE [Blog ] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Blog ] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Blog ] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Blog ] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Blog ] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Blog ] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Blog ] SET QUERY_STORE = OFF
GO
USE [Blog ]
GO
/****** Object:  Table [dbo].[tbl_blog]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_blog](
	[Blogid] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[title] [nvarchar](max) NULL,
	[blogcontent] [nvarchar](max) NULL,
	[image1] [nvarchar](max) NULL,
	[image2] [nvarchar](max) NULL,
	[image3] [nvarchar](max) NULL,
	[catid] [int] NULL,
	[tags] [nvarchar](max) NULL,
	[ispublished] [int] NULL,
	[createdby] [int] NULL,
	[createddate] [datetime] NULL,
 CONSTRAINT [PK_tbl_blog] PRIMARY KEY CLUSTERED 
(
	[Blogid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Category]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Category](
	[Catid] [int] IDENTITY(1,1) NOT NULL,
	[Catname] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Category] PRIMARY KEY CLUSTERED 
(
	[Catid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_comments]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_comments](
	[commentid] [int] IDENTITY(1,1) NOT NULL,
	[parentid] [int] NULL,
	[comment] [nvarchar](max) NULL,
	[commentaddedid] [int] NULL,
	[blogid] [int] NULL,
	[createddate] [datetime] NULL,
 CONSTRAINT [PK_tbl_comments] PRIMARY KEY CLUSTERED 
(
	[commentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_likes]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_likes](
	[likeid] [int] IDENTITY(1,1) NOT NULL,
	[blogid] [int] NULL,
	[likecount] [int] NULL,
	[likeaddedid] [int] NULL,
 CONSTRAINT [PK_tbl_likes] PRIMARY KEY CLUSTERED 
(
	[likeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserCategory]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Catid] [int] NULL,
	[userid] [int] NULL,
 CONSTRAINT [PK_tbl_UserCategory] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccount]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccount](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](50) NULL,
	[name] [nvarchar](50) NULL,
	[password] [nvarchar](max) NULL,
	[account_type] [nvarchar](50) NULL,
	[interest] [int] NULL,
	[photo] [nvarchar](max) NULL,
	[instalink] [nvarchar](max) NULL,
	[fblink] [nvarchar](max) NULL,
	[twitterlink] [nvarchar](max) NULL,
	[bio] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tbl_blog] ON 

INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (4, 1, N'assss', N'<p>zzzzz</p>', N'', N'', N'/uploads/images/202412612123587.jpg', 4, N'assss', 1, 1, CAST(N'2024-01-26T12:12:21.187' AS DateTime))
INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (5, 1, N'zzzxxx', N'<p>cccccc jaseela super have</p>', N'/uploads/images/2024126121513107.jpg', N'', N'', 1, N'zzzxxx', 1, 1, CAST(N'2024-01-27T10:43:07.603' AS DateTime))
INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (6, 1, N'sss', N'<p>Petroleum, also called crude oil, is a naturally occurring liquid found beneath the earth&rsquo;s surface that can be refined into fuel. A fossil fuel, petroleum is created by the decomposition of organic matter over time and used as fuel to power vehicles, heating units, and machines, and can be converted into plastics.</p>', N'/uploads/images/202412612208579.jpg', N'', N'', 1, N'html,css,java', 1, 1, CAST(N'2024-01-28T16:15:21.293' AS DateTime))
INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (7, 1, N'Programing language importance ', N'<p>Google LLC is an American multinational technology company focusing on artificial intelligence, online advertising, search engine technology, cloud computing, computer software, quantum computing, e-commerce, and consumer electronics.&nbsp;</p>', N'/uploads/images/202412814339318.jpg', N'/uploads/images/202412814339329.jpg', N'/uploads/images/202412814339331.jpg', 7, N'html,css,java,javascript', 1, 1, CAST(N'2024-01-28T15:49:48.463' AS DateTime))
INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (8, 13, N'demo test', N'<p>this one is demo purpose</p>', N'', N'/uploads/images/2024129191726543.jpg', N'', 1, N'html,css,java,javascript', 1, 13, CAST(N'2024-01-31T00:31:37.037' AS DateTime))
INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (9, 13, N'z', N'<p>good blog</p>', N'/uploads/images/202412919542180.jpg', N'', N'', 1, N'C#,c,html,css,javascript', 1, 13, CAST(N'2024-01-31T00:31:30.743' AS DateTime))
INSERT [dbo].[tbl_blog] ([Blogid], [userid], [title], [blogcontent], [image1], [image2], [image3], [catid], [tags], [ispublished], [createdby], [createddate]) VALUES (10, 13, N'dd', N'<p>test demo purpose</p>', N'/uploads/images/202412920336360.jpg', N'', N'', 3, NULL, 1, 13, CAST(N'2024-01-31T00:33:47.220' AS DateTime))
SET IDENTITY_INSERT [dbo].[tbl_blog] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_Category] ON 

INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (1, N'Programming')
INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (2, N'DataScience')
INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (3, N'Technology')
INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (4, N'Self Improvement')
INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (5, N'Writing')
INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (6, N'Relationship')
INSERT [dbo].[tbl_Category] ([Catid], [Catname]) VALUES (7, N'Machine learning')
SET IDENTITY_INSERT [dbo].[tbl_Category] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_comments] ON 

INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (36, 0, N'<p>super</p>', 13, 7, CAST(N'2024-01-30T10:58:15.650' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (37, 0, N'<p>woow</p>', 13, 7, CAST(N'2024-01-30T10:58:33.467' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (38, 0, N'<p>high</p>', 13, 7, CAST(N'2024-01-30T10:58:42.500' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (39, 36, N'super under', 13, 7, CAST(N'2024-01-30T11:19:48.407' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (40, 36, N'super under1', 13, 7, CAST(N'2024-01-30T11:25:36.063' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (41, 36, N'under 3', 13, 7, CAST(N'2024-01-30T11:48:00.223' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (42, 37, N'super ', 13, 7, CAST(N'2024-01-30T11:54:02.083' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (43, 37, N'super bb', 13, 7, CAST(N'2024-01-30T11:59:45.663' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (44, 36, N' j', 13, 7, CAST(N'2024-01-30T12:00:48.077' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (45, 36, N'b', 13, 7, CAST(N'2024-01-30T12:03:02.593' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (46, 38, N'no', 13, 7, CAST(N'2024-01-30T12:48:27.350' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (47, 46, N'no under', 13, 7, CAST(N'2024-01-30T13:10:08.987' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (48, 0, N'<p>hi jaseela</p>', 13, 7, CAST(N'2024-01-30T13:24:37.113' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (49, 48, N'super jaseela', 13, 7, CAST(N'2024-01-30T13:25:35.690' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (50, 48, N'jaseela how are u', 13, 7, CAST(N'2024-01-30T14:19:24.520' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (51, 48, N'hi jaseela', 13, 7, CAST(N'2024-01-30T14:25:16.733' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (52, 48, N'testtoday', 13, 7, CAST(N'2024-01-30T14:28:42.930' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (53, 48, N'testtoday1', 13, 7, CAST(N'2024-01-30T14:31:20.000' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (54, 48, N'testtoday1', 13, 7, CAST(N'2024-01-30T14:31:30.803' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (55, 48, N'testtoday2', 13, 7, CAST(N'2024-01-30T14:32:09.980' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (56, 48, N'testtoday2', 13, 7, CAST(N'2024-01-30T14:32:11.127' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (57, 48, N'testtoday2', 13, 7, CAST(N'2024-01-30T14:33:04.267' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (58, 48, N'testtoday2', 13, 7, CAST(N'2024-01-30T14:42:51.683' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (59, 48, N'new', 13, 7, CAST(N'2024-01-30T14:48:01.397' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (60, 0, N'<p>super</p>', 16, 10, CAST(N'2024-01-31T00:45:19.893' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (61, 0, N'<p>good</p>', 16, 10, CAST(N'2024-01-31T00:45:29.980' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (62, 60, N'super under', 16, 10, CAST(N'2024-01-31T00:45:48.423' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (63, 60, N'super under1', 16, 10, CAST(N'2024-01-31T00:45:52.337' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (64, 60, N'super under1', 16, 10, CAST(N'2024-01-31T00:45:54.040' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (65, 60, N'good d', 16, 10, CAST(N'2024-01-31T00:49:41.367' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (1011, 0, N'<p><strong>excellent</strong></p>', 1013, 10, CAST(N'2024-01-31T07:10:58.243' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (1012, 1011, N'under excellent', 1013, 10, CAST(N'2024-01-31T07:11:28.490' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (1013, 0, N'<p>fantanstic</p>', 1014, 10, CAST(N'2024-01-31T09:23:37.250' AS DateTime))
INSERT [dbo].[tbl_comments] ([commentid], [parentid], [comment], [commentaddedid], [blogid], [createddate]) VALUES (1014, 60, N'shafeequ test', 1014, 10, CAST(N'2024-01-31T09:24:23.200' AS DateTime))
SET IDENTITY_INSERT [dbo].[tbl_comments] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_UserCategory] ON 

INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1, 1, 2)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2, 2, 2)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (3, 3, 2)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (4, 1, 1)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (5, 2, 1)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (6, 3, 1)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1002, 4, 13)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1003, 5, 13)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1004, 6, 13)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1005, 1, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1006, 2, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1007, 3, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1008, 4, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1009, 5, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1010, 6, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (1011, 7, 16)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2002, 1, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2003, 2, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2004, 3, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2005, 4, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2006, 5, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2007, 6, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2008, 7, 1013)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2009, 1, 1014)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2010, 2, 1014)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2011, 3, 1014)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2012, 4, 1014)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2013, 5, 1014)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2014, 6, 1014)
INSERT [dbo].[tbl_UserCategory] ([id], [Catid], [userid]) VALUES (2015, 7, 1014)
SET IDENTITY_INSERT [dbo].[tbl_UserCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[UserAccount] ON 

INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (1, N'jaseelashafeequ@gmail.com', N'Jaseela Shafeequ', N'123', N'author', 1, N'/uploads/images/2024124104641578.jpg', N'https://www.googlein.com/', N'https://www.googlefb.com/', N'https://www.googletw.com/', N'ssss')
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (2, N'jaseelashafeequ1@gmail.com', N'jaseela', N'123', N'author', 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (3, N'jaseelashafeequ11@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (4, N'jaseelashafeequ44@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (5, N'shafeequ@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (6, N'jaseelashafeequ44@gmail.com', N'jaseelaww', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (7, N'jaseelashafeequ44@gmail.com', N'jaseelaww', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (8, N'jaseelashafeequ55555@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (9, N'jaseelashafeequ55555@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (10, N'jaseelashafeequwwww@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (11, N'jaseelashafeequ5t66y6556@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (12, N'jaseelashafeeqeeeu@gmail.com', N'jaseela', N'123', N'author', 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (13, N'jaseelaka945@gmail.com', N'Mubashira', N'123', N'author', 1, N'/uploads/images/202413015727459.jpg', N'https://www.googlein.com/', N'https://www.googlefb.com/', N'https://www.googletw.com/', N'good')
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (14, N'admin@gmail.com', N'Admin Jhon', N'123', N'admin', 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (15, N'editor@gmail.com', N'Editor Joy', N'123', N'editor', 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (16, N'zohan@gmail.com', N'zohan', N'123', N'author', 1, N'/uploads/images/2024130214815839.jpg', NULL, NULL, NULL, NULL)
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (1013, N'jasna@gmail.com', N'jasna', N'123', N'author', 1, N'/uploads/images/2024131785787.jpg', N'https://www.googlein.com/', N'https://www.googlefb.com/', N'https://www.googletw.com/', N'jasna is good')
INSERT [dbo].[UserAccount] ([userid], [email], [name], [password], [account_type], [interest], [photo], [instalink], [fblink], [twitterlink], [bio]) VALUES (1014, N'jubi@gmail.com', N'jubi', N'123', N'author', 1, N'/uploads/images/202413191730977.jpg', N'https://www.googlein.com/', N'https://www.googlefb.com/', N'https://www.googletw.com/', N'jubi is good')
SET IDENTITY_INSERT [dbo].[UserAccount] OFF
GO
ALTER TABLE [dbo].[tbl_UserCategory]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UserCategory_tbl_UserCategory] FOREIGN KEY([id])
REFERENCES [dbo].[tbl_UserCategory] ([id])
GO
ALTER TABLE [dbo].[tbl_UserCategory] CHECK CONSTRAINT [FK_tbl_UserCategory_tbl_UserCategory]
GO
ALTER TABLE [dbo].[tbl_UserCategory]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UserCategory_tbl_UserCategory1] FOREIGN KEY([id])
REFERENCES [dbo].[tbl_UserCategory] ([id])
GO
ALTER TABLE [dbo].[tbl_UserCategory] CHECK CONSTRAINT [FK_tbl_UserCategory_tbl_UserCategory1]
GO
/****** Object:  StoredProcedure [dbo].[sp_AddCommentGetcomments]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec sp_AddCommentGetcomments 'testtoday2',48,7,48
--select * from [dbo].[tbl_comments] 
-- =============================================
CREATE PROCEDURE [dbo].[sp_AddCommentGetcomments] 
	-- Add the parameters for the stored procedure here
	@comment			nvarchar(max),
	@commentaddedid     int,
	@blogid				int,
	@parentid           int
AS
BEGIN

	SET NOCOUNT ON;
if(@parentid=0)
begin
INSERT INTO [dbo].[tbl_comments]
           (
					[comment]			,
					[commentaddedid]	,
					[blogid]			,
					[createddate]        ,
					[parentid]
		   )
     VALUES
           (
					@comment        ,
					@commentaddedid			,
					@blogid			,
					getdate()   ,
					0
		   )
select 
					[commentid]											,
					[comment]											,
					[commentaddedid]									,
					c.[blogid]											,
					name as commentaddedname						    ,
					c.createddate      as createddate                   ,
				    [parentid]         as parentid  ,
					 (
						SELECT COUNT(*) 
						FROM [dbo].[tbl_comments] nested 
						WHERE  nested.blogid=@blogid
					 ) AS nestedCommentCount
 from				[dbo].[tbl_comments] c
 inner join         [dbo].[UserAccount]  u on  c.commentaddedid=u.userid
 where             c.[blogid]	=@blogid and c.parentid=0






end
else
begin
print 's'
INSERT INTO [dbo].[tbl_comments]
           (
					[comment]			,
					[commentaddedid]	,
					[blogid]			,
					[createddate]       ,
					[parentid]
		   )
     VALUES
           (
					@comment        ,
					@commentaddedid			,
					@blogid			,
					getdate() ,
					@parentid
		   )
select 
					[commentid]											,
					[comment]											,
					[commentaddedid]									,
					c.[blogid]											,
					name as commentaddedname						    ,
					c.createddate      as createddate                   ,
					c.[parentid]     as parentid,
					(
						SELECT COUNT(*) 
						FROM [dbo].[tbl_comments] nested 
						WHERE nested.parentid = c.commentid AND nested.blogid=@blogid
					 ) as nestedCommentCount
 from				[dbo].[tbl_comments] c
 inner join         [dbo].[UserAccount]  u on  c.commentaddedid=u.userid
 where             c.[blogid]	=@blogid  and c.[parentid]=@parentid




end


 
 

END

GO
/****** Object:  StoredProcedure [dbo].[sp_addupdateblog]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_addupdateblog] 
	-- Add the parameters for the stored procedure here
	@userid						int 					,			
	@featuredImage1Path			nvarchar(max)=null		,
	@featuredImage2Path			nvarchar(max)=null		,
	@featuredImage3Path			nvarchar(max)=null		,
	@tags						nvarchar(max)=null		,
	@blogContent				nvarchar(max)=null		,
	@Catid						int						,
	@title   					nvarchar(max)=null,
	@Blogid                     int 
AS
BEGIN

	SET NOCOUNT ON;
	if (@Blogid=0)
	begin
	 DECLARE @InsertedBlogId INT=0;
	INSERT INTO [dbo].[tbl_blog]
           (
			[userid]					,
			[title]						,
			[blogcontent]				,
			[image1]					,
			[image2]					,
			[image3]					,
			[catid]						,
			[tags]						,
		    ispublished					,
			createdby    ,
			createddate
		   )
     VALUES
           (
		   @userid					   ,
           @title					   ,
           @blogContent				   ,
           @featuredImage1Path		   ,
           @featuredImage2Path		   ,
           @featuredImage3Path		   ,
           @Catid					   ,
           @tags,
		   0,
		   @userid  ,
		   getdate()
		   )
SET @InsertedBlogId = SCOPE_IDENTITY();
if(@InsertedBlogId>0)
begin
select 'success' as message
end

  end
    else
	begin
	UPDATE [dbo].[tbl_blog]
   SET 
			[title] = @title						,
			[blogcontent] =@blogContent				,
			[image1] = @featuredImage1Path			,
			[image2] = @featuredImage2Path			,
			[image3] = @featuredImage3Path			,
			[catid] = @Catid						,
			[tags] = @tags							,
			[ispublished] = 0,
			createdby=@userid   ,
			createddate=getdate()
 WHERE     Blogid=@Blogid  and [userid]=@userid

 select 'success' as message

	end 

END

GO
/****** Object:  StoredProcedure [dbo].[sp_blogdetails]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_blogdetails] '10'
--select * from [dbo].[tbl_blog]
-- =============================================
CREATE PROCEDURE [dbo].[sp_blogdetails] 
	-- Add the parameters for the stored procedure here
	@Blogid   int						
	         
AS
BEGIN

	SET NOCOUNT ON;
	SELECT				b.[Blogid]         as Blogid					,
						b.[userid]		 as userid					,
						isnull([title],'')			 as title					,
						isnull([blogcontent],'')	 as blogcontent					,
						isnull([image1],'')		 as hiddenImageName1		,
						isnull([image2],'')		 as hiddenImageName2		,
						isnull([image3],'')		 as hiddenImageName3		,
						b.[catid]			 as Catid					,
						isnull([tags],'')			 as tags                    ,
						isnull(ispublished,0)      as ispublished				,
						isnull(ua.name,'')          as username                ,
						isnull(b.createddate,getdate())    as createddate             ,
						isnull(ca.Catname,'')       as Catname                 ,
						ISNULL(likecount, 0) AS likecount

  FROM					[dbo].[tbl_blog] b
  inner join            [dbo].[UserAccount] ua  on ua.[userid]=b.[userid]
  inner join            [dbo].[tbl_Category] ca  on ca.Catid=b.catid
   LEFT JOIN
                (SELECT COUNT([likeid]) AS likecount, [blogid] AS blogid
                 FROM [dbo].[tbl_likes]
                 GROUP BY [blogid]) AS li ON li.blogid = b.Blogid
  where				    b.Blogid=@Blogid
 SELECT 
    c.[commentid],
    c.[comment],
    c.[commentaddedid],
    c.[blogid],
    u.name AS commentaddedname,
    c.createddate,
    (
        SELECT COUNT(*) 
        FROM [dbo].[tbl_comments] nested 
        WHERE nested.parentid = c.commentid AND nested.Blogid=@Blogid
    ) AS nestedCommentCount
FROM 
    [dbo].[tbl_comments] c
INNER JOIN 
    [dbo].[UserAccount] u ON c.commentaddedid = u.userid
INNER JOIN 
    [dbo].[tbl_blog] b ON b.Blogid = c.blogid
WHERE 
    c.[blogid] = @Blogid 
    AND c.parentid=0; -- Filter to retrieve only parent comments (comments without a parent)



END

GO
/****** Object:  StoredProcedure [dbo].[sp_blogdetailsbyauthor]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_blogdetails] 1
-- =============================================
create PROCEDURE [dbo].[sp_blogdetailsbyauthor] 
	-- Add the parameters for the stored procedure here
	@Blogid   int						
	         
AS
BEGIN

	SET NOCOUNT ON;
	SELECT				[Blogid]         as Blogid					,
						b.[userid]		 as userid					,
						[title]			 as title					,
						[blogcontent]	 as title					,
						[image1]		 as hiddenImageName1		,
						[image2]		 as hiddenImageName2		,
						[image3]		 as hiddenImageName3		,
						b.[catid]			 as Catid					,
						[tags]			 as tags                    ,
						ispublished      as ispublished				,
						ua.name          as username                ,
						b.createddate    as createddate             ,
						ca.Catname       as Catname
  FROM					[dbo].[tbl_blog] b
  inner join            [dbo].[UserAccount] ua  on ua.[userid]=b.[userid]
  inner join            [dbo].[tbl_Category] ca  on ca.Catid=b.catid

  where				    b.Blogid=@Blogid  	
  order by [Blogid] desc
END

GO
/****** Object:  StoredProcedure [dbo].[sp_deleteblog]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_deleteblog] 
    @Blogid INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RowsAffected INT;

    -- Delete from tbl_blog
    DELETE FROM [dbo].[tbl_blog]
    WHERE Blogid = @Blogid;

    SET @RowsAffected = @@ROWCOUNT;

    -- Delete from tbl_comments
    DELETE FROM [dbo].[tbl_comments]
    WHERE [blogid] = @Blogid;

    SET @RowsAffected = @RowsAffected + @@ROWCOUNT;

    -- Delete from tbl_likes
    DELETE FROM [dbo].[tbl_likes]
    WHERE [blogid] = @Blogid;

    SET @RowsAffected = @RowsAffected + @@ROWCOUNT;

    -- Check if all delete operations were successful
  
        SELECT 'Successfully deleted blog' AS Message;
   
END
GO
/****** Object:  StoredProcedure [dbo].[sp_EmailExistance]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_EmailExistance] 
	-- Add the parameters for the stored procedure here
	
	@email			 nvarchar(50)=null	
	
	
AS
BEGIN

	SET NOCOUNT ON;
IF EXISTS (SELECT * FROM [dbo].[UserAccount] WHERE [email] = @email)
    BEGIN
	 SELECT 'This emil already exist.please use different email.' AS message;
    END
    ELSE
    BEGIN
	 SELECT '' AS message;
    END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_filterblogs]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_filterblogs] 
    @categoryId INT = 0,
    @FromDate DATETIME = NULL,
    @ToDate DATETIME = NULL,
    @orderby NVARCHAR(MAX) = 'DESC'  -- Default order by DESC
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @condition NVARCHAR(MAX) = '1 = 1'; -- Always true initially

    -- Add conditions based on parameters
    IF (@categoryId != 0)
    BEGIN
        SET @condition = @condition + ' AND b.[catid] = ' + CAST(@categoryId AS NVARCHAR);
    END

    IF (@FromDate IS NOT NULL)
    BEGIN
        SET @condition = @condition + ' AND b.[createddate] >= @FromDate';
    END

    IF (@ToDate IS NOT NULL)
    BEGIN
        SET @condition = @condition + ' AND b.[createddate] <= @ToDate';
    END

    -- Include the ispublished condition
    SET @condition = @condition + ' AND b.ispublished = 1';

    DECLARE @sql NVARCHAR(MAX) = '
    SELECT	b.[Blogid] AS Blogid,
            b.[userid] AS userid,
            b.[title] AS title,
            ISNULL(b.[blogcontent], '''') AS blogContent,
            b.[image1] AS hiddenImageName1,
            b.[image2] AS hiddenImageName2,
            b.[image3] AS hiddenImageName3,
            b.[catid] AS Catid,
            ISNULL(b.[tags], '''') AS tags,
            b.ispublished AS ispublished,
            ua.name AS username,
            b.createddate AS createddate,
            ISNULL(li.likecount, 0) AS likecount           
    FROM [dbo].[tbl_blog] b
    INNER JOIN [dbo].[UserAccount] ua ON ua.[userid] = b.[userid]
    INNER JOIN [dbo].[tbl_Category] c ON c.Catid = b.catid
    LEFT JOIN (
        SELECT COUNT([likeid]) AS likecount, [blogid] AS blogid
        FROM [dbo].[tbl_likes]
        GROUP BY [blogid]
    ) AS li ON li.blogid = b.Blogid
    WHERE ' + @condition + '
    ORDER BY b.[Blogid] ' + @orderby;

    PRINT @sql; -- Print the SQL for debugging

    EXEC sp_executesql @sql, N'@FromDate DATETIME, @ToDate DATETIME', @FromDate, @ToDate;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_getblogs]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getblogs] 
	-- Add the parameters for the stored procedure here
	@userid						int 						
	         
AS
BEGIN

	SET NOCOUNT ON;
	SELECT				[Blogid]         as Blogid					,
						b.[userid]		 as userid					,
						[title]			 as title					,
						[blogcontent]	 as blogcontent					,
						[image1]		 as hiddenImageName1		,
						[image2]		 as hiddenImageName2		,
						[image3]		 as hiddenImageName3		,
						[catid]			 as Catid					,
						[tags]			 as tags                    ,
						ispublished      as ispublished				,
						ua.name          as username                ,
						b.createddate    as createddate
  FROM					[dbo].[tbl_blog] b
  inner join            [dbo].[UserAccount] ua  on ua.[userid]=b.[userid]
  where				    b.[userid]=@userid	
  order by [Blogid] desc
END

GO
/****** Object:  StoredProcedure [dbo].[sp_getblogsadmin]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getblogsadmin] 
	-- Add the parameters for the stored procedure here
	         
AS
BEGIN

	SET NOCOUNT ON;
	SELECT				[Blogid]         as Blogid					,
						b.[userid]		 as userid					,
						[title]			 as title					,
						[blogcontent]	 as blogcontent					,
						[image1]		 as hiddenImageName1		,
						[image2]		 as hiddenImageName2		,
						[image3]		 as hiddenImageName3		,
						b.[catid]			 as Catid					,
						[tags]			 as tags                    ,
						ispublished      as ispublished				,
						ua.name          as username                ,
						b.createddate    as createddate,
						isnull(c.[Catname],'')        as Catname
  FROM					[dbo].[tbl_blog] b
  inner join            [dbo].[UserAccount] ua  on ua.[userid]=b.[userid]
  inner join           [dbo].[tbl_Category] c  on c.Catid=b.catid
 	
  order by [Blogid] desc
END

GO
/****** Object:  StoredProcedure [dbo].[sp_getcategoryblogs]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_getcategoryblogs]   0,'desc'
--select * from [dbo].[tbl_blog]
-- =============================================
CREATE PROCEDURE [dbo].[sp_getcategoryblogs] 
    @categoryId INT,
    @orderby NVARCHAR(MAX)='desc'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    IF (@categoryId = 0)
    BEGIN
        SET @sql = '
            SELECT
                b.[Blogid] AS Blogid,
                b.[userid] AS userid,
                [title] AS title,
                ISNULL([blogcontent], '''') AS blogContent,
                [image1] AS hiddenImageName1,
                [image2] AS hiddenImageName2,
                [image3] AS hiddenImageName3,
                b.[catid] AS Catid,
                ISNULL([tags], '''') AS tags,
                ispublished AS ispublished,
                ua.name AS username,
                b.createddate AS createddate,
                ISNULL(likecount, 0) AS likecount
            FROM
                [dbo].[tbl_blog] b
            INNER JOIN
                [dbo].[UserAccount] ua ON ua.[userid] = b.[userid]
            INNER JOIN
                [dbo].[tbl_Category] c ON c.Catid = b.catid
            LEFT JOIN
                (SELECT COUNT([likeid]) AS likecount, [blogid] AS blogid
                 FROM [dbo].[tbl_likes]
                 GROUP BY [blogid]) AS li ON li.blogid = b.Blogid
            WHERE
                b.ispublished = 1
            ORDER BY
                b.[Blogid] ' + @orderby;

        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        SET @sql = '
            SELECT
                b.[Blogid] AS Blogid,
                b.[userid] AS userid,
                [title] AS title,
                ISNULL([blogcontent], '''') AS blogContent,
                [image1] AS hiddenImageName1,
                [image2] AS hiddenImageName2,
                [image3] AS hiddenImageName3,
                b.[catid] AS Catid,
                ISNULL([tags], '''') AS tags,
                ispublished AS ispublished,
                ua.name AS username,
                b.createddate AS createddate,
                ISNULL(likecount, 0) AS likecount
            FROM
                [dbo].[tbl_blog] b
            INNER JOIN
                [dbo].[UserAccount] ua ON ua.[userid] = b.[userid]
            INNER JOIN
                [dbo].[tbl_Category] c ON c.Catid = b.catid
            LEFT JOIN
                (SELECT COUNT([likeid]) AS likecount, [blogid] AS blogid
                 FROM [dbo].[tbl_likes]
                 GROUP BY [blogid]) AS li ON li.blogid = b.Blogid
            WHERE
                b.ispublished = 1 AND c.Catid = @categoryId
            ORDER BY
                b.[Blogid] ' + @orderby;

        EXEC sp_executesql @sql, N'@categoryId INT', @categoryId;
    END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_getprofileinfo]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec sp_getprofileinfo 13
-- =============================================
CREATE PROCEDURE [dbo].[sp_getprofileinfo] 
	-- Add the parameters for the stored procedure here
	@userid				int							
	    
AS
BEGIN

	SET NOCOUNT ON;



 SELECT 
 userid       ,
 isnull(name ,'')	as		name,
 isnull(photo,'')	as		photo,
 isnull(instalink,'')	as	instalink,
 isnull(fblink,'')	as	fblink,
 isnull(twitterlink,'') as	twitterlink,
 isnull(bio,'') as 			bio 
 FROM [dbo].[UserAccount] WHERE userid=@userid

END

GO
/****** Object:  StoredProcedure [dbo].[sp_homedetails]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_homedetails]  1
-- =============================================
CREATE PROCEDURE [dbo].[sp_homedetails] 
	-- Add the parameters for the stored procedure here
	
	@userid     int=0 
	
	
AS
BEGIN

	SET NOCOUNT ON;
SELECT *  FROM [dbo].[tbl_Category]
select c.Catid as Catid, c.Catname as Catname 
from		[dbo].[tbl_Category]        c
inner join	[dbo].[tbl_UserCategory]    uc on c.Catid=uc.Catid
where   uc.userid=@userid
SELECT				    b.[Blogid]         as Blogid					,
						b.[userid]		 as userid					,
						[title]			 as title					,
						isnull([blogcontent],'')	 as blogContent					,
						[image1]		 as hiddenImageName1		,
						[image2]		 as hiddenImageName2		,
						[image3]		 as hiddenImageName3		,
						[catid]			 as Catid					,
						isnull([tags],'')			 as tags                    ,
						ispublished      as ispublished				,
						ua.name          as username                ,
						b.createddate    as createddate   ,          
					    isnull(likecount ,0)       as likecount           
  FROM					[dbo].[tbl_blog] b
  inner join            [dbo].[UserAccount] ua  on ua.[userid]=b.[userid]
  left join            (select 	count([likeid]) as likecount ,[blogid] as  blogid
						from     [dbo].[tbl_likes]
						group by [blogid]
						) as li  on li.blogid=b.Blogid
  where				    b.ispublished=1
  order by				[Blogid] desc 

 



 

END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertSelectedCategories]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_InsertSelectedCategories] '2','1,2,3'
--select * from [dbo].[tbl_UserCategory]
-- =============================================
CREATE PROCEDURE [dbo].[sp_InsertSelectedCategories] 
	-- Add the parameters for the stored procedure here
	@userid INT,
    @CategoryIds NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;
INSERT INTO [dbo].[tbl_UserCategory] (userid, Catid)
    SELECT @userid, value
    FROM STRING_SPLIT(@CategoryIds, ',');
if @@ROWCOUNT>0
begin
update [dbo].[UserAccount] set interest=1 where userid=@userid
select interest,userid from [dbo].[UserAccount] where userid=@userid

end
else
begin
select interest,userid from [dbo].[UserAccount] where userid=@userid
END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertUser]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_InsertUser] 
	-- Add the parameters for the stored procedure here
	@name            nvarchar(50)   ,
	@email			 nvarchar(50)	,
	@password			 nvarchar(50),
	@account_type        nvarchar(50),
	@message         NVARCHAR(50) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
INSERT INTO [dbo].[UserAccount]
           (
		 
				[email]				,			
				[name]				,
				[password]			,
				[account_type]      ,
				interest
			)
     VALUES
           (
		   
           @email              ,
           @name			   ,
		   @password		   ,
           @account_type	   ,
		   0
		   )
if @@ROWCOUNT>0
begin
 SET @message = 'success';
  --SET @message = 'Try';
end
else
begin
SET @message = 'An error occurred while processing your request.';
end
END

GO
/****** Object:  StoredProcedure [dbo].[sp_IsUserLogin]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--[dbo].[sp_IsUserLogin]  'admin@gmail.com','123','author'
-- =============================================
CREATE PROCEDURE [dbo].[sp_IsUserLogin] 
	-- Add the parameters for the stored procedure here
	
	@email			 nvarchar(50)=null    ,
	@password         nvarchar(50)=null    ,
	@account_type     nvarchar(50)=null  
	 
	
AS
BEGIN

	SET NOCOUNT ON;
SELECT userid,email,name,account_type,interest  FROM [dbo].[UserAccount] WHERE [email] = @email and password=@password and  account_type=@account_type
   
END

GO
/****** Object:  StoredProcedure [dbo].[sp_nestedcommentunder]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_nestedcommentunder] 48,7
--select * from [dbo].[tbl_comments]
-- =============================================
CREATE PROCEDURE [dbo].[sp_nestedcommentunder] 
	-- Add the parameters for the stored procedure here
	
	@commentId           int,
	@blogid              int
AS
BEGIN

	SET NOCOUNT ON;
select 
					[commentid]											,
					[comment]											,
					[commentaddedid]									,
					c.[blogid]											,
					name as commentaddedname						    ,
					c.createddate      as createddate                   ,
					c.[parentid]     as parentid,
					(
						SELECT COUNT(*) 
						FROM [dbo].[tbl_comments] nested 
						WHERE nested.parentid = c.commentid and nested.blogid=@blogid
					 ) as nestedCommentCount
 from				[dbo].[tbl_comments] c
 inner join         [dbo].[UserAccount]  u on  c.commentaddedid=u.userid
 where            c.[parentid]=@commentId



 
 

END

GO
/****** Object:  StoredProcedure [dbo].[sp_publishchanges]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_publishchanges] 
	-- Add the parameters for the stored procedure here
	     @status int ,
		 @blogid int
		 
AS
BEGIN

	SET NOCOUNT ON;
	update [dbo].[tbl_blog] set ispublished=@status where Blogid=@blogid
	 IF @@ROWCOUNT > 0
	 begin
	 if @status=1
	 begin
	 select 'blog published successfully'  as message
	 end
	 else
	 begin
	 	 select 'blog ubpublished successfully'  as message

	 end
	 end

END

GO
/****** Object:  StoredProcedure [dbo].[sp_searchblogs]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[sp_searchblogs] 'css'
--exec [dbo].[sp_filterblogs] '','2024-01-01 10:43:07.603','2024-01-27 14:03:52.853'
--select * from [dbo].[tbl_blog]
CREATE PROCEDURE [dbo].[sp_searchblogs] 
    @searchkeyword NVARCHAR(MAX) = NULL,
    @orderby NVARCHAR(MAX) = 'desc'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
        SELECT  b.[Blogid] AS Blogid,
                b.[userid] AS userid,
                b.[title] AS title,
                ISNULL(b.[blogcontent], '''') AS blogContent,
                b.[image1] AS hiddenImageName1,
                b.[image2] AS hiddenImageName2,
                b.[image3] AS hiddenImageName3,
                b.[catid] AS Catid,
                ISNULL(b.[tags], '''') AS tags,
                b.ispublished AS ispublished,
                ua.name AS username,
                b.createddate AS createddate,
                ISNULL(li.likecount, 0) AS likecount           
        FROM    [dbo].[tbl_blog] b
                INNER JOIN [dbo].[UserAccount] ua ON ua.[userid] = b.[userid]
                INNER JOIN [dbo].[tbl_Category] c ON c.Catid = b.catid
                LEFT JOIN (
                    SELECT  COUNT([likeid]) AS likecount, [blogid] AS blogid
                    FROM    [dbo].[tbl_likes]
                    GROUP BY [blogid]
                ) AS li ON li.blogid = b.Blogid
        WHERE   ispublished = 1
                AND (   c.Catname LIKE ''%' + @searchkeyword + '%''
                        OR b.title LIKE ''%' + @searchkeyword + '%''
                        OR b.tags LIKE ''%' + @searchkeyword + '%''
                        OR b.blogcontent LIKE ''%' + @searchkeyword + '%''
                    )
        ORDER BY b.[Blogid] ' + @orderby + ';
    ';

    EXEC sp_executesql @sql;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SelectCategory]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_SelectCategory] 1,1
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectCategory] 
	-- Add the parameters for the stored procedure here
	
	@userid     int ,
	@Blogid     int=0
	
AS
BEGIN

	SET NOCOUNT ON;
SELECT *  FROM [dbo].[tbl_Category]
select count(Catid) as categorycount from [dbo].[tbl_UserCategory] where userid=@userid
   if(@Blogid!=0)
   begin
   SELECT				[Blogid]         as Blogid					,
						[userid]		 as userid					,
						[title]			 as title					,
						isnull([blogcontent],'')	 as blogcontent					,
						[image1]		 as hiddenImageName1		,
						[image2]		 as hiddenImageName2		,
						[image3]		 as hiddenImageName3		,
						[catid]			 as Catid					,
						isnull([tags],'')			 as tags                    ,
						ispublished      as ispublished
  FROM					[dbo].[tbl_blog]
  where				    [Blogid]=@Blogid   and [userid]=@userid
   end

END

GO
/****** Object:  StoredProcedure [dbo].[sp_SelectCategoryadmin]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[sp_SelectCategory] 1,1
-- =============================================
create PROCEDURE [dbo].[sp_SelectCategoryadmin] 
	-- Add the parameters for the stored procedure here
	

AS
BEGIN

	SET NOCOUNT ON;
SELECT *  FROM [dbo].[tbl_Category]


END

GO
/****** Object:  StoredProcedure [dbo].[sp_updateprofile]    Script Date: 1/31/2024 9:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_updateprofile] 
	-- Add the parameters for the stored procedure here
	@userid				int							,
	@instalink          nvarchar(max)=null			,
	@facebooklink		 nvarchar(max)=null			,
	@twitterlink		  nvarchar(max)=null		,
	@photo                nvarchar(max)=null		,
	@bio                  nvarchar(max)=null        ,
	@name                 nvarchar(max)=null       
AS
BEGIN

	SET NOCOUNT ON;
UPDATE [dbo].[UserAccount]
   SET 
			[photo] = @photo				,
			[instalink] = @instalink		,
			[fblink] = @facebooklink		,
			[twitterlink] = @twitterlink	,
			[bio] = @bio,
			name=@name
 WHERE      userid=@userid


 SELECT 
 userid,
 isnull(name,'')			as name           ,
 isnull(photo,'')			as photo		  ,
 isnull(instalink,'')		as  instalink	  ,
 isnull(fblink,'')			as  fblink		  ,
 isnull(twitterlink,'')		as   twitterlink  ,
 isnull(bio,'')             as  bio			  
 FROM 
 [dbo].[UserAccount] 
 WHERE userid=@userid

END

GO
USE [master]
GO
ALTER DATABASE [Blog ] SET  READ_WRITE 
GO
