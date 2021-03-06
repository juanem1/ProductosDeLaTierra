USE [ProductosDeLaTierra]
GO
/****** Object:  Table [dbo].[AyudaItem]    Script Date: 02/24/2016 13:19:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

--drop table AyudaItem
--go

CREATE TABLE [dbo].[AyudaItem](
	[AyudaItemID] [int] IDENTITY(1,1) NOT NULL,
	[AyudaID] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[US_ID] [int] NOT NULL,
	[Mensaje] [text] NULL,
	[Archivo] [varchar](255) NULL,
	[ArchivoNombre] [varchar](255) NULL,
 CONSTRAINT [PKAyudaItem] PRIMARY KEY CLUSTERED 
(
	[AyudaItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AyudaItem]  WITH CHECK ADD  CONSTRAINT [FKAyudaItem_Ayuda] FOREIGN KEY([AyudaID])
REFERENCES [dbo].[Ayuda] ([AyudaID])
GO
ALTER TABLE [dbo].[AyudaItem] CHECK CONSTRAINT [FKAyudaItem_Ayuda]
GO
ALTER TABLE [dbo].[AyudaItem]  WITH CHECK ADD  CONSTRAINT [FKAyudaItem_Usuario] FOREIGN KEY([US_ID])
REFERENCES [dbo].[usuario] ([UsuarioID])
GO
ALTER TABLE [dbo].[AyudaItem] CHECK CONSTRAINT [FKAyudaItem_Usuario]