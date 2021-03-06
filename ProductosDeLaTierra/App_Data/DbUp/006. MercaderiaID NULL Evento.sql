/*
   jueves, 22 de septiembre de 20162:39:22 a. m.
   User: 
   Server: HP\SQLEXPRESS
   Database: ProductosDeLaTierra
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Evento
	DROP CONSTRAINT FKEvento_Mercaderia
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Evento
	DROP CONSTRAINT FKEvento_Cargamento
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Evento
	(
	EventoID int NOT NULL IDENTITY (1, 1),
	TipoEventoID int NOT NULL,
	Fecha datetime NOT NULL,
	CargamentoID int NULL,
	MercaderiaID int NULL,
	Ganancia decimal(10, 2) NOT NULL,
	Notas text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_Evento ON
GO
IF EXISTS(SELECT * FROM dbo.Evento)
	 EXEC('INSERT INTO dbo.Tmp_Evento (EventoID, TipoEventoID, Fecha, CargamentoID, MercaderiaID, Ganancia, Notas)
		SELECT EventoID, TipoEventoID, Fecha, CargamentoID, MercaderiaID, Ganancia, Notas FROM dbo.Evento WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Evento OFF
GO
ALTER TABLE dbo.ItemCobranza
	DROP CONSTRAINT FKItemCobranza_Evento
GO
DROP TABLE dbo.Evento
GO
EXECUTE sp_rename N'dbo.Tmp_Evento', N'Evento', 'OBJECT' 
GO
ALTER TABLE dbo.Evento ADD CONSTRAINT
	PKEvento PRIMARY KEY CLUSTERED 
	(
	EventoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX Evento_general ON dbo.Evento
	(
	EventoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX Evento_general2 ON dbo.Evento
	(
	Fecha,
	TipoEventoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX Evento_general3 ON dbo.Evento
	(
	Fecha,
	CargamentoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX Evento_Cargamento ON dbo.Evento
	(
	CargamentoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Evento ADD CONSTRAINT
	FKEvento_Cargamento FOREIGN KEY
	(
	CargamentoID
	) REFERENCES dbo.Cargamento
	(
	CargamentoID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Evento ADD CONSTRAINT
	FKEvento_Mercaderia FOREIGN KEY
	(
	MercaderiaID
	) REFERENCES dbo.Mercaderia
	(
	MercaderiaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ItemCobranza ADD CONSTRAINT
	FKItemCobranza_Evento FOREIGN KEY
	(
	EventoID
	) REFERENCES dbo.Evento
	(
	EventoID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
