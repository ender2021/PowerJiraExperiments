/*

Script created by SQL Compare version 13.1.1.5299 from Red Gate Software Ltd at 9/19/2019 7:49:49 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Read committed
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating role JiraRefreshRole'
GO
CREATE ROLE [JiraRefreshRole]
AUTHORIZATION [dbo]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Worklog_Delete]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Worklog_Delete]
(
[Worklog_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Worklog_Delete] on [dbo].[tbl_stg_Jira_Worklog_Delete]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Worklog_Delete] ADD CONSTRAINT [PK_tbl_stg_Jira_Worklog_Delete] PRIMARY KEY CLUSTERED  ([Worklog_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Worklog]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Worklog]
(
[Worklog_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Time_Spent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent_Seconds] [int] NOT NULL,
[Start_Date] [datetime] NOT NULL,
[Create_Date] [datetime] NOT NULL,
[Update_Date] [datetime] NOT NULL,
[Create_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Create_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Worklogs_Staging] on [dbo].[tbl_stg_Jira_Worklog]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Worklog] ADD CONSTRAINT [PK_tbl_Jira_Worklogs_Staging] PRIMARY KEY CLUSTERED  ([Worklog_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Worklog]'
GO
CREATE TABLE [dbo].[tbl_Jira_Worklog]
(
[Worklog_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Time_Spent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent_Seconds] [int] NOT NULL,
[Start_Date] [datetime] NOT NULL,
[Create_Date] [datetime] NOT NULL,
[Update_Date] [datetime] NOT NULL,
[Create_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Create_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Worklogs_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Worklogs] on [dbo].[tbl_Jira_Worklog]'
GO
ALTER TABLE [dbo].[tbl_Jira_Worklog] ADD CONSTRAINT [PK_tbl_Jira_Worklogs] PRIMARY KEY CLUSTERED  ([Worklog_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Worklog]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Worklog]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Worklog]
	WHERE [Worklog_Id] IN (SELECT DISTINCT [Worklog_Id] FROM [dbo].[tbl_stg_Jira_Worklog])

	DELETE FROM [dbo].[tbl_Jira_Worklog]
	WHERE [Worklog_Id] IN (SELECT [Worklog_Id] FROM [dbo].[tbl_stg_Jira_Worklog_Delete])

	INSERT INTO [dbo].[tbl_Jira_Worklog]
	(
	    [Worklog_Id],
	    [Issue_Id],
	    [Time_Spent],
	    [Time_Spent_Seconds],
	    [Start_Date],
	    [Create_Date],
	    [Update_Date],
	    [Create_User_Id],
	    [Create_User_Name],
	    [Update_User_Id],
	    [Update_User_Name],
	    [Comment],
	    [Update_Refresh_Id]
	)
	SELECT [Worklog_Id],
	    [Issue_Id],
	    [Time_Spent],
	    [Time_Spent_Seconds],
	    [Start_Date],
	    [Create_Date],
	    [Update_Date],
	    [Create_User_Id],
	    [Create_User_Name],
	    [Update_User_Id],
	    [Update_User_Name],
	    [Comment],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Worklog]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Version]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Version]
(
[Version_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Archived] [bit] NOT NULL,
[Released] [bit] NOT NULL,
[Start_Date] [datetime] NULL,
[Release_Date] [datetime] NULL,
[User_Start_Date] [datetime] NULL,
[User_Release_Date] [datetime] NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Version_Staging] on [dbo].[tbl_stg_Jira_Version]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Version] ADD CONSTRAINT [PK_tbl_Jira_Version_Staging] PRIMARY KEY CLUSTERED  ([Version_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_User]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_User]
(
[Account_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_16] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_24] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_32] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_48] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_User] on [dbo].[tbl_stg_Jira_User]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_User] ADD CONSTRAINT [PK_tbl_stg_Jira_User] PRIMARY KEY CLUSTERED  ([Account_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Status_Category]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Status_Category]
(
[Status_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Color_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Status_Category] on [dbo].[tbl_stg_Jira_Status_Category]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Status_Category] ADD CONSTRAINT [PK_tbl_stg_Jira_Status_Category] PRIMARY KEY CLUSTERED  ([Status_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Status]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Status]
(
[Status_Id] [int] NOT NULL,
[Status_Catgory_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Status] on [dbo].[tbl_stg_Jira_Status]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Status] ADD CONSTRAINT [PK_tbl_stg_Jira_Status] PRIMARY KEY CLUSTERED  ([Status_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Sprint]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Rapid_View_Id] [int] NOT NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Goal] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Start_Date] [datetime] NOT NULL,
[End_Date] [datetime] NOT NULL,
[Complete_Date] [datetime] NULL,
[Sequence] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Sprint_Staging] on [dbo].[tbl_stg_Jira_Sprint]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Sprint_Staging] PRIMARY KEY CLUSTERED  ([Sprint_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Resolution]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Resolution]
(
[Resolution_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Resolution] on [dbo].[tbl_stg_Jira_Resolution]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Resolution] ADD CONSTRAINT [PK_tbl_stg_Jira_Resolution] PRIMARY KEY CLUSTERED  ([Resolution_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Project_Category]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Project_Category]
(
[Project_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Project_Category_Staging] on [dbo].[tbl_stg_Jira_Project_Category]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Project_Category] ADD CONSTRAINT [PK_tbl_Jira_Project_Category_Staging] PRIMARY KEY CLUSTERED  ([Project_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Project]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Project]
(
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Project_Project_Name] DEFAULT (''),
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category_Id] [int] NULL,
[Project_Type_Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Simplified] [bit] NOT NULL,
[Style] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Private] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Project_Staging] on [dbo].[tbl_stg_Jira_Project]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Project] ADD CONSTRAINT [PK_tbl_Jira_Project_Staging] PRIMARY KEY CLUSTERED  ([Project_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Priority]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Priority]
(
[Priority_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Color] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Priority] on [dbo].[tbl_stg_Jira_Priority]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Priority] ADD CONSTRAINT [PK_tbl_stg_Jira_Priority] PRIMARY KEY CLUSTERED  ([Priority_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Type]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Type]
(
[Issue_Type_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subtask_Type] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Issue_Type] on [dbo].[tbl_stg_Jira_Issue_Type]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Type] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Type] PRIMARY KEY CLUSTERED  ([Issue_Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Sprint]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Issue_Sprint_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Sprint_Staging] on [dbo].[tbl_stg_Jira_Issue_Sprint]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Issue_Sprint_Staging] PRIMARY KEY CLUSTERED  ([Sprint_Id], [Issue_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Link_Type]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Link_Type]
(
[Issue_Link_Type_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Inward_Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Outward_Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Issue_Link_Type] on [dbo].[tbl_stg_Jira_Issue_Link_Type]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Link_Type] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Link_Type] PRIMARY KEY CLUSTERED  ([Issue_Link_Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Link]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Link]
(
[Issue_Link_Id] [int] NOT NULL,
[Link_Type_Id] [int] NOT NULL,
[In_Issue_Id] [int] NOT NULL,
[In_Issue_Key] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Out_Issue_Id] [int] NOT NULL,
[Out_Issue_Key] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Issue_Link] on [dbo].[tbl_stg_Jira_Issue_Link]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Link] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Link] PRIMARY KEY CLUSTERED  ([Issue_Link_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Label]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Label]
(
[Label] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_stg_Jira_Issue_Label] on [dbo].[tbl_stg_Jira_Issue_Label]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Label] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Label] PRIMARY KEY CLUSTERED  ([Issue_Id], [Label])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Fix_Version]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Fix_Version]
(
[Issue_Id] [int] NOT NULL,
[Version_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Issue_Fix_Version_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Fix_Version_Staging] on [dbo].[tbl_stg_Jira_Issue_Fix_Version]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Fix_Version] ADD CONSTRAINT [PK_tbl_Jira_Issue_Fix_Version_Staging] PRIMARY KEY CLUSTERED  ([Issue_Id], [Version_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue_Component]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Component]
(
[Issue_Id] [int] NOT NULL,
[Component_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Issue_Component_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Component_Staging] on [dbo].[tbl_stg_Jira_Issue_Component]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Component] ADD CONSTRAINT [PK_tbl_Jira_Issue_Component_Staging] PRIMARY KEY CLUSTERED  ([Issue_Id], [Component_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Issue]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Issue]
(
[Issue_Id] [int] NOT NULL,
[Issue_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Type_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent] [int] NULL,
[Aggregate_Time_Spent] [int] NULL,
[Resolution_Date] [datetime] NULL,
[Work_Ratio] [bigint] NULL,
[Created_Date] [datetime] NOT NULL,
[Time_Estimate] [int] NULL,
[Aggregate_Time_Original_Estimate] [int] NULL,
[Updated_Date] [datetime] NOT NULL,
[Time_Original_Estimate] [int] NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aggregate_Time_Estimate] [int] NULL,
[Summary] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Due_Date] [datetime] NULL,
[Flagged] [bit] NOT NULL,
[External_Reporter_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desired_Date] [datetime] NULL,
[Chart_Date_Of_First_Response] [datetime] NULL,
[Start_Date] [datetime] NULL,
[Story_Points] [int] NULL,
[Epic_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolution_Id] [int] NULL,
[Priority_Id] [int] NOT NULL,
[Assignee_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [int] NOT NULL,
[Creator_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Creator_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reporter_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reporter_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Votes] [int] NULL,
[Parent_Id] [int] NULL,
[Parent_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Staging] on [dbo].[tbl_stg_Jira_Issue]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue] ADD CONSTRAINT [PK_tbl_Jira_Issue_Staging] PRIMARY KEY CLUSTERED  ([Issue_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Jira_Component]'
GO
CREATE TABLE [dbo].[tbl_stg_Jira_Component]
(
[Component_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Real_Assignee_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assignee_Type_Valid] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Component_Staging] on [dbo].[tbl_stg_Jira_Component]'
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Component] ADD CONSTRAINT [PK_tbl_Jira_Component_Staging] PRIMARY KEY CLUSTERED  ([Component_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Clear]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-13
-- Description:	Clears the Jira staging tables
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Clear]
AS
BEGIN
	SET NOCOUNT ON;

    TRUNCATE TABLE [dbo].[tbl_stg_Jira_Component]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Component]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Fix_Version]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Label]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Link]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Link_Type]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Sprint]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Issue_Type]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Priority]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Project]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Project_Category]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Resolution]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Sprint]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Status]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Status_Category]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_User]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Version]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Worklog]
	TRUNCATE TABLE [dbo].[tbl_stg_Jira_Worklog_Delete]

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Version]'
GO
CREATE TABLE [dbo].[tbl_Jira_Version]
(
[Version_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Archived] [bit] NOT NULL,
[Released] [bit] NOT NULL,
[Start_Date] [datetime] NULL,
[Release_Date] [datetime] NULL,
[User_Start_Date] [datetime] NULL,
[User_Release_Date] [datetime] NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Version_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Version] on [dbo].[tbl_Jira_Version]'
GO
ALTER TABLE [dbo].[tbl_Jira_Version] ADD CONSTRAINT [PK_tbl_Jira_Version] PRIMARY KEY CLUSTERED  ([Version_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Version]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Version]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Version]
	WHERE [Project_Id] IN (SELECT DISTINCT [Project_Id] FROM [dbo].[tbl_stg_Jira_Project])

	INSERT INTO [dbo].[tbl_Jira_Version]
	(
	    [Version_Id],
	    [Project_Id],
	    [Name],
	    [Archived],
	    [Released],
	    [Start_Date],
	    [Release_Date],
	    [User_Start_Date],
	    [User_Release_Date],
	    [Update_Refresh_Id]
	)
	SELECT [Version_Id],
	    [Project_Id],
	    [Name],
	    [Archived],
	    [Released],
	    [Start_Date],
	    [Release_Date],
	    [User_Start_Date],
	    [User_Release_Date],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Version]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_User]'
GO
CREATE TABLE [dbo].[tbl_Jira_User]
(
[Account_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_16] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_24] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_32] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_48] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_User] on [dbo].[tbl_Jira_User]'
GO
ALTER TABLE [dbo].[tbl_Jira_User] ADD CONSTRAINT [PK_tbl_Jira_User] PRIMARY KEY CLUSTERED  ([Account_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_User]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_User]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_User]

	INSERT INTO [dbo].[tbl_Jira_User]
	(
	    [Account_Id],
	    [Account_Type],
	    [DisplayName],
	    [Name],
	    [Avatar_16],
	    [Avatar_24],
	    [Avatar_32],
	    [Avatar_48],
	    [Active],
	    [Update_Refresh_Id]
	)
	SELECT [Account_Id],
	    [Account_Type],
	    [DisplayName],
	    [Name],
	    [Avatar_16],
	    [Avatar_24],
	    [Avatar_32],
	    [Avatar_48],
	    [Active],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_User]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Status_Category]'
GO
CREATE TABLE [dbo].[tbl_Jira_Status_Category]
(
[Status_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Color_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Status_Category] on [dbo].[tbl_Jira_Status_Category]'
GO
ALTER TABLE [dbo].[tbl_Jira_Status_Category] ADD CONSTRAINT [PK_tbl_Jira_Status_Category] PRIMARY KEY CLUSTERED  ([Status_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Status_Category]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Status_Category]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Status_Category]

	INSERT INTO [dbo].[tbl_Jira_Status_Category]
	(
	    [Status_Category_Id],
	    [Name],
	    [Key],
	    [Color_Name],
	    [Update_Refresh_Id]
	)
	SELECT [Status_Category_Id],
	    [Name],
	    [Key],
	    [Color_Name],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Status_Category]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Status]'
GO
CREATE TABLE [dbo].[tbl_Jira_Status]
(
[Status_Id] [int] NOT NULL,
[Status_Catgory_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Status] on [dbo].[tbl_Jira_Status]'
GO
ALTER TABLE [dbo].[tbl_Jira_Status] ADD CONSTRAINT [PK_tbl_Jira_Status] PRIMARY KEY CLUSTERED  ([Status_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Status]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Status]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Status]

	INSERT INTO [dbo].[tbl_Jira_Status]
	(
	    [Status_Id],
	    [Status_Catgory_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Update_Refresh_Id]
	)
	SELECT [Status_Id],
	    [Status_Catgory_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Status]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Sprint]'
GO
CREATE TABLE [dbo].[tbl_Jira_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Rapid_View_Id] [int] NOT NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Goal] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Start_Date] [datetime] NOT NULL,
[End_Date] [datetime] NOT NULL,
[Complete_Date] [datetime] NULL,
[Sequence] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Sprint_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Sprint] on [dbo].[tbl_Jira_Sprint]'
GO
ALTER TABLE [dbo].[tbl_Jira_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Sprint] PRIMARY KEY CLUSTERED  ([Sprint_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Sprint]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Sprint]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Sprint]
	WHERE [Sprint_Id] IN (SELECT DISTINCT [Sprint_Id] FROM [dbo].[tbl_stg_Jira_Sprint])

	INSERT INTO [dbo].[tbl_Jira_Sprint]
	(
	    [Sprint_Id],
	    [Rapid_View_Id],
	    [State],
	    [Name],
	    [Goal],
	    [Start_Date],
	    [End_Date],
	    [Complete_Date],
	    [Sequence],
	    [Update_Refresh_Id]
	)
	SELECT [Sprint_Id],
	    [Rapid_View_Id],
	    [State],
	    [Name],
	    [Goal],
	    [Start_Date],
	    [End_Date],
	    [Complete_Date],
	    [Sequence],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Sprint]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Resolution]'
GO
CREATE TABLE [dbo].[tbl_Jira_Resolution]
(
[Resolution_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Resolution] on [dbo].[tbl_Jira_Resolution]'
GO
ALTER TABLE [dbo].[tbl_Jira_Resolution] ADD CONSTRAINT [PK_tbl_Jira_Resolution] PRIMARY KEY CLUSTERED  ([Resolution_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Resolution]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Resolution]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Resolution]

	INSERT INTO [dbo].[tbl_Jira_Resolution]
	(
	    [Resolution_Id],
	    [Name],
	    [Description],
	    [Update_Refresh_Id]
	)
	SELECT [Resolution_Id],
	    [Name],
	    [Description],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Resolution]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Project_Category]'
GO
CREATE TABLE [dbo].[tbl_Jira_Project_Category]
(
[Project_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Project_Category_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Project_Category] on [dbo].[tbl_Jira_Project_Category]'
GO
ALTER TABLE [dbo].[tbl_Jira_Project_Category] ADD CONSTRAINT [PK_tbl_Jira_Project_Category] PRIMARY KEY CLUSTERED  ([Project_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Project_Category]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Project_Category]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Project_Category]

	INSERT INTO [dbo].[tbl_Jira_Project_Category]
	(
	    [Project_Category_Id],
	    [Name],
	    [Description],
	    [Update_Refresh_Id]
	)
	SELECT [Project_Category_Id],
	    [Name],
	    [Description],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Project_Category]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Project]'
GO
CREATE TABLE [dbo].[tbl_Jira_Project]
(
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_Jira_Project_Project_Name] DEFAULT (''),
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category_Id] [int] NULL,
[Project_Type_Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Simplified] [bit] NOT NULL,
[Style] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Private] [bit] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Project_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Project] on [dbo].[tbl_Jira_Project]'
GO
ALTER TABLE [dbo].[tbl_Jira_Project] ADD CONSTRAINT [PK_tbl_Jira_Project] PRIMARY KEY CLUSTERED  ([Project_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Project]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Project]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Project]
	WHERE [Project_Id] IN (SELECT DISTINCT [Project_Id] FROM [dbo].[tbl_stg_Jira_Project])

	INSERT INTO [dbo].[tbl_Jira_Project]
	(
	    [Project_Id],
	    [Project_Key],
		[Project_Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Category_Id],
	    [Project_Type_Key],
	    [Simplified],
	    [Style],
	    [Private],
	    [Update_Refresh_Id]
	)
	SELECT [Project_Id],
	    [Project_Key],
		[Project_Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Category_Id],
	    [Project_Type_Key],
	    [Simplified],
	    [Style],
	    [Private],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Project]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Priority]'
GO
CREATE TABLE [dbo].[tbl_Jira_Priority]
(
[Priority_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Color] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Priority] on [dbo].[tbl_Jira_Priority]'
GO
ALTER TABLE [dbo].[tbl_Jira_Priority] ADD CONSTRAINT [PK_tbl_Jira_Priority] PRIMARY KEY CLUSTERED  ([Priority_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Priority]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Priority]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Priority]

	INSERT INTO [dbo].[tbl_Jira_Priority]
	(
	    [Priority_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Status_Color],
	    [Update_Refresh_Id]
	)
	SELECT [Priority_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Status_Color],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Priority]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Link_Type]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Link_Type]
(
[Issue_Link_Type_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Inward_Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Outward_Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Link_Type] on [dbo].[tbl_Jira_Issue_Link_Type]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Link_Type] ADD CONSTRAINT [PK_tbl_Jira_Issue_Link_Type] PRIMARY KEY CLUSTERED  ([Issue_Link_Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Link_Type]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Link_Type]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Link_Type]

	INSERT INTO [dbo].[tbl_Jira_Issue_Link_Type]
	(
	    [Issue_Link_Type_Id],
	    [Name],
	    [Inward_Label],
	    [Outward_Label],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Link_Type_Id],
	    [Name],
	    [Inward_Label],
	    [Outward_Label],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Link_Type]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Type]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Type]
(
[Issue_Type_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subtask_Type] [bit] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Type] on [dbo].[tbl_Jira_Issue_Type]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Type] ADD CONSTRAINT [PK_tbl_Jira_Issue_Type] PRIMARY KEY CLUSTERED  ([Issue_Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue_Type]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Type]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Issue_Type]
	WHERE [Issue_Type_Id] IN (SELECT DISTINCT [Issue_Type_Id] FROM [dbo].[tbl_stg_Jira_Issue_Type])

	INSERT INTO [dbo].[tbl_Jira_Issue_Type]
	(
	    [Issue_Type_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Subtask_Type],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Type_Id],
		[Name],
		[Description],
		[Icon_Url],
		[Subtask_Type],
		[Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Type]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Sprint]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Sprint] on [dbo].[tbl_Jira_Issue_Sprint]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Issue_Sprint] PRIMARY KEY CLUSTERED  ([Sprint_Id], [Issue_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue_Sprint]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Sprint]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Sprint]
	WHERE [Issue_Id] IN (SELECT DISTINCT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Sprint]
	(
	    [Sprint_Id],
	    [Issue_Id],
	    [Update_Refresh_Id]
	)
	SELECT DISTINCT [Sprint_Id],
	    [Issue_Id],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Sprint]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Link]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Link]
(
[Issue_Link_Id] [int] NOT NULL,
[Link_Type_Id] [int] NOT NULL,
[In_Issue_Id] [int] NOT NULL,
[In_Issue_Key] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Out_Issue_Id] [int] NOT NULL,
[Out_Issue_Key] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Link] on [dbo].[tbl_Jira_Issue_Link]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Link] ADD CONSTRAINT [PK_tbl_Jira_Issue_Link] PRIMARY KEY CLUSTERED  ([Issue_Link_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue_Link]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Link]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Link]
	WHERE [In_Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])
	   OR [Out_Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Link]
	(
	    [Issue_Link_Id],
	    [Link_Type_Id],
	    [In_Issue_Id],
	    [In_Issue_Key],
	    [Out_Issue_Id],
	    [Out_Issue_Key],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Link_Id],
	    [Link_Type_Id],
	    [In_Issue_Id],
	    [In_Issue_Key],
	    [Out_Issue_Id],
	    [Out_Issue_Key],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Link]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Label]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Label]
(
[Label] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Label] on [dbo].[tbl_Jira_Issue_Label]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Label] ADD CONSTRAINT [PK_tbl_Jira_Issue_Label] PRIMARY KEY CLUSTERED  ([Issue_Id], [Label])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue_Label]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Label]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Label]
	WHERE [Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Label]
	(
	    [Label],
	    [Issue_Id],
	    [Update_Refresh_Id]
	)
	SELECT [Label],
	    [Issue_Id],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Label]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Fix_Version]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Fix_Version]
(
[Issue_Id] [int] NOT NULL,
[Version_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Fix_Version] on [dbo].[tbl_Jira_Issue_Fix_Version]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Fix_Version] ADD CONSTRAINT [PK_tbl_Jira_Issue_Fix_Version] PRIMARY KEY CLUSTERED  ([Issue_Id], [Version_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue_Fix_Version]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Fix_Version]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Fix_Version]
	WHERE [Issue_Id] IN (SELECT DISTINCT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Fix_Version]
	(
	    [Issue_Id],
	    [Version_Id],
	    [Update_Refresh_Id]
	)
	SELECT DISTINCT [Issue_Id],
	    [Version_Id],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Fix_Version]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Component]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Component]
(
[Issue_Id] [int] NOT NULL,
[Component_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Component] on [dbo].[tbl_Jira_Issue_Component]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Component] ADD CONSTRAINT [PK_tbl_Jira_Issue_Component] PRIMARY KEY CLUSTERED  ([Issue_Id], [Component_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue_Component]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Component]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Component]
	WHERE [Issue_Id] IN (SELECT DISTINCT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Component]
	(
	    [Issue_Id],
	    [Component_Id],
	    [Update_Refresh_Id]
	)
	SELECT DISTINCT [Issue_Id],
	    [Component_Id],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Component]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue]
(
[Issue_Id] [int] NOT NULL,
[Issue_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Type_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent] [int] NULL,
[Aggregate_Time_Spent] [int] NULL,
[Resolution_Date] [datetime] NULL,
[Work_Ratio] [bigint] NULL,
[Created_Date] [datetime] NOT NULL,
[Time_Estimate] [int] NULL,
[Aggregate_Time_Original_Estimate] [int] NULL,
[Updated_Date] [datetime] NOT NULL,
[Time_Original_Estimate] [int] NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aggregate_Time_Estimate] [int] NULL,
[Summary] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Due_Date] [datetime] NULL,
[Flagged] [bit] NOT NULL,
[External_Reporter_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desired_Date] [datetime] NULL,
[Chart_Date_Of_First_Response] [datetime] NULL,
[Start_Date] [datetime] NULL,
[Story_Points] [int] NULL,
[Epic_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolution_Id] [int] NULL,
[Priority_Id] [int] NOT NULL,
[Assignee_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [int] NOT NULL,
[Creator_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Creator_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reporter_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reporter_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Votes] [int] NULL,
[Parent_Id] [int] NULL,
[Parent_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Issue_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue] on [dbo].[tbl_Jira_Issue]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue] ADD CONSTRAINT [PK_tbl_Jira_Issue] PRIMARY KEY CLUSTERED  ([Issue_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Issue]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue]
	WHERE [Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue]
	(
	    [Issue_Id],
	    [Issue_Key],
	    [Issue_Type_Id],
	    [Project_Id],
	    [Project_Key],
	    [Time_Spent],
	    [Aggregate_Time_Spent],
	    [Resolution_Date],
	    [Work_Ratio],
	    [Created_Date],
	    [Time_Estimate],
	    [Aggregate_Time_Original_Estimate],
	    [Updated_Date],
	    [Time_Original_Estimate],
	    [Description],
	    [Aggregate_Time_Estimate],
	    [Summary],
	    [Due_Date],
	    [Flagged],
	    [External_Reporter_Name],
	    [External_Reporter_Email],
	    [External_Reporter_Department],
	    [Desired_Date],
	    [Chart_Date_Of_First_Response],
	    [Start_Date],
	    [Story_Points],
	    [Epic_Key],
	    [Resolution_Id],
	    [Priority_Id],
	    [Assignee_User_Id],
	    [Assignee_User_Name],
	    [Status_Id],
	    [Creator_User_Id],
	    [Creator_User_Name],
	    [Reporter_User_Id],
	    [Reporter_User_Name],
	    [Votes],
	    [Parent_Id],
	    [Parent_Key],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Id],
	    [Issue_Key],
	    [Issue_Type_Id],
	    [Project_Id],
	    [Project_Key],
	    [Time_Spent],
	    [Aggregate_Time_Spent],
	    [Resolution_Date],
	    [Work_Ratio],
	    [Created_Date],
	    [Time_Estimate],
	    [Aggregate_Time_Original_Estimate],
	    [Updated_Date],
	    [Time_Original_Estimate],
	    [Description],
	    [Aggregate_Time_Estimate],
	    [Summary],
	    [Due_Date],
	    [Flagged],
	    [External_Reporter_Name],
	    [External_Reporter_Email],
	    [External_Reporter_Department],
	    [Desired_Date],
	    [Chart_Date_Of_First_Response],
	    [Start_Date],
	    [Story_Points],
	    [Epic_Key],
	    [Resolution_Id],
	    [Priority_Id],
	    [Assignee_User_Id],
	    [Assignee_User_Name],
	    [Status_Id],
	    [Creator_User_Id],
	    [Creator_User_Name],
	    [Reporter_User_Id],
	    [Reporter_User_Name],
	    [Votes],
	    [Parent_Id],
	    [Parent_Key],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Component]'
GO
CREATE TABLE [dbo].[tbl_Jira_Component]
(
[Component_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Real_Assignee_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assignee_Type_Valid] [bit] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Component_Update_Refresh_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Component] on [dbo].[tbl_Jira_Component]'
GO
ALTER TABLE [dbo].[tbl_Jira_Component] ADD CONSTRAINT [PK_tbl_Jira_Component] PRIMARY KEY CLUSTERED  ([Component_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Sync_Component]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Component]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Component]
	WHERE [Project_Id] IN (SELECT DISTINCT [Project_Id] FROM [dbo].[tbl_stg_Jira_Project])

	INSERT INTO [dbo].[tbl_Jira_Component]
	(
	    [Component_Id],
	    [Project_Key],
	    [Project_Id],
	    [Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Assignee_Type],
	    [Real_Assignee_Type],
	    [Assignee_Type_Valid],
	    [Update_Refresh_Id]
	)
	SELECT [Component_Id],
	    [Project_Key],
	    [Project_Id],
	    [Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Assignee_Type],
	    [Real_Assignee_Type],
	    [Assignee_Type_Valid],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Component]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Staging_Synchronize]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-13
-- Description:	Synchronize staging tables with the live tables
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Synchronize]
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [dbo].[usp_Jira_Staging_Sync_Component]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Component]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Fix_Version]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Label]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Link]
	EXEC [dbo].[usp_Jira_Staging_Sync_Link_Type]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Sprint]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Type]
	EXEC [dbo].[usp_Jira_Staging_Sync_Priority]
	EXEC [dbo].[usp_Jira_Staging_Sync_Project]
	EXEC [dbo].[usp_Jira_Staging_Sync_Project_Category]
	EXEC [dbo].[usp_Jira_Staging_Sync_Resolution]
	EXEC [dbo].[usp_Jira_Staging_Sync_Sprint]
	EXEC [dbo].[usp_Jira_Staging_Sync_Status]
	EXEC [dbo].[usp_Jira_Staging_Sync_Status_Category]
	EXEC [dbo].[usp_Jira_Staging_Sync_User]
	EXEC [dbo].[usp_Jira_Staging_Sync_Version]
	EXEC [dbo].[usp_Jira_Staging_Sync_Worklog]

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Refresh]'
GO
CREATE TABLE [dbo].[tbl_Jira_Refresh]
(
[Refresh_ID] [int] NOT NULL IDENTITY(1, 1),
[Refresh_Start] [datetime] NOT NULL,
[Refresh_Start_Unix] [int] NOT NULL,
[Refresh_End] [datetime] NULL,
[Refresh_End_Unix] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Refresh] on [dbo].[tbl_Jira_Refresh]'
GO
ALTER TABLE [dbo].[tbl_Jira_Refresh] ADD CONSTRAINT [PK_tbl_Jira_Refresh] PRIMARY KEY CLUSTERED  ([Refresh_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Refresh_Get_Max]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Get the most recent jira refresh record
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Refresh_Get_Max]
	AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1
		   [Refresh_ID]
		  ,[Refresh_Start]
		  ,[Refresh_Start_Unix]
	FROM [dbo].[tbl_Jira_Refresh]
	ORDER BY [Refresh_Start] DESC
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Jira_Epic]'
GO
CREATE VIEW [dbo].[vw_Jira_Epic]
AS
SELECT        Issue_Id, Issue_Key, Issue_Type_Id, Project_Id, Project_Key, Time_Spent, Aggregate_Time_Spent, Resolution_Date, Work_Ratio, Created_Date, Time_Estimate, Aggregate_Time_Original_Estimate, Updated_Date, 
                         Time_Original_Estimate, Description, Aggregate_Time_Estimate, Summary, Due_Date, Flagged, External_Reporter_Name, External_Reporter_Email, External_Reporter_Department, Desired_Date, 
                         Chart_Date_Of_First_Response, Start_Date, Story_Points, Epic_Key, Resolution_Id, Priority_Id, Assignee_User_Id, Assignee_User_Name, Status_Id, Creator_User_Id, Creator_User_Name, Reporter_User_Id, 
                         Reporter_User_Name, Votes, Parent_Id, Parent_Key, Update_Refresh_Id
FROM            dbo.tbl_Jira_Issue
WHERE        (Issue_Type_Id = 10004)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Refresh_Update_End]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Sets the end time of a Jira refresh
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Refresh_Update_End]
	@Refresh_Id AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	UPDATE [dbo].[tbl_Jira_Refresh]
	SET [Refresh_End] = @currDate
	   ,[Refresh_End_Unix] = DATEDIFF(s, '1970-01-01', @currDate)
	WHERE [Refresh_ID] = @Refresh_Id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Jira_Subtask]'
GO
CREATE VIEW [dbo].[vw_Jira_Subtask]
AS
SELECT        I.Issue_Id, I.Issue_Key, I.Issue_Type_Id, I.Project_Id, I.Project_Key, I.Time_Spent, I.Aggregate_Time_Spent, I.Resolution_Date, I.Work_Ratio, I.Created_Date, I.Time_Estimate, I.Aggregate_Time_Original_Estimate, 
                         I.Updated_Date, I.Time_Original_Estimate, I.Description, I.Aggregate_Time_Estimate, I.Summary, I.Due_Date, I.Flagged, I.External_Reporter_Name, I.External_Reporter_Email, I.External_Reporter_Department, I.Desired_Date, 
                         I.Chart_Date_Of_First_Response, I.Start_Date, I.Story_Points, I.Epic_Key, I.Resolution_Id, I.Priority_Id, I.Assignee_User_Id, I.Assignee_User_Name, I.Status_Id, I.Creator_User_Id, I.Creator_User_Name, I.Reporter_User_Id, 
                         I.Reporter_User_Name, I.Votes, I.Parent_Id, I.Parent_Key, I.Update_Refresh_Id
FROM            dbo.tbl_Jira_Issue AS I INNER JOIN
                         dbo.tbl_Jira_Issue_Type AS IT ON IT.Issue_Type_Id = I.Issue_Type_Id
WHERE        (IT.Subtask_Type = 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[fn_Jira_Parent_Epic]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-16
-- Description:	Get the Parent Epic for a given issue ID
-- =============================================
CREATE FUNCTION [dbo].[fn_Jira_Parent_Epic]
(
	@Issue_Id AS INT
)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @parentEpic AS VARCHAR(500)

	SELECT @parentEpic = CASE
							WHEN [IT].[Subtask_Type] = 1 THEN (SELECT [P].[Epic_Key] FROM [dbo].[tbl_Jira_Issue] AS [P] WHERE [P].[Issue_Id] = [I].[Parent_Id])
							ELSE [I].[Epic_Key]
						 END
	FROM [dbo].[tbl_Jira_Issue] AS [I]
	INNER JOIN [dbo].[tbl_Jira_Issue_Type] AS IT
	ON [IT].[Issue_Type_Id] = [I].[Issue_Type_Id]
	WHERE i.[Issue_Id] = @Issue_Id

	RETURN @parentEpic
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Jira_Issue]'
GO
CREATE VIEW [dbo].[vw_Jira_Issue]
AS
SELECT        Issue_Id, Issue_Key, Issue_Type_Id, Project_Id, Project_Key, Time_Spent, Aggregate_Time_Spent, Resolution_Date, Work_Ratio, Created_Date, Time_Estimate, Aggregate_Time_Original_Estimate, Updated_Date, 
                         Time_Original_Estimate, Description, Aggregate_Time_Estimate, Summary, Due_Date, Flagged, External_Reporter_Name, External_Reporter_Email, External_Reporter_Department, Desired_Date, 
                         Chart_Date_Of_First_Response, Start_Date, Story_Points, Epic_Key, Resolution_Id, Priority_Id, Assignee_User_Id, Assignee_User_Name, Status_Id, Creator_User_Id, Creator_User_Name, Reporter_User_Id, 
                         Reporter_User_Name, Votes, Parent_Id, Parent_Key, Update_Refresh_Id, dbo.fn_Jira_Parent_Epic(Issue_Id) AS Parent_Epic_Key
FROM            dbo.tbl_Jira_Issue
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating extended properties'
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_Jira_Issue"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 310
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Epic', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Epic', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_Jira_Issue"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 310
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Issue', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Issue', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "I"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 310
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IT"
            Begin Extent = 
               Top = 6
               Left = 348
               Bottom = 136
               Right = 534
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Subtask', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Subtask', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Component]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Component] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Component]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Component] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Fix_Version]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Fix_Version] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Label]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Label] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Link]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Link] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Link_Type]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Link_Type] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Sprint]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Sprint] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Issue_Type]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Type] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Priority]'
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Priority] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Project]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Project] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Project_Category]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Project_Category] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Resolution]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Resolution] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Sprint]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Sprint] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Status]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Status] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Status_Category]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Status_Category] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_User]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_User] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Version]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Version] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Worklog]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Worklog] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Jira_Worklog_Delete]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Worklog_Delete] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Jira_Refresh_Get_Max]'
GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Refresh_Get_Max] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Jira_Refresh_Update_End]'
GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Refresh_Update_End] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Jira_Staging_Clear]'
GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Clear] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Jira_Staging_Synchronize]'
GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Synchronize] TO [JiraRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
