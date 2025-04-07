object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 182
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 56
    Top = 112
    Width = 110
    Height = 13
    Caption = 'Time with Parameters: '
  end
  object lbl2: TLabel
    Left = 56
    Top = 131
    Width = 126
    Height = 13
    Caption = 'Time without Parameters: '
  end
  object btn1: TButton
    Left = 56
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Open Queries'
    TabOrder = 0
    OnClick = btn1Click
  end
  object DatabaseSistemaDBX: TSQLConnection
    ConnectionName = 'Devart SQL Server'
    DriverName = 'DevartSQLServer'
    GetDriverFunc = 'getSQLDriverSQLServer'
    LibraryName = 'dbexpsda40.dll'
    LoginPrompt = False
    Params.Strings = (
      'SchemaOverride=%.dbo'
      'DriverUnit=DBXDevartSQLServer'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver160.' +
        'bpl'
      
        'DriverAssemblyLoader=Devart.DbxSda.DriverLoader.TCRDynalinkDrive' +
        'rLoader,Devart.DbxSda.DriverLoader,Version=16.0.0.1,Culture=neut' +
        'ral,PublicKeyToken=09af7300eec23701'
      
        'MetaDataAssemblyLoader=Devart.DbxSda.DriverLoader.TDBXDevartMSSQ' +
        'LMetaDataCommandFactory,Devart.DbxSda.DriverLoader,Version=16.0.' +
        '0.1,Culture=neutral,PublicKeyToken=09af7300eec23701'
      
        'MetaDataPackageLoader=TDBXDevartMSSQLMetaDataCommandFactory,DbxD' +
        'evartSQLServerDriver160.bpl'
      'ProductName=DevartSQLServer'
      'GetDriverFunc=getSQLDriverSQLServer'
      'LibraryName=dbexpsda40.dll'
      'VendorLib=sqloledb.dll'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'MaxBlobSize=-1'
      'UseUnicode=True'
      'BlobSize=-1'
      'HostName=SQLSERVER2008R2'
      'Database=SampleSQLQuery'
      'DriverName=DevartSQLServer'
      'User_Name=SISCOMP'
      'Password=SISCOMP'
      'LongStrings=True'
      'EnableBCD=True'
      'FetchAll=True'
      
        'ConnectionString=SchemaOverride=%.dbo,DriverUnit=DBXDevartSQLSer' +
        'ver,DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver' +
        '160.bpl,DriverAssemblyLoader=Devart.DbxSda.DriverLoader.TCRDynal' +
        'inkDriverLoader,Devart.DbxSda.DriverLoader,Version=16.0.0.1,Cult' +
        'ure=neutral,PublicKeyToken=09af7300eec23701,MetaDataAssemblyLoad' +
        'er=Devart.DbxSda.DriverLoader.TDBXDevartMSSQLMetaDataCommandFact' +
        'ory,Devart.DbxSda.DriverLoader,Version=16.0.0.1,Culture=neutral,' +
        'PublicKeyToken=09af7300eec23701,MetaDataPackageLoader=TDBXDevart' +
        'MSSQLMetaDataCommandFactory,DbxDevartSQLServerDriver160.bpl,Prod' +
        'uctName=DevartSQLServer,GetDriverFunc=getSQLDriverSQLServer,Libr' +
        'aryName=dbexpsda40.dll,VendorLib=sqloledb.dll,LocaleCode=0000,Is' +
        'olationLevel=ReadCommitted,MaxBlobSize=-1,UseUnicode=True,BlobSi' +
        'ze=-1,HostName=SQLSERVER2008R2,Database=BDFLEXNYL,DriverName=Dev' +
        'artSQLServer,User_Name=SISCOMP,Password=SISCOMP,LongStrings=True' +
        ',EnableBCD=True,FetchAll=True'
      'TrimChar=False')
    VendorLib = 'sqloledb.dll'
    Left = 56
    Top = 10
  end
  object sqlSemMovto: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DatabaseSistemaDBX
    Left = 182
    Top = 17
  end
end
