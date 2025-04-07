USE [master]
GO

/****** Object:  StoredProcedure [dbo].[Shortcuts]    Script Date: 15/06/2018 10:48:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**************************************************************  
Productivity Keyboard Shortcuts 2

By Emil Bialobrzeski, 2015/07/13

1. Go to Tools >> Options
2. Environment // Keyboard
3.
For CTRL+3 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 3, @DB,
For CTRL+4 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 4, @DB,
For CTRL+5 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 5, @DB,
For CTRL+6 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 6, @DB,
For CTRL+7 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 7, @DB,
For CTRL+8 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 8, @DB,
For CTRL+9 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 9, @DB,
For CTRL+0 enter DECLARE @DB NVARCHAR(500) SET @DB = DB_NAME() EXEC master.dbo.Shortcuts 0, @DB,
4. Run script
5. Restart SSMS

Object types:
U - user table
SP - stored procedure
FN - function
TR - trigger
VW - view

Description:
CTRL+3: selects TOP 1000 rows from a selected table or view (highlight table name in text editor and hit shortcut). If you pass a second parameter that is a column name in the given table it will sort the results by that column ascendible, if you add # to the second parameter it will sort descendible ex: Table,Column2#. If there is a column with name ID and you pass a value it will return rows with passed ID ex: Table, 3

CTRL+4: executes sp_help if the object is a user table or if it's a SP,FN,TR,VW executes sp_helptext

CTRL+5: search for a database object with selected name in it (# char works like % wildcard) ex: ab#xyz will find you all objects that name LIKE '%ab%xyz%'. Additionally you can provide a second parameter to choose what object type to look for ex: ab#xyz, u

CTRL+6: Is using a procedure written by Adam Machanic sp_WhoIsActive it’s a great replacement for sp_who and with much more details. Use S as parameter and hit CTRL+6 to execute with default values, P to include execution plans and D to get much more details.

CTRL+7: NOT IMPLEMENTED

CTRL+8: search for table/view or stored procedure with selected column/parameter name in it ex: ColName# will look for tables/views/SPs with column/parameter name LIKE ‘ColName%’. Additionally you can provide a second parameter to choose what object type to look for ex: ColName#, u

CTRL+9: listing columns/parameters from selected table, view or stored proc ex: Table1# will return a list of columns for table/view/SP with name LIKE 'Table1%'. Additionally you can provide a second parameter to choose what object type to look for ex: Table1#, u

CTRL+0: looks for an object that contains selected phrase in the objects script (# char works like % wildcard) ex: Insert#into#Table1 will give you objects with that string in the object script
**************************************************************/ 
ALTER PROCEDURE [dbo].[Shortcuts](@Action INT, @DBName NVARCHAR(1000), @Object NVARCHAR(1000), @AddParam NVARCHAR(1000) = NULL)        
AS        
BEGIN              
  
  DECLARE @SQL nvarchar (4000)        
  DECLARE @_Object_ nvarchar(1000)       
  DECLARE @_Schema_ nvarchar(500)  
          
  SET @Object = REPLACE (@Object, '#','%')     
  SET @AddParam = REPLACE (@AddParam, '#','%')        
  SET @SQL = ''        
  SET @_Object_ = REPLACE(REPLACE(@Object, '[', ''), ']', '')  
  SET @DBName = QUOTENAME(@DBName)
  
  IF CHARINDEX( '.', @_Object_) > 0  
  BEGIN  
    SET @_Schema_ = SUBSTRING(@_Object_, 1, CHARINDEX( '.', @_Object_)-1)  
    SET @_Object_ = SUBSTRING(@_Object_, CHARINDEX( '.', @_Object_)+1, LEN(@_Object_)-CHARINDEX( '.', @_Object_))
  END  
  ELSE  
  BEGIN  
    SET @_Schema_ = 'dbo'  
  END  
  
----------------------        
  IF @Action = 3        
  BEGIN        
  
    IF @AddParam IS NOT NULL  
    BEGIN  
      SET @SQL = N'IF EXISTS (SELECT 1 FROM '+@DBName+'.dbo.syscolumns c INNER JOIN '+@DBName+'.dbo.sysobjects o ON o.ID = c.ID WHERE o.name = '''+@_Object_+''' AND c.Name = '''+REPLACE(@AddParam,'%', '')+''')  
                    EXEC sp_executesql N''SELECT TOP 1000 * FROM '+@DBName+'.'+QUOTENAME(@_Schema_)+'.' + QUOTENAME(@_Object_) + ' ORDER BY ' +REPLACE(@AddParam,'%', '') + CASE WHEN CHARINDEX('%', @AddParam) > 0 THEN ' DESC ' ELSE ' ASC ' END + '''  
        ELSE  
                  BEGIN  
                    DECLARE @ColName NVARCHAR(50) SET @ColName = (SELECT c.name FROM '+@DBName+'.dbo.syscolumns c INNER JOIN '+@DBName+'.dbo.sysobjects o ON o.ID = c.ID WHERE o.name = '''+@_Object_+''' AND c.colorder = 1)  
                    DECLARE @SQL NVARCHAR(2000) SET @SQL = ''SELECT TOP 1000 * FROM '+@DBName+'.'+QUOTENAME(@_Schema_)+'.' + QUOTENAME(@_Object_) + ' WHERE ''+@ColName+'' = ''''' + @AddParam  +'''''''  
                    EXEC sp_executesql @SQL  
                  END'  
    END  
    ELSE  
    BEGIN  
      SET @SQL = N'IF EXISTS(SELECT * FROM '+@DBName+'.dbo.syscolumns c INNER JOIN '+@DBName+'.dbo.sysobjects o ON o.ID = c.ID WHERE o.name = '''+@_Object_+''' AND c.Name = ''ID'')  
                   EXEC sp_executesql N''SELECT TOP 1000 * FROM '+@DBName+'.'+QUOTENAME(@_Schema_)+'.' + QUOTENAME(@_Object_) + ' ORDER BY ID DESC''  
                  ELSE   
                    EXEC sp_executesql N''SELECT TOP 1000 * FROM '+@DBName+'.'+QUOTENAME(@_Schema_)+'.' + QUOTENAME(@_Object_)+'  ORDER BY 1 DESC'''  
    END  
      
  END        
          
  ELSE        
--------------        
  IF @Action = 4        
  BEGIN        
  SET @SQL = '  
    IF EXISTS(SELECT 1 FROM '+ @DBName +'.sys.objects WHERE name = '''+@_Object_+''' AND type = ''U'')  
      EXEC '+ @DBName +'..sp_Help '''+QUOTENAME(@_Schema_)+'.'+QUOTENAME(@_Object_)+'''       
    ELSE    
      EXEC '+ @DBName +'..sp_HelpText '''+QUOTENAME(@_Schema_)+'.'+QUOTENAME(@_Object_)+''''      
  END        
  ELSE       
--------------        
  IF @Action = 5        
  BEGIN        
    SET @SQL = 'SELECT o.Name, o.Type, s.name Schema_Name, o.object_id, o.create_date, o.parent_object_id , ISNULL(po.name,'''') Parent_Name, ISNULL(po.Type,'''') AS Parent_Type '        
              +'FROM '+ @DBName +'.sys.objects o '        
              +'JOIN '+ @DBName +'.sys.schemas s ON s.schema_id = o.schema_id '    
              +'LEFT JOIN '+ @DBName +'.sys.objects po ON po.object_id = o.parent_object_id '     
              +'WHERE o.Name LIKE '         
              + '''%''+'''+@_Object_+'''+''%'''  
              +ISNULL(' AND o.Type = '''+@AddParam+'''' ,'')        
              +' ORDER BY o.Name'          
  END        
  ELSE    
  
  IF @Action = 6        
  BEGIN        
	IF @Object = 'S'
    SET @SQL = 'EXEC '+ @DBName +'.dbo.sp_WhoIsActive @find_block_leaders = 1'    
    
    IF @Object = 'P'   
    SET @SQL = 'EXEC '+ @DBName +'.dbo.sp_WhoIsActive @get_plans = 1, @find_block_leaders = 1, '
              +'@get_outer_command = 1, @get_transaction_info = 1, @get_additional_info = 1'
    
    IF @Object = 'D'   
    SET @SQL = 'EXEC '+ @DBName +'.dbo.sp_WhoIsActive @get_plans = 1, @show_system_spids = 1, @show_own_spid = 1, '
              +'@get_outer_command = 1, @get_transaction_info = 1, @find_block_leaders = 1, @get_additional_info = 1'
  END        
  ELSE     
--------------        
         
  IF @Action = 8        
  BEGIN        
    SET @SQL = 'SELECT o.Name ObjectName, o.Type ObjectType, c.ColOrder , c.name ColName, '      
              +'  CASE       
                    WHEN t.Name like ''n%char%'' THEN t.name + '' (''+LTRIM(STR(c.Length/2,5))+'')''       
                    WHEN t.Name like ''%char%'' THEN t.name + '' (''+LTRIM(STR(c.Length,5))+'')''       
                    ELSE t.name       
                  END AS Type '        
              +'FROM '+ @DBName +'.dbo.syscolumns c '        
              +'INNER JOIN '+ @DBName +'.dbo.sysobjects o ON o.ID = c.ID '        
              +'INNER JOIN '+ @DBName +'.dbo.systypes t ON t.xUserType = c.xUserType '        
              +'WHERE c.name LIKE ''%''+'''+@_Object_+'''+''%'''        
              +ISNULL(' AND o.Type = '''+@AddParam+'''' ,'')        
              +' ORDER BY o.Name, c.Number, c.ColOrder '      
  END        
  ELSE        
--------------        
  IF @Action = 9        
  BEGIN        
    SET @SQL = 'SELECT o.Name ObjectName, o.Type ObjectType,  c.ColOrder ColOrder, c.name ColName, '      
         +' REPLACE(''@''+c.name, ''@@'', ''@'')+'' ''+CASE       
                    WHEN t.Name like ''n%char%'' THEN t.name + '' (''+LTRIM(ISNULL(STR(NULLIF(c.Length,-1)/2,5), ''MAX''))+'')''       
                    WHEN t.Name like ''%char%'' THEN t.name + '' (''+LTRIM(ISNULL(STR(NULLIF(c.Length,-1),5), ''MAX''))+'')''       
                    ELSE t.name       
                  END +'','' AS Variables '      
              +'FROM '+ @DBName +'.dbo.syscolumns c  '        
              +'INNER JOIN '+ @DBName +'.dbo.sysobjects o ON o.ID = c.ID  '        
              +'INNER JOIN '+ @DBName +'.dbo.systypes t ON t.xUserType = c.xUserType '        
              +'WHERE o.name LIKE '''+@_Object_+''''        
              +ISNULL(' AND o.Type = '''+@AddParam+'''' ,'')        
              +' ORDER BY o.Name, c.Number, c.ColOrder '  
    print @sql                
  END        
  ELSE        
        
--------------        
  IF @Action = 0        
  BEGIN        
    SET @SQL = 'SELECT DISTINCT o.Name, o.Type, o.Id   
                FROM '+ @DBName +'.dbo.syscomments t   
                INNER JOIN '+ @DBName +'.dbo.sysobjects o ON o.ID = t.ID '        
              +'WHERE t.TEXT LIKE ''%'+@Object+'%'''  
  
  END        
        
------------------------------------------------------------------------------------        
  --PRINT @SQL        
  EXEC sp_executesql @SQL      
      
END 
GO


