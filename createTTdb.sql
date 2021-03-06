-- 
--  TestTracker v2 Database Creation Script
--  Copyright 2018, Wineman Technology, Inc.
--  All Rights Reserved

DROP DATABASE [TestTracker_v2]
GO

CREATE DATABASE [TestTracker_v2]
GO
--
USE [TestTracker_v2]
GO
ALTER DATABASE [TestTracker_v2]
SET ALLOW_SNAPSHOT_ISOLATION ON
GO
--                                                                                                                                      
--  !! First manually create this database (called TestTracker_v2) within SQL Server and then run this script                    
--  !! If TestTracker is hosted in IIS, SQL Server and Database may require a user account: IIS APPPOOL\{IIS Service Name}   
--  !! User account default database = TestTracker_v2, roles would be db_datareader and db_datawriter
--                                                                                                            
--  ALLOW_SNAPSHOT_ISOLATION (ON) helps prevents deadlocks by allowing queries to read snapshots                     
--  without locking tables.  NOTE the default isolation level for Entity Framework is READ COMMITTED                 
--  SNAPSHOT isolation specifies that data read within a transaction will never reflect changes made by other        
--  simultaneous transactions                                                                                        

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entity](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ParentId] [bigint] NULL,
	[Revision] [int] NOT NULL CONSTRAINT [DF_Entity_Revision]  DEFAULT ((0)),
	[RevisionTypeId] [int] NOT NULL CONSTRAINT [DF_Entity_IsActiveRevision]  DEFAULT ((1)),
	[IsVersionControlled] [bit] NOT NULL CONSTRAINT [DF_Entity_IsVersionControlled]  DEFAULT ((0)),
	[IsDeletable] [bit] NOT NULL CONSTRAINT [DF_Entity_IsDeletable]  DEFAULT ((1)),
	[trackGetActivity] [bit] NULL,
	[trackPutActivity] [bit] NULL,
	[isCheckedOut] [bit] NULL,
	[CheckedOutStationId] [bigint] NULL,
	[CheckedOutUserId] [bigint] NULL,
	[EntityType] [nvarchar](64) NULL CONSTRAINT [DF_Entity_EntityType]  DEFAULT ('none'),
	[CreatedBy] [nvarchar](128) NULL,
	[CreationDate] [datetime2](7) NOT NULL CONSTRAINT [DF_Entity_CreationDate]  DEFAULT (getdate()),
	[CreatedById] [bigint] NULL,
	[UriParent] [nvarchar](64) NULL,
	[isReadOnly] [bit] NULL,
	[CheckedOutPositionId] [bigint] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EntityRevisionType]    Script Date: 6/29/2017 3:54:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntityRevisionType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_EntityRevisionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/**                              **/
/** Add default revision types   **/
/** these should not be changed  **/
/**                              **/
INSERT INTO [dbo].[EntityRevisionType] (Name)
VALUES ('none'),('active'),('working'),('archive'),('unknown');
GO
/****** Object:  Table [dbo].[Property]    Script Date: 6/29/2017 3:54:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Property](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EntityId] [bigint] NOT NULL,
	[PropertyTypeId] [bigint] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[DateTimeValue] [datetime2](7) NULL,
	[NumberValue] [float] NULL,
	[IsWrittenOnce] [bit] NOT NULL CONSTRAINT [DF_Property_IsWrittenOnce]  DEFAULT ((0)),
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PropertyDataType]    Script Date: 6/29/2017 3:54:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyDataType](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PropertyDataType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/**                              **/
/** Add default data types       **/
/** these should not be changed  **/
/**                              **/
INSERT INTO [dbo].[PropertyDataType] (Value)
VALUES ('string'),('number'),('guid'),('boolean'),('stringArray'),('pickList'),('nameValuePair'),('dateTime'),('binary');
GO
/****** Object:  Table [dbo].[PropertyType]    Script Date: 6/29/2017 3:54:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyType](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DataType] [bigint] NOT NULL CONSTRAINT [DF_PropertyType_DataType]  DEFAULT ((1)),
	[Description] [nvarchar](1024) NULL,
	[IsUnique] [bit] NOT NULL CONSTRAINT [DF_PropertyType_IsUnique]  DEFAULT ((0)),
	[IsReadOnly] [bit] NOT NULL CONSTRAINT [DF_PropertyType_IsReadOnly]  DEFAULT ((0)),
	[IsWriteOnce] [bit] NOT NULL CONSTRAINT [DF_PropertyType_IsWriteOnce]  DEFAULT ((0)),
	[IsDeletable] [bit] NOT NULL CONSTRAINT [DF_PropertyType_Is Deletable]  DEFAULT ((1)),
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_PropertyType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_Entity] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Entity] ([Id])
GO
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_Entity]
GO
ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_EntityRevisionType] FOREIGN KEY([RevisionTypeId])
REFERENCES [dbo].[EntityRevisionType] ([Id])
GO
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_EntityRevisionType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_Project] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity] ([Id])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Project]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_PropertyType] FOREIGN KEY([PropertyTypeId])
REFERENCES [dbo].[PropertyType] ([Id])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_PropertyType]
GO
ALTER TABLE [dbo].[PropertyType]  WITH CHECK ADD  CONSTRAINT [FK_PropertyType_PropertyDataType] FOREIGN KEY([DataType])
REFERENCES [dbo].[PropertyDataType] ([Id])
GO
ALTER TABLE [dbo].[PropertyType] CHECK CONSTRAINT [FK_PropertyType_PropertyDataType]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates an entity can only contain one instance of this property' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyType', @level2type=N'COLUMN',@level2name=N'IsUnique'
GO

/**                                                   **/
/**  Create all default Property Types                **/
/**    Many of these are referenced by name           **/
/**    so name changes should NOT be made             **/
/**  If new types are added to the database,          **/
/**    they should also be added here                 **/
/**                                                   **/
SET IDENTITY_INSERT [dbo].[PropertyType] ON 

GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (1, N'Activity', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (2, N'Comment', 1, N'', 0, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (3, N'StationId', 2, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (4, N'StationPosition', 2, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (5, N'ResourceGroupId', 2, N'References a resource group that contains resources compatible with this parent.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (6, N'DutId', 2, N'The id of the dut this instance refers to.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (7, N'FilePath', 1, N'', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (8, N'OriginalDirectory', 1, N'', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (9, N'DestinationDirectory', 1, N'', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (10, N'FileGuid', 3, N'', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (11, N'UserGroupId', 2, N'User group entity id.', 1, 0, 0, 0, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (12, N'Tags', 5, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (13, N'NamingFormat', 1, N'An entity naming format string, e.g. MyEntity_{<id>}  Valid symbols include <id>, <date>, <parent>, <parentId>, <user>, <name>, <count>', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (14, N'NamingFormatTarget', 1, N'The type of child entity a naming format applies to, e.g. configuration', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (15, N'Parameter_DataType', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (16, N'Parameter_Value', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (17, N'Parameter_Unit', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (18, N'Parameter_Minimum', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (19, N'Parameter_Maximum', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (20, N'Parameter_Data', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (21, N'Parameter_DefaultValue', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (22, N'URI', 1, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (23, N'Method', 1, N'GET, PUT, POST, or DELETE', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (24, N'IsAllowed', 4, N'Indicates that the associated URI and Method are allowed within the parent group.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (25, N'ConfigurationId', 2, N'Entity Id of a configuration', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (26, N'TestRequestId', 2, N'Entity Id of the test request this run refers to.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (27, N'TestId', 2, N'Entity Id of the test this run refers to.', 1, 0, 0, 0, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (28, N'Index', 2, N'The index or order of this entity relative to applicable siblings.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (29, N'StationGuid', 3, N'', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (30, N'StationEvent', 6, N'Indicates an action or event that occurred on a station', 1, 0, 0, 1, N'[{''label'':''login'',''value'':0},{''label'':''logout'',''value'':1},{''label'':''pull test request'',''value'':2}]')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (31, N'TestStepId', 2, N'Entity Id of a test step entity', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (32, N'TestRunId', 2, N'Entity Id of a test run entity', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (33, N'ChildEntityCounters', 7, N'Counters for all child entities', 1, 1, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (34, N'CompletionDate', 8, N'Indicates when this item has completed all its tasks.', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (35, N'CompletedBy', 1, N'Indicates the user that marked this item complete.', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (36, N'UserId', 2, N'The id of a user in this group.', 0, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (37, N'Password', 1, N'A hashed password.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (38, N'ExpirationDate', 8, N'The date when this token becomes invalid.', 1, 0, 1, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (39, N'ElapsedTime', 2, N'The number of seconds this dut was testing for this run.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (40, N'ReadOnly', 4, NULL, 0, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (41, N'Iterations', 2, NULL, 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (42, N'Iteration', 2, NULL, 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (43, N'TestInstanceId', 2, N'Entity Id of a test instance', 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (44, N'StartedDate', 8, N'When this item was started', 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (45, N'StartedBy', 1, N'User that started this item', 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (46, N'ReleaseType', 1, N'Indicates that the release process must be completed serial or parallel', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (47, N'BinaryData', 9, N'Any data recorded with this comparison.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (48, N'BinaryDataType', 1, N'Describes the BinaryData data type, e.g. boolean, string. etc.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (49, N'Pass', 4, N'Indicates this comparison resulted in a passing result.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (50, N'ResultValue', 1, N'The string formatted result of this comparison.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (51, N'Valid', 4, N'Indicates this comparison was performed.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (52, N'ValidationRule', 1, N'Describes the comparison logic used determine Pass.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (53, N'ValidationRuleTemplate', 1, N'Describes the comparison logic used determine this result.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (54, N'State', 1, N'The state of this dut when it was marked completed, e.g. completed, aborted, or damaged.', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (55, N'StationState', 1, N'The current state of this test station active, maintenance, calibration,...', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (56, N'ReleaseState', 1, N'The state of an object that has a release process, e.g. created, inprocess, released', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (57, N'TestGroupId', 2, N'Entity id of a test group', 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (58, N'DutGroupId', 2, N'Entity id of a dut group', 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (59, N'Version', 1, N'Version requirements (active, fixed: 2, minimum: 2, etc.) typically for a referenced object', 1, 0, 0, 0, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (60, N'EntityType', 1, N'Entity type this object applies to', 1, 0, 0, 0, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (61, N'DutInstanceId', 2, N'Entity id of a dut instance within a test request', 1, 0, 0, 0, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (62, N'Type', 1, N'General property indicating the type of its parent', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (63, N'Channel', 1, N'General property indicating the name of a communication channel', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (64, N'Host', 1, N'General property typically used for an email server address', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (65, N'Port', 2, N'General property typically a communication port number', 1, 0, 0, 1, NULL)
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (66, N'Email', 1, N'A user or group email address', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (67, N'Token', 1, N'Some form of authorization token', 1, 0, 0, 1, N'')
GO
INSERT [dbo].[PropertyType] ([Id], [Name], [DataType], [Description], [IsUnique], [IsReadOnly], [IsWriteOnce], [IsDeletable], [Data]) VALUES (68, N'ConnectorId', 2, N'Entity id of a connector type object.', 1, 0, 0, 1, NULL)
GO

/** NOTE if adding new property types - also modify the Update TestTracker Property Types SQL file, so existing databases can be easily updated **/

SET IDENTITY_INSERT [dbo].[PropertyType] OFF
GO

/**                                                                          **/
/**   Create default Admin user, group and permissions                       **/
/**                                                                          **/

/* ENTITY 1  User Admin Parent*/
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'userAdmin', N'userAdmin', null, N'UserAdmin', N'main admin parent',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO

/* ENTITY 2 */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'userGroup', N'userGroups', 1, N'AdminGroup', N'main admin user group',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO

/* ENTITY 3 default user = 'admin' */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'user', N'users', 1, N'admin', N'main admin account',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO
/**     Create default password property for the admin user ('apassword'),  property id for a password MUST be 37 as created earlier                             **/
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (3, 37, N'$2a$10$mH66Og8j0wdZhJ4GCVBGK.zhhcdGpsmvIcxspWr7s1LEgY92VJNty', 0)
GO

/* ENTITY 4 */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'permission', N'permissions', 2, N'GET*', N'allow get all',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO
/**     Create properties for the permission                             **/
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (4, 22, N'/*', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (4, 23, N'GET', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (4, 24, N'true', 0)
GO

/* ENTITY 5 */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'permission', N'permissions', 2, N'PUT*', N'allow put all',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO
/**     Create properties for the permission                             **/
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (5, 22, N'/*', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (5, 23, N'PUT', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (5, 24, N'true', 0)
GO

/* ENTITY 6 */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'permission', N'permissions', 2, N'POST*', N'allow post all',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO
/**     Create properties for the permission                             **/
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (6, 22, N'/*', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (6, 23, N'POST', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (6, 24, N'true', 0)
GO

/* ENTITY 7 */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'permission', N'permissions', 2, N'DELETE*', N'allow delete all',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO
/**     Create properties for the permission                             **/
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (7, 22, N'/*', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (7, 23, N'DELETE', 0)
GO
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) VALUES (7, 24, N'true', 0)
GO

/* ENTITY 8 */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'userInstance', N'groupUsers', 2, N'user admin', N'',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO
/**     Create properties linking userInstance to admin user                             **/
INSERT [dbo].[Property] ([EntityId],[PropertyTypeId],[Value],[isWrittenOnce]) 
	VALUES (8, 36, N'3', 0)
GO

/* ENTITY 9 Resource Parent */
INSERT [dbo].Entity ([EntityType], [UriParent], [ParentId], [Name],[Description],IsDeletable, Revision, RevisionTypeId, IsVersionControlled, CreatedBy, CreationDate) 
	VALUES (N'resource', N'resources', null, N'Resource Parent', N'',0, 0, 1, 0, N'script' , CONVERT(VARCHAR(23), GETDATE(), 121))
GO

/* Create view of stored procedures so metrics can be used. */
CREATE VIEW View_StoredProcedures AS
SELECT        name, type
FROM            dbo.sysobjects
WHERE        (type IN ('P', 'FN', 'IF', 'TF', 'PC')) AND (LEFT(name, 3) NOT IN ('sp_', 'xp_', 'ms_', 'fn_'))
GO

-- Create a non-clustered index between property and property type - speeds up property reads quite a bit
-- Find an existing index and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_Property_PropertyType')   
    DROP INDEX IX_Property_PropertyType ON [dbo].[Property];   
GO    
CREATE NONCLUSTERED INDEX IX_Property_PropertyType   
    ON [dbo].[Property] ([PropertyTypeId]) INCLUDE ([Id],[EntityId],[Value],[IsWrittenOnce],[DateTimeValue],[NumberValue]);   
GO 

-- Create a non-clustered index between property and entityid - speeds up property/entity reads quite a bit
-- Find an existing index and delete it if found.  
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_Property_Entity')   
    DROP INDEX IX_Property_Entity ON [dbo].[Property];   
GO  
  
CREATE NONCLUSTERED INDEX IX_Property_Entity   
    ON [dbo].[Property] ([EntityId])   
GO 

-- Speeds up queries with revisions

CREATE NONCLUSTERED INDEX [PK_Project_and_Revisions]
ON [dbo].[Entity] ([ParentId],[UriParent])
INCLUDE ([Id],[Name],[Description],[Revision],[RevisionTypeId],[IsVersionControlled],[IsDeletable],[trackGetActivity],[trackPutActivity],[isCheckedOut],[CheckedOutStationId],[CheckedOutUserId],[EntityType],[CreatedBy],[CreationDate],[CreatedById],[isReadOnly],[CheckedOutPositionId])
GO

-- speeds up delete
CREATE NONCLUSTERED INDEX [IX_Entity_ParentId]
ON [dbo].[Entity] ([ParentId])
GO

-- speeds up user parse and a few others
CREATE NONCLUSTERED INDEX [IX_Entity_EntityType>]
ON [dbo].[Entity] ([Name],[EntityType])

GO