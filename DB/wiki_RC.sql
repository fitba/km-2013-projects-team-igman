USE [master]
GO
/****** Object:  Database [UZDB]    Script Date: 11.3.2013. 10:09:03 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteArticleComments]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteArticleComments]
@ArticleID INT

AS

DELETE FROM dbo.Comment 
WHERE ArticleID = @ArticleID



GO
/****** Object:  StoredProcedure [dbo].[DeleteRating]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteTagInArticles]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteTagInCategory]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[get_question_by_category]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_question_by_category]
	-- Add the parameters for the stored procedure here
	
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT q.QuestionID
	from dbo.QuestionInCategory as q
	where q.CategoryID=@id
END

GO
/****** Object:  StoredProcedure [dbo].[get_question_by_tag]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_question_by_tag]
	-- Add the parameters for the stored procedure here
	
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT q.Questions_QuestionID
	from dbo.TagInQuestion as q
	where q.Tag_TagID=@id
END

GO
/****** Object:  StoredProcedure [dbo].[GetAiComplete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[GetPretragaWiki]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRoleByUserID]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTags]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[IncerementLikes]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[IncerementViews]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[PagingTagWiki]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[PreoprukaTaga]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_AnswersDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_AnswersInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_AnswersSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_AnswersUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategoryDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategoryInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategorySelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInCategoryUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesLikesUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesRatingUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ArticlesUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CategoryDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CategoryInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CategorySelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CategoryUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CityDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CityInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CitySelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CityUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CommentDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CommentInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CommentSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CommentUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CountryDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CountryInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CountrySelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_CountryUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_DeleteArticleComments]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_DeleteArticleComments] 
    @ArticlesID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Comment]
	WHERE  [ArticleID] = @ArticlesID

	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_QuestionsInCategoryInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_QuestionsInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_QuestionsLikesInsert]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_QuestionsLikesInsert] 
    @QuestionID int,
    @UserID int,
    @DateLike datetime,
    @CreatorIP nvarchar(50),
    @GUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID])
	SELECT @QuestionID, @UserID, @DateLike, @CreatorIP, @GUID
	
	-- Begin Return Select <- do not remove
	SELECT [QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]
	FROM   [dbo].[QuestionLikes]
	WHERE  [QuestionID] = @QuestionID
	       AND [UserID] = @UserID
	-- End Return Select <- do not remove
               
	COMMIT

GO
/****** Object:  StoredProcedure [dbo].[usp_QuestionsSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_QuestionsUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_RoleDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_RoleInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_RoleSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_RoleUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_SelectComments]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInArticleUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInQuestionUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_TagUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserRoleDelete]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserRoleInsert]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserRoleSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserRoleUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserSelect]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UserUpdate]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[A2ROMAN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ACOSEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ACOSH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ACOT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ADD_MONTHS]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ARR]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ASCII2EBCDIC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ASEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ASINH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ATANH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[BINTODEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[CHARINDEXREV]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COMBIN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COMPLEMENT1]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COMPLEMENT2]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COSEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COSECH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COSH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[COTH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[CRYPTX8]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[CUBE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DDATE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DECTOBIN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DECTOHEX]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DECTON]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DECTOOCT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DEG2GRAD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DISTANCE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DIVI]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DTIME]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[E]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[EBCDIC2ASCII]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[EQUIVALENT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FACT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FACTDOUBLE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FIBONACCI]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FRAC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FROMMORSE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GCD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GETBIT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetListaInteger]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetScoreParse]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GRAD2DEG]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GRAD2RAD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GREGORIAN2HIJRI]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[HEXTODEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[HIJRI2GREGORIAN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[IIF]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[IMPLIES]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[INC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[INCLUDED]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[INITCAP]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[IPOCTECT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISABUNDNUM]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISALPHA]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISBIN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISDEFNUM]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISEMPTY]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISEVEN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISHEX]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISINTNUMBER]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISINTPOSNUMBER]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISITNULL]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISLETTER]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISNEG]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISNUMBER]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISOCT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISODD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISPERFNUM]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISPOSNUMBER]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISPRIME]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ISROMAN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[LAST_DAY]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[LCM]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[LEVENSHTEIN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[LOG2]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[LOGN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[LPAD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MAX2]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MAX3]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MIN2]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MIN3]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MONTHS_BETWEEN]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MORSE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NAND]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NEXT_DAY]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NINT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NOR]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NROOT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NTODEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[NUMBERTOWORDS]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[OCTTODEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[PALINDROME]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[PALINDROMEW]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[PENTIUMBUG]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[PERFNUMBER]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[PHI]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[PROPERCASE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[RAD2GRAD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[RESETBIT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[REWRAP]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ROMAN2A]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[RPAD]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SEC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SECH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SETBIT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SHIFTLEFT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SHIFTRIGHT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SINH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SLOPE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SQRTPI]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[STRIPL]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[STRIPR]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SUMALIQUOT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[SUMSEQ]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[TANH]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[TRANSLATE]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[TRIM]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[TRUNC]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[UNWRAP]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[VAL]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[VALIDEMAIL]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[VALIDIP]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[VALIDZIP]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[VALIDZIP9]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[WORDCOUNT]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[WRAP]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[XORCHAR]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Answer]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Article]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[ArticlesInCategory]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[ArticlesLikes]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[ArticlesRating]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Category]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[City]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Comment]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Country]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Question]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[QuestionInCategory]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[QuestionLikes]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionLikes](
	[QuestionID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[DateLike] [datetime] NULL,
	[CreatorIP] [nvarchar](50) NULL,
	[GUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_QuestionLikes] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuestionsRating]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionsRating](
	[QuestionID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[DateRating] [datetime] NULL,
	[CreatorIP] [nvarchar](50) NULL,
	[GUID] [uniqueidentifier] NULL,
	[Score] [int] NULL,
 CONSTRAINT [PK_QuestionsRating] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[Tag]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[TagInArticle]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagInArticle](
	[Articles_ArticlesID] [int] NOT NULL,
	[Tag_TagID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TagInQuestion]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagInQuestion](
	[Questions_QuestionID] [int] NOT NULL,
	[Tag_TagID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 11.3.2013. 10:09:04 ******/
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
/****** Object:  Table [dbo].[UserRole]    Script Date: 11.3.2013. 10:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[Role_RoleID] [int] NOT NULL,
	[User_UserID] [int] NOT NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Answer] ON 

INSERT [dbo].[Answer] ([AnswerID], [AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]) VALUES (1006, N'&nbsp;scscsc', 0, 11, CAST(0x0000A1770075301F AS DateTime), 1026, N'834cf2d9-c2b2-4094-a9ff-847d5bc64c40', 0)
INSERT [dbo].[Answer] ([AnswerID], [AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]) VALUES (1007, N'Test', 0, 11, CAST(0x0000A17700760341 AS DateTime), 1024, N'86975284-c233-4b9f-8086-77b1c2b3fc06', 0)
INSERT [dbo].[Answer] ([AnswerID], [AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]) VALUES (1008, N'Test', 0, 11, CAST(0x0000A177007A572F AS DateTime), 1026, N'4ac4cf08-4106-40a3-a7c7-a66e87705d76', 0)
INSERT [dbo].[Answer] ([AnswerID], [AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]) VALUES (1009, N'Test2', 0, 11, CAST(0x0000A177007A984D AS DateTime), 1024, N'5b2edd9a-2ba3-4e93-87c2-555645475e0a', 0)
INSERT [dbo].[Answer] ([AnswerID], [AnswerBody], [IsSpam], [CreatorID], [CreatedID], [QuestionID], [GUID], [Likes]) VALUES (1010, N'xxxx', 0, 11, CAST(0x0000A17700A39238 AS DateTime), 1024, N'387a57be-8519-491a-a367-47ba895f3649', 0)
SET IDENTITY_INSERT [dbo].[Answer] OFF
SET IDENTITY_INSERT [dbo].[Article] ON 

INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (64, N'Bosanske piramide', NULL, N'<b>Bosanske piramide</b><span>&nbsp;su teorija pseudoistraživaca&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Semir_Osmanagi%C4%87">Semira Osmanagica</a><span>&nbsp;koja tvrdi da se nedaleko od grada&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Visoko">Visokog</a><span>&nbsp;nalazi više&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Piramida">piramida</a><span>&nbsp;izgradenih ljudskom rukom u davnoj prošlosti. Prema istoj teoriji najveca piramida,&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Piramida_Sunca&amp;action=edit&amp;redlink=1">Piramida Sunca</a><span>, je prva takve vrste u&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Evropa">Evropi</a><span>&nbsp;a da je ona zapravo&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Brdo">brdo</a>&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Viso%C4%8Dica">Visocica</a>, dok se<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Piramida_Mjeseca&amp;action=edit&amp;redlink=1">Piramida Mjeseca</a><span>&nbsp;zapravo brdo&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Plje%C5%A1evica&amp;action=edit&amp;redlink=1">Plješevica</a><span>, a treca&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Piramida_Bosanskog_Zmaja&amp;action=edit&amp;redlink=1">Piramida Bosanskog Zmaja</a><span>&nbsp;desno od prethodne. Istraživanja u cilju dokazivanja ove teorije su trenutno u toku, dok su detaljna istraživanja pocela&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/14._april">14. aprila</a>&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/2006">2006</a>. godine. Ova teorija je odbacena od strane kako domacih tako i stranih strucnjaka u oblastima<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Historija">historije</a><span>&nbsp;i&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Arheologija">arheologije</a><span>.</span>', CAST(0x0000A15C008B65F0 AS DateTime), 1, 1, 43, N'52f0eaed-577c-4f9f-bc32-1ca49cdfb86a', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (65, N'Muzika', NULL, N'<span><b>Muzika</b>&nbsp;je pojam, koji oznacava vrstu&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Umjetnost">umjetnosti</a>&nbsp;koja kao medij koristi zvuk organizovan u vremenu po odredenom planu ili bez njega. <br><br>Osnovni elementi muzike su&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Ton&amp;action=edit&amp;redlink=1">ton</a>&nbsp;(koji odreduje&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Melodija">melodiju</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Harmonija" title="Link: http://bs.wikipedia.org/wiki/Harmonija">harmoniju</a>), ritam (i njemu pridruženi koncepti: tempo, metrika i artikulacija), dinamika i karakteristike zvuka kao što su boja i punoca. Pojam muzike kroz historiju su pokušali definirati brojni teoreticari,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Filozofija" title="Link: http://bs.wikipedia.org/wiki/Filozofija">filozofi</a>, leksikografi, kompozitori i sami muzicari, nastojeci pronaci univerzalan i odgovarajuci opis pojma muzike. Sama rijec muzika potice od&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Gr%C4%8Dka" title="Link: http://bs.wikipedia.org/wiki/Gr%C4%8Dka">grcke</a>&nbsp;rijeci&nbsp;<i>mousikê</i>, koja je izvedena od rijeci&nbsp;<i>mousa</i>&nbsp;(muza), a svijetom se raširila kroz latinski oblik&nbsp;<i>musica</i>, i najcešce služi da opiše ugodne eufonijske zvukove.<br></span><span><br>Jedna od mogucih definicija muzike može glasiti ovako: "Muzika je umjetnost stvaranja i kombiniranja zvukova koji, prema odredenim zakonima&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Fizika">fizike</a>, fiziološke reakcije i formalnih konvencija, izražavaju i izazivaju osjetilni i emotivni stimulus preko slušnog&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Aparat&amp;action=edit&amp;redlink=1" title="Link: http://bs.wikipedia.org/w/index.php?title=Aparat&amp;action=edit&amp;redlink=1">aparata</a>. Prema pravilu, zvuk se može stvarati ljudskim glasom (pjevanje) ili predmetima - instrumentima koji, iskorištavajuci akusticke fenomene, uzrokuju slušni doživljaj i emotivno iskustvo na nacin kako je to zamislio umjetnik - stvaralac. <br><br>Znacenje pojma ipak nije univerzalno definisano i bilo je predmetom mnogih naucnih polemika kroz historiju.</span>', CAST(0x0000A15C009AC194 AS DateTime), 1, 1, 9, N'4f5f5a8a-e9ef-4abd-b175-7509a031bc47', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (66, N'Pop muzika', NULL, N'<span><b>Pop</b>&nbsp;je skracenica za popularnu&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Muzika">muziku</a>&nbsp;ili cešce za jedan od njegovih&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Pod%C5%BEanr&amp;action=edit&amp;redlink=1">podžanrova</a>.</span><span>U pravilu, pop-muzika sadrži jednostavne, pamtljive&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Melodija">melodije</a>&nbsp;s&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Refren&amp;action=edit&amp;redlink=1">refrenima</a>&nbsp;koji lako ulaze u uho. Cesto imaju&nbsp;<i>udicu</i>&nbsp;- jednu ili više muzickih,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Ritam">ritmickih</a>&nbsp;ili<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Vokal">vokalnih</a>&nbsp;zamisli dizajniranih da ponavljanjem&nbsp;<i>zakace</i>&nbsp;pažnju slušaoca.</span><span>Pop muzika je najcešce izravno pristupacna svakome, cak i pocetniku.</span>', CAST(0x0000A15C009AE4BC AS DateTime), 1, 1, 4, N'1fe3dfbc-a9a8-482a-9944-3e79bdf8e436', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (67, N'Metal (muzika)', NULL, N'<span><b>Metal</b>&nbsp;je vrsta&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Rock_muzika">rock</a>&nbsp;muzike koji se pojavio kao definisani tip muzike 70-ih godina prošlog vijeka i ima korijene u hard rock grupama koje su, izmedu 1967. i 1974. godine, sastavili rock i blues stvorivši na taj nacin hibridnu vrstu muzike sa teškim i gitarom-i-bubnjevima orijentisanim zvukom, koji je karakteristican po upotrebi visoko pojacane distorzije (izoblicenja).</span><span>Metal je dobio na popularnosti u periodu izmedu 70-ih i 80ih godina prošlog vijeka, a ujedno se i tada vecina današnjih podžanrova razvila. Metal ima svjetski poznate klubove obožavaoca kao što su&nbsp;<i>metalheads</i>,&nbsp;<i>metal maniacs</i>,&nbsp;<i>headbangers</i>&nbsp;i&nbsp;<i>mettalers</i>&nbsp;(izvorno sa engleskog).</span>Neki od žanrova su:<ul><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Avant_garde_metal">Avant garde metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Black_metal">Black metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Death_metal">Death metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Doom_metal">Doom metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Folk_metal">Folk metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Glam_metal">Glam metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Gothic_metal">Gothic metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Groove_metal">Groove metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Heavy_metal">Heavy metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Nu_Metal&amp;action=edit&amp;redlink=1">Nu Metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Progresivni_metal">Progresivni metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Thrash_metal">Thrash metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Power_metal">Power metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Speed_metal">Speed metal</a></li><li><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Symphonic_metal&amp;action=edit&amp;redlink=1">Symphonic metal</a></li></ul>', CAST(0x0000A15C009B4D08 AS DateTime), 1, 1, 3, N'281e53d7-1827-4f2b-abb5-4928d118392d', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (74, N'Zenica', NULL, N'<b>Zenica</b>&nbsp;je&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Grad">grad</a>&nbsp;u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Zeni%C4%8Dko-dobojski_kanton">Zenicko-dobojskom kantonu</a>, u srednjem dijelu&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina">Bosne i Hercegovine</a>. Ekonomsko je središte geografske regije&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Srednja_Bosna">Srednje Bosne</a><span>&nbsp;i pored Travnika i Jajca najvažniji grad tog dijela države.<br><br></span>', CAST(0x0000A15C010034AC AS DateTime), 1, 1, 3, N'9e33d7d8-d70f-4f25-b04d-fc45862910ae', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (75, N'Semir Osmanagic', NULL, N'<b>Semir Osmanagic</b>&nbsp;je bosanskohercegovacki&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Pseudohistori%C4%8Dar&amp;action=edit&amp;redlink=1">pseudohistoricar</a>&nbsp;te&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Pseudoistra%C5%BEiva%C4%8D&amp;action=edit&amp;redlink=1" title="Link: http://bs.wikipedia.org/w/index.php?title=Pseudoistra%C5%BEiva%C4%8D&amp;action=edit&amp;redlink=1">pseudoistraživac</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Pseudoarheolog&amp;action=edit&amp;redlink=1">pseudoarheolog</a>. Roden je&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1960">1960</a>. godine u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Zenica">Zenici</a>. Živi i radi u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Houston">Houstonu</a>, (<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sjedinjene_Ameri%C4%8Dke_Dr%C5%BEave">SAD</a>). Autor je ambicioznog višetomnog ciklusa "Alternativna historija". Pojedini tomovi su objavljivani kao knjige u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina">Bosni i Hercegovini</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Hrvatska">Hrvatskoj</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Estonija" title="Link: http://bs.wikipedia.org/wiki/Estonija">Estoniji</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sjedinjene_Ameri%C4%8Dke_Dr%C5%BEave">Sjedinjenim Americkim Državama</a>. Kroz svoj pseudoistraživacki rad i posjete mnogobrojnim drevnim gradovima širom svijeta nudi drugaciji pogled na antropologiju, historiju civilizacija i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Teorija_evolucije">teoriju evolucije</a>.', CAST(0x0000A15C01018500 AS DateTime), 1, 1, 5, N'a6beeb2b-9b30-4d05-a186-53381712d9e1', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (76, N'Piramida ', NULL, N'<span><b>Piramida</b>&nbsp;ili&nbsp;<b>šiljnik<a target="_blank" rel="nofollow" href="http://hr.wikipedia.org/wiki/Piramida_(geometrija)#cite_note-1">[1]</a></b>&nbsp;je&nbsp;<a target="_blank" rel="nofollow" href="http://hr.wikipedia.org/w/index.php?title=Geometrijsko_tijelo&amp;action=edit&amp;redlink=1">geometrijsko tijelo</a>&nbsp;sastavljeno od baze (mnogokut, najcešce&nbsp;<a target="_blank" rel="nofollow" href="http://hr.wikipedia.org/wiki/Trokut">trokut</a>&nbsp;ili&nbsp;<a target="_blank" rel="nofollow" href="http://hr.wikipedia.org/wiki/Pravokutnik">pravokutnik</a>) i stranica (trokuti).</span>U deskriptivnom smislu piramida "nastaje" kada:<ol><li>Postavimo&nbsp;<i>bazu</i>&nbsp;u neku ravninu (npr. horizontalna ravnina). Baza može biti bilo koji mnogokut (npr. kvadrat).</li><li><i>Visina piramide</i>&nbsp;je dužina okomita na ravninu baze, spaja ravninu baze s vrhom piramide.</li><li>Spojimo krajnju tocku visine s vrhovima baze.</li></ol>', CAST(0x0000A15C0101DCE4 AS DateTime), 1, 1, 2, N'e6f69f91-0ce4-4e39-9f52-b84102c1d55a', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 10, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (78, N'Ivan s Wiki no 1.', NULL, N'Ovo je Test Wiki. Wiki Igman i the Best programming team.<br>Wiki Igman go go go!!! LoL', CAST(0x0000A16200E47014 AS DateTime), 1, 1, 2, N'a3768321-b847-4319-b110-f220b3202703', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (79, N'xxx', NULL, N'xxx', CAST(0x0000A162017E173C AS DateTime), 1, 1, 3, N'c6a92936-83bd-4916-a0c7-2e6c9ec3f287', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (80, N'Ne vjerujte svemu što procitate na Faceu, ovo je prava istina o &#39;tamnim kvadraticima&#39;', NULL, N'<h2>Ne vjerujte svemu što procitate na&nbsp;Faceu, ovo je prava istina o &#39;tamnim kvadraticima&#39;</h2>', CAST(0x0000A16300C159A8 AS DateTime), 1, 1, 3, N'8273547b-e2ac-4855-b2cd-4c2553dc0d88', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (81, N'Ne vjerujte svemu što procitate na Faceu, ovo je prava istina o &#39;tamnim kvadraticima&#39;', NULL, N'<h3>Po internetu se mogu naci raznorazne besmislice, no neke od njih predstavljaju se kao cinjenice i šire virtualnom stvarnošcu poput požara. Tako se nedavno pojavila vijest koja navodno razotkriva znacenje kvadratica na pastama za zube, šamponima, kremama...</h3><span>"Jeste li ikad primijetili da na svakoj tubi postoji oznaka? One su: crne, tamnosmede, tamnoplave, tamnozelene boje (obicno tamne boje)", stoji u pitanju koje je putem Facebooka zajedno s odgovorom u samo nekoliko dana podijelilo više od 13 tisuca ljudi.&nbsp;</span>', CAST(0x0000A16300C1875C AS DateTime), 1, 1, 3, N'9360fc15-2c0f-47da-89f9-be9eba161dd0', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (82, N'@Html.Raw(ccc)', NULL, N'Clanak o nicemu!', CAST(0x0000A16300DC32B4 AS DateTime), 1, 1, 0, N'0242e61c-01dd-40a2-9a74-bd049188f658', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (83, N'Test Lucine DB', NULL, N'Lucine db engine', CAST(0x0000A16300DCA334 AS DateTime), 1, 1, 0, N'fdadd196-f19a-4de7-8f65-c7300628c7ee', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1080, N'PlayStation', NULL, N'<span><b>PlayStation</b>&nbsp;je porodica&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Igra%C4%87a_konzola">igracih konzola</a>&nbsp;koju proizvodi&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sony">Sony</a>. Konzola je izašla u decembru 1994. godine u Japanu. Do 2006.godine prodana je u 100 miliona primjeraka. Ova konzola je postala sinonim i uzor za druge konzole koje su se pojavile u kasnom 20. vijeku.</span>PlayStation je zbog svoje popularnosti postala sinonim za igrace konzole u popularnoj kulturi, te se pojavila na mnogo filmova i TV serija (Prijatelji).<span>Najnovija konzola je&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/PlayStation_3">PlayStation 3</a>.</span>Ostale poznate konzole su:<ul><li>-PlayStation 1 (PS1)</li><li>-PlayStation 2 (PS2)</li><li>-PlayStation 3 (PS3)<br></li><li>-PlayStation Portable (PSP)</li></ul>', CAST(0x0000A163011EB60C AS DateTime), 1, 1, 2, N'e31955d2-9ec5-4575-a428-7d9eed3bce54', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1081, N'Novi', NULL, N'Clanak ivan', CAST(0x0000A16F009377F4 AS DateTime), 1, 1, 6, N'052bcb4d-ba2a-489a-95ff-751805992f37', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1084, N'Televizori tvrtke Sony', NULL, N'Kad smo 1960. godine pustili u prodaju svoj prvi televizor u boji Trinitron, pomaknuli smo granicu mogucnosti televizora. Svake sljedece godine još smo više pomicali granice, pa smo 1990. na tržište izbacili prve HD televizore, a 2007. razvili prve OLED televizore. Isto je i s našim najnovijim televizorima:&nbsp;naš televizor s 4K rezolucijom sadrži cetiri puta više detalja u odnosu na Full HD televizor<span>. Oni prepoznaju što gledate i znaju tocno kako uciniti taj sadržaj oštrijim, cišcim i realisticnijim te na koji nacin akcija može biti ugladenija i lakša za pracenje.<br><br></span>Sve što možete zamisliti vjerojatno možete pronaci putem znacajke&nbsp;Sony Internet TV. Bio to najnoviji holivudski filmski hit, klasicni animirani film iz vašeg djetinjstva ili pjesma koju ste culi na radiju, uz Sony Internet TV sve je dostupno pritiskom gumba. Pristupite&nbsp;omiljenoj glazbi, filmovima, web-mjestima, usluzi pracenja propuštenih televizijskih sadržaja i aplikacijama<span>&nbsp;kad god želite. To je zabavno i na zahtjev.&nbsp;<br></span><br><img alt="Pogledajte izraenost detalja na televizorima tvrtke Sony" src="http://www.sony.ba/res/images/image/19/1237488997819.jpg" title="Image: http://www.sony.ba/res/images/image/19/1237488997819.jpg"><br><br>Bežicno povežite svoje prijenosne uredaje s televizorom i dignite zabavu na novu razinu. Prebacujte&nbsp;filmove, glazbu i web-stranice&nbsp;s&nbsp;pametnog telefona ili tabletnog racunala<span>&nbsp;izravno na TV. Zaboravite na daljinski upravljac – koristite svoj prijenosni uredaj za upravljanje televizorom i pristup internetu.<br></span><br>Kod naših najnovijih televizora kvaliteta slike ostaje visoka, ali potrošnja energije pada. Potrošnja energije smanjuje se za do 30%* samo putem&nbsp;optimiziranja osvjetljenja i svjetline&nbsp;zaslona tako da najviše pogoduje sadržaju koji gledate. Zbog takvih znacajki vecina naših novih televizora ima EU energetsku oznaku A ili vecu u skladu s EU klasama energetske ucinkovitosti&nbsp;i pomažu vam štedjeti energiju&nbsp;dok gledate.&nbsp;<br>', CAST(0x0000A177008404E0 AS DateTime), 1, 1, 2, N'ccab789d-9659-4322-9a98-f2b7be2dff53', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1087, N'Visoko', NULL, N'<span><b>Visoko</b>&nbsp;je grad i središte istoimene opcine u središnjem dijelu&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina">Bosne i Hercegovine</a>&nbsp;u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Zeni%C4%8Dko-dobojski_kanton">Zenicko-Dobojskom</a>&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Kanton">kantonu</a>.</span><span>Podrucje Visokog je nekad bilo centar&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Visoko_u_srednjem_vijeku" title="Link: http://bs.wikipedia.org/wiki/Visoko_u_srednjem_vijeku">srednjovjekovne države Bosne</a>. Najvažnija mjesta vezana za taj period su&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Stari_grad_Visoki">stari grad Visoki</a>, njegovo podgrade i trgovacko središte&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Podvisoki" title="Link: http://bs.wikipedia.org/wiki/Podvisoki">Podvisoki</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Mile">Mile</a>&nbsp;kao krunidbeno mjesto&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosanski_vladari">bosanskih kraljeva</a>, te&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Mo%C5%A1tre&amp;action=edit&amp;redlink=1">Moštre</a>&nbsp;koje su bilo povremeno stolno mjesto kraljeva. <br><br>Osvajanjem Bosne od strane&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Osmanlijsko_carstvo" title="Link: http://bs.wikipedia.org/wiki/Osmanlijsko_carstvo">Osmanlijskog carstva</a>&nbsp;Visoko gubi na znacaju i vecinom biva&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Nahija&amp;action=edit&amp;redlink=1">nahija</a>&nbsp;uz manje promjene tokom citave vladavine. Osnivacem modernog Visokog se smatra&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Ajas-beg">Ajas-beg</a>. Po popisu iz 1991. godine u opcini Visoko je živjelo 46.160 stanovnika, od toga u gradu Visokom živjelo je 13.663 stanovnika.<br><br></span>Opcina&nbsp;<b>Visoko</b>&nbsp;se prostire na površini od 231 km² i nalazi se središnjem dijelu Bosne i Hercegovine. Granici sa opcinama&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Kiseljak">Kiseljak</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Busova%C4%8Da">Busovaca</a>,<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Kakanj">Kakanj</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Vare%C5%A1">Vareš</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Breza">Breza</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Ilija%C5%A1">Ilijaš</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Ilid%C5%BEa">Ilidža</a>. Opcina je smještena na pravcu multimodalnog transportnog koridora V-c prema sjeveru i regionalnim putevima sa susjednim opcinama, te željeznickom prugom u pravcu&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Jadransko_more" title="Link: http://bs.wikipedia.org/wiki/Jadransko_more">Jadranskog mora</a><span>. Na podrucju opcine se nalazi sportski aerodrom u Moštrima. Prirodni resursi kojima raspolaže opcina su poljoprivredno zemljište, šume, vode, te mineralne sirovine kao što su glina, gips, ugalj i razlicite vrste stijena.<br></span><br>Prirodna sredina opcine je odredena dolinama rijeka&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Rijeka_Bosna">Bosne</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Fojnica_(rijeka)&amp;action=edit&amp;redlink=1">Fojnice</a>, morfološkim diferencijacijama dolina sa padinama podbrda i vijencem visokih planina srednje Bosne -&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Ozren_(planina_u_BiH)">Ozrena</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Vranica">Vranice</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Zvijezda_(planina)&amp;action=edit&amp;redlink=1">Zvijezde</a>. Prostor opcine doseže relativno niske nadmorske visine i to od 399 do 1050m nadmorske visine, što je veoma povoljno sa stanovišta razvoja&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Poljoprivreda">poljoprivredne</a>&nbsp;proizvodnje,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Industrija">industrije</a>, gradenja i održavanja&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Saobra%C4%87aj">saobracajnica</a>&nbsp;i drugih sistema komunalne infrastrukture. Podrucje grada je smješteno na nadmorskog visini od 422 m.<br>', CAST(0x0000A1770084E964 AS DateTime), 1, 1, 4, N'553f53d3-e96f-4f5a-93a8-b02ded2826e9', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1088, N'Mostar', NULL, N'<span><b>Mostar</b>&nbsp;(službeni naziv:&nbsp;<b>Grad Mostar</b>) je&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Grad_(naseljeno_mjesto)">grad</a>&nbsp;u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina">Bosni i Hercegovini</a>, kulturno i privredno središte&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Hercegovina">Hercegovine</a>&nbsp;te upravno sjedište&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Hercegova%C4%8Dko-neretvanski_kanton" title="Link: http://bs.wikipedia.org/wiki/Hercegova%C4%8Dko-neretvanski_kanton">Hercegovacko-Neretvanskog</a>&nbsp;kantona. Ime je dobio po cuvarima mostova (mostarima), na obalama rijeke&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Neretva">Neretve</a>. Grad je poznat po cuvenom&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Stari_most">Starom mostu</a>, izgradenom u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/16._vijek">16. vijeku</a>, kojeg su srušile snage&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/HVO">HVO</a>-a&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/9._novembar">9. novembra</a>&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1993">1993</a>., da bi nakon rata&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/2004">2004</a>. godine most ponovo bio izgraden. Stari most je prvi kulturni spomenik u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina">Bosni i Hercegovini</a>&nbsp;koji se nalazi na UNESCO-voj listi zašticenih spomenika kulture svijeta.</span><span>Grad je najveci urbani centar u Hercegovini i peti grad po velicini u Bosni i Hercegovini. Prema popisu iz&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1991" title="Link: http://bs.wikipedia.org/wiki/1991">1991</a>. godine imao je 75.865 stanovnika. Danas je broj stanovnika u samom gradu nešto manji i iznosi 64.301. U cijeloj opcini, prema procjenama Zavoda za statistiku&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Federacija_Bosne_i_Hercegovine">Federacije Bosne i Hercegovine</a>&nbsp;iz&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/2003">2003</a>. godine, ukupno živi 105.448 ljudi. Od toga, 50.019&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bo%C5%A1njaci" title="Link: http://bs.wikipedia.org/wiki/Bo%C5%A1njaci">Bošnjaka</a>, 50.929&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Hrvati">Hrvata</a>, 3.644&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Srbi">Srba</a>, i 856 ostalih. Okolina urbane zone je veoma naseljena, sa bogatim naseljima poput naselja Potoci (2921 stanovnika 1991. god.), Vrapcici (3461 stanovnika 1991. god.), i Rodoc (4499 stanovnika 1991. god.).</span>', CAST(0x0000A177008610B4 AS DateTime), 1, 1, 2, N'0bb95d35-b1ea-4616-b07b-fe1653a9a7fe', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1089, N'Maglaj', NULL, N'<b>Maglaj</b>&nbsp;je od 14 opcina u&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Zeni%C4%8Dko-dobojski_kanton" title="Link: http://bs.wikipedia.org/wiki/Zeni%C4%8Dko-dobojski_kanton">Zenicko-dobojskom kantonu</a><span>. Centar opcine je grad Maglaj. Grad se prvi put izravno spominje u poznatoj povelji "Sub castro nostro Maglay" (pod našom tvrdavom Maglaj).<br><br></span>Prije odbrambenog rata (1992-1995) Maglaj je bio industrijski centar, u kojem se nalazi tvornica celuloze i papira "Natron", ali u ratnom periodu njeni pogoni su pretrpjeli teška ratna razaranja. Maglaj ima neke vrlo vrijedne znamenitosti, kao što je&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Jusuf-pa%C5%A1ina_%22Kur%C5%A1umlija%22_d%C5%BEamija">Jusuf-pašina "Kuršumlija" džamija</a>(izgradena&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1560">1560</a>. godine),&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Crkva_Sv._Leopolda&amp;action=edit&amp;redlink=1" title="Link: http://bs.wikipedia.org/w/index.php?title=Crkva_Sv._Leopolda&amp;action=edit&amp;redlink=1">Crkva Sv. Leopolda</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Hram_Proroka_Ilije&amp;action=edit&amp;redlink=1">Hram Proroka Ilije</a>&nbsp;(izgraden 1909),&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Maglajska_tvr%C4%91ava_%22Gradina%22">Maglajska tvrdava "Gradina"</a>&nbsp;i drugi vrijedni spomenici.<br>', CAST(0x0000A17700B8F6C8 AS DateTime), 1, 1, 0, N'02ae8fa4-a0ec-4d64-96ba-6cb899104a8c', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1090, N'Sarajevo', NULL, N'<b>Sarajev</b>&nbsp;je&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Glavni_grad">glavni grad</a>&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina" title="Link: http://bs.wikipedia.org/wiki/Bosna_i_Hercegovina">Bosne i Hercegovine</a>&nbsp;i njen najveci urbani, kulturni, ekonomski i prometni centar, glavni grad&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Federacija_Bosne_i_Hercegovine" title="Link: http://bs.wikipedia.org/wiki/Federacija_Bosne_i_Hercegovine">Federacije Bosne i Hercegovine</a>&nbsp;i sjedište&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Kanton_Sarajevo">Sarajevskog kantona</a>. Prema popisu iz&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1991">1991</a>. grad je imao 416.497, a prema procjeni iz&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/2008" title="Link: http://bs.wikipedia.org/wiki/2008">2008</a>. 304.614 stanovnika, dok podrucje metropole grada Sarajeva ima 421.289 stanovnika, ukljucujuci sve opcine Sarajevskog kantona&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sarajevo#cite_note-FZS-1">[1]</a>. Kroz grad protice&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Rijeka_(vodotok)">rijeka</a>&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Miljacka">Miljacka</a>, a u neposrednoj blizini grada je i izvorište rijeke&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bosna_(rijeka)">Bosne</a>, sa popularnim izletištem Sarajlija,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Vrelo_Bosne">Vrelom Bosne</a><span>. <br><br>Oko grada su olimpijske planine:&nbsp;</span><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Jahorina">Jahorina</a>,<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Bjela%C5%A1nica">Bjelašnica</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Igman">Igman</a>,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Treskavica">Treskavica</a>&nbsp;i&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Trebevi%C4%87">Trebevic</a>, koji su posebno tokom zimskih mjeseci omiljena izletišta Sarajlija i turista iz cijeloga svijeta. Sarajevo je relativno mali grad u usporedbi sa velikim, svjetskim metropolama, ali je njegovo ime kroz bogat duhovni, historijski i prirodni izgled, poznatije od imena nekih vecih svjetskih gradova.&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1914">1914</a>. godine u Sarajevu su ubijeni austrougarski prijestolonasljednik&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Franz_Ferdinand">Franz Ferdinand</a>&nbsp;i njegova supruga Sophie, cime je otpoceo&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Prvi_svjetski_rat" title="Link: http://bs.wikipedia.org/wiki/Prvi_svjetski_rat">Prvi svjetski rat</a>. Sedamdeset godina kasnije,&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1984">1984</a>. godine u gradu se održavaju&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/XIV._Zimske_olimpijske_igre_-_Sarajevo_1984.">14. Zimske olimpijske igre</a>. <br><br>Tokom ranih<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/1990te">1990-ih</a>&nbsp;godina ime grada je cesto bilo na naslovnicama dnevnih novina u cijelome svijetu, jer se tu vodio jedan od najkrvavijih ratova u novijoj evropskoj historiji. Grad je 1.425 dana bio pod stalnom opsadom srpskih snaga. U napadima je 11.541 ljudi svih nacionalnosti izgubilo život, od toga 1.601 dijete, a skoro 50.000 ih je bilo povrijedeno. Danas, u vremenu posljeratne izgradnje, Sarajevo je najbrže rastuci grad u Bosni i Hercegovini&nbsp;<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sarajevo#cite_note-2">[2]</a>. Turisticki vodic&nbsp;<i><a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/w/index.php?title=Lonely_Planet&amp;action=edit&amp;redlink=1">Lonely Planet</a></i>&nbsp;svrstao je 2006. godine Sarajevo na 43 mjesto najljepših gradova svijeta<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sarajevo#cite_note-Lonely_Planet_2006-3">[3]</a>, a 2009. je Sarajevo jedno od deset gradova koje je vrijedno posjetiti<a target="_blank" rel="nofollow" href="http://bs.wikipedia.org/wiki/Sarajevo#cite_note-4">[4]</a>.', CAST(0x0000A17A01649EEC AS DateTime), 1, 1, 0, N'b06974b4-9718-4c39-b220-0984420b8473', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.152 Safari/537.22', NULL, 11, NULL)
INSERT [dbo].[Article] ([ArticlesID], [Name], [Summary], [Content], [DatePublish], [IsPublish], [IsActive], [Views], [GUID], [CreatorIP], [ModiferIP], [CreatorUserAgent], [CategoryID], [UserID], [Likes]) VALUES (1092, N'Step Your Game Up™ with PSP® Portable Systems and Games at New Lower Prices', NULL, N'<span>Now you can enjoy the sleek, totally-digital PSP®go system for $199.99 MSRP and the unsurpassed PSP®-3000 system for $129.99 MSRP.<br><br>Same great features, now at incredible values.</span><span>After you get the systems, play exclusive, full-featured PSP®&nbsp;games for less: get&nbsp;<a target="_blank" rel="nofollow" href="http://us.playstation.com/uwps/BrowseGames?console=pspgo,psp3000&amp;beginsWith=Any"><i>new releases</i></a>&nbsp;at the new lower price of $29.99 MSRP, buy best-selling<a target="_blank" rel="nofollow" href="http://us.playstation.com/games-and-media/greatest-hits/"><i>Greatest Hits</i></a>&nbsp;for just $19.99 MSRP and play new&nbsp;<a target="_blank" rel="nofollow" href="http://us.playstation.com/psp/games-and-media/psp-favorites/index.htm"><i>PSP®&nbsp;Favorites</i></a>&nbsp;for only $9.99 MSRP.</span>You can also watch movies and TV series, load up your music and photos, stay connected with friends, play online and update your system with new downloads from PlayStation®Store using the PSP®&nbsp;system&#39;s built-in Wi-Fi.', CAST(0x0000A17A016673AC AS DateTime), 1, 1, 2, N'8997361a-1b15-4977-bafd-6a7b62f3753d', N'::1', NULL, N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.152 Safari/537.22', NULL, 11, NULL)
SET IDENTITY_INSERT [dbo].[Article] OFF
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (64, 6)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (64, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (65, 8)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (65, 12)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (66, 8)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (66, 12)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (67, 8)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (67, 12)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (74, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (75, 6)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (75, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (76, 4)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (78, 1)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (78, 8)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (80, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (80, 10)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (81, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (81, 10)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (82, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (82, 10)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (83, 4)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (83, 8)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1080, 1)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1081, 1)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1081, 6)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1084, 1)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1087, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1088, 3)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1088, 7)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1092, 1)
INSERT [dbo].[ArticlesInCategory] ([ArticleID], [CategoryID]) VALUES (1092, 13)
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (57, 10, CAST(0x0000A15B0123BCC4 AS DateTime), N'::1', N'42a3d30d-be90-40ab-ae8f-a72d48a34172')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (58, 10, CAST(0x0000A15B0123D434 AS DateTime), N'::1', N'5cf1874a-edf2-4ff2-a3de-2faa48c2159e')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (58, 11, CAST(0x0000A177007B39B4 AS DateTime), N'::1', N'4db0046c-454d-4115-adca-d866dc9282d5')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (59, 10, CAST(0x0000A15B0123E370 AS DateTime), N'::1', N'c4bfe87e-2ab2-43d8-93c4-6b207022c3ce')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (60, 10, CAST(0x0000A15C0084C894 AS DateTime), N'::1', N'473f36dd-754e-4bcb-bfae-65dbe4d377e0')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (61, 10, CAST(0x0000A15C00870B7C AS DateTime), N'::1', N'3944305a-cf2a-4dd1-9b4b-66024ccb2143')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (63, 9, CAST(0x0000A15C009252FC AS DateTime), N'::1', N'40156494-6612-4e01-bec5-dd5b982e9cd1')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (63, 10, CAST(0x0000A15C008AB9AC AS DateTime), N'::1', N'9acec235-fced-418f-9d86-7c98a39941e4')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (64, 9, CAST(0x0000A15C00926B98 AS DateTime), N'::1', N'81b5fd6b-edf5-41f6-a0eb-f11786b84a2a')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (65, 10, CAST(0x0000A17E0098E950 AS DateTime), N'::1', N'29afdeab-dbf2-486a-91be-5b4b37926ca6')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (71, 10, CAST(0x0000A15C00FE7AE0 AS DateTime), N'::1', N'2e94b65b-b133-443d-a4b4-2e813c743cd9')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1081, 11, CAST(0x0000A16F009BE68C AS DateTime), N'::1', N'ba6cb28e-5194-4a90-9879-64f3c2647216')
INSERT [dbo].[ArticlesLikes] ([ArticleID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1087, 7, CAST(0x0000A17C016F07C4 AS DateTime), N'::1', N'99b03ca9-606e-4138-8fa6-e41e090da695')
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (64, 8, CAST(0x0000A15C0093BD18 AS DateTime), NULL, N'34058cbf-66c9-431d-a98d-9f42c80e80ce', 2)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (64, 9, CAST(0x0000A15C00926490 AS DateTime), NULL, N'1d1759b8-5969-4f11-802f-f4ede09800e9', 2)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (64, 10, CAST(0x0000A15C008B72D4 AS DateTime), NULL, N'58c83685-f9b6-4f80-b166-999ae20b4923', 4)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (65, 10, CAST(0x0000A15C009AF524 AS DateTime), NULL, N'1f377572-faa1-467f-beea-9da19d5739a9', 3)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (66, 10, CAST(0x0000A15C009B0460 AS DateTime), NULL, N'324a3c60-955d-4795-9d8c-6018956e8353', 3)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (67, 10, CAST(0x0000A15C009B553C AS DateTime), NULL, N'5f76a5f1-fe76-4536-9422-f7311c75a702', 3)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (75, 10, CAST(0x0000A15C010191E4 AS DateTime), NULL, N'13e52f58-efc3-4190-bb24-f948b775f658', 5)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (76, 10, CAST(0x0000A15C0101E89C AS DateTime), NULL, N'6f23fbb8-a821-45f7-b04f-8c147dc08886', 4)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (1084, 11, CAST(0x0000A17700854850 AS DateTime), NULL, N'f795886a-82f4-43fb-b0f2-b90ac06c8b97', 4)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (1087, 7, CAST(0x0000A17C016EFF90 AS DateTime), NULL, N'45336bb9-293e-4bb0-94e1-0cf6fef3cbfd', 4)
INSERT [dbo].[ArticlesRating] ([ArticlesID], [UserID], [DateRating], [CreatorIP], [GUID], [Score]) VALUES (1092, 11, CAST(0x0000A17A01669F08 AS DateTime), NULL, N'cc5e7b5f-34eb-4d75-ab6c-110a7f47404a', 3)
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (1, NULL, N'Tehnologija', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (2, NULL, N'Životopisi', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (3, NULL, N'Društvo', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (4, NULL, N'Matematika', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (5, NULL, N'Medicina', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (6, NULL, N'Historija', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (7, NULL, N'Geografija', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (8, NULL, N'Umjetnost', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (9, NULL, N'Filozofija', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (10, NULL, N'Politika', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (12, NULL, N'Muzika', NULL)
INSERT [dbo].[Category] ([CategoryID], [GUID], [Name], [Description]) VALUES (13, NULL, N'Znanost', NULL)
SET IDENTITY_INSERT [dbo].[Category] OFF
SET IDENTITY_INSERT [dbo].[Comment] ON 

INSERT [dbo].[Comment] ([CommentID], [GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID], [AnswerID]) VALUES (1033, N'ca6738d3-8fea-40a6-95fa-3017f870ba36', N'::1', N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22', N'ivan.dugandzic86@gmail.com', N'Ivan Dugandžic', NULL, N'Mostar je zakon!', 1, 0, CAST(0x0000A17700863A69 AS DateTime), 11, NULL, NULL, 1088, NULL)
INSERT [dbo].[Comment] ([CommentID], [GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID], [AnswerID]) VALUES (1034, N'b8eb47dd-98c0-4827-b472-8f70e9f60ea9', N'::1', N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22', N'ivan.dugandzic86@gmail.com', N'Ivan', NULL, N'xa', 1, 0, CAST(0x0000A17700A39C7B AS DateTime), 11, NULL, NULL, NULL, 1010)
INSERT [dbo].[Comment] ([CommentID], [GUID], [CreatorIP], [CreatorUserAgent], [CreatorEmail], [CreatorName], [Title], [Body], [IsActive], [IsSpam], [Created], [CreatedByUserID], [Modified], [ModifiedByUserID], [ArticleID], [AnswerID]) VALUES (1035, N'52f75fb5-e87b-4332-b071-81aa00365a19', N'::1', N'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.152 Safari/537.22', N'admir.rey@gmail.com', N'Selma Dedic', NULL, N'bbbbb', 1, 0, CAST(0x0000A17C016F1963 AS DateTime), 7, NULL, NULL, 1087, NULL)
SET IDENTITY_INSERT [dbo].[Comment] OFF
SET IDENTITY_INSERT [dbo].[Question] ON 

INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1018, N'Kako cu odradit ovaj seminarski rad!', N'Seminarski radi iz predmeta UZ je poprilicno zahtjevan! Molim kolege da se udružimo i odradimo ga skupa! ;)', 7, CAST(0x0000A1720153432E AS DateTime), N'bec7befe-c483-4c82-97b4-304972f4078f', 0, 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1019, N'Koji programski jezik je najbolji???', N'Molim kolege da predlože programski jezik koji je najprikladniji za ovaj seminarski rad?', 7, CAST(0x0000A1720153BE38 AS DateTime), N'fcb1a753-cb8d-4680-bf20-58d303f62332', 0, 9)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1020, N'Kako uhvatiti exception?', N'Ako može netko od kolega reci kako da uhvatim exception u c#??', 11, CAST(0x0000A17201548A20 AS DateTime), N'49ade307-5b98-4e33-8db1-332b449d8a82', 0, 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1021, N'Ne vjerujte svemu što procitate na Faceu, ovo je prava istina o ', N'Nemojte vjerovati sve šta piše na facebooku!', 11, CAST(0x0000A172015F95DD AS DateTime), N'e77bfa11-bb2d-4cdf-a6bd-d41fd6df4cb2', 0, 13)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1022, N'Ne vjerujte svemu što procitate na Faceu...', N'Nemojte sve vjerovati što piše na face-u!!!', 11, CAST(0x0000A172015FD527 AS DateTime), N'603fefd1-efec-48de-9e25-81b2e522138e', 2, 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1023, N'Seminarski rad', N'Testitanje', 10, CAST(0x0000A1720161C730 AS DateTime), N'58791141-27cc-4957-b2f7-d64a5aa6971d', 3, 10)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1024, N'c#', N'Test cccccccccccccccccccc', 10, CAST(0x0000A172016202F5 AS DateTime), N'd5c4dff4-48e6-4b61-9585-319c0710d9b6', 2, 21)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1025, N'naslov', N'test xxxxxxxxxxxxx', 10, CAST(0x0000A1720174721A AS DateTime), N'b6303641-e008-4508-9155-007fcaae2ba3', 0, 8)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1026, N'100%', N'tehologija visual studio C#', 11, CAST(0x0000A17301093CCB AS DateTime), N'80734f5f-62e3-4142-9c8d-afc82bce2e93', 0, 63)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1027, N'test vrijeme', N'xxxx mmmnbkink', 11, CAST(0x0000A177007B03CD AS DateTime), N'fd83e69c-99dc-47f0-9e33-7edfde7475e9', 0, 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionTitle], [QuestionBody], [CreatorID], [CreatedDate], [GUID], [Likes], [NumOfViews]) VALUES (1028, N'Koji lijek je najbolji za glavobolju?', N'Molimo nemojte odgovarati oni koji ne znaju!', 11, CAST(0x0000A17A013F9D7C AS DateTime), N'2e5e9202-204f-4fac-ae89-e117494df3d1', 0, 12)
SET IDENTITY_INSERT [dbo].[Question] OFF
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1018, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1019, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1019, 3)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1020, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1021, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1021, 3)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1022, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1022, 3)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1023, 3)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1024, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1024, 3)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1025, 7)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1025, 10)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1026, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1026, 3)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1027, 1)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1027, 6)
INSERT [dbo].[QuestionInCategory] ([QuestionID], [CategoryID]) VALUES (1028, 5)
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1018, 11, CAST(0x0000A173008D2CA0 AS DateTime), N'::1', N'f452ba46-8f4d-4f6f-9f9b-513fcb76a929')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1021, 10, CAST(0x0000A172016FD988 AS DateTime), N'::1', N'27a67c5c-7db1-43d6-b08a-74f9ae1a8127')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1022, 10, CAST(0x0000A172016FC7F4 AS DateTime), N'::1', N'6c3c0ec1-89a5-4146-aad2-8f42dc79479d')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1023, 10, CAST(0x0000A172016F37D0 AS DateTime), N'::2', N'23b3b758-d7ce-4901-ab4b-4334fdb24c08')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1024, 10, CAST(0x0000A172016F1CDC AS DateTime), N'::2', N'ef36f6db-b3b9-4100-b503-6808a41e606e')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1024, 11, CAST(0x0000A17700747930 AS DateTime), N'::1', N'f83fd2a1-b8b5-4067-9522-5896c650d0d2')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1025, 10, CAST(0x0000A172017477F4 AS DateTime), N'::1', N'8aa24a7c-e5da-4ff1-85f1-d44ae3d4def4')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1026, 10, CAST(0x0000A17D01114440 AS DateTime), N'::1', N'a6228723-5b62-4dda-96ab-b96d1e6f8cd1')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1026, 14, CAST(0x0000A17D01102FB0 AS DateTime), N'::1', N'b9920a6b-40cc-4147-982e-82db7a0c4596')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1027, 7, CAST(0x0000A17C01704B34 AS DateTime), N'::1', N'bef24eb0-674c-40a0-9451-a32816f1daa3')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1027, 10, CAST(0x0000A17D01113C0C AS DateTime), N'::1', N'bb46fd08-b213-4413-99f0-c11d5b2ee5b9')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1028, 7, CAST(0x0000A17C017048DC AS DateTime), N'::1', N'7d6e6f77-f00d-424d-ad82-f5b018f7b79b')
INSERT [dbo].[QuestionLikes] ([QuestionID], [UserID], [DateLike], [CreatorIP], [GUID]) VALUES (1028, 10, CAST(0x0000A17D011140BC AS DateTime), N'::1', N'9fdca890-81b1-435a-b9f8-f3d096a766a3')
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([RoleID], [GUID], [Name], [Description]) VALUES (1, NULL, N'Administrator', NULL)
INSERT [dbo].[Role] ([RoleID], [GUID], [Name], [Description]) VALUES (2, NULL, N'User', NULL)
SET IDENTITY_INSERT [dbo].[Role] OFF
SET IDENTITY_INSERT [dbo].[Tag] ON 

INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1, NULL, N'Program')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (2, NULL, N'.Net')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (3, NULL, N'C#')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (4, NULL, N'Windows')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (6, NULL, N'Termodnimika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (7, NULL, N'Informatika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (8, NULL, N'Inženjering')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (10, N'ed15f072-05e3-4e7e-900d-6cbe5489eaf0', N'Informacija')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (12, N'c5c83195-b807-4fbc-ae8b-188b265bd211', N'43')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (13, N'a9f89aea-da8d-4c32-a224-fb3005867aec', N'Office')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (14, N'68620021-01f8-4cdb-ab78-8e5d4fac6061', N'Micosoft')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (15, N'7cc8b883-88f4-4563-94e9-6cc484cd8c5d', N'TAIEX')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (16, N'474c1b46-a932-4e04-a672-fc5b43caae87', N'Policija')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (17, N'82f8f3f6-ed18-48b2-adc9-a41d15cc3fd1', N'Sipa')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (18, N'c37db2c3-bb0f-4d8f-80ef-998da5219f61', N'Substitucija')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (19, N'1f9407e4-0261-4c65-9351-1710d58fa32c', N'Šifra')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (20, N'32c2c715-61ea-4802-b6ba-c0a73e6884a4', N'Cezar')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (21, N'c362d118-2330-40ee-8c6c-0a66a68b28fe', N'Julie')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (22, N'4ba31ec4-6467-4d80-8c47-3a1a0dbe00db', N'Raspberry ')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (23, N'28132aa4-2e49-4c7d-802c-4070df9930a6', N'Google')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (24, N'bb293be1-fc79-4c3d-912b-f5cbe9a335d2', N'Brazil')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (25, N'b0a20ca1-933a-4c41-b741-efabac02bb82', N'Bosna')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (26, N'16a9ca29-ab72-47e2-abe1-d88979a4bd62', N'Zemljotres')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (27, N'1c686d46-d2c7-46a8-ae23-0507fc1a0ed6', N'Lucifer')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (28, N'2d6aaf9e-37fc-4b4b-900a-a49f9abf9d87', N'Kljuc')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (29, N'12463f1f-5972-400b-abad-574265eb7d0e', N'S.A.D.')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (30, N'ad784e93-5aa8-4dc3-a63b-2e9e498e614e', N'DES')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (31, N'a833c2e4-035f-4c4e-95e7-9d0adbd526fd', N'UNIX')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (32, N'090fe5de-ff00-4551-baa2-b1231f2ebadf', N'IBM')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (33, N'f93d2e21-8033-46ae-8690-042c3e1ce065', N'Mark Zuckerberg')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (34, N'89894755-967d-42b2-b7a7-8d3fddd7e1d1', N'mreža')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (35, N'e9d41dfa-77c8-4cea-a5d7-8922cb38d6da', N'Facebook')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (36, N'3244a098-f66f-482a-b041-67a73a80943b', N'Fukare')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (37, N'e09cc524-2226-4933-9b60-8a431d9fefc1', N'Bagra')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (38, N'44fb0af5-efc7-40d3-9773-1b367c436176', N'Francuska')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (39, N'40077c28-8ca7-4ab0-9d5e-8e919df66891', N'Pariz')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (40, N'7814a53a-dddf-4ab2-a36d-9798f8b72592', N'Vikend')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (41, N'7c2ece92-92cb-4132-8a7d-b7de09c57fe8', N'Tetka')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (42, N'11ff90e4-9e49-4fbf-b9f1-4075149e2224', N'Remza')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (43, N'0035ac8e-8266-4c43-aa3f-9a56f8412a96', N'Admir')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (44, N'596197c8-9350-4dab-a5c0-47bae725fc42', N'Maglaj')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (45, N'e14332fa-c163-4bb8-b4e0-f911f6a96da6', N'Grad')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (46, N'3bbc86a4-2e09-47c9-b6b6-0ace5e610ea3', N'Tehno')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (47, N'1308d2fc-2cd7-4320-8cb7-8ee009f2e6a7', N'Astro')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (48, N'8c0d4818-205f-44a0-81cd-9613716b6210', N'Matematika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (49, N'e114b564-5731-4dfa-a807-2c3e84a097c8', N'Fizika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (50, N'10017df6-ba2f-404d-9fb6-b47817902c7d', N'Znanje')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (51, N'790cb0fb-469f-400a-b9e8-bd6adc65d371', N'Jezik')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (52, N'2aaa5cef-79cd-4f76-a304-7f8408b32e3e', N'Abdeceda')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (53, N'46888084-c6c5-4a68-b4be-2a564dd4ec4a', N'Shakespearean')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (54, N'15f680bb-ec23-491d-88c8-016700d014bc', N'Android')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (55, N'ad4ba7c5-55a2-45df-abdd-f568f8976ece', N'Mobitel')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (56, N'46e4a64e-47db-4141-9bad-90c7544b4fd3', N'Pirtaterija')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (57, N'0b59f37e-7c12-486b-afe0-fc925dc38450', N'Apple')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (58, N'9621a6b6-82d0-44f7-86d6-661bcb9754f7', N'2010')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (59, N'038beb3d-bbb9-417a-b834-54b42c9dcd6c', N'WAN')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (60, N'b0a1e499-0264-4ae7-85c2-974890a7d47e', N'Mreže')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (61, N'678740bb-ad59-40fe-9218-e58d81b69bc8', N'Haker')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (62, N'9938a302-02ea-4b98-9c3a-1bec4ac438c7', N'Skype')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (63, N'44122bc0-b105-404f-a65b-a5c090db52b9', N'Idiot')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (64, N'd262b82c-57b5-47d3-a142-9e769c8759d0', N'Najbolji')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (65, N'0fa8130c-dc92-4795-8bfc-3b2278e87b58', N'Ljudine')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (66, N'f2e705cd-81a7-4717-b144-70287bb0627a', N'Agencija')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (67, N'f03ca428-c05f-44f4-a8c2-26dfd1193f58', N'Sarajavo')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (68, N'e9744ff7-13e1-4966-848f-a4ce4f197fe8', N'ZDK')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (69, N'b3d7f550-206f-4f6d-8bb6-a3b57a0a0cc1', N'Kapija')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (70, N'a2eb8c17-7895-42c0-86cd-b735ffeaaea6', N'Tuzla')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (71, N'b3f34181-b274-44f8-bf7d-983ff31f69bb', N'Piramida')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (72, N'bffe7e7f-6db6-468e-923a-cacc31ed8903', N'Visoko')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (73, N'813a7f36-4b43-4863-8f64-224d57ff3562', N'Fakultet')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (74, N'f4c04465-3cb4-4966-b633-0ac663dc4dad', N'FIT')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (75, N'd82e48c0-a45d-45cd-9131-47d61fd7d5b9', N'Telefon')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (76, N'ea4a1c36-ad4d-47d6-89b5-2c9175126e94', N'World War II')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (77, N'578e5077-b417-4d0f-ab94-03953aa52930', N'American football')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (78, N'f669c553-d460-4ad5-8e6d-fe06864bb93d', N'Otto ')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (79, N'ddbf8d0f-1102-4bd2-88e1-681d0106d382', N'Država')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (80, N'ded1dcb8-acb0-47f0-b37f-b70ded49eb16', N'Sport')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (81, N'e4fa20f0-f094-4dac-9f17-0cf521933512', N'Reket')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (82, N'65fb4f42-18b4-47ad-9f79-b5bd52bbc0cc', N'Tenis')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (83, N'0874ad7a-2a6b-4367-ab6c-74139f3d658c', N'Zenica')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (84, N'ced833fa-1e08-4d14-b81c-62d2b107c877', N'Japan')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (85, N'6057ff72-96de-4d2a-901e-6785a58de800', N'PlayStation')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (86, N'38543127-48b4-4b25-b8f3-4ea5a43a7c7b', N'Sony')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (87, N'66e4cd21-1f2e-4ba9-9190-0603522bbcd4', N'Koševo')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (88, N'e3e59bbd-0e1c-46b0-92ae-3b603a2e1577', N'LCD')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (89, N'150b2929-3a2c-4157-89b7-16f88a2c93d0', N'PSP')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (90, N'047f49a8-ecde-4554-a5de-7f31d55d2bea', N'Muzika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (91, N'61d1dea0-3c1c-466d-b73f-2c6bb34fb228', N'Pop muzika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (92, N'75abb758-8a85-4abd-839b-13f2d4bf4aee', N'Metal muzika')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (93, N'dccbc6f8-3a36-4a75-852d-3aa84c896be6', N'wiki')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (94, N'1aba6c76-dba7-4eba-b7db-d4b9ca410f5f', N'xml')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (95, N'b104bb2b-0b5c-4935-b86f-6a31ef9d8478', N'net.hr')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (96, N'dd26b265-5265-436a-94f1-628a5ec339aa', N'Lucine')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1093, N'c2fb7ca8-68a7-4f1f-a697-d6f05f840281', N'css')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1094, N'e7ca720f-6045-4111-bc1d-52ed812f7094', N'')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1095, N'57451850-d0d7-42bf-b5e2-28b7ba7f1227', N'selma')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1096, N'5b8a42cf-0915-43aa-8bcd-4ce64c17230c', N'mvc')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1097, N'795ada1f-8925-4017-991a-07d72cbeca31', N'Visual Studio ')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1098, N'5f06ad7b-ffa2-40ae-97f5-e3159cade0c1', N'Seminarski rad')
GO
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1099, N'bf10a328-8a2c-4d37-8b9b-580ad4b689d4', N'xxx')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1100, N'd3a8278b-fb38-441e-8ad6-5c90cf91d4f4', N'BiH')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1101, N'e33cd3b7-e8d9-4696-b97f-4dc71fe0d24f', N'West Herzegovina')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1102, N'6e49f239-f43c-4545-ad00-28ecb0b404d1', N'Mostar')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1103, N'96e234ad-5478-4e0b-bf70-71df9f7ac1cc', N'jj')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1104, N'fca696de-5c7a-41c4-b3c2-95cd900af82e', N'lijekovi')
INSERT [dbo].[Tag] ([TagID], [GUID], [Name]) VALUES (1105, N'32cb1219-21a1-4597-b386-1d4faefd8ddf', N'medicina')
SET IDENTITY_INSERT [dbo].[Tag] OFF
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (64, 25)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (64, 45)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (64, 68)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (64, 71)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (64, 72)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (65, 90)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (66, 90)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (66, 91)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (67, 90)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (67, 92)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (74, 83)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (75, 25)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (75, 68)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (75, 71)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (75, 72)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (76, 71)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (78, 7)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (78, 93)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (80, 95)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (81, 95)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (82, 3)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (83, 96)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1080, 84)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1080, 85)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1080, 86)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1084, 86)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1087, 25)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1087, 72)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1088, 1100)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1088, 1101)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1088, 1102)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1092, 84)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1092, 85)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1092, 86)
INSERT [dbo].[TagInArticle] ([Articles_ArticlesID], [Tag_TagID]) VALUES (1092, 89)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1018, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1018, 1096)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1018, 1097)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1019, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1019, 1098)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1020, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1020, 7)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1021, 35)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1022, 35)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1023, 1098)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1024, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1024, 7)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1025, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1025, 94)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1026, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1026, 7)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1027, 3)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1027, 1099)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1028, 1104)
INSERT [dbo].[TagInQuestion] ([Questions_QuestionID], [Tag_TagID]) VALUES (1028, 1105)
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (7, N'64b78ed3-adda-4486-844a-83fb9db0f61f', N'Selma', N'Dedic', NULL, NULL, NULL, NULL, NULL, N'test', NULL, NULL, N'admir.rey@gmail.com', N'admir.rey@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (8, N'ddaa2128-c492-4885-87d2-07bfd0b74d71', N'Selma', N'Bradaric', NULL, NULL, NULL, NULL, NULL, N'e', NULL, NULL, N'e', N'e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (9, N'fde05a5f-cd6c-4b4a-876a-b444500861da', N'Belma', N'Ðonko', NULL, NULL, NULL, NULL, NULL, N'b', NULL, NULL, N'b', N'b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (10, N'f848c798-4c30-408e-9bc7-819b0aaeb99f', N'Alen', N'Ðonko', NULL, NULL, NULL, NULL, NULL, N'a', NULL, NULL, N'a', N'eldo@fit.baa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (11, N'938471cf-b422-4c68-9967-b0941baecf44', N'Ivan', N'Dugandžic', NULL, NULL, NULL, NULL, NULL, N'test', NULL, NULL, N'ivan.dugandzic86@gmail.com', N'ivan.dugandzic86@gmail.com', NULL, NULL, N'ivan.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (12, N'2dc55aee-719f-49e2-9d20-2c984eb2655f', N'Mate', N'Matic', NULL, NULL, NULL, NULL, NULL, N'test', NULL, NULL, N'test@gmail.com', N'test@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (13, N'cb30d406-6271-4d3e-8daf-f48777bf1f2a', N'Mate', N'dugandzic', NULL, NULL, NULL, NULL, NULL, N'x', NULL, NULL, N'zeljadugandzic@hotmail.com', N'zeljadugandzic@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([UserID], [GUID], [FirstName], [LastName], [Gender], [Phone], [Address], [CityID], [UserName], [Password], [PasswordFormat], [PasswordSalt], [Email], [LoweredEmail], [PasswordQuestion], [PasswordAnswer], [PhotoLocation], [LastActivity], [LastLogin], [LastPasswordChange], [LastLockout], [IsApproved], [IsLockedOut], [Created], [Modified], [Description], [LocationCover], [CoverPostion], [IsFirst]) VALUES (14, N'26938da5-8a1b-498c-94f4-0458ff8e35e2', N'x', N'x', NULL, NULL, NULL, NULL, NULL, N'x', NULL, NULL, N'x@gmail.com', N'x@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[User] OFF
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (1, 12)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (1, 13)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (1, 14)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (2, 7)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (2, 8)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (2, 9)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (2, 10)
INSERT [dbo].[UserRole] ([Role_RoleID], [User_UserID]) VALUES (2, 11)
/****** Object:  Index [IX_FK_Answers_Questions]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Answers_Questions] ON [dbo].[Answer]
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Answers_User]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Answers_User] ON [dbo].[Answer]
(
	[CreatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Articles_Category]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Articles_Category] ON [dbo].[Article]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_City_Country]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_City_Country] ON [dbo].[City]
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Comment_Articles]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Comment_Articles] ON [dbo].[Comment]
(
	[ArticleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_MerchantComment_User]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_MerchantComment_User] ON [dbo].[Comment]
(
	[CreatedByUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_MerchantComment_User1]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_MerchantComment_User1] ON [dbo].[Comment]
(
	[ModifiedByUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_Questions_User]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_Questions_User] ON [dbo].[Question]
(
	[CreatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_TagInArticle]    Script Date: 11.3.2013. 10:09:04 ******/
ALTER TABLE [dbo].[TagInArticle] ADD  CONSTRAINT [PK_TagInArticle] PRIMARY KEY NONCLUSTERED 
(
	[Articles_ArticlesID] ASC,
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_TagInArticle_Tag]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_TagInArticle_Tag] ON [dbo].[TagInArticle]
(
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_TagInQuestion]    Script Date: 11.3.2013. 10:09:04 ******/
ALTER TABLE [dbo].[TagInQuestion] ADD  CONSTRAINT [PK_TagInQuestion] PRIMARY KEY NONCLUSTERED 
(
	[Questions_QuestionID] ASC,
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_TagInQuestion_Tag]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_TagInQuestion_Tag] ON [dbo].[TagInQuestion]
(
	[Tag_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_User_City]    Script Date: 11.3.2013. 10:09:04 ******/
CREATE NONCLUSTERED INDEX [IX_FK_User_City] ON [dbo].[User]
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_UserRole]    Script Date: 11.3.2013. 10:09:04 ******/
ALTER TABLE [dbo].[UserRole] ADD  CONSTRAINT [PK_UserRole] PRIMARY KEY NONCLUSTERED 
(
	[Role_RoleID] ASC,
	[User_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_UserRole_User]    Script Date: 11.3.2013. 10:09:04 ******/
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
ALTER TABLE [dbo].[QuestionLikes]  WITH CHECK ADD  CONSTRAINT [FK_QuestionLikes_Question] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionLikes] CHECK CONSTRAINT [FK_QuestionLikes_Question]
GO
ALTER TABLE [dbo].[QuestionLikes]  WITH CHECK ADD  CONSTRAINT [FK_QuestionLikes_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[QuestionLikes] CHECK CONSTRAINT [FK_QuestionLikes_User]
GO
ALTER TABLE [dbo].[QuestionsRating]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsRating_Question] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionsRating] CHECK CONSTRAINT [FK_QuestionsRating_Question]
GO
ALTER TABLE [dbo].[QuestionsRating]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsRating_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[QuestionsRating] CHECK CONSTRAINT [FK_QuestionsRating_User]
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
