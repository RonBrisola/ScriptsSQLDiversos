USE [master]
GO

/****** Object:  StoredProcedure [dbo].[sp_VerificaIndices]    Script Date: 15/06/2018 10:20:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE [dbo].[sp_VerificaIndices]( @dB NVARCHAR(1000), @Object NVARCHAR(1000) )
AS 
BEGIN
   DECLARE @tabela varchar(50),
           @likeTabela varchar(50), 
          --@dB     VARCHAR(100) ,
           @insSQL NVARCHAR(4000) ,
           @dbID   VARCHAR(6)

   --SELECT @dB = DB_NAME()
   SET @dbID = RTRIM(LTRIM(CAST(DB_ID ( @dB )  AS VARCHAR)))  

   SET @tabela     = ''''+ @Object + ''''  -- <=== Informe aqui a tabela que deseja verificar
   SET @likeTabela = ''''+'%' + @Object +'%'+ ''''  

   SET NOCOUNT ON

   SET @insSQL = '
   ;WITH cteIDX as
   (
   SELECT RTRIM(LTRIM(cast(i.name as char(50)))) as Nome_Indice,
          RTRIM(LTRIM(STUFF((SELECT '', '' + c.Name FROM ' + @dB + '.SYS.INDEX_COLUMNS x, ' + @dB + '.SYS.COLUMNS c
                             WHERE x.object_id = i.object_id 
                               AND x.index_id  = i.index_id
                               AND c.object_id = x.object_id
                               AND c.column_id = x.column_id 
                             ORDER BY x.index_column_id  for xml path('''')) ,1,1,''''))) as Campos_Indice,
          RTRIM(LTRIM(cast(t.name as char(15)))) as Tabela
   FROM       ' + @dB + '.SYS.INDEXES AS i 
   INNER JOIN ' + @dB + '.SYS.TABLES  AS t
           ON i.object_id = t.object_id
   WHERE t.name = ' + @tabela + '
   ) SELECT *, 
            ''DROP INDEX ''   + Tabela + ''.'' + Nome_Indice  AS sqlDROP,
            ''CREATE INDEX '' + Nome_Indice + '' ON '' + Tabela + '' (''+ Campos_Indice + '')'' AS sqlCREATE
     FROM cteIDX
     ORDER BY Tabela,
              Nome_Indice

   USE '+ @dB +'
   SELECT Cast(fk.name as VarChar(40))                                                      AS ForeignKey,
          Cast(OBJECT_NAME (fk.referenced_object_id) as VarChar(40))                        AS TabelaReferenciada,
          Cast(COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) as VarChar(40)) AS CampoReferenciado,
          Cast(OBJECT_NAME(fk.parent_object_id) as VarChar(40))                             AS Tabela,
          Cast(COL_NAME(fkc.parent_object_id, fkc.parent_column_id) as VarChar(40))         AS CampoChave
   FROM       sys.foreign_keys AS fk
   INNER JOIN sys.foreign_key_columns AS fkc
           ON fk.OBJECT_ID = fkc.constraint_object_id
   WHERE OBJECT_NAME(fk.parent_object_id)  = ' + @tabela + '
   ORDER BY Tabela
  
    SELECT CAST(c.name AS VARCHAR(30)) ColName,  
           Cast((CASE       
                  WHEN t.Name like ''n%char%'' THEN t.name + '' (''+LTRIM(ISNULL(STR(NULLIF(c.Length,-1)/2,5), ''MAX''))+'')''       
                  WHEN t.Name like ''%char%'' THEN t.name + '' (''+LTRIM(ISNULL(STR(NULLIF(c.Length,-1),5), ''MAX''))+'')''       
                  ELSE t.name       
                 END) AS VARCHAR(20))  AS Type, 
           c.ColOrder ColOrder, 
           Cast((REPLACE(''@''+c.name, ''@@'', ''@'')+'' ''+CASE       
                        WHEN t.Name like ''n%char%'' THEN t.name + '' (''+LTRIM(ISNULL(STR(NULLIF(c.Length,-1)/2,5), ''MAX''))+'')''       
                        WHEN t.Name like ''%char%'' THEN t.name + '' (''+LTRIM(ISNULL(STR(NULLIF(c.Length,-1),5), ''MAX''))+'')''       
                        ELSE t.name       
                      END +'','') AS VARCHAR(60)) AS Variables ,
           CAST(O.name AS VARCHAR(40)) ObjectName,
           o.Type ObjectType
    FROM ' + @dB + '.dbo.syscolumns c  
    INNER JOIN ' + @dB + '.dbo.sysobjects o 
            ON o.ID = c.ID  
    INNER JOIN ' + @dB + '.dbo.systypes t 
            ON t.xUserType = c.xUserType 
    WHERE o.name = ' + @tabela + '
    ORDER BY o.Name, c.Number, c.ColOrder 

    SELECT DISTINCT o.Type, o.Name 
    FROM syscomments t   
    INNER JOIN sysobjects o ON o.ID = t.ID         
    WHERE t.TEXT LIKE ' + @likeTabela + '


   '
   --PRINT @insSQL
   EXEC sp_executesql @insSQL

END
GO


