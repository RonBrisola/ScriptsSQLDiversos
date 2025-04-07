unit uSampleQ;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBXDevartSQLServer, Data.FMTBcd, Vcl.StdCtrls, Data.DB, Data.SqlExpr;

type
  TForm2 = class(TForm)
    DatabaseSistemaDBX: TSQLConnection;
    sqlSemMovto: TSQLQuery;
    btn1: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btn1Click(Sender: TObject);
var
   tTempo : TTime;
begin
   sqlSemMovto.Close;
   sqlSemMovto.SQL.Clear;
   sqlSemMovto.SQL.Add(' SELECT TB11A.CODCONTA, TB11A.VALSALDO       ');
   sqlSemMovto.SQL.Add('   FROM TBCONT011 TB11A                      ');
   sqlSemMovto.SQL.Add('  WHERE TB11A.CODEMP  = :ParCodEmp           ');
   sqlSemMovto.SQL.Add('    AND TB11A.ANOLOTE = :ParAnoLote1         ');
   sqlSemMovto.SQL.Add('    AND TB11A.MESLOTE = :ParMesLote1         ');
   sqlSemMovto.SQL.Add('    AND NOT EXISTS                           ');
   sqlSemMovto.SQL.Add('  ( SELECT DISTINCT TB11B.CODCONTA           ');
   sqlSemMovto.SQL.Add('      FROM TBCONT011 TB11B                   ');
   sqlSemMovto.SQL.Add('     WHERE TB11B.CODEMP   = TB11A.CODEMP     ');
   sqlSemMovto.SQL.Add('       AND TB11B.ANOLOTE  = :ParAnoLote2     ');
   sqlSemMovto.SQL.Add('       AND TB11B.MESLOTE  = :ParMesLote2     ');
   sqlSemMovto.SQL.Add('       AND TB11B.CODCONTA = TB11A.CODCONTA ) ');

   sqlSemMovto.ParamByName('ParCodEmp').AsString   := '01';
   sqlSemMovto.ParamByName('ParAnoLote1').AsString := '2015';
   sqlSemMovto.ParamByName('ParMesLote1').AsString := '04';
   sqlSemMovto.ParamByName('ParAnoLote2').AsString := '2015';
   sqlSemMovto.ParamByName('ParMesLote2').AsString := '05';

   tTempo := Now;
   sqlSemMovto.Open;
   tTempo := Now - tTempo;

   lbl1.Caption := 'Time with Parameters: ' + FormatDateTime('zzz', tTempo) + ' miliseconds';

   sqlSemMovto.Close;
   sqlSemMovto.SQL.Clear;
   sqlSemMovto.SQL.Add(' SELECT TB11A.CODCONTA, TB11A.VALSALDO       ');
   sqlSemMovto.SQL.Add('   FROM TBCONT011 TB11A                      ');
   sqlSemMovto.SQL.Add('  WHERE TB11A.CODEMP  = ''01''           ');
   sqlSemMovto.SQL.Add('    AND TB11A.ANOLOTE = ''2015''         ');
   sqlSemMovto.SQL.Add('    AND TB11A.MESLOTE = ''04''           ');
   sqlSemMovto.SQL.Add('    AND NOT EXISTS                           ');
   sqlSemMovto.SQL.Add('  ( SELECT DISTINCT TB11B.CODCONTA           ');
   sqlSemMovto.SQL.Add('      FROM TBCONT011 TB11B                   ');
   sqlSemMovto.SQL.Add('     WHERE TB11B.CODEMP   = TB11A.CODEMP     ');
   sqlSemMovto.SQL.Add('       AND TB11B.ANOLOTE  = ''2015''     ');
   sqlSemMovto.SQL.Add('       AND TB11B.MESLOTE  = ''05''       ');
   sqlSemMovto.SQL.Add('       AND TB11B.CODCONTA = TB11A.CODCONTA ) ');

   tTempo := Now;
   sqlSemMovto.Open;
   tTempo := Now - tTempo;

   lbl2.Caption := 'Time without Parameters: ' + FormatDateTime('zzz', tTempo) + ' miliseconds';

end;

end.
