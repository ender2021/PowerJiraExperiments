CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Link_Type]
(
[Issue_Link_Type_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Inward_Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Outward_Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Link_Type] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Link_Type] PRIMARY KEY CLUSTERED  ([Issue_Link_Type_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Link_Type] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue_Link_Type] TO [JiraRefreshRole]
GO
