SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbFuncionalidade]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbFuncionalidade](
	[FUN_SEQUENCIAL] [int] NOT NULL,
	[FUN_DESCRICAO] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Funcionalidade] PRIMARY KEY CLUSTERED 
(
	[FUN_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbUsuario]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbUsuario](
	[USU_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[USU_NOME] [varchar](50) NOT NULL,
	[USU_SENHA] [varchar](50) NOT NULL,
	[USU_DATA_HORA] [datetime] NOT NULL,
	[USU_LOGIN] [varchar](20) NOT NULL,
	[USU_BLOQUEADO] [bit] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[USU_SEQUENCIAL] ASC
) ON [PRIMARY],
 CONSTRAINT [UQ__tbUsuario__7D78A4E7] UNIQUE NONCLUSTERED 
(
	[USU_LOGIN] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbCarretel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbCarretel](
	[CAR_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[CAR_NUM_LOTE] [varchar](30) NOT NULL,
	[CAR_COD_FORNECEDOR] [varchar](50) NOT NULL,
	[CAR_COMPRIMENTO] [decimal](18, 2) NOT NULL,
	[CAR_LOCAL] [varchar](20) NOT NULL,
	[MAT_CODIGO] [varchar](10) NOT NULL,
 CONSTRAINT [PK_tbCarretel] PRIMARY KEY CLUSTERED 
(
	[CAR_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbRecebimento]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbRecebimento](
	[REC_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[ERP_CODIGO_RECEBIMENTO] [int] NOT NULL,
	[ERP_NUM_NOTA] [int] NOT NULL,
 CONSTRAINT [PK_tbRecebimento] PRIMARY KEY CLUSTERED 
(
	[REC_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbNumeroCarretel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbNumeroCarretel](
	[NUC_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[NUC_ANO] [int] NOT NULL,
 CONSTRAINT [PK_tbNumeroCarretel] PRIMARY KEY CLUSTERED 
(
	[NUC_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbConfiguracaoMP]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbConfiguracaoMP](
	[CMP_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[MAT_CODIGO] [varchar](50) NOT NULL,
	[CMP_COMP_MINIMO] [decimal](18, 1) NOT NULL,
 CONSTRAINT [PK_tbConfiguracaoMP] PRIMARY KEY CLUSTERED 
(
	[CMP_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbFuncionalidadeUsuario]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbFuncionalidadeUsuario](
	[UFU_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[USU_SEQUENCIAL] [int] NOT NULL,
	[FUN_SEQUENCIAL] [int] NOT NULL,
 CONSTRAINT [PK_tbFuncionalidadeUsuario] PRIMARY KEY CLUSTERED 
(
	[UFU_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbDevCarretel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbDevCarretel](
	[DEC_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[DEC_COMPRIMENTO_DEV] [decimal](18, 1) NOT NULL,
	[DEC_CONSOLIDADO] [bit] NULL,
	[DEC_DATA] [datetime] NULL,
	[USU_SEQUENCIAL] [int] NULL,
	[DEV_SEQUENCIAL] [int] NOT NULL,
	[RCA_SEQUENCIAL] [int] NOT NULL,
 CONSTRAINT [PK_tbDevCarretel] PRIMARY KEY CLUSTERED 
(
	[DEC_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbReqCarretel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbReqCarretel](
	[RCA_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[RCA_ENTREGUE] [bit] NOT NULL,
	[RCA_DATA] [datetime] NULL,
	[USU_SEQUENCIAL] [int] NULL,
	[CAR_SEQUENCIAL] [int] NOT NULL,
	[RCA_COMPRIMENTO] [decimal](18, 1) NOT NULL,
	[REQ_SEQUENCIAL] [int] NOT NULL,
	[RCA_APROVADO] [bit] NULL,
 CONSTRAINT [PK_tbReqCarretel] PRIMARY KEY CLUSTERED 
(
	[RCA_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbItemRecebimento]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbItemRecebimento](
	[IRC_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[IRC_COMPRIMENTO] [decimal](18, 1) NOT NULL,
	[IRC_APROVADO] [bit] NULL,
	[IRC_DATA_APROVACAO] [datetime] NULL,
	[CAR_SEQUENCIAL] [int] NOT NULL,
	[REC_SEQUENCIAL] [int] NOT NULL,
	[USU_SEQUENCIAL] [int] NULL,
 CONSTRAINT [PK_tbItemRecebimento] PRIMARY KEY CLUSTERED 
(
	[IRC_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbDevolucao]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbDevolucao](
	[DEV_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[DEV_DATA] [datetime] NOT NULL,
	[DEV_CENTRO_CUSTO] [varchar](30) NOT NULL,
	[USU_SEQUENCIAL] [int] NOT NULL,
 CONSTRAINT [PK_tbDevolucao] PRIMARY KEY CLUSTERED 
(
	[DEV_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tbRequisicao]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tbRequisicao](
	[REQ_SEQUENCIAL] [int] IDENTITY(1,1) NOT NULL,
	[REQ_OP] [int] NULL,
	[REQ_CENTRO_CUSTO] [varchar](20) NOT NULL,
	[REQ_DATA] [datetime] NOT NULL,
	[USU_SEQUENCIAL] [int] NOT NULL,
 CONSTRAINT [PK_tbRequisicao] PRIMARY KEY CLUSTERED 
(
	[REQ_SEQUENCIAL] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[vwItemRecebimento]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vwItemRecebimento]
AS
SELECT     dbo.tbItemRecebimento.IRC_SEQUENCIAL, dbo.tbItemRecebimento.IRC_COMPRIMENTO, dbo.tbItemRecebimento.IRC_APROVADO, 
                      dbo.tbItemRecebimento.IRC_DATA_APROVACAO, dbo.tbItemRecebimento.CAR_SEQUENCIAL, dbo.tbItemRecebimento.REC_SEQUENCIAL, 
                      dbo.tbItemRecebimento.USU_SEQUENCIAL, dbo.tbCarretel.CAR_NUM_LOTE, dbo.tbCarretel.CAR_COD_FORNECEDOR, 
                      dbo.tbCarretel.CAR_COMPRIMENTO, dbo.tbCarretel.CAR_LOCAL, dbo.tbCarretel.MAT_CODIGO, dbo.tbUsuario.USU_LOGIN
FROM         dbo.tbCarretel INNER JOIN
                      dbo.tbItemRecebimento ON dbo.tbCarretel.CAR_SEQUENCIAL = dbo.tbItemRecebimento.CAR_SEQUENCIAL LEFT OUTER JOIN
                      dbo.tbUsuario ON dbo.tbItemRecebimento.USU_SEQUENCIAL = dbo.tbUsuario.USU_SEQUENCIAL

' 
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'USER',N'dbo', N'VIEW',N'vwItemRecebimento', NULL,NULL))
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
         Begin Table = "tbCarretel"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 214
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "tbItemRecebimento"
            Begin Extent = 
               Top = 6
               Left = 281
               Bottom = 220
               Right = 482
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbUsuario"
            Begin Extent = 
               Top = 6
               Left = 520
               Bottom = 121
               Right = 690
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
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
' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwItemRecebimento'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'USER',N'dbo', N'VIEW',N'vwItemRecebimento', NULL,NULL))
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwItemRecebimento'
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbFuncionalidadeUsuario_tbFuncionalidade]') AND type = 'F')
ALTER TABLE [dbo].[tbFuncionalidadeUsuario]  WITH CHECK ADD  CONSTRAINT [FK_tbFuncionalidadeUsuario_tbFuncionalidade] FOREIGN KEY([FUN_SEQUENCIAL])
REFERENCES [dbo].[tbFuncionalidade] ([FUN_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbFuncionalidadeUsuario] CHECK CONSTRAINT [FK_tbFuncionalidadeUsuario_tbFuncionalidade]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbFuncionalidadeUsuario_tbUsuario]') AND type = 'F')
ALTER TABLE [dbo].[tbFuncionalidadeUsuario]  WITH NOCHECK ADD  CONSTRAINT [FK_tbFuncionalidadeUsuario_tbUsuario] FOREIGN KEY([USU_SEQUENCIAL])
REFERENCES [dbo].[tbUsuario] ([USU_SEQUENCIAL])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tbFuncionalidadeUsuario] CHECK CONSTRAINT [FK_tbFuncionalidadeUsuario_tbUsuario]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbDevCarretel_tbDevolucao]') AND type = 'F')
ALTER TABLE [dbo].[tbDevCarretel]  WITH CHECK ADD  CONSTRAINT [FK_tbDevCarretel_tbDevolucao] FOREIGN KEY([DEV_SEQUENCIAL])
REFERENCES [dbo].[tbDevolucao] ([DEV_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbDevCarretel] CHECK CONSTRAINT [FK_tbDevCarretel_tbDevolucao]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbDevCarretel_tbReqCarretel]') AND type = 'F')
ALTER TABLE [dbo].[tbDevCarretel]  WITH CHECK ADD  CONSTRAINT [FK_tbDevCarretel_tbReqCarretel] FOREIGN KEY([RCA_SEQUENCIAL])
REFERENCES [dbo].[tbReqCarretel] ([RCA_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbDevCarretel] CHECK CONSTRAINT [FK_tbDevCarretel_tbReqCarretel]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbDevCarretel_tbUsuario]') AND type = 'F')
ALTER TABLE [dbo].[tbDevCarretel]  WITH NOCHECK ADD  CONSTRAINT [FK_tbDevCarretel_tbUsuario] FOREIGN KEY([USU_SEQUENCIAL])
REFERENCES [dbo].[tbUsuario] ([USU_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbDevCarretel] CHECK CONSTRAINT [FK_tbDevCarretel_tbUsuario]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbReqCarretel_tbCarretel]') AND type = 'F')
ALTER TABLE [dbo].[tbReqCarretel]  WITH CHECK ADD  CONSTRAINT [FK_tbReqCarretel_tbCarretel] FOREIGN KEY([CAR_SEQUENCIAL])
REFERENCES [dbo].[tbCarretel] ([CAR_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbReqCarretel] CHECK CONSTRAINT [FK_tbReqCarretel_tbCarretel]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbReqCarretel_tbRequisicao]') AND type = 'F')
ALTER TABLE [dbo].[tbReqCarretel]  WITH CHECK ADD  CONSTRAINT [FK_tbReqCarretel_tbRequisicao] FOREIGN KEY([REQ_SEQUENCIAL])
REFERENCES [dbo].[tbRequisicao] ([REQ_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbReqCarretel] CHECK CONSTRAINT [FK_tbReqCarretel_tbRequisicao]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbReqCarretel_tbUsuario]') AND type = 'F')
ALTER TABLE [dbo].[tbReqCarretel]  WITH NOCHECK ADD  CONSTRAINT [FK_tbReqCarretel_tbUsuario] FOREIGN KEY([USU_SEQUENCIAL])
REFERENCES [dbo].[tbUsuario] ([USU_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbReqCarretel] CHECK CONSTRAINT [FK_tbReqCarretel_tbUsuario]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbItemRecebimento_tbItemRecebimento]') AND type = 'F')
ALTER TABLE [dbo].[tbItemRecebimento]  WITH CHECK ADD  CONSTRAINT [FK_tbItemRecebimento_tbItemRecebimento] FOREIGN KEY([CAR_SEQUENCIAL])
REFERENCES [dbo].[tbCarretel] ([CAR_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbItemRecebimento] CHECK CONSTRAINT [FK_tbItemRecebimento_tbItemRecebimento]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbItemRecebimento_tbRecebimento]') AND type = 'F')
ALTER TABLE [dbo].[tbItemRecebimento]  WITH CHECK ADD  CONSTRAINT [FK_tbItemRecebimento_tbRecebimento] FOREIGN KEY([REC_SEQUENCIAL])
REFERENCES [dbo].[tbRecebimento] ([REC_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbItemRecebimento] CHECK CONSTRAINT [FK_tbItemRecebimento_tbRecebimento]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbItemRecebimento_tbUsuario]') AND type = 'F')
ALTER TABLE [dbo].[tbItemRecebimento]  WITH NOCHECK ADD  CONSTRAINT [FK_tbItemRecebimento_tbUsuario] FOREIGN KEY([USU_SEQUENCIAL])
REFERENCES [dbo].[tbUsuario] ([USU_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbItemRecebimento] CHECK CONSTRAINT [FK_tbItemRecebimento_tbUsuario]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbDevolucao_tbUsuario]') AND type = 'F')
ALTER TABLE [dbo].[tbDevolucao]  WITH NOCHECK ADD  CONSTRAINT [FK_tbDevolucao_tbUsuario] FOREIGN KEY([USU_SEQUENCIAL])
REFERENCES [dbo].[tbUsuario] ([USU_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbDevolucao] CHECK CONSTRAINT [FK_tbDevolucao_tbUsuario]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_tbRequisicao_tbUsuario]') AND type = 'F')
ALTER TABLE [dbo].[tbRequisicao]  WITH NOCHECK ADD  CONSTRAINT [FK_tbRequisicao_tbUsuario] FOREIGN KEY([USU_SEQUENCIAL])
REFERENCES [dbo].[tbUsuario] ([USU_SEQUENCIAL])
GO
ALTER TABLE [dbo].[tbRequisicao] CHECK CONSTRAINT [FK_tbRequisicao_tbUsuario]
