USE [master]
GO
/****** Object:  Database [UZDB]    Script Date: 21.2.2013. 8:27:09 ******/
CREATE DATABASE [UZDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UZDEB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\UZDEB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'UZDEB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\UZDEB_log.ldf' , SIZE = 4224KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [UZDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [UZDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [UZDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [UZDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [UZDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [UZDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [UZDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [UZDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [UZDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [UZDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [UZDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [UZDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [UZDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [UZDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [UZDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [UZDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [UZDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [UZDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [UZDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [UZDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [UZDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [UZDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [UZDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [UZDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [UZDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [UZDB] SET RECOVERY FULL 
GO
ALTER DATABASE [UZDB] SET  MULTI_USER 
GO
ALTER DATABASE [UZDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [UZDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [UZDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [UZDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'UZDB', N'ON'
GO
USE [UZDB]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRating]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteRating]
@ArticleID INT
AS
DELETE FROM dbo.ArticlesRating 
WHERE ArticlesID = @ArticleID
GO
/****** Object:  StoredProcedure [dbo].[DeleteTagInArticles]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteTagInArticles]
@ArticleID INT
AS
DELETE FROM dbo.TagInArticle 
WHERE Articles_ArticlesID = @ArticleID
GO
/****** Object:  StoredProcedure [dbo].[DeleteTagInCategory]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteTagInCategory]
@ArticleID INT
AS
DELETE FROM dbo.ArticlesInCategory 
WHERE ArticleID = @ArticleID
GO
/****** Object:  StoredProcedure [dbo].[GetAiComplete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAiComplete]
@Args NVARCHAR(max)
AS
SELECT A.* FROM dbo.Article as A
JOIN dbo.GetListaInteger(@Args) AS F
	  ON A.ArticlesID = F.number
GO
/****** Object:  StoredProcedure [dbo].[GetPretragaWiki]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetPretragaWiki]
(
  @Strana int,
  @Velicina int,
  @ArIDs varchar(max),
  @Score varchar(max)
)
AS
SET NOCOUNT ON;

SELECT TOP(@Velicina) * FROM 
(
 SELECT RedID = ROW_NUMBER() OVER(ORDER BY S.number desc), 
A.*,BrojRedova=Count(*) OVER()
 FROM dbo.Article As A JOIN dbo.GetListaInteger(@ArIDs) AS F
	  ON A.ArticlesID = F.number LEFT JOIN [dbo].[GetScoreParse](@Score) AS S ON
	  F.i = S.i
) 

T WHERE T.RedID > ((@Strana-1)*@Velicina)

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[GetRoleByUserID]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetRoleByUserID]
@UserID INT
AS
SELECT R.* FROM dbo.[User] AS U JOIN dbo.UserRole AS UR ON
		 UR.[User_UserID] = U.[UserID] JOIN dbo.Role AS R ON
		 R.[RoleID] = UR.[Role_RoleID]
WHERE U.UserID =@UserID
GO
/****** Object:  StoredProcedure [dbo].[GetTags]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetTags]
@Args NVARCHAR(max)
AS
SELECT * FROM dbo.Tag
WHERE Name LIKE ('%'+@Args+'%')
GO
/****** Object:  StoredProcedure [dbo].[IncerementLikes]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IncerementLikes]
@id INT
AS
UPDATE dbo.Article
SET Likes = Likes +1
WHERE ArticlesID = @id
GO
/****** Object:  StoredProcedure [dbo].[IncerementViews]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IncerementViews]
@Id INT
AS
UPDATE dbo.Article
SET Views = Views +1
WHERE ArticlesID = @id
GO
/****** Object:  StoredProcedure [dbo].[PagingTagWiki]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PagingTagWiki]
(
  @Strana int,
  @Velicina int,
  @TagID int
)
AS
SET NOCOUNT ON;

SELECT TOP(@Velicina) * FROM 
(
 SELECT RedID = ROW_NUMBER() OVER (ORDER BY A.ArticlesID desc), 
  A.*,BrojRedova=Count(*) OVER()
 FROM dbo.Article as A JOIN dbo.TagInArticle as TA ON A.ArticlesID = TA.Articles_ArticlesID
        JOIN dbo.Tag  AS T ON  TA.Tag_TagID = T.TagID

 WHERE T.TagID = @TagID
 
) 

T WHERE T.RedID > ((@Strana-1)*@Velicina)
Order by T.ArticlesID desc
SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[PreoprukaTaga]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PreoprukaTaga]
@Arg NVARCHAR(Max)
AS
SELECT DISTINCT  T.*, CONVERT(INT, dbo.LEVENSHTEIN(Name, @Arg)) AS Rez
FROM dbo.Tag AS T
WHERE Name <> @Arg AND (CONVERT(INT, dbo.LEVENSHTEIN(Name, @Arg)) <=2 OR SOUNDEX(Name) = SOUNDEX(@Arg))
ORDER BY Rez 
GO
/****** Object:  StoredProcedure [dbo].[usp_AnswersDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_AnswersDelete] 
    @AnswerID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Answers]
	WHERE  [AnswerID] = @AnswerID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_AnswersInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_AnswersInsert] 
    @Answer nvarchar(MAX),
    @IsSpam bit,
    @CreatorID int,
    @CreatedID datetime,
    @QuestionID int,
    @GUID uniqueidentifier,
    @Likes int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Answer] ([AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes])
	SELECT @Answer, @IsSpam, @CreatorID, @CreatedID, @QuestionID, @GUID, @Likes
	
	-- Begin Return Select <- do not remove
	SELECT [AnswerID], [AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]
	FROM   [dbo].[Answer]
	WHERE  [AnswerID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_AnswersSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_AnswersSelect] 
    @AnswerID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [AnswerID], [Answer], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes] 
	FROM   [dbo].[Answers] 
	WHERE  ([AnswerID] = @AnswerID OR @AnswerID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_AnswersUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_AnswersUpdate] 
    @AnswerID int,
    @Answer nvarchar(MAX),
    @IsSpam bit,
    @CreatorID int,
    @CreatedID datetime,
    @QuestionID int,
    @GUID uniqueidentifier,
    @Likes int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Answers]
	SET    [Answer] = @Answer, [IsSpam] = @IsSpam, [CreatorID] = @CreatorID, [CreatedID] = @CreatedID, [QuestionID] = @QuestionID, [GUID] = @GUID, [Likes] = @Likes
	WHERE  [AnswerID] = @AnswerID
	
	-- Begin Return Select <- do not remove
	SELECT [AnswerID], [Answer], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]
	FROM   [dbo].[Answers]
	WHERE  [AnswerID] = @AnswerID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesDelete] 
    @ArticlesID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Article]
	WHERE  [ArticlesID] = @ArticlesID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategoryDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesInCategoryDelete] 
    @ArticleID int,
    @CategoryID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ArticlesInCategory]
	WHERE  [ArticleID] = @ArticleID
	       AND [CategoryID] = @CategoryID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategoryInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesInCategoryInsert] 
    @ArticleID int,
    @CategoryID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID])
	SELECT @ArticleID, @CategoryID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticleID], [CategoryID]
	FROM   [dbo].[ArticlesInCategory]
	WHERE  [ArticleID] = @ArticleID
	       AND [CategoryID] = @CategoryID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategorySelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesInCategorySelect] 
    @ArticleID INT,
    @CategoryID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ArticleID], [CategoryID] 
	FROM   [dbo].[ArticlesInCategory] 
	WHERE  ([ArticleID] = @ArticleID OR @ArticleID IS NULL) 
	       AND ([CategoryID] = @CategoryID OR @CategoryID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategoryUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesInCategoryUpdate] 
    @ArticleID int,
    @CategoryID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ArticlesInCategory]
	SET    [ArticleID] = @ArticleID, [CategoryID] = @CategoryID
	WHERE  [ArticleID] = @ArticleID
	       AND [CategoryID] = @CategoryID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticleID], [CategoryID]
	FROM   [dbo].[ArticlesInCategory]
	WHERE  [ArticleID] = @ArticleID
	       AND [CategoryID] = @CategoryID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesInsert] 
    @Name nvarchar(MAX),
    @Summary nvarchar(MAX),
    @Content nvarchar(MAX),
    @DatePublish datetime,
    @IsPublish bit,
    @IsActive bit,
    @Views int,
    @GUID uniqueidentifier,
    @CreatorIP nvarchar(MAX),
    @ModiferIP nvarchar(MAX),
    @CreatorUserAgent nvarchar(MAX),
    @CategoryID int,
    @UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Article] ([Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID])
	SELECT @Name, @Summary, @Content, @DatePublish, @IsPublish, @IsActive, @Views, @GUID, @CreatorIP, @ModiferIP, @CreatorUserAgent, @CategoryID, @UserID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID]
	FROM   [dbo].[Article]
	WHERE  [ArticlesID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesLikesDelete] 
    @ArticleID int,
    @UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ArticlesLikes]
	WHERE  [ArticleID] = @ArticleID
	       AND [UserID] = @UserID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesLikesInsert] 
    @ArticleID int,
    @UserID int,
    @DateLike datetime,
    @CreatorIP nvarchar(50),
    @GUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID])
	SELECT @ArticleID, @UserID, @DateLike, @CreatorIP, @GUID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]
	FROM   [dbo].[ArticlesLikes]
	WHERE  [ArticleID] = @ArticleID
	       AND [UserID] = @UserID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesLikesSelect] 
    @ArticleID INT,
    @UserID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ArticleID], [UserID], [DateLike], [CreatorIP], [GUID] 
	FROM   [dbo].[ArticlesLikes] 
	WHERE  ([ArticleID] = @ArticleID OR @ArticleID IS NULL) 
	       AND ([UserID] = @UserID OR @UserID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesLikesUpdate] 
    @ArticleID int,
    @UserID int,
    @DateLike datetime,
    @CreatorIP nvarchar(50),
    @GUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ArticlesLikes]
	SET    [ArticleID] = @ArticleID, [UserID] = @UserID, [DateLike] = @DateLike, [CreatorIP] = @CreatorIP, [GUID] = @GUID
	WHERE  [ArticleID] = @ArticleID
	       AND [UserID] = @UserID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]
	FROM   [dbo].[ArticlesLikes]
	WHERE  [ArticleID] = @ArticleID
	       AND [UserID] = @UserID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesRatingDelete] 
    @ArticlesID int,
    @UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ArticlesRating]
	WHERE  [ArticlesID] = @ArticlesID
	       AND [UserID] = @UserID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesRatingInsert] 
    @ArticlesID int,
    @UserID int,
    @DateRating datetime,
    @CreatorIP datetime,
    @GUID uniqueidentifier,
    @Score int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score])
	SELECT @ArticlesID, @UserID, @DateRating, @CreatorIP, @GUID, @Score
	
	-- Begin Return Select <- do not remove
	SELECT [ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]
	FROM   [dbo].[ArticlesRating]
	WHERE  [ArticlesID] = @ArticlesID
	       AND [UserID] = @UserID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesRatingSelect] 
    @ArticlesID INT,
    @UserID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score] 
	FROM   [dbo].[ArticlesRating] 
	WHERE  ([ArticlesID] = @ArticlesID OR @ArticlesID IS NULL) 
	       AND ([UserID] = @UserID OR @UserID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesRatingUpdate] 
    @ArticlesID int,
    @UserID int,
    @DateRating datetime,
    @CreatorIP datetime,
    @GUID uniqueidentifier,
    @Score int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ArticlesRating]
	SET    [ArticlesID] = @ArticlesID, [UserID] = @UserID, [DateRating] = @DateRating, [CreatorIP] = @CreatorIP, [GUID] = @GUID, [Score] = @Score
	WHERE  [ArticlesID] = @ArticlesID
	       AND [UserID] = @UserID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]
	FROM   [dbo].[ArticlesRating]
	WHERE  [ArticlesID] = @ArticlesID
	       AND [UserID] = @UserID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesSelect] 
    @ArticlesID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID] 
	FROM   [dbo].[Articles] 
	WHERE  ([ArticlesID] = @ArticlesID OR @ArticlesID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_ArticlesUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ArticlesUpdate] 
    @ArticlesID int,
    @Name nvarchar(MAX),
    @Summary nvarchar(MAX),
    @Content nvarchar(MAX),
    @DatePublish datetime,
    @IsPublish bit,
    @IsActive bit,
    @Views int,
    @GUID uniqueidentifier,
    @CreatorIP nvarchar(MAX),
    @ModiferIP nvarchar(MAX),
    @CreatorUserAgent nvarchar(MAX),
    @CategoryID int,
    @UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Articles]
	SET    [Name] = @Name, [Summary] = @Summary, [Content] = @Content, [DatePublish] = @DatePublish, [IsPublish] = @IsPublish, [IsActive] = @IsActive, [Views] = @Views, [GUID] = @GUID, [CreatorIP] = @CreatorIP, [ModiferIP] = @ModiferIP, [CreatorUserAgent] = @CreatorUserAgent, [CategoryID] = @CategoryID, [UserID] = @UserID
	WHERE  [ArticlesID] = @ArticlesID
	
	-- Begin Return Select <- do not remove
	SELECT [ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID]
	FROM   [dbo].[Articles]
	WHERE  [ArticlesID] = @ArticlesID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CategoryDelete] 
    @CategoryID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Category]
	WHERE  [CategoryID] = @CategoryID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CategoryInsert] 
    @GUID uniqueidentifier,
    @Name nvarchar(255),
    @Description nvarchar(500)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Category] ([GUID], [Name], [Description])
	SELECT @GUID, @Name, @Description
	
	-- Begin Return Select <- do not remove
	SELECT [CategoryID], [GUID], [Name], [Description]
	FROM   [dbo].[Category]
	WHERE  [CategoryID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CategorySelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CategorySelect] 
    @CategoryID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [CategoryID], [GUID], [Name], [Description] 
	FROM   [dbo].[Category] 
	WHERE  ([CategoryID] = @CategoryID OR @CategoryID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CategoryUpdate] 
    @CategoryID int,
    @GUID uniqueidentifier,
    @Name nvarchar(255),
    @Description nvarchar(500)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Category]
	SET    [GUID] = @GUID, [Name] = @Name, [Description] = @Description
	WHERE  [CategoryID] = @CategoryID
	
	-- Begin Return Select <- do not remove
	SELECT [CategoryID], [GUID], [Name], [Description]
	FROM   [dbo].[Category]
	WHERE  [CategoryID] = @CategoryID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CityDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CityDelete] 
    @CityID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[City]
	WHERE  [CityID] = @CityID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CityInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CityInsert] 
    @GUID uniqueidentifier,
    @CountryID int,
    @Name nvarchar(255),
    @ZipCode varchar(20)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[City] ([GUID], [CountryID], [Name], [ZipCode])
	SELECT @GUID, @CountryID, @Name, @ZipCode
	
	-- Begin Return Select <- do not remove
	SELECT [CityID], [GUID], [CountryID], [Name], [ZipCode]
	FROM   [dbo].[City]
	WHERE  [CityID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CitySelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CitySelect] 
    @CityID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [CityID], [GUID], [CountryID], [Name], [ZipCode] 
	FROM   [dbo].[City] 
	WHERE  ([CityID] = @CityID OR @CityID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CityUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CityUpdate] 
    @CityID int,
    @GUID uniqueidentifier,
    @CountryID int,
    @Name nvarchar(255),
    @ZipCode varchar(20)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[City]
	SET    [GUID] = @GUID, [CountryID] = @CountryID, [Name] = @Name, [ZipCode] = @ZipCode
	WHERE  [CityID] = @CityID
	
	-- Begin Return Select <- do not remove
	SELECT [CityID], [GUID], [CountryID], [Name], [ZipCode]
	FROM   [dbo].[City]
	WHERE  [CityID] = @CityID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CommentDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CommentDelete] 
    @CommentID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Comment]
	WHERE  [CommentID] = @CommentID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CommentInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CommentInsert] 
    @GUID uniqueidentifier,
    @CreatorIP varchar(50),
    @CreatorUserAgent varchar(MAX),
    @CreatorEmail nvarchar(100),
    @CreatorName nvarchar(50),
    @Title nvarchar(255),
    @Body nvarchar(500),
    @IsActive bit,
    @IsSpam bit,
    @Created datetime,
    @CreatedByUserID int,
    @Modified datetime,
    @ModifiedByUserID int,
    @ArticleID int,
	@AnswerID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Comment] ([GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID],[AnswerID])
	SELECT @GUID, @CreatorIP, @CreatorUserAgent, @CreatorEmail, @CreatorName, @Title, @Body, @IsActive, @IsSpam, @Created, @CreatedByUserID, @Modified, @ModifiedByUserID, @ArticleID,@AnswerID
	
	-- Begin Return Select <- do not remove
	SELECT [CommentID], [GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID],[AnswerID]
	FROM   [dbo].[Comment]
	WHERE  [CommentID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CommentSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CommentSelect] 
    @CommentID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [CommentID], [GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID] 
	FROM   [dbo].[Comment] 
	WHERE  ([CommentID] = @CommentID OR @CommentID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CommentUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CommentUpdate] 
    @CommentID int,
    @GUID uniqueidentifier,
    @CreatorIP varchar(50),
    @CreatorUserAgent varchar(MAX),
    @CreatorEmail nvarchar(100),
    @CreatorName nvarchar(50),
    @Title nvarchar(255),
    @Body nvarchar(500),
    @IsActive bit,
    @IsSpam bit,
    @Created datetime,
    @CreatedByUserID int,
    @Modified datetime,
    @ModifiedByUserID int,
    @ArticleID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Comment]
	SET    [GUID] = @GUID, [CreatorIP] = @CreatorIP, [CreatorUserAgent] = @CreatorUserAgent, [CreatorEmail] = @CreatorEmail, [CreatorName] = @CreatorName, [Title] = @Title, [Body] = @Body, [IsActive] = @IsActive, [IsSpam] = @IsSpam, [Created] = @Created, [CreatedByUserID] = @CreatedByUserID, [Modified] = @Modified, [ModifiedByUserID] = @ModifiedByUserID, [ArticleID] = @ArticleID
	WHERE  [CommentID] = @CommentID
	
	-- Begin Return Select <- do not remove
	SELECT [CommentID], [GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID]
	FROM   [dbo].[Comment]
	WHERE  [CommentID] = @CommentID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CountryDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CountryDelete] 
    @CountryID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Country]
	WHERE  [CountryID] = @CountryID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CountryInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CountryInsert] 
    @GUID uniqueidentifier,
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Country] ([GUID], [Name])
	SELECT @GUID, @Name
	
	-- Begin Return Select <- do not remove
	SELECT [CountryID], [GUID], [Name]
	FROM   [dbo].[Country]
	WHERE  [CountryID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CountrySelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CountrySelect] 
    @CountryID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [CountryID], [GUID], [Name] 
	FROM   [dbo].[Country] 
	WHERE  ([CountryID] = @CountryID OR @CountryID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_CountryUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CountryUpdate] 
    @CountryID int,
    @GUID uniqueidentifier,
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Country]
	SET    [GUID] = @GUID, [Name] = @Name
	WHERE  [CountryID] = @CountryID
	
	-- Begin Return Select <- do not remove
	SELECT [CountryID], [GUID], [Name]
	FROM   [dbo].[Country]
	WHERE  [CountryID] = @CountryID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_QuestionsDelete] 
    @QuestionID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Questions]
	WHERE  [QuestionID] = @QuestionID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsInCategoryInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_QuestionsInCategoryInsert]
    @QuestionID int,
    @CategoryID int
   
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[QuestionInCategory]([QuestionID] ,[CategoryID])
	SELECT @QuestionID, @CategoryID
	
	-- Begin Return Select <- do not remove
	SELECT * 
	FROM   [dbo].[QuestionInCategory]
	WHERE  CategoryID = @CategoryID
	       AND QuestionID = @QuestionID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_QuestionsInsert] 
    @Question nvarchar(MAX),
    @CreatorID int,
    @CreatedDate datetime,
    @GUID uniqueidentifier,
	@QuestionTitle varchar(200),
    @Likes int,
	@NumOfViews int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Question] ([QuestionBody], [CreatorID], [CreatedDate], [GUID],[QuestionTitle], [Likes], [NumOfViews])
	SELECT @Question, @CreatorID, @CreatedDate, @GUID,@QuestionTitle, @Likes, @NumOfViews
	
	-- Begin Return Select <- do not remove
	SELECT [QuestionID], [QuestionBody], [CreatorID], [CreatedDate],[GUID],[QuestionTitle], [Likes], [NumOfViews]
	FROM   [dbo].[Question]
	WHERE  [QuestionID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_QuestionsSelect] 
    @QuestionID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [QuestionID], [Question], [CreatorID], [CreatedDate], [CategoryID], [GUID], [Likes] 
	FROM   [dbo].[Questions] 
	WHERE  ([QuestionID] = @QuestionID OR @QuestionID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_QuestionsUpdate] 
    @QuestionID int,
    @Question nvarchar(MAX),
    @CreatorID int,
    @CreatedDate datetime,	
    @GUID uniqueidentifier,
    @Likes int,
	@NumOfViews int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Question]
	SET    [QuestionBody] = @Question, [CreatorID] = @CreatorID, [CreatedDate] = @CreatedDate, [GUID] = @GUID, [Likes] = @Likes, [NumOfViews]=@NumOfViews
	WHERE  [QuestionID] = @QuestionID
	
	-- Begin Return Select <- do not remove
	SELECT [QuestionID], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]
	FROM   [dbo].[Question]
	WHERE  [QuestionID] = @QuestionID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_RoleDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_RoleDelete] 
    @RoleID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Role]
	WHERE  [RoleID] = @RoleID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_RoleInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_RoleInsert] 
    @GUID uniqueidentifier,
    @Name nvarchar(255),
    @Description nvarchar(500)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Role] ([GUID], [Name], [Description])
	SELECT @GUID, @Name, @Description
	
	-- Begin Return Select <- do not remove
	SELECT [RoleID], [GUID], [Name], [Description]
	FROM   [dbo].[Role]
	WHERE  [RoleID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_RoleSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_RoleSelect] 
    @RoleID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RoleID], [GUID], [Name], [Description] 
	FROM   [dbo].[Role] 
	WHERE  ([RoleID] = @RoleID OR @RoleID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_RoleUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_RoleUpdate] 
    @RoleID int,
    @GUID uniqueidentifier,
    @Name nvarchar(255),
    @Description nvarchar(500)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Role]
	SET    [GUID] = @GUID, [Name] = @Name, [Description] = @Description
	WHERE  [RoleID] = @RoleID
	
	-- Begin Return Select <- do not remove
	SELECT [RoleID], [GUID], [Name], [Description]
	FROM   [dbo].[Role]
	WHERE  [RoleID] = @RoleID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_SelectComments]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SelectComments]
	
	@QuestionID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Question q join Answer a on q.QuestionID=a.QuestionID
	 join Comment c on a.AnswerID=c.AnswerID where q.QuestionID=@QuestionID
	 END

GO
/****** Object:  StoredProcedure [dbo].[usp_TagDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagDelete] 
    @TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Tag]
	WHERE  [TagID] = @TagID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInArticleDelete] 
    @Articles_ArticlesID int,
    @Tag_TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[TagInArticle]
	WHERE  [Articles_ArticlesID] = @Articles_ArticlesID
	       AND [Tag_TagID] = @Tag_TagID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInArticleInsert] 
    @Articles_ArticlesID int,
    @Tag_TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID])
	SELECT @Articles_ArticlesID, @Tag_TagID
	
	-- Begin Return Select <- do not remove
	SELECT [Articles_ArticlesID], [Tag_TagID]
	FROM   [dbo].[TagInArticle]
	WHERE  [Articles_ArticlesID] = @Articles_ArticlesID
	       AND [Tag_TagID] = @Tag_TagID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInArticleSelect] 
    @Articles_ArticlesID INT,
    @Tag_TagID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Articles_ArticlesID], [Tag_TagID] 
	FROM   [dbo].[TagInArticle] 
	WHERE  ([Articles_ArticlesID] = @Articles_ArticlesID OR @Articles_ArticlesID IS NULL) 
	       AND ([Tag_TagID] = @Tag_TagID OR @Tag_TagID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInArticleUpdate] 
    @Articles_ArticlesID int,
    @Tag_TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[TagInArticle]
	SET    [Articles_ArticlesID] = @Articles_ArticlesID, [Tag_TagID] = @Tag_TagID
	WHERE  [Articles_ArticlesID] = @Articles_ArticlesID
	       AND [Tag_TagID] = @Tag_TagID
	
	-- Begin Return Select <- do not remove
	SELECT [Articles_ArticlesID], [Tag_TagID]
	FROM   [dbo].[TagInArticle]
	WHERE  [Articles_ArticlesID] = @Articles_ArticlesID
	       AND [Tag_TagID] = @Tag_TagID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInQuestionDelete] 
    @Questions_QuestionID int,
    @Tag_TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[TagInQuestion]
	WHERE  [Questions_QuestionID] = @Questions_QuestionID
	       AND [Tag_TagID] = @Tag_TagID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInQuestionInsert] 
    @Questions_QuestionID int,
    @Tag_TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID])
	SELECT @Questions_QuestionID, @Tag_TagID
	
	-- Begin Return Select <- do not remove
	SELECT [Questions_QuestionID], [Tag_TagID]
	FROM   [dbo].[TagInQuestion]
	WHERE  [Questions_QuestionID] = @Questions_QuestionID
	       AND [Tag_TagID] = @Tag_TagID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInQuestionSelect] 
    @Questions_QuestionID INT,
    @Tag_TagID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Questions_QuestionID], [Tag_TagID] 
	FROM   [dbo].[TagInQuestion] 
	WHERE  ([Questions_QuestionID] = @Questions_QuestionID OR @Questions_QuestionID IS NULL) 
	       AND ([Tag_TagID] = @Tag_TagID OR @Tag_TagID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInQuestionUpdate] 
    @Questions_QuestionID int,
    @Tag_TagID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[TagInQuestion]
	SET    [Questions_QuestionID] = @Questions_QuestionID, [Tag_TagID] = @Tag_TagID
	WHERE  [Questions_QuestionID] = @Questions_QuestionID
	       AND [Tag_TagID] = @Tag_TagID
	
	-- Begin Return Select <- do not remove
	SELECT [Questions_QuestionID], [Tag_TagID]
	FROM   [dbo].[TagInQuestion]
	WHERE  [Questions_QuestionID] = @Questions_QuestionID
	       AND [Tag_TagID] = @Tag_TagID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagInsert] 
    @GUID uniqueidentifier,
    @Name nvarchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Tag] ([GUID], [Name])
	SELECT @GUID, @Name
	
	-- Begin Return Select <- do not remove
	SELECT [TagID], [GUID], [Name]
	FROM   [dbo].[Tag]
	WHERE  [TagID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagSelect] 
    @TagID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [TagID], [GUID], [Name] 
	FROM   [dbo].[Tag] 
	WHERE  ([TagID] = @TagID OR @TagID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_TagUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_TagUpdate] 
    @TagID int,
    @GUID uniqueidentifier,
    @Name nvarchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Tag]
	SET    [GUID] = @GUID, [Name] = @Name
	WHERE  [TagID] = @TagID
	
	-- Begin Return Select <- do not remove
	SELECT [TagID], [GUID], [Name]
	FROM   [dbo].[Tag]
	WHERE  [TagID] = @TagID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserDelete] 
    @UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[User]
	WHERE  [UserID] = @UserID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserInsert] 
    @GUID uniqueidentifier,
    @FirstName nvarchar(255),
    @LastName nvarchar(255),
    @Gender char(1),
    @Phone varchar(50),
    @Address nvarchar(255),
    @CityID int,
    @UserName nvarchar(256),
    @Password nvarchar(128),
    @PasswordFormat int,
    @PasswordSalt nvarchar(128),
    @Email nvarchar(256),
    @LoweredEmail nvarchar(256),
    @PasswordQuestion nvarchar(256),
    @PasswordAnswer nvarchar(128),
    @PhotoLocation nvarchar(500),
    @LastActivity datetime,
    @LastLogin datetime,
    @LastPasswordChange datetime,
    @LastLockout datetime,
    @IsApproved bit,
    @IsLockedOut bit,
    @Created datetime,
    @Modified datetime,
    @Description nvarchar(MAX),
    @LocationCover nvarchar(MAX),
    @CoverPostion nvarchar(MAX),
    @IsFirst bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[User] ([GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst])
	SELECT @GUID, @FirstName, @LastName, @Gender, @Phone, @Address, @CityID, @UserName, @Password, @PasswordFormat, @PasswordSalt, @Email, @LoweredEmail, @PasswordQuestion, @PasswordAnswer, @PhotoLocation, @LastActivity, @LastLogin, @LastPasswordChange, @LastLockout, @IsApproved, @IsLockedOut, @Created, @Modified, @Description, @LocationCover, @CoverPostion, @IsFirst
	
	-- Begin Return Select <- do not remove
	SELECT [UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]
	FROM   [dbo].[User]
	WHERE  [UserID] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserRoleDelete]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserRoleDelete] 
    @Role_RoleID int,
    @User_UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[UserRole]
	WHERE  [Role_RoleID] = @Role_RoleID
	       AND [User_UserID] = @User_UserID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserRoleInsert]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserRoleInsert] 
    @Role_RoleID int,
    @User_UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[UserRole] ([Role_RoleID], [User_UserID])
	SELECT @Role_RoleID, @User_UserID
	
	-- Begin Return Select <- do not remove
	SELECT [Role_RoleID], [User_UserID]
	FROM   [dbo].[UserRole]
	WHERE  [Role_RoleID] = @Role_RoleID
	       AND [User_UserID] = @User_UserID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserRoleSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserRoleSelect] 
    @Role_RoleID INT,
    @User_UserID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Role_RoleID], [User_UserID] 
	FROM   [dbo].[UserRole] 
	WHERE  ([Role_RoleID] = @Role_RoleID OR @Role_RoleID IS NULL) 
	       AND ([User_UserID] = @User_UserID OR @User_UserID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserRoleUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserRoleUpdate] 
    @Role_RoleID int,
    @User_UserID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[UserRole]
	SET    [Role_RoleID] = @Role_RoleID, [User_UserID] = @User_UserID
	WHERE  [Role_RoleID] = @Role_RoleID
	       AND [User_UserID] = @User_UserID
	
	-- Begin Return Select <- do not remove
	SELECT [Role_RoleID], [User_UserID]
	FROM   [dbo].[UserRole]
	WHERE  [Role_RoleID] = @Role_RoleID
	       AND [User_UserID] = @User_UserID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserSelect]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserSelect] 
    @UserID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst] 
	FROM   [dbo].[User] 
	WHERE  ([UserID] = @UserID OR @UserID IS NULL) 

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_UserUpdate]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_UserUpdate] 
    @UserID int,
    @GUID uniqueidentifier,
    @FirstName nvarchar(255),
    @LastName nvarchar(255),
    @Gender char(1),
    @Phone varchar(50),
    @Address nvarchar(255),
    @CityID int,
    @UserName nvarchar(256),
    @Password nvarchar(128),
    @PasswordFormat int,
    @PasswordSalt nvarchar(128),
    @Email nvarchar(256),
    @LoweredEmail nvarchar(256),
    @PasswordQuestion nvarchar(256),
    @PasswordAnswer nvarchar(128),
    @PhotoLocation nvarchar(500),
    @LastActivity datetime,
    @LastLogin datetime,
    @LastPasswordChange datetime,
    @LastLockout datetime,
    @IsApproved bit,
    @IsLockedOut bit,
    @Created datetime,
    @Modified datetime,
    @Description nvarchar(MAX),
    @LocationCover nvarchar(MAX),
    @CoverPostion nvarchar(MAX),
    @IsFirst bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[User]
	SET    [GUID] = @GUID, [FirstName] = @FirstName, [LastName] = @LastName, [Gender] = @Gender, [Phone] = @Phone, [Address] = @Address, [CityID] = @CityID, [UserName] = @UserName, [Password] = @Password, [PasswordFormat] = @PasswordFormat, [PasswordSalt] = @PasswordSalt, [Email] = @Email, [LoweredEmail] = @LoweredEmail, [PasswordQuestion] = @PasswordQuestion, [PasswordAnswer] = @PasswordAnswer, [PhotoLocation] = @PhotoLocation, [LastActivity] = @LastActivity, [LastLogin] = @LastLogin, [LastPasswordChange] = @LastPasswordChange, [LastLockout] = @LastLockout, [IsApproved] = @IsApproved, [IsLockedOut] = @IsLockedOut, [Created] = @Created, [Modified] = @Modified, [Description] = @Description, [LocationCover] = @LocationCover, [CoverPostion] = @CoverPostion, [IsFirst] = @IsFirst
	WHERE  [UserID] = @UserID
	
	-- Begin Return Select <- do not remove
	SELECT [UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]
	FROM   [dbo].[User]
	WHERE  [UserID] = @UserID	
	-- End Return Select <- do not remove

	COMMIT

GO
/****** Object:  UserDefinedFunction [dbo].[A2ROMAN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[A2ROMAN](@n int ) 
--Converts an arabic numeral to roman, as a string.
returns VARCHAR(20)
as
BEGIN
DECLARE @i int, @temp char(1), @s VARCHAR(20)
DECLARE @p1 char(4),@p2 char(4),@p3 char(4),@p4 char(4)
SET @s=STR(@n,4,0)
SET @p1=' '
SET @p2=' '
SET @p3=' '
SET @p4=' '
SET @i=LEN(@s)
WHILE (@i>0)
BEGIN
SET @temp=UPPER(SUBSTRING(@s,@i,1))
IF LEN(@s)-@i=0
	SET @p1=CASE UPPER(SUBSTRING(@s,@i,1))
	WHEN '1' THEN 'I'
	WHEN '2' THEN 'II'
	WHEN '3' THEN 'III'
	WHEN '4' THEN 'IV'
	WHEN '5' THEN 'V'
	WHEN '6' THEN 'VI'
	WHEN '7' THEN 'VII'
	WHEN '8' THEN 'VIII'
	WHEN '9' THEN 'IX'
	ELSE ' '
	END
IF LEN(@s)-@i=1
	SET @p2=CASE UPPER(SUBSTRING(@s,@i,1))
	WHEN '1' THEN 'X'
	WHEN '2' THEN 'XX'
	WHEN '3' THEN 'XXX'
	WHEN '4' THEN 'XL'
	WHEN '5' THEN 'L'
	WHEN '6' THEN 'LX'
	WHEN '7' THEN 'LXX'
	WHEN '8' THEN 'LXXX'
	WHEN '9' THEN 'XC'
ELSE ' '
	END
IF LEN(@s)-@i=2
	SET @p3=CASE UPPER(SUBSTRING(@s,@i,1))
	WHEN '1' THEN 'C'
	WHEN '2' THEN 'CC'
	WHEN '3' THEN 'CCC'
	WHEN '4' THEN 'CD'
	WHEN '5' THEN 'D'
	WHEN '6' THEN 'DC'
	WHEN '7' THEN 'DCC'
	WHEN '8' THEN 'DCCC'
	WHEN '9' THEN 'CM'
ELSE ' '
	END
IF LEN(@s)-@i=3
	SET @p4=CASE UPPER(SUBSTRING(@s,@i,1))
	WHEN '1' THEN 'M'
	WHEN '2' THEN 'MM'
	WHEN '3' THEN 'MMM'
	WHEN '4' THEN 'MMMM'
ELSE ' '
	END
SET @i=@i-1
END
SET @s= @p4+@p3+@p2+@p1
SET @s=REPLACE(@s,' ','')
RETURN @s
END






GO
/****** Object:  UserDefinedFunction [dbo].[ACOSEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ACOSEC](@a float ) 
--Returns the angle in radians whose cosecant is the given float expression (also called arccosecant).
returns float
as
BEGIN
return (ASIN(1/@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[ACOSH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ACOSH](@a float ) 
--Returns the inverse hyperbolic cosine of a number
returns float
as
BEGIN
return LOG(@a+SQRT(@a*@a-1))
END



GO
/****** Object:  UserDefinedFunction [dbo].[ACOT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ACOT](@a float ) 
--Returns the angle in radians whose cotangent is the given float expression (also called arccotangent).
returns float
as
BEGIN
return (ATAN(1/@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[ADD_MONTHS]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ADD_MONTHS] (@d datetime, @n int ) 
--Returns the date d plus i months
returns datetime
as
BEGIN
RETURN dateadd(m,@n,@d)
END



GO
/****** Object:  UserDefinedFunction [dbo].[ARR]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ARR](@n bigint, @k bigint) 
--Returns the number of arrangements for a given number of objects.
returns bigint
as
BEGIN
return dbo.FACT(@n)/(dbo.FACT(@n-@k))
END



GO
/****** Object:  UserDefinedFunction [dbo].[ASCII2EBCDIC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ASCII2EBCDIC](@s VARCHAR(255) ) 
--Converts a string from ASCII to EBCDIC.
returns  VARCHAR(255)
as
BEGIN
DECLARE @i int, @temp char(1),@ebcdic char(1), @result VARCHAR(255) 
SET @i=1
SET @result=''
WHILE (@i<=LEN(@s))
BEGIN
SET @temp=SUBSTRING(@s,@i,1)
SET @ebcdic=CASE @temp
		WHEN char(13) THEN '%'
		WHEN ' ' THEN '@'
		WHEN '.' THEN 'K'
		WHEN '<' THEN 'L'
		WHEN '(' THEN 'M'
		WHEN '+' THEN 'N'
		WHEN '|' THEN 'O'
		WHEN '&' THEN 'P'
		WHEN '!' THEN 'Z'
		WHEN '$' THEN CHAR(91)
		WHEN ')' THEN CHAR(92)
		WHEN '*' THEN CHAR(93)
		WHEN ';' THEN CHAR(94)
		WHEN '-' THEN CHAR(96)
		WHEN '`' THEN CHAR(185)
		WHEN '/' THEN 'a'
		WHEN ',' THEN 'k'
		WHEN '%' THEN 'l'
		WHEN '_' THEN 'm'
		WHEN '>' THEN 'n'
		WHEN '?' THEN 'o'
		WHEN '' THEN 'p'
		WHEN ':' THEN 'z'
		WHEN '#' THEN CHAR(123)
		WHEN '@' THEN CHAR(124)
		WHEN '''' THEN CHAR(125)
		WHEN '=' THEN CHAR(126)
		WHEN '"' THEN CHAR(127)
		ELSE ''
		END
IF @ebcdic=''
SET @ebcdic=CASE
	WHEN ASCII(@temp) BETWEEN 97 AND 105 THEN CHAR(ASCII(@temp)+32) 
	WHEN ASCII(@temp) BETWEEN 106 AND 114 THEN CHAR(ASCII(@temp)+39) 
	WHEN ASCII(@temp) BETWEEN 115 AND 122 THEN CHAR(ASCII(@temp)+47) 
	WHEN ASCII(@temp) BETWEEN 65 AND 73 THEN CHAR(ASCII(@temp)+128) 
	WHEN ASCII(@temp) BETWEEN 74 AND 82 THEN CHAR(ASCII(@temp)+135)
	WHEN ASCII(@temp) BETWEEN 83 AND 90 THEN CHAR(ASCII(@temp)+143)
	WHEN ASCII(@temp) BETWEEN 48 AND 57 THEN CHAR(ASCII(@temp)+192)
	ELSE ''
	END
SET @result=@result+@ebcdic
SET @i=@i+1
END
RETURN   @result
END





GO
/****** Object:  UserDefinedFunction [dbo].[ASEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ASEC](@a float ) 
--Returns the angle in radians whose secant is the given float expression (also called arcsecant).
returns float
as
BEGIN
return (ACOS(1/@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[ASINH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ASINH](@a float ) 
--Returns the inverse hyperbolic sine of a number.
returns float
as
BEGIN
return LOG(@a+SQRT(@a*@a+1))
END




GO
/****** Object:  UserDefinedFunction [dbo].[ATANH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ATANH](@a float ) 
--Returns the inverse hyperbolic tangent of a number.
returns float
as
BEGIN
return LOG((1+@a)/(1-@a))/2
END



GO
/****** Object:  UserDefinedFunction [dbo].[BINTODEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[BINTODEC](@s VARCHAR(255) ) 
--Converts a binary number to decimal.
returns int
as
BEGIN
DECLARE @i int, @temp char(1), @result int
SELECT @i=1
SELECT @result=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
SELECT @result=@result+ (ASCII(@temp)-48)*POWER(2,LEN(@s)-@i)
SELECT @i=@i+1
END
return @result
END




GO
/****** Object:  UserDefinedFunction [dbo].[CHARINDEXREV]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[CHARINDEXREV](@s varchar(255),@p varchar(255) ) 
--Returns the position of an occurrence of one string within another, from the end of string.
returns int
as
BEGIN
DECLARE @i int
SET @i=1
WHILE charindex(@s, @p, @i)>0
BEGIN
SET @i=charindex(@s, @p, @i)+1
END
IF @i>0
	SET @i=@i-1
RETURN  @i
END





GO
/****** Object:  UserDefinedFunction [dbo].[COMBIN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COMBIN](@n bigint, @k bigint) 
--Returns the number of combinations for a given number of objects.
returns bigint
as
BEGIN
return dbo.FACT(@n)/(dbo.FACT(@k)*dbo.FACT(@n-@k))
END



GO
/****** Object:  UserDefinedFunction [dbo].[COMPLEMENT1]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COMPLEMENT1](@a int ) 
--Returns a number's one's complement.
returns int
as
BEGIN
return ~@a
END



GO
/****** Object:  UserDefinedFunction [dbo].[COMPLEMENT2]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COMPLEMENT2](@a int ) 
--Returns a number's two's complement.
returns int
as
BEGIN
return (~@a+1)
END



GO
/****** Object:  UserDefinedFunction [dbo].[COSEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COSEC](@a float ) 
--Returns the trigonometric cosecant of the given angle (in radians) in the given expression.
returns float
as
BEGIN
return (1/SIN(@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[COSECH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COSECH](@a float ) 
--Returns the hyperbolic cosecant of a number.
returns float
as
BEGIN
return 2/( POWER(dbo.E(),@a) -  POWER(dbo.E(),-@a) )
END



GO
/****** Object:  UserDefinedFunction [dbo].[COSH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COSH](@a float ) 
--Returns the hyperbolic cosine of a number.
returns float
as
BEGIN
return ( POWER(dbo.E(),@a) +  POWER(dbo.E(),-@a) )/2
END



GO
/****** Object:  UserDefinedFunction [dbo].[COTH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[COTH](@a float ) 
--Returns the hyperbolic cotangent of a number.
returns float
as
BEGIN
return (dbo.COSH(@a)/dbo.SINH(@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[CRYPTX8]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[CRYPTX8]( @s VARCHAR(1024), @k VARCHAR(8) ) 
--Returns a string s1 encrypted/decrypted with key s2, up to 8 chars ( XOR encryption ). 
returns VARCHAR(1024)
as
BEGIN
DECLARE @result VARCHAR(1024), @l int, @i int, @j int, @temp tinyint, @x tinyint
SET @i=LEN(@k)
IF @i<8--if the pwd<8 char
	BEGIN
	SET @k=@k+@k+@k+@k+@k+@k+@k+@k--add pwd to itself
	SET @k=LEFT(@k,8)
	END
SET @l=(LEN(@s) % 8)
IF @l<>0--if there are no complete 64 bit blocks
	BEGIN
	SET @i=(LEN(@s))/8+1
	SET @l= @i*8-len(@s)
	SET @s=@s+replicate('*',@l)
	END
SET @i=1
SET @result=''
WHILE @i<=LEN(@s)
	BEGIN
	SET @j=0
	WHILE @j<8
		BEGIN	
		SET @temp=ASCII(SUBSTRING(@s,@i+@j,1))
		SET @x=ASCII(SUBSTRING(@k,@j+1,1))
		SET @result=@result + CHAR(@temp ^ @x)	
		SET @j=@j+1
		END
	SET @i=@i+8
	END
IF @l<>0
	BEGIN	
	SET @result=LEFT(@result,LEN(@result)-@l)
	END
RETURN    @result
END





GO
/****** Object:  UserDefinedFunction [dbo].[CUBE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[CUBE](@a float ) 
--Returns the cube of the given expression.
returns float
as
BEGIN
return @a*@a*@a
END



GO
/****** Object:  UserDefinedFunction [dbo].[DDATE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DDATE]( @d as DATETIME) 
--Returns the date from a datetime input as a string.
returns varchar(255)
as
BEGIN
DECLARE @s varchar(255) 
SET @s= CONVERT(VARCHAR(255),@d,101)
RETURN @s
END




GO
/****** Object:  UserDefinedFunction [dbo].[DEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DEC](@a int ) 
--Returns a number decremented by 1.
returns int
as
BEGIN
return @a-1
END



GO
/****** Object:  UserDefinedFunction [dbo].[DECTOBIN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DECTOBIN](@n int ) 
--Converts a decimal number to binary.
returns varchar(255)
as
BEGIN
DECLARE @i int,@temp int, @s varchar(255)
SET @i=@n
SET @s=''
WHILE (@i>0)
BEGIN
SET @temp=@i % 2
SET @i=@i /2
SET @s=char(48+@temp)+@s
END
RETURN @s
END



GO
/****** Object:  UserDefinedFunction [dbo].[DECTOHEX]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DECTOHEX](@n int ) 
--Converts a decimal number to hexadecimal.
returns varchar(255)
as
BEGIN
DECLARE @i int,@temp int, @s varchar(255)
SET @i=@n
SET @s=''
WHILE (@i>0)
BEGIN
SET @temp=@i % 16
SET @i=@i /16
IF @temp>9
	SET @s=char(55+@temp)+@s
ELSE
	SET @s=char(48+@temp)+@s
END
RETURN @s
END




GO
/****** Object:  UserDefinedFunction [dbo].[DECTON]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DECTON](@n int, @b int ) 
--Converts a decimal number to base n.
returns varchar(255)
as
BEGIN
DECLARE @i int,@temp int, @s varchar(255)
SET @i=@n
SET @s=''
WHILE (@i>0)
BEGIN
SET @temp=@i % @b
SET @i=@i /@b
IF @temp>9
	SET @s=char(55+@temp)+@s
ELSE
	SET @s=char(48+@temp)+@s
END
RETURN @s
END



GO
/****** Object:  UserDefinedFunction [dbo].[DECTOOCT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DECTOOCT](@n int ) 
--Converts a decimal number to octal.
returns varchar(255)
as
BEGIN
DECLARE @i int,@temp int, @s varchar(255)
SET @i=@n
SET @s=''
WHILE (@i>0)
BEGIN
SET @temp=@i % 8
SET @i=@i /8
SET @s=char(48+@temp)+@s
END
RETURN @s
END



GO
/****** Object:  UserDefinedFunction [dbo].[DEG2GRAD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DEG2GRAD](@a float ) 
--Converts an angle from degrees to grads.
returns float
as
BEGIN
return (@a*10.0/9.0)
END


GO
/****** Object:  UserDefinedFunction [dbo].[DISTANCE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DISTANCE](@x1 float,@y1 float, @x2 float,@y2 float) 
--Returns the distance between 2 points P(f1, f2) to T(f3, f4). 
returns float
as
BEGIN
return sqrt((@x1-@x2)*(@x1-@x2)+(@y1-@y2)*(@y1-@y2))
END



GO
/****** Object:  UserDefinedFunction [dbo].[DIVI]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[DIVI](@a bigint, @b bigint, @precision bigint) 
--Returns the result of the division of i1 by i2 with precision i3 (Infinite precision division).  
returns VARCHAR(5000)
as
BEGIN
DECLARE @l bigint, @p bigint,@d bigint,@t bigint,@result VARCHAR(5000), @err bit
SET @result=''
SET @l=10
SET @err=0
SET @t=@a/@b
WHILE @err=0
	BEGIN
	SET @a=@a*@l
	IF @b>@a
		SET @result=@result+'0'
	WHILE (@b > @a)
		BEGIN
		SET @a=@a*@l
		IF @b>@a
			SET @result=@result+'0'
		END
	SET @p=@a/@b
	IF (@p * @b) < @a 
		SET @p = @p + 1
	SET @d = @p * @b
	IF @d=@a
		BEGIN
		SET @err=1
		SET @result=@result+CONVERT(VARCHAR(20),(@p))
		END
	IF @d>@a
		BEGIN
		SET @p=@p-1
		SET @result=@result+CONVERT(VARCHAR(20),(@p))
		IF LEN(@result)>@precision
			SET @err=1
		SET @a = @a - @p * @b
		END
	END
SET @l=LEN(CONVERT(VARCHAR(20),(@t)))
IF @p=0
	SET @result='0.'+@result
ELSE
	SET @result=LEFT(@result,@l)+'.'+RIGHT(@result,LEN(@result)-@l)
RETURN  @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[DTIME]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DTIME]( @d as DATETIME) 
--Returns the time from a datetime input as a string.
returns varchar(255)
as
BEGIN
DECLARE @s varchar(255) 
SET @s= CONVERT(VARCHAR(255),@d,108)
RETURN @s
END




GO
/****** Object:  UserDefinedFunction [dbo].[E]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[E]( ) 
--Returns e, Natural Logarithmic Base.
returns float
as
BEGIN
return EXP(1)
END



GO
/****** Object:  UserDefinedFunction [dbo].[EBCDIC2ASCII]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[EBCDIC2ASCII](@s VARCHAR(255) ) 
--Converts a string from EBCDIC to ASCII.
returns  VARCHAR(255)
as
BEGIN
DECLARE @i int, @temp char(1),@ebcdic char(1), @result VARCHAR(255) 
SET @i=1
SET @result=''
WHILE (@i<=LEN(@s))
BEGIN
SET @temp=SUBSTRING(@s,@i,1)
SET @ebcdic=CASE @temp
		WHEN '%' THEN char(13)
		WHEN '@' THEN ' '
		WHEN 'K' THEN '.'
		WHEN 'L' THEN '<'
		WHEN 'M' THEN '('
		WHEN 'N' THEN '+'
		WHEN 'O' THEN '|'
		WHEN 'P' THEN '&'
		WHEN 'Z' THEN '!'
		WHEN CHAR(91) THEN '$'
		WHEN CHAR(92) THEN ')'
		WHEN CHAR(93) THEN '*'
		WHEN CHAR(94) THEN ';'
		WHEN CHAR(96) THEN '-'
		WHEN CHAR(185) THEN '`'
		WHEN 'a' THEN '/'
		WHEN 'k' THEN ','
		WHEN 'l' THEN '%'
		WHEN 'm' THEN '_'
		WHEN 'n' THEN '>'
		WHEN 'o' THEN '?'
		WHEN 'p' THEN ''
		WHEN 'z' THEN ':'
		WHEN CHAR(123) THEN '#'
		WHEN CHAR(124) THEN '@'
		WHEN CHAR(125) THEN ''''
		WHEN CHAR(126) THEN '='
		WHEN CHAR(127) THEN '"'
		ELSE ''
		END
IF @ebcdic=''
	SET @ebcdic=CASE
			WHEN ASCII(@temp) BETWEEN 129 AND 137 THEN CHAR(ASCII(@temp)-32) 
			WHEN ASCII(@temp) BETWEEN 145 AND 153 THEN CHAR(ASCII(@temp)-39) 
			WHEN ASCII(@temp) BETWEEN 162 AND 169 THEN CHAR(ASCII(@temp)-47) 
			WHEN ASCII(@temp) BETWEEN 193 AND 201 THEN CHAR(ASCII(@temp)-128) 
			WHEN ASCII(@temp) BETWEEN 209 AND 217 THEN CHAR(ASCII(@temp)-135)
			WHEN ASCII(@temp) BETWEEN 226 AND 233 THEN CHAR(ASCII(@temp)-143)
			WHEN ASCII(@temp) BETWEEN 240 AND 249 THEN CHAR(ASCII(@temp)-192)
			ELSE ''
			END
SET @result=@result+@ebcdic
SET @i=@i+1
END
RETURN @result
END




GO
/****** Object:  UserDefinedFunction [dbo].[EQUIVALENT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[EQUIVALENT](@a int, @b int ) 
--Returns the result of a logical formal equivalence.
returns int
as
BEGIN
return ~(@a ^ @b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[FACT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[FACT](@n bigint) 
--Returns the factorial of a number.
returns bigint
as
BEGIN
    declare @temp bigint
    if (@n <= 1) 
	select @temp = 1
    else 
        select @temp = @n * dbo.FACT(@n - 1)
    return @temp
END




GO
/****** Object:  UserDefinedFunction [dbo].[FACTDOUBLE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[FACTDOUBLE](@n float ) 
--Returns the double factorial of a number.
returns float 
as
BEGIN
    declare @temp float 
    if (@n <= 1) 
	select @temp = 1
    else 
        select @temp = @n * dbo.FACTDOUBLE(@n - 1)
    return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[FIBONACCI]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[FIBONACCI](@n bigint) 
--Returns the Fibonacci series for a given number.
returns bigint
as
BEGIN
    declare @temp bigint
    if (@n <=2) 
	select @temp = 1
    else 
        select @temp =  dbo.FACT(@n - 1)+ dbo.FACT(@n - 2)
    return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[FRAC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[FRAC](@a float ) 
--Returns the decimal part of a number.
returns float
as
BEGIN
return (@a-convert(int,@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[FROMMORSE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[FROMMORSE](@s varchar(255) ) 
--Returns the text corresponding to a morse code string.
returns  varchar(255)
as
BEGIN
DECLARE @i int,@j int,@p int, @result varchar(255),@chars1 char(26),@chars2 char(10)
DECLARE @chars3 char(3), @morse1 char(104)
DECLARE @morse2 char(50),@morse3 char(18), @temp varchar(6)
SET @chars1='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
SET @chars2='0123456789'
SET @chars3='.,?'
SET @morse1='.-  -...-.-.-.. .   ..-.--. ......  .----.- .-..--  -.  --- .--.--.-.-. ... -   ..- ...-.-- -..--.----..'
SET @morse2='-----.----..---...--....-.....-....--...---..----.'
SET @morse3='.-.-.---..--..--..'
SET @result=''
SET @s=LTRIM(RTRIM(@s))
WHILE CHARINDEX('  ',@s)>0
	SET @s=REPLACE(@s,'  ',' ')
SET @s=@s+' '
SET @i=1
SET @j=CHARINDEX(' ',@s,@i)-1
WHILE (@j>0)
BEGIN
SET @temp=(SUBSTRING(@s,@i,@j-@i+1))
IF LEN(@temp)<5
	BEGIN
	SET @p=1
	WHILE @p<(104)
		BEGIN
		IF @temp=LTRIM(RTRIM(SUBSTRING(@morse1,@p,4)))
			SET @result=@result+SUBSTRING(@chars1,@p/4+1,1)
		SET @p=@p+4
		END
	END 
IF LEN(@temp)=5
	BEGIN
	SET @p=1
	WHILE @p<(50)
		BEGIN
		IF @temp=LTRIM(RTRIM(SUBSTRING(@morse2,@p,5)))
			SET @result=@result+SUBSTRING(@chars2,@p/5+1,1)
		SET @p=@p+5
		END
	END 
IF LEN(@temp)=6
	BEGIN
	SET @p=1
	WHILE @p<(18)
		BEGIN
		IF @temp=LTRIM(RTRIM(SUBSTRING(@morse3,@p,6)))
			SET @result=@result+SUBSTRING(@chars3,@p/6+1,1)
		SET @p=@p+6
		END
	END 
SET @i=@j+2
SET @j=CHARINDEX(' ',@s,@i)-1
END
RETURN @result
END




GO
/****** Object:  UserDefinedFunction [dbo].[GCD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[GCD](@a int, @b int) 
--Returns the greatest common divisor of 2 numbers.
returns int
as
BEGIN
declare @c int
select @c=1
While (@c <> 0)
	BEGIN        
	select @c=@a % @b
	select @a=@b
	select @b=@c
        END
return @a
END




GO
/****** Object:  UserDefinedFunction [dbo].[GETBIT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[GETBIT](@a int, @b int ) 
--Returns the value of a certain bit.
returns int
as
BEGIN
return ABS(SIGN(@a & (POWER(2,@b))))
END



GO
/****** Object:  UserDefinedFunction [dbo].[GetListaInteger]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetListaInteger] (@list nvarchar(MAX))
   RETURNS @tbl TABLE (i int NOT NULL, number int NOT NULL) AS
BEGIN
   DECLARE @pos        int,
           @nextpos    int,
           @valuelen   int,
		    @i   int
			set @i = 0
   SELECT @pos = 0, @nextpos = 1

   WHILE @nextpos > 0
   BEGIN
      SELECT @nextpos = charindex(',', @list, @pos + 1)
      SELECT @valuelen = CASE WHEN @nextpos > 0
                              THEN @nextpos
                              ELSE len(@list) + 1
                         END - @pos - 1
      INSERT @tbl (i,number)
         VALUES (@i,convert(int, substring(@list, @pos + 1, @valuelen)))
      SELECT @pos = @nextpos
	  set @i = @i+1
   END
  RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetScoreParse]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetScoreParse] (@list nvarchar(MAX))
   RETURNS @tbl TABLE (i int NOT NULL, number float) AS
BEGIN
   DECLARE @pos        int,
           @nextpos    int,
           @valuelen   int,
		    @i   int
			set @i = 0
   SELECT @pos = 0, @nextpos = 1

   WHILE @nextpos > 0
   BEGIN
      SELECT @nextpos = charindex(',', @list, @pos + 1)
      SELECT @valuelen = CASE WHEN @nextpos > 0
                              THEN @nextpos
                              ELSE len(@list) + 1
                         END - @pos - 1
      INSERT @tbl (i,number)
         VALUES (@i,convert(float, substring(@list, @pos + 1, @valuelen)))
      SELECT @pos = @nextpos
	  set @i = @i+1
   END
  RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[GRAD2DEG]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[GRAD2DEG](@a float ) 
--Converts an angle from grads to degrees.
returns float
as
BEGIN
return (@a*9.0/10.0)
END


GO
/****** Object:  UserDefinedFunction [dbo].[GRAD2RAD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[GRAD2RAD](@a float ) 
--Converts an angle from grads to radians.
returns float
as
BEGIN
return (@a*200.0/PI())
END


GO
/****** Object:  UserDefinedFunction [dbo].[GREGORIAN2HIJRI]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[GREGORIAN2HIJRI](@d datetime) 
--Returns the date FROM Gregorian into Hijri calendar
returns NVARCHAR(100)
as
BEGIN
return CONVERT(NVARCHAR(100), @d, 131)
END





GO
/****** Object:  UserDefinedFunction [dbo].[HEXTODEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[HEXTODEC](@s VARCHAR(255) ) 
--Converts an hexadecimal number to decimal.
returns int
as
BEGIN
DECLARE @i int, @temp char(1), @result int
SELECT @i=1
SELECT @result=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=UPPER(SUBSTRING(@s,@i,1))
IF (@temp>='0') AND (@temp<='9') 
	SELECT @result=@result+ (ASCII(@temp)-48)*POWER(16,LEN(@s)-@i)
ELSE
	IF (@temp>='A') AND (@temp<='F') 
		SELECT @result=@result+ (ASCII(@temp)-55)*POWER(16,LEN(@s)-@i)
SELECT @i=@i+1
END
return @result
END





GO
/****** Object:  UserDefinedFunction [dbo].[HIJRI2GREGORIAN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[HIJRI2GREGORIAN](@d NVARCHAR(100)) 
--Returns the date FROM Hijri into Gregorian calendar
returns datetime
as
BEGIN
return  CONVERT(datetime, @d, 131)
END




GO
/****** Object:  UserDefinedFunction [dbo].[IIF]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[IIF](@b bit, @t SQL_VARIANT,@f SQL_VARIANT  ) 
--Returns one of two parts, depending on the evaluation of an expression.
returns SQL_VARIANT
as
BEGIN
DECLARE @temp SQL_VARIANT
IF @b=1
	SELECT @temp=@t
ELSE 
	SELECT @temp=@f
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[IMPLIES]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[IMPLIES](@a int, @b int ) 
--Returns the result of a logical formal implication.
returns int
as
BEGIN
return ~@a | @b
END



GO
/****** Object:  UserDefinedFunction [dbo].[INC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[INC](@a int ) 
--Returns a number incremented by 1.
returns int
as
BEGIN
return @a+1
END



GO
/****** Object:  UserDefinedFunction [dbo].[INCLUDED]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[INCLUDED](@s varchar(255),@p varchar(255) ) 
--Returns how many times a string is included (occurs) into another one.
returns int
as
BEGIN
DECLARE @i int,@c int
SET @i=1
SET @c=0
WHILE charindex(@s, @p, @i)>0
BEGIN
SET @i=charindex(@s, @p, @i)+1
SET @c=@c+1
END
RETURN  @c
END




GO
/****** Object:  UserDefinedFunction [dbo].[INITCAP]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[INITCAP] (@s varchar(255) ) 
--Returns a string with the first letter of each word in uppercase, all other letters in lowercase (capitalize first character).  
returns varchar(255)
as
BEGIN
DECLARE @i int, @c char(1),@result varchar(255)
SET @result=LOWER(@s)
SET @i=2
SET @result=STUFF(@result,1,1,UPPER(SUBSTRING(@s,1,1)))
WHILE @i<=LEN(@s)
	BEGIN
	SET @c=SUBSTRING(@s,@i,1)
	IF (@c=' ') OR (@c=';') OR (@c=':') OR (@c='!') OR (@c='?') OR (@c=',')OR (@c='.')OR (@c='_')
		IF @i<LEN(@s)
			BEGIN
			SET @i=@i+1
			SET @result=STUFF(@result,@i,1,UPPER(SUBSTRING(@s,@i,1)))
			END
	SET @i=@i+1
	END
RETURN  @result
END





GO
/****** Object:  UserDefinedFunction [dbo].[IPOCTECT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[IPOCTECT](@s varchar(15), @o int) 
--Returns an octect i (1-4) from an IP.
returns varchar(3)
as
BEGIN
DECLARE @u VARCHAR(3), @v VARCHAR(3), @x VARCHAR(3),@y VARCHAR(3), @i int, @j int, @result varchar(15)
IF (dbo.INCLUDED('.',@s)<>3) OR (@i<1) OR (@i>4)
	BEGIN
	SET @result=''
	GOTO done
	END
SET @i=CHARINDEX('.',@s)
SET @u=LEFT(@s,@i-1)
SET @j=CHARINDEX('.',@s,@i+1)
SET @v=substring(@s,@i+1,@j-@i-1)
SET @i=CHARINDEX('.',@s,@j+1)
SET @x=substring(@s,@j+1,@i-@j-1)
SET @y=substring(@s,@i+1,LEN(@s)-@i)
IF ISNUMERIC(@u)=0 OR ISNUMERIC(@v)=0 OR ISNUMERIC(@x)=0 OR ISNUMERIC(@y)=0
	BEGIN
	SET @result=''
	GOTo done
	END
IF (CONVERT(INT, @u)<0) OR  (CONVERT(INT, @v)<0) OR  (CONVERT(INT, @x)<0)  OR  (CONVERT(INT, @y)<0) 
	BEGIN
	SET @result=''
	GOTo done
	END
IF (CONVERT(INT, @u)>255) OR  (CONVERT(INT, @v)>255) OR  (CONVERT(INT, @x)>255)  OR  (CONVERT(INT, @y)>255) 
	BEGIN
	SET @result=''
	GOTo done
	END
SET @result=CASE @o
	WHEN 1 THEN @u
	WHEN 2 THEN @v
	WHEN 3 THEN @x
	WHEN 4 THEN @y
	END
done:
RETURN  @result
END




GO
/****** Object:  UserDefinedFunction [dbo].[ISABUNDNUM]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[ISABUNDNUM](@n bigint ) 
--Returns true if the number is abundant
returns bit
as
BEGIN
DECLARE @b bit
IF dbo.SUMALIQUOT(@n)>@n
	SET @b=1
ELSE
	SET @b=0
RETURN @b
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISALPHA]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISALPHA](@s VARCHAR(50) ) 
--Returns true if the string has valid alphanumeric characters.
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if (@temp<='z') AND (@temp>='a') OR  (@temp<='Z') AND (@temp>='A') OR  (@temp<='9') AND (@temp>='0') OR (@temp='-')  OR (@temp='.') 
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END






GO
/****** Object:  UserDefinedFunction [dbo].[ISBIN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISBIN](@s VARCHAR(50) ) 
--Returns true if the string is a valid binary number. 
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if  (@temp='0')  OR (@temp='1') 
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END







GO
/****** Object:  UserDefinedFunction [dbo].[ISDEFNUM]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[ISDEFNUM](@n bigint ) 
--Returns true if the number is deficient
returns bit
as
BEGIN
DECLARE @b bit
IF dbo.SUMALIQUOT(@n)<@n
	SET @b=1
ELSE
	SET @b=0
RETURN @b
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISEMPTY]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISEMPTY](@a SQL_VARIANT ) 
--Returns true if the input is empty.
returns BIT
as
BEGIN
DECLARE @temp bit
IF (@a='')
	SELECT @temp=1
ELSE
	SELECT @temp=0
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISEVEN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISEVEN](@a int ) 
--Returns true if the number is even.
returns bit
as
BEGIN
return ~(CONVERT(bit, @a & 1 ))
END




GO
/****** Object:  UserDefinedFunction [dbo].[ISHEX]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISHEX](@s VARCHAR(50) ) 
--Returns true if the string is a valid hexadecimalal number. 
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
if (@temp<='f') AND (@temp>='a') OR  (@temp<='F') AND (@temp>='A') OR  (@temp<='9') AND (@temp>='0')  
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END







GO
/****** Object:  UserDefinedFunction [dbo].[ISINTNUMBER]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISINTNUMBER](@s VARCHAR(50) ) 
--Returns true if the string is a valid integer number.
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
if (@temp<='9') AND (@temp>='0') OR (@temp='-') 
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISINTPOSNUMBER]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISINTPOSNUMBER](@s VARCHAR(50) ) 
--Returns true if the string is a valid positive integer number. 
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=1
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if (@temp>'9') OR (@temp<'0')
	SELECT @bool=0
SELECT @i=@i+1
END
return @bool
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISITNULL]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISITNULL](@a SQL_VARIANT ) 
--Returns true if the input is null.
returns BIT
as
BEGIN
DECLARE @temp bit
IF (@a=NULL)
	SELECT @temp=1
ELSE
	SELECT @temp=0
return @temp
END




GO
/****** Object:  UserDefinedFunction [dbo].[ISLETTER]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISLETTER](@s VARCHAR(50) ) 
--Returns true if the string has only letters.
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if (@temp<='z') AND (@temp>='a') OR  (@temp<='Z') AND (@temp>='A') 
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END





GO
/****** Object:  UserDefinedFunction [dbo].[ISNEG]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISNEG](@a float ) 
--Returns true if the number is negative.
returns BIT
as
BEGIN
DECLARE @temp bit
IF (@a < 0)
	SELECT @temp=1
ELSE
	SELECT @temp=0
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISNUMBER]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISNUMBER](@s VARCHAR(50) ) 
--Returns true if the string is a valid number. 
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if (@temp<='9') AND (@temp>='0') OR (@temp='-')  OR (@temp='.') 
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END




GO
/****** Object:  UserDefinedFunction [dbo].[ISOCT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISOCT](@s VARCHAR(50) ) 
--Returns true if the string is a valid octal number.
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=1
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if (@temp>'7') OR (@temp<'0')
	SELECT @bool=0
SELECT @i=@i+1
END
return @bool
END




GO
/****** Object:  UserDefinedFunction [dbo].[ISODD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISODD](@a int ) 
--Returns true if the number is odd.
returns bit
as
BEGIN
return CONVERT(bit, @a & 1 )
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISPERFNUM]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[ISPERFNUM](@n bigint ) 
--Returns true if the number is perfect
returns bit
as
BEGIN
DECLARE @b bit
IF dbo.SUMALIQUOT(@n)=@n
	SET @b=1
ELSE
	SET @b=0
RETURN @b
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISPOSNUMBER]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISPOSNUMBER](@s VARCHAR(50) ) 
--Returns true if the string is a valid positive number.
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
--PRINT @temp
if (@temp<='9') AND (@temp>='0')  OR (@temp='.') 
	SELECT @bool=1
SELECT @i=@i+1
END
return @bool
END



GO
/****** Object:  UserDefinedFunction [dbo].[ISPRIME]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISPRIME](@i INT ) 
--Returns true if the number is prime. 
returns bit
as
BEGIN
DECLARE @c int, @t int, @result bit
SET @result=1
IF (@i & 1)=0
	BEGIN
	SET @result=0
	GOTO done
	END
SET @c=3
SET @t=SQRT(@i)
WHILE @c<=@t
	BEGIN
	IF @i % @c=0
		BEGIN
		SET @result=0
		GOTO done
		END
	SET @c=@c+2
	END
done:
RETURN  @result
END




GO
/****** Object:  UserDefinedFunction [dbo].[ISROMAN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ISROMAN](@s VARCHAR(255) ) 
--Returns true if the string is a valid Roman numeral.
returns bit
as
BEGIN
DECLARE @i int, @temp char(1), @bool bit
SELECT @i=1
SELECT @bool=1
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=UPPER(SUBSTRING(@s,@i,1))
--LOOK FOR INVALID CHARS
if  NOT( (@temp='I')  OR (@temp='V') OR (@temp='X') OR (@temp='L') OR (@temp='C') OR (@temp='D')  OR (@temp='M') )
	SELECT @bool=0
SELECT @i=@i+1
END
--LOOK FOR INVALID SEQUENCE SUCH AS IIII INSTEAD OF IV
IF (CHARINDEX('IIII',UPPER(@s))>0) OR (CHARINDEX('VV',UPPER(@s))>0) OR (CHARINDEX('XXXX',UPPER(@s))>0) OR (CHARINDEX('LL',UPPER(@s))>0) OR (CHARINDEX('CCCC',UPPER(@s))>0) OR (CHARINDEX('DD',UPPER(@s))>0) OR (CHARINDEX('MMMMM',UPPER(@s))>0)
	SELECT @bool=0
--LOOK FOR INVALID PRECEDENCE SUCH AS IL (49?) INSTEAD OF XLIX
IF (CHARINDEX('IL',UPPER(@s))>0) OR (CHARINDEX('IC',UPPER(@s))>0) OR (CHARINDEX('ID',UPPER(@s))>0) OR (CHARINDEX('IM',UPPER(@s))>0) OR (CHARINDEX('VX',UPPER(@s))>0) OR (CHARINDEX('VL',UPPER(@s))>0) OR (CHARINDEX('VC',UPPER(@s))>0) OR (CHARINDEX('VD',UPPER(@s))>0) OR (CHARINDEX('VM',UPPER(@s))>0) OR (CHARINDEX('XC',UPPER(@s))>0) OR (CHARINDEX('XD',UPPER(@s))>0) OR (CHARINDEX('XM',UPPER(@s))>0) OR (CHARINDEX('LC',UPPER(@s))>0) OR (CHARINDEX('LD',UPPER(@s))>0) OR (CHARINDEX('LM',UPPER(@s))>0) OR (CHARINDEX('CM',UPPER(@s))>0) OR (CHARINDEX('DM',UPPER(@s))>0)
	SELECT @bool=0
--LOOK FOR INVALID PRECEDENCE SUCH AS IIV INSTEAD OF III
IF (CHARINDEX('IIV',UPPER(@s))>0) OR (CHARINDEX('IIX',UPPER(@s))>0) OR (CHARINDEX('XXL',UPPER(@s))>0) OR (CHARINDEX('XXC',UPPER(@s))>0) OR (CHARINDEX('CCD',UPPER(@s))>0) OR (CHARINDEX('CCM',UPPER(@s))>0)
	SELECT @bool=0
return @bool
END










GO
/****** Object:  UserDefinedFunction [dbo].[LAST_DAY]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[LAST_DAY](@d datetime ) 
returns datetime
as
BEGIN
DECLARE @nextmonth datetime, @i int
SET @nextmonth=dateadd(m,1,@d)
SET @i=-day(@nextmonth)
SET @nextmonth=dateadd(d,@i,@nextmonth)
return day(@nextmonth) 
END


GO
/****** Object:  UserDefinedFunction [dbo].[LCM]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[LCM](@a int, @b int ) 
--Returns the least common multiple of 2 numbers.
returns int
as
BEGIN
return (@a * @b) / dbo.GCD(@a, @b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[LEVENSHTEIN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[LEVENSHTEIN]( @s varchar(50), @t varchar(50) ) 
--Returns the Levenshtein Distance between strings s1 and s2.
--Original developer: Michael Gilleland    http://www.merriampark.com/ld.htm
--Translated to TSQL by Joseph Gama
returns varchar(50)
as
BEGIN
DECLARE @d varchar(2500), @LD int, @m int, @n int, @i int, @j int,
@s_i char(1), @t_j char(1),@cost int
--Step 1
SET @n=LEN(@s)
SET @m=LEN(@t)
SET @d=replicate(CHAR(0),2500)
If @n = 0
	BEGIN
	SET @LD = @m
	GOTO done
	END
If @m = 0
	BEGIN
	SET @LD = @n
	GOTO done
	END
--Step 2
SET @i=0
WHILE @i<=@n
	BEGIN
	SET @d=STUFF(@d,@i+1,1,CHAR(@i))--d(i, 0) = i
	SET @i=@i+1
	END

SET @i=0
WHILE @i<=@m
	BEGIN
	SET @d=STUFF(@d,@i*(@n+1)+1,1,CHAR(@i))--d(0, j) = j
	SET @i=@i+1
	END
--goto done
--Step 3
	SET @i=1
	WHILE @i<=@n
		BEGIN
		SET @s_i=(substring(@s,@i,1))
--Step 4
	SET @j=1
	WHILE @j<=@m
		BEGIN
		SET @t_j=(substring(@t,@j,1))
		--Step 5
		If @s_i = @t_j
			SET @cost=0
		ELSE
			SET @cost=1
--Step 6
		SET @d=STUFF(@d,@j*(@n+1)+@i+1,1,CHAR(dbo.MIN3(
		ASCII(substring(@d,@j*(@n+1)+@i-1+1,1))+1,
		ASCII(substring(@d,(@j-1)*(@n+1)+@i+1,1))+1,
		ASCII(substring(@d,(@j-1)*(@n+1)+@i-1+1,1))+@cost)
		))
		SET @j=@j+1
		END
	SET @i=@i+1
	END      
--Step 7
SET @LD = ASCII(substring(@d,@n*(@m+1)+@m+1,1))
done:
--RETURN @LD
--I kept this code that can be used to display the matrix with all calculated values
--From Query Analyser it provides a nice way to check the algorithm in action
--
RETURN @LD
--declare @z varchar(8000)
--set @z=''
--SET @i=0
--WHILE @i<=@n
--	BEGIN
--	SET @j=0
--	WHILE @j<=@m
--		BEGIN
--		set @z=@z+CONVERT(char(3),ASCII(substring(@d,@i*(@m+1 )+@j+1 ,1)))
--		SET @j=@j+1 
--		END
--	SET @i=@i+1
--	END
--print dbo.wrap(@z,3*(@n+1))
END




GO
/****** Object:  UserDefinedFunction [dbo].[LOG2]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[LOG2]( @n float) 
--Returns the logarithm (base 2) of the given float expression.
returns float
as
BEGIN
    return LOG(@n)/LOG(2)
END



GO
/****** Object:  UserDefinedFunction [dbo].[LOGN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[LOGN](@b float, @n float) 
--Returns the logarithm (base b) of the given float expression.
returns float
as
BEGIN
    return LOG(@n)/LOG(@b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[LPAD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[LPAD](@s varchar(255), @n int, @p varchar(255) ) 
--Returns a string s1 left-padded to length i with a sequence of characters s2. 
returns varchar(255)
as
BEGIN
return REPLICATE(@p,@n)+@s
END




GO
/****** Object:  UserDefinedFunction [dbo].[MAX2]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[MAX2](@a int,@b int ) 
--Returns the largest of 2 numbers.
returns int
as
BEGIN
declare @temp int
if (@a > @b) 
	select @temp=@a
else 
	select @temp=@b
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[MAX3]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[MAX3](@a int,@b int,@c int ) 
--Returns the largest of 3 numbers.
returns int
as
BEGIN
declare @temp int
if (@a > @b)  AND (@a > @c)
	select @temp=@a
else 
	if (@b > @a)  AND (@b > @c)
		select @temp=@b
	else
		select @temp=@c
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[MIN2]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[MIN2](@a int,@b int ) 
--Returns the smallest of 2 numbers.
returns int
as
BEGIN
declare @temp int
if (@a < @b) 
	select @temp=@a
else 
	select @temp=@b
return @temp
END




GO
/****** Object:  UserDefinedFunction [dbo].[MIN3]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[MIN3](@a int,@b int,@c int ) 
--Returns the smallest of 3 numbers.
returns int
as
BEGIN
declare @temp int
if (@a < @b)  AND (@a < @c)
	select @temp=@a
else 
	if (@b < @a)  AND (@b < @c)
		select @temp=@b
	else
		select @temp=@c
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[MONTHS_BETWEEN]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[MONTHS_BETWEEN] ( @d datetime, @e datetime ) 
--Returns number of months between dates d1 and d2. 
returns int
as
BEGIN
return datediff(m, @d, @e)
END



GO
/****** Object:  UserDefinedFunction [dbo].[MORSE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[MORSE](@s varchar(255) ) 
--Returns the morse code corresponding to a string.
returns  varchar(255)
as
BEGIN
DECLARE @i int,@result varchar(255),@chars1 char(26),@chars2 char(10)
DECLARE @chars3 char(3), @morse1 char(104)
DECLARE @morse2 char(50),@morse3 char(18), @temp char(1)
SET @chars1='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
SET @chars2='0123456789'
SET @chars3='.,?'
SET @morse1='.-  -...-.-.-.. .   ..-.--. ......  .----.- .-..--  -.  --- .--.--.-.-. ... -   ..- ...-.-- -..--.----..'
SET @morse2='-----.----..---...--....-.....-....--...---..----.'
SET @morse3='.-.-.---..--..--..'
SET @result=''
SET @i=1
WHILE (@i<=LEN(@s))
BEGIN
SET @temp=UPPER(SUBSTRING(@s,@i,1))
IF CHARINDEX(@temp,@chars1)>0
	SET @result=@result+' '+SUBSTRING(@morse1,CHARINDEX(@temp,@chars1)*4-3,4)
IF CHARINDEX(@temp,@chars2)>0
	SET @result=@result+' '+SUBSTRING(@morse2,CHARINDEX(@temp,@chars2)*5-4,5)
IF CHARINDEX(@temp,@chars3)>0
	SET @result=@result+' '+SUBSTRING(@morse3,CHARINDEX(@temp,@chars3)*6-5,6)
SET @i=@i+1
END
WHILE CHARINDEX('  ',@result)>0
	SET @result=REPLACE(@result,'  ',' ')
RETURN @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[NAND]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NAND](@a int, @b int ) 
--Returns the result of a logical negated AND.
returns int
as
BEGIN
return ~(@a & @b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[NEXT_DAY]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NEXT_DAY]( @d datetime, @n int ) 
returns datetime
as
BEGIN
declare @i int, @result datetime
IF (@n<1)OR (@n>7)
	SET @n=1
SET @i=2
SET @result=dateadd(d,1,@d)
WHILE DATEPART(dw,@result)<>@n
	BEGIN
	set @result=dateadd(d,1,@result)
	set @i=@i+1
	END
RETURN  @result
END


GO
/****** Object:  UserDefinedFunction [dbo].[NINT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NINT](@a float ) 
--Rounds a number to the nearest integer.
returns int
as
BEGIN
return convert(int,round(@a,0))
END



GO
/****** Object:  UserDefinedFunction [dbo].[NOR]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NOR](@a int, @b int ) 
--Returns the result of a logical negated OR.
returns int
as
BEGIN
return ~(@a | @b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[NROOT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NROOT](@a float, @b float) 
--Returns the n root of a number.
returns float
as
BEGIN
return POWER(@a,1/@b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[NTODEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NTODEC](@s VARCHAR(255), @b int) 
--Converts a number on base n to decimal.
returns int
as
BEGIN
DECLARE @i int, @temp char(1), @result int
SELECT @i=1
SELECT @result=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=UPPER(SUBSTRING(@s,@i,1))
IF (@temp>='0') AND (@temp<='9') 
	SELECT @result=@result+ (ASCII(@temp)-48)*POWER(@b,LEN(@s)-@i)
ELSE
	SELECT @result=@result+ (ASCII(@temp)-55)*POWER(@b,LEN(@s)-@i)
SELECT @i=@i+1
END
return @result
END






GO
/****** Object:  UserDefinedFunction [dbo].[NUMBERTOWORDS]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[NUMBERTOWORDS](@n bigint ) 
--Returns the number as words.
returns VARCHAR(255) 
as
BEGIN
DECLARE @i int, @temp char(1),  @s VARCHAR(20), @result VARCHAR(255)
SELECT @s=convert(varchar(20), @n)
SELECT @i=LEN(@s)
SELECT @result=''
WHILE (@i>0)
BEGIN
SELECT @temp=(SUBSTRING(@s,@i,1))
IF ((LEN(@s)-@i) % 3)=1
IF @temp='1'
SELECT @result=CASE (SUBSTRING(@s,@i+1,1))
	WHEN '0' THEN 'ten'
	WHEN '1' THEN 'eleven'
	WHEN '2' THEN 'twelve'
	WHEN '3' THEN 'thirteen'
	WHEN '4' THEN 'fourteen'
	WHEN '5' THEN 'fifteen'
	WHEN '6' THEN 'sixteen'
	WHEN '7' THEN 'seventeen'
	WHEN '8' THEN 'eighteen'
	WHEN '9' THEN 'nineteen'
	END+' '+CASE
			WHEN ((LEN(@s)-@i)=4) THEN 'thousand '
			WHEN ((LEN(@s)-@i)=7) THEN 'million '
			WHEN ((LEN(@s)-@i)=10) THEN 'billion '
			WHEN ((LEN(@s)-@i)=13) THEN 'trillion '
			WHEN ((LEN(@s)-@i)=16) THEN 'quadrillion '
			WHEN ((LEN(@s)-@i)=19) THEN 'quintillion '
			WHEN ((LEN(@s)-@i)=22) THEN 'sextillion '
			WHEN ((LEN(@s)-@i)=25) THEN 'septillion '
			WHEN ((LEN(@s)-@i)=28) THEN 'octillion '
			WHEN ((LEN(@s)-@i)=31) THEN 'nonillion '
			WHEN ((LEN(@s)-@i)=34) THEN 'decillion '
			WHEN ((LEN(@s)-@i)=37) THEN 'undecillion '
			WHEN ((LEN(@s)-@i)=40) THEN 'duodecillion '
			WHEN ((LEN(@s)-@i)=43) THEN 'tredecillion '
			WHEN ((LEN(@s)-@i)=46) THEN 'quattuordecillion '
			WHEN ((LEN(@s)-@i)=49) THEN 'quindecillion '
			WHEN ((LEN(@s)-@i)=52) THEN 'sexdecillion '
			WHEN ((LEN(@s)-@i)=55) THEN 'septendecillion '
			WHEN ((LEN(@s)-@i)=58) THEN 'octodecillion '
			WHEN ((LEN(@s)-@i)=61) THEN 'novemdecillion '
			ELSE ''
			END+@result
ELSE
BEGIN
	SELECT @result=CASE (SUBSTRING(@s,@i+1,1))
		WHEN '0' THEN ''
		WHEN '1' THEN 'one'
		WHEN '2' THEN 'two'
		WHEN '3' THEN 'three'
		WHEN '4' THEN 'four'
		WHEN '5' THEN 'five'
		WHEN '6' THEN 'six'
		WHEN '7' THEN 'seven'
		WHEN '8' THEN 'eight'
		WHEN '9' THEN 'nine'
		END+' '+ CASE
			WHEN ((LEN(@s)-@i)=4) THEN 'thousand '
			WHEN ((LEN(@s)-@i)=7) THEN 'million '
			WHEN ((LEN(@s)-@i)=10) THEN 'billion '
			WHEN ((LEN(@s)-@i)=13) THEN 'trillion '
			WHEN ((LEN(@s)-@i)=16) THEN 'quadrillion '
			WHEN ((LEN(@s)-@i)=19) THEN 'quintillion '
			WHEN ((LEN(@s)-@i)=22) THEN 'sextillion '
			WHEN ((LEN(@s)-@i)=25) THEN 'septillion '
			WHEN ((LEN(@s)-@i)=28) THEN 'octillion '
			WHEN ((LEN(@s)-@i)=31) THEN 'nonillion '
			WHEN ((LEN(@s)-@i)=34) THEN 'decillion '
			WHEN ((LEN(@s)-@i)=37) THEN 'undecillion '
			WHEN ((LEN(@s)-@i)=40) THEN 'duodecillion '
			WHEN ((LEN(@s)-@i)=43) THEN 'tredecillion '
			WHEN ((LEN(@s)-@i)=46) THEN 'quattuordecillion '
			WHEN ((LEN(@s)-@i)=49) THEN 'quindecillion '
			WHEN ((LEN(@s)-@i)=52) THEN 'sexdecillion '
			WHEN ((LEN(@s)-@i)=55) THEN 'septendecillion '
			WHEN ((LEN(@s)-@i)=58) THEN 'octodecillion '
			WHEN ((LEN(@s)-@i)=61) THEN 'novemdecillion '
			ELSE ''
			END+@result
	SELECT @result=CASE @temp
		WHEN '0' THEN ''
		WHEN '1' THEN 'ten'
		WHEN '2' THEN 'twenty'
		WHEN '3' THEN 'thirty'
		WHEN '4' THEN 'fourty'
		WHEN '5' THEN 'fifty'
		WHEN '6' THEN 'sixty'
		WHEN '7' THEN 'seventy'
		WHEN '8' THEN 'eighty'
		WHEN '9' THEN 'ninety'
		END+' '+@result
END
IF (((LEN(@s)-@i) % 3)=2) OR (((LEN(@s)-@i) % 3)=0) AND (@i=1)
BEGIN
SELECT @result=CASE @temp
	WHEN '0' THEN ''
	WHEN '1' THEN 'one'
	WHEN '2' THEN 'two'
	WHEN '3' THEN 'three'
	WHEN '4' THEN 'four'
	WHEN '5' THEN 'five'
	WHEN '6' THEN 'six'
	WHEN '7' THEN 'seven'
	WHEN '8' THEN 'eight'
	WHEN '9' THEN 'nine'
	END +' '+CASE
		WHEN (@s='0') THEN 'zero'
		WHEN (@temp<>'0')AND( ((LEN(@s)-@i) % 3)=2) THEN 'hundred '
		ELSE ''
		END + CASE
		WHEN ((LEN(@s)-@i)=3) THEN 'thousand '
		WHEN ((LEN(@s)-@i)=6) THEN 'million '
		WHEN ((LEN(@s)-@i)=9) THEN 'billion '
		WHEN ((LEN(@s)-@i)=12) THEN 'trillion '
		WHEN ((LEN(@s)-@i)=15) THEN 'quadrillion '
		WHEN ((LEN(@s)-@i)=18) THEN 'quintillion '
		WHEN ((LEN(@s)-@i)=21) THEN 'sextillion '
		WHEN ((LEN(@s)-@i)=24) THEN 'septillion '
		WHEN ((LEN(@s)-@i)=27) THEN 'octillion '
		WHEN ((LEN(@s)-@i)=30) THEN 'nonillion '
		WHEN ((LEN(@s)-@i)=33) THEN 'decillion '
		WHEN ((LEN(@s)-@i)=36) THEN 'undecillion '
		WHEN ((LEN(@s)-@i)=39) THEN 'duodecillion '
		WHEN ((LEN(@s)-@i)=42) THEN 'tredecillion '
		WHEN ((LEN(@s)-@i)=45) THEN 'quattuordecillion '
		WHEN ((LEN(@s)-@i)=48) THEN 'quindecillion '
		WHEN ((LEN(@s)-@i)=51) THEN 'sexdecillion '
		WHEN ((LEN(@s)-@i)=54) THEN 'septendecillion '
		WHEN ((LEN(@s)-@i)=57) THEN 'octodecillion '
		WHEN ((LEN(@s)-@i)=60) THEN 'novemdecillion '
		ELSE ''
			END+ @result
END
SELECT @i=@i-1
END
return REPLACE(@result,'  ',' ')
END












GO
/****** Object:  UserDefinedFunction [dbo].[OCTTODEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[OCTTODEC](@s VARCHAR(255) ) 
--Converts an octal number to decimal.
returns int
as
BEGIN
DECLARE @i int, @temp char(1), @result int
SELECT @i=1
SELECT @result=0
WHILE (@i<=LEN(@s))
BEGIN
SELECT @temp=SUBSTRING(@s,@i,1)
SELECT @result=@result+ (ASCII(@temp)-48)*POWER(8,LEN(@s)-@i)
SELECT @i=@i+1
END
return @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[PALINDROME]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[PALINDROME](@n int ) 
--Returns true if the number is a palindrome.
returns bit
as
BEGIN
DECLARE @i int,@bool bit, @s varchar(20)
SET @s=convert(varchar(20),@n)
SET @i=1
SET @bool=1
WHILE (@i<=LEN(@s)/2)
BEGIN
IF SUBSTRING(@s,@i,1)<>SUBSTRING(@s,LEN(@s)-@i+1,1)
	SET @bool=0
SET @i=@i+1
END
RETURN @bool
END



GO
/****** Object:  UserDefinedFunction [dbo].[PALINDROMEW]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[PALINDROMEW]( @s varchar(255) ) 
--Returns true if the string is a palindrome.
returns bit
as
BEGIN
DECLARE @i int,@bool bit
SET @i=1
SET @bool=1
WHILE (@i<=LEN(@s)/2)
BEGIN
IF SUBSTRING(@s,@i,1)<>SUBSTRING(@s,LEN(@s)-@i+1,1)
	SET @bool=0
SET @i=@i+1
END
RETURN @bool
END




GO
/****** Object:  UserDefinedFunction [dbo].[PENTIUMBUG]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[PENTIUMBUG]( ) 
returns bit
as
BEGIN
DECLARE @i float, @j float, @b bit
SET @i=4195835
SET @j=3145727
IF convert(varchar(255),(@i / @j))='1.33382'
	SET @b=0
ELSE
	SET @b=1
RETURN (@b)
END


GO
/****** Object:  UserDefinedFunction [dbo].[PERFNUMBER]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[PERFNUMBER](@n int ) 
--Returns the nth perfect number. 
returns bigint
as
BEGIN
RETURN POWER(2,@n-1)*(POWER(2,@n)-1)
END



GO
/****** Object:  UserDefinedFunction [dbo].[PHI]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[PHI]() 
--Returns phi, the "golden ratio".
returns float
as
BEGIN
declare @temp float
select @temp=(1 + SQRT(5))/2 
return @temp
END



GO
/****** Object:  UserDefinedFunction [dbo].[PROPERCASE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[PROPERCASE](@s varchar(255)) 
--Returns a string with the first letter of each word at the beginning of a sentence  in uppercase, all other letters in lowercase
returns  varchar(255)
as
BEGIN
DECLARE @i int, @c char(1),@result varchar(255)
SET @result=LOWER(@s)
SET @i=2
SET @result=STUFF(@result,1,1,UPPER(SUBSTRING(@s,1,1)))
WHILE @i<=LEN(@s)
	BEGIN
	SET @c=SUBSTRING(@s,@i,1)
	IF (@c='!') OR (@c='?') OR (@c='_')OR (@c='.')
		IF @i<LEN(@s)
			BEGIN
lblSeek:
			SET @i=@i+1
			IF UPPER(SUBSTRING(@s,@i,1)) LIKE '[A-Z]'
				SET @result=STUFF(@result,@i,1,UPPER(SUBSTRING(@s,@i,1)))
			ELSE
				IF @i<LEN(@s)
					GOTO lblSeek
			END
	SET @i=@i+1
	END
RETURN  @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[RAD2GRAD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[RAD2GRAD](@a float ) 
--Converts an angle from radians to grads.
returns float
as
BEGIN
return (@a*PI()/200.0)
END


GO
/****** Object:  UserDefinedFunction [dbo].[RESETBIT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[RESETBIT](@a int, @b int ) 
--Resets the value of a certain bit.
returns int
as
BEGIN
return @a | ~(POWER(2,@b))
END



GO
/****** Object:  UserDefinedFunction [dbo].[REWRAP]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[REWRAP](@s varchar(255), @n int ) 
--Returns a string s wrapped in blocks of i characters, removing previous wrapping. 
returns varchar(255)
as
BEGIN
DECLARE @t VARCHAR(255), @i int
SET @i=1
SET @t=''
SET @s=REPLACE(@s,CHAR(10),'')
SET @s=REPLACE(@s,CHAR(13),'')
WHILE @i<=LEN(@s)
	BEGIN
	SET @t=@t+substring(@s,@i,1)
	IF (@i % @n)=0
		SET @t=@t+CHAR(13)
	SET @i=@i+1
	END
RETURN  @t
END




GO
/****** Object:  UserDefinedFunction [dbo].[ROMAN2A]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[ROMAN2A](@s VARCHAR(20)) 
--Converts an roman numeral to arabic.
returns int
as
BEGIN
declare @f int, @k int, @z int, @z1 int
select @f=LEN(@s)
select @k=0
select @z1=0
WHILE (@f>0)
BEGIN
	select @z = CASE UPPER(SUBSTRING(@s,@f,1))
	WHEN 'I' THEN 1
	WHEN 'V' THEN 5
	WHEN 'X' THEN 10
	WHEN 'L' THEN 50
	WHEN 'C' THEN 100
	WHEN 'D' THEN 500
	WHEN 'M' THEN 1000
	END
IF @z1>@z
	SELECT @k=@k-@z
ELSE
	BEGIN
	SELECT @k=@k+@z
	SELECT @z1=@z
	END
select @f=@f-1
END
return @k
END








GO
/****** Object:  UserDefinedFunction [dbo].[RPAD]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[RPAD](@s varchar(255), @n int, @p varchar(255) ) 
--Returns a string s1 right-padded to length i with a sequence of characters s2. 
returns varchar(255)
as
BEGIN
return @s+REPLICATE(@p,@n)
END



GO
/****** Object:  UserDefinedFunction [dbo].[SEC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SEC](@a float ) 
--Returns the trigonometric secant of the given angle (in radians) in the given expression.
returns float
as
BEGIN
return (1/COS(@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[SECH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SECH](@a float ) 
--Returns the hyperbolic secant of a number.
returns float
as
BEGIN
return 2/( POWER(dbo.E(),@a) +  POWER(dbo.E(),-@a) )
END



GO
/****** Object:  UserDefinedFunction [dbo].[SETBIT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SETBIT](@a int, @b int ) 
--Sets the value of a certain bit.
returns int
as
BEGIN
return @a | (POWER(2,@b))
END



GO
/****** Object:  UserDefinedFunction [dbo].[SHIFTLEFT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SHIFTLEFT](@a int, @b int ) 
--Returns a number shifted to the left.
returns int
as
BEGIN
return @a * POWER(2, @b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[SHIFTRIGHT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SHIFTRIGHT](@a int, @b int ) 
--Returns a number shifted to the right.
returns int
as
BEGIN
return @a / POWER(2, @b)
END



GO
/****** Object:  UserDefinedFunction [dbo].[SINH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SINH](@a float ) 
--Returns the hyperbolic sine of a number.
returns float
as
BEGIN
return ( POWER(dbo.E(),@a) -  POWER(dbo.E(),-@a) )/2
END



GO
/****** Object:  UserDefinedFunction [dbo].[SLOPE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[SLOPE](@x1 float,@y1 float, @x2 float,@y2 float) 
--Returns the slope of a line define by 2 points P(f1, f2) and T(f3, f4). 
returns float
as
BEGIN
return (@y2-@y1)/(@x2-@x1)
END



GO
/****** Object:  UserDefinedFunction [dbo].[SQRTPI]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SQRTPI](@a float ) 
--Returns the square root of (number * Pi).
returns float
as
BEGIN
return SQRT(@a*PI())
END



GO
/****** Object:  UserDefinedFunction [dbo].[STRIPL]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[STRIPL](@s varchar(255) ) 
--Returns the left side of half of the string. 
returns varchar(255)
as
BEGIN
return LEFT(@s, LEN(@s)/2)
END



GO
/****** Object:  UserDefinedFunction [dbo].[STRIPR]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[STRIPR](@s varchar(255) ) 
--Returns the right side of half of the string. 
returns varchar(255)
as
BEGIN
DECLARE @i int
SET @i=LEN(@s)-LEN(@s)/2
return RIGHT(@s, @i)
END



GO
/****** Object:  UserDefinedFunction [dbo].[SUMALIQUOT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[SUMALIQUOT] (@n bigint ) 
--Returns the sum of all aliquots from i
returns bigint
as
BEGIN
DECLARE @i bigint, @j bigint
SET @i=1
SET @j=0
WHILE @i<=@n/2
BEGIN
IF (@n % @i)=0
	SET @j=@j+@i
SET @i=@i+1
END
RETURN @j
END



GO
/****** Object:  UserDefinedFunction [dbo].[SUMSEQ]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[SUMSEQ](@n bigint) 
--Returns the summation of all integers from 1 to n.
returns bigint
as
BEGIN
    return (@n+@n*@n)/2
END



GO
/****** Object:  UserDefinedFunction [dbo].[TANH]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[TANH](@a float ) 
--Returns the hyperbolic tangent of a number.
returns float
as
BEGIN
return (dbo.SINH(@a)/dbo.COSH(@a))
END



GO
/****** Object:  UserDefinedFunction [dbo].[TRANSLATE]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[TRANSLATE]( @s varchar(255), @f varchar(255), @t varchar(255) ) 
returns varchar(255)
as
BEGIN
DECLARE @i int, @j int, @c char(1),@result varchar(255)
SET @i=1
SET @result=''
WHILE @i<=LEN(@s)
	BEGIN
	SET @c=SUBSTRING(@s,@i,1)
	SET @j=CHARINDEX(@c,@f)
	IF @j>0
		SET @result=@result + SUBSTRING(@t,@j,1)
	SET @i=@i+1
	END
RETURN @result
END


GO
/****** Object:  UserDefinedFunction [dbo].[TRIM]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[TRIM](@s VARCHAR(255) ) 
--Returns a string removing spaces at both ends.
returns  VARCHAR(255) 
as
BEGIN
return RTRIM(LTRIM(@s))
END



GO
/****** Object:  UserDefinedFunction [dbo].[TRUNC]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[TRUNC](@a float ) 
--Returns a number truncated to an integer.
returns int
as
BEGIN
return convert(int,@a)
END



GO
/****** Object:  UserDefinedFunction [dbo].[UNWRAP]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[UNWRAP](@s varchar(255)) 
--Returns a string removing all wrapping. 
returns varchar(255)
as
BEGIN
SET @s=REPLACE(@s,CHAR(10),'')
SET @s=REPLACE(@s,CHAR(13),'')
RETURN @s
END





GO
/****** Object:  UserDefinedFunction [dbo].[VAL]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[VAL](@a VARCHAR(50) ) 
--Returns a numeric value from a string, it is the opposite of STR.
returns float
as
BEGIN
declare @temp float
if (ISNUMERIC(@a)=1)
	select @temp=convert(float,@a)
ELSE
	select @temp=0
return @temp
END




GO
/****** Object:  UserDefinedFunction [dbo].[VALIDEMAIL]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[VALIDEMAIL](@s varchar(255)) 
--Returns true if the string is a valid email address.
returns bit
as
BEGIN
DECLARE @u VARCHAR(60), @v VARCHAR(60), @x VARCHAR(60), @i int, @j int, @result bit
SET @result=1
SET @i=CHARINDEX('@',@s)
SET @u=LEFT(@s,@i-1)
SET @j=dbo.CHARINDEXREV('.',@s)
SET @v=RIGHT(@s,LEN(@s)-@j)
SET @x=substring(@s,@i+1,@j-@i-1)
IF LEN(@x)<3
	BEGIN
	SET @result=0
	GOTo done
	END
IF (LEN(@x)=3) AND (@x NOT LIKE '[a-z,A-Z][a-z,A-Z][a-z,A-Z]')
	BEGIN
	SET @result=0
	GOTo done
	END
IF (LEN(@x)=2) AND (@x NOT LIKE '[a-z,A-Z][a-z,A-Z]')
	BEGIN
	SET @result=0
	GOTo done
	END
SET @i=1
WHILE (@i<LEN(@u))
	BEGIN
	IF SUBSTRING(@u,@i,1) NOT LIKE '[a-z,A-Z,0-9,_,-,.]'
		BEGIN
		SET @result=0
		GOTo done
		END
	SET @i=@i+1
	END
SET @i=1
WHILE (@i<LEN(@v))
	BEGIN
	IF SUBSTRING(@v,@i,1) NOT LIKE '[a-z,A-Z,0-9,_,-,.]'
		BEGIN
		SET @result=0
		GOTo done
		END
	SET @i=@i+1
	END
done:
return @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[VALIDIP]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[VALIDIP](@s varchar(15)) 
--Returns true if the string is a IP.
returns bit
as
BEGIN
DECLARE @u VARCHAR(3), @v VARCHAR(3), @x VARCHAR(3),@y VARCHAR(3), @i int, @j int, @result bit
SET @result=1
IF dbo.INCLUDED('.',@s)<>3
	BEGIN
	SET @result=0
	GOTO done
	END
SET @i=CHARINDEX('.',@s)
SET @u=LEFT(@s,@i-1)
SET @j=CHARINDEX('.',@s,@i+1)
SET @v=substring(@s,@i+1,@j-@i-1)
SET @i=CHARINDEX('.',@s,@j+1)
SET @x=substring(@s,@j+1,@i-@j-1)
SET @y=substring(@s,@i+1,LEN(@s)-@i)
IF ISNUMERIC(@u)=0 OR ISNUMERIC(@v)=0 OR ISNUMERIC(@x)=0 OR ISNUMERIC(@y)=0
	BEGIN
	SET @result=0
	GOTo done
	END
IF (CONVERT(INT, @u)<0) OR  (CONVERT(INT, @v)<0) OR  (CONVERT(INT, @x)<0)  OR  (CONVERT(INT, @y)<0) 
	BEGIN
	SET @result=0
	GOTo done
	END
IF (CONVERT(INT, @u)>255) OR  (CONVERT(INT, @v)>255) OR  (CONVERT(INT, @x)>255)  OR  (CONVERT(INT, @y)>255) 
	BEGIN
	SET @result=0
	GOTo done
	END
done:
RETURN  @result
END





GO
/****** Object:  UserDefinedFunction [dbo].[VALIDZIP]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[VALIDZIP](@s varchar(5)) 
--Returns true if the string is a valid zip code.
returns bit
as
BEGIN
DECLARE @result bit
IF @s LIKE '[1-9][0-9][0-9][0-9][0-9]'
SET @s=1
ELSE
SET @s=0
return @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[VALIDZIP9]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[VALIDZIP9](@s varchar(10)) 
--Returns true if the string is a valid zip code 5+4.
returns bit
as
BEGIN
DECLARE @result bit
IF @s LIKE '[1-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'
SET @s=1
ELSE
SET @s=0
return @result
END



GO
/****** Object:  UserDefinedFunction [dbo].[WORDCOUNT]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[WORDCOUNT](@s varchar(255)) 
--Returns the number of words from string s. 
returns INT
as
BEGIN
DECLARE @i INT
SET @s=REPLACE(@s,CHAR(10),' ')
SET @s=REPLACE(@s,CHAR(13),' ')
SET @s=REPLACE(@s,'0','')
SET @s=REPLACE(@s,'1','')
SET @s=REPLACE(@s,'2','')
SET @s=REPLACE(@s,'3','')
SET @s=REPLACE(@s,'4','')
SET @s=REPLACE(@s,'5','')
SET @s=REPLACE(@s,'6','')
SET @s=REPLACE(@s,'7','')
SET @s=REPLACE(@s,'8','')
SET @s=REPLACE(@s,'9','')
SET @s=REPLACE(@s,'!',' ')
SET @s=REPLACE(@s,';',' ')
SET @s=REPLACE(@s,':',' ')
SET @s=REPLACE(@s,'[',' ')
SET @s=REPLACE(@s,']',' ')
SET @s=REPLACE(@s,'+',' ')
SET @s=REPLACE(@s,'{',' ')
SET @s=REPLACE(@s,'}',' ')
SET @s=REPLACE(@s,'&','')
SET @s=REPLACE(@s,'.',' ')
SET @s=REPLACE(@s,',',' ')
SET @s=REPLACE(@s,'?',' ')
SET @s=REPLACE(@s,'/',' ')
SET @s=REPLACE(@s,'_',' ')
SET @s=REPLACE(@s,'-','')
SET @s=REPLACE(@s,'(',' ')
SET @s=REPLACE(@s,')',' ')
SET @s=REPLACE(@s,'''','')
SET @s=REPLACE(@s,'"',' ')
WHILE CHARINDEX ('  ',@s)>0
	SET @s=REPLACE(@s,'  ',' ')
SET @s=RTRIM(LTRIM(@s))
SET @i=dbo.INCLUDED(' ',@s)+1
RETURN @i
END



GO
/****** Object:  UserDefinedFunction [dbo].[WRAP]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[WRAP](@s varchar(255), @n int ) 
--Returns a string s wrapped in blocks of i characters. 
returns varchar(255)
as
BEGIN
DECLARE @t VARCHAR(255), @i int
SET @i=1
SET @t=''
WHILE @i<=LEN(@s)
	BEGIN
	SET @t=@t+substring(@s,@i,1)
	IF (@i % @n)=0
		SET @t=@t+CHAR(13)
	SET @i=@i+1
	END
RETURN  @t
END




GO
/****** Object:  UserDefinedFunction [dbo].[XORCHAR]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[XORCHAR]( @s VARCHAR(255), @x tinyint ) 
--Returns a string encrypted/decrypted with key t ( XOR encryption )
returns VARCHAR(255)
as
BEGIN
DECLARE @result VARCHAR(255), @i int, @temp tinyint
SET @i=1
SET @result=''
WHILE @i<=LEN(@s)
	BEGIN
	SET @temp=ASCII(SUBSTRING(@s,@i,1))
	SET @result=@result + CHAR(@temp ^ @x)
	SET @i=@i+1
	END
RETURN @result
END



GO
/****** Object:  Table [dbo].[Answer]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answer](
	[AnswerID] [int] IDENTITY(1,1) NOT NULL,
	[AnswerBody] [nvarchar](max) NULL,
	[IsSpam] [bit] NULL,
	[CreatorID] [int] NULL,
	[CreatedID] [datetime] NULL,
	[QuestionID] [int] NULL,
	[GUID] [uniqueidentifier] NULL,
	[Likes] [int] NULL,
 CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED 
(
	[AnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Article]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Article](
	[ArticlesID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Summary] [nvarchar](max) NULL,
	[Content] [nvarchar](max) NULL,
	[DatePublish] [datetime] NULL,
	[IsPublish] [bit] NULL,
	[IsActive] [bit] NULL,
	[Views] [int] NULL,
	[GUID] [uniqueidentifier] NULL,
	[CreatorIP] [nvarchar](max) NULL,
	[ModiferIP] [nvarchar](max) NULL,
	[CreatorUserAgent] [nvarchar](max) NULL,
	[CategoryID] [int] NULL,
	[UserID] [int] NULL,
	[Likes] [int] NULL,
 CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED 
(
	[ArticlesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ArticlesInCategory]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticlesInCategory](
	[ArticleID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_ArticlesInCategory] PRIMARY KEY CLUSTERED 
(
	[ArticleID] ASC,
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ArticlesLikes]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticlesLikes](
	[ArticleID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[DateLike] [datetime] NULL,
	[CreatorIP] [nvarchar](50) NULL,
	[GUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ArticlesLikes] PRIMARY KEY CLUSTERED 
(
	[ArticleID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ArticlesRating]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticlesRating](
	[ArticlesID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[DateRating] [datetime] NULL,
	[CreatorIP] [datetime] NULL,
	[GUID] [uniqueidentifier] NULL,
	[Score] [int] NULL,
 CONSTRAINT [PK_ArticlesRating] PRIMARY KEY CLUSTERED 
(
	[ArticlesID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[Name] [nvarchar](255) NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[City]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[City](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[CountryID] [int] NULL,
	[Name] [nvarchar](255) NULL,
	[ZipCode] [varchar](20) NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Comment]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Comment](
	[CommentID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[CreatorIP] [varchar](50) NULL,
	[CreatorUserAgent] [varchar](max) NULL,
	[CreatorEmail] [nvarchar](100) NULL,
	[CreatorName] [nvarchar](50) NULL,
	[Title] [nvarchar](255) NULL,
	[Body] [nvarchar](2500) NULL,
	[IsActive] [bit] NULL,
	[IsSpam] [bit] NULL,
	[Created] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedByUserID] [int] NULL,
	[ArticleID] [int] NULL,
	[AnswerID] [int] NULL,
 CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[Name] [nvarchar](255) NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Question]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionTitle] [varchar](200) NULL,
	[QuestionBody] [nvarchar](max) NULL,
	[CreatorID] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[GUID] [uniqueidentifier] NULL,
	[Likes] [int] NULL,
	[NumOfViews] [int] NULL,
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QuestionInCategory]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionInCategory](
	[QuestionID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_QuestionInCategory] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC,
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[Name] [nvarchar](255) NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tag]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tag](
	[TagID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TagInArticle]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagInArticle](
	[Articles_ArticlesID] [int] NOT NULL,
	[Tag_TagID] [int] NOT NULL,
 CONSTRAINT [PK_TagInArticle] PRIMARY KEY NONCLUSTERED 
(
	[Articles_ArticlesID] ASC,
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TagInQuestion]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagInQuestion](
	[Questions_QuestionID] [int] NOT NULL,
	[Tag_TagID] [int] NOT NULL,
 CONSTRAINT [PK_TagInQuestion] PRIMARY KEY NONCLUSTERED 
(
	[Questions_QuestionID] ASC,
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[FirstName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[Gender] [char](1) NULL,
	[Phone] [varchar](50) NULL,
	[Address] [nvarchar](255) NULL,
	[CityID] [int] NULL,
	[UserName] [nvarchar](256) NULL,
	[Password] [nvarchar](128) NULL,
	[PasswordFormat] [int] NULL,
	[PasswordSalt] [nvarchar](128) NULL,
	[Email] [nvarchar](256) NULL,
	[LoweredEmail] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[PhotoLocation] [nvarchar](500) NULL,
	[LastActivity] [datetime] NULL,
	[LastLogin] [datetime] NULL,
	[LastPasswordChange] [datetime] NULL,
	[LastLockout] [datetime] NULL,
	[IsApproved] [bit] NULL,
	[IsLockedOut] [bit] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
	[LocationCover] [nvarchar](max) NULL,
	[CoverPostion] [nvarchar](max) NULL,
	[IsFirst] [bit] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 21.2.2013. 8:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[Role_RoleID] [int] NOT NULL,
	[User_UserID] [int] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY NONCLUSTERED 
(
	[Role_RoleID] ASC,
	[User_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_FK_Answers_Questions]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Answers_Questions] ON [dbo].[Answer]
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Answers_User]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Answers_User] ON [dbo].[Answer]
(
	[CreatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Articles_Category]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Articles_Category] ON [dbo].[Article]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_City_Country]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_City_Country] ON [dbo].[City]
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Comment_Articles]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Comment_Articles] ON [dbo].[Comment]
(
	[ArticleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_MerchantComment_User]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_MerchantComment_User] ON [dbo].[Comment]
(
	[CreatedByUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_MerchantComment_User1]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_MerchantComment_User1] ON [dbo].[Comment]
(
	[ModifiedByUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Questions_User]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Questions_User] ON [dbo].[Question]
(
	[CreatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_TagInArticle_Tag]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_TagInArticle_Tag] ON [dbo].[TagInArticle]
(
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_TagInQuestion_Tag]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_TagInQuestion_Tag] ON [dbo].[TagInQuestion]
(
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_User_City]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_User_City] ON [dbo].[User]
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_UserRole_User]    Script Date: 21.2.2013. 8:27:10 ******/
CREATE NONCLUSTERED INDEX [IX_FK_UserRole_User] ON [dbo].[UserRole]
(
	[User_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answers_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answers_Questions]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answers_User] FOREIGN KEY([CreatorID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answers_User]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_Articles_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_Articles_User]
GO
ALTER TABLE [dbo].[ArticlesInCategory]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesInCategory_Articles] FOREIGN KEY([ArticleID])
REFERENCES [dbo].[Article] ([ArticlesID])
GO
ALTER TABLE [dbo].[ArticlesInCategory] CHECK CONSTRAINT [FK_ArticlesInCategory_Articles]
GO
ALTER TABLE [dbo].[ArticlesInCategory]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesInCategory_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[ArticlesInCategory] CHECK CONSTRAINT [FK_ArticlesInCategory_Category]
GO
ALTER TABLE [dbo].[ArticlesLikes]  WITH NOCHECK ADD  CONSTRAINT [FK_ArticlesLikes_Articles] FOREIGN KEY([ArticleID])
REFERENCES [dbo].[Article] ([ArticlesID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[ArticlesLikes] NOCHECK CONSTRAINT [FK_ArticlesLikes_Articles]
GO
ALTER TABLE [dbo].[ArticlesLikes]  WITH NOCHECK ADD  CONSTRAINT [FK_ArticlesLikes_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[ArticlesLikes] NOCHECK CONSTRAINT [FK_ArticlesLikes_User]
GO
ALTER TABLE [dbo].[ArticlesRating]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesRating_Articles] FOREIGN KEY([ArticlesID])
REFERENCES [dbo].[Article] ([ArticlesID])
GO
ALTER TABLE [dbo].[ArticlesRating] CHECK CONSTRAINT [FK_ArticlesRating_Articles]
GO
ALTER TABLE [dbo].[ArticlesRating]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesRating_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[ArticlesRating] CHECK CONSTRAINT [FK_ArticlesRating_User]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK_City_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [FK_City_Country]
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Answers] FOREIGN KEY([AnswerID])
REFERENCES [dbo].[Answer] ([AnswerID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_Comment_Answers]
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Articles] FOREIGN KEY([ArticleID])
REFERENCES [dbo].[Article] ([ArticlesID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_Comment_Articles]
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_MerchantComment_User] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_MerchantComment_User]
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_MerchantComment_User1] FOREIGN KEY([ModifiedByUserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_MerchantComment_User1]
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Questions_User] FOREIGN KEY([CreatorID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Questions_User]
GO
ALTER TABLE [dbo].[QuestionInCategory]  WITH CHECK ADD  CONSTRAINT [FK_QuestionInCategory_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[QuestionInCategory] CHECK CONSTRAINT [FK_QuestionInCategory_Category]
GO
ALTER TABLE [dbo].[QuestionInCategory]  WITH CHECK ADD  CONSTRAINT [FK_QuestionInCategory_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionInCategory] CHECK CONSTRAINT [FK_QuestionInCategory_Questions]
GO
ALTER TABLE [dbo].[TagInArticle]  WITH CHECK ADD  CONSTRAINT [FK_TagInArticle_Articles] FOREIGN KEY([Articles_ArticlesID])
REFERENCES [dbo].[Article] ([ArticlesID])
GO
ALTER TABLE [dbo].[TagInArticle] CHECK CONSTRAINT [FK_TagInArticle_Articles]
GO
ALTER TABLE [dbo].[TagInArticle]  WITH CHECK ADD  CONSTRAINT [FK_TagInArticle_Tag] FOREIGN KEY([Tag_TagID])
REFERENCES [dbo].[Tag] ([TagID])
GO
ALTER TABLE [dbo].[TagInArticle] CHECK CONSTRAINT [FK_TagInArticle_Tag]
GO
ALTER TABLE [dbo].[TagInQuestion]  WITH CHECK ADD  CONSTRAINT [FK_TagInQuestion_Questions] FOREIGN KEY([Questions_QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[TagInQuestion] CHECK CONSTRAINT [FK_TagInQuestion_Questions]
GO
ALTER TABLE [dbo].[TagInQuestion]  WITH CHECK ADD  CONSTRAINT [FK_TagInQuestion_Tag] FOREIGN KEY([Tag_TagID])
REFERENCES [dbo].[Tag] ([TagID])
GO
ALTER TABLE [dbo].[TagInQuestion] CHECK CONSTRAINT [FK_TagInQuestion_Tag]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_City] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_City]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_Role] FOREIGN KEY([Role_RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_Role]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_User] FOREIGN KEY([User_UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_User]
GO
USE [master]
GO
ALTER DATABASE [UZDB] SET  READ_WRITE 
GO
