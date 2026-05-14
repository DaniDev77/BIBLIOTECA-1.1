unit uDTMConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,System.IniFiles, Vcl.Dialogs;

type
  TdtmPrincipal = class(TDataModule)
    dtmPrincipalDB: TFDConnection;
  private
    procedure DataModuleCreate(Sender: TObject);
   // procedure ConfigurarConexaoDinamicamente;
   // procedure ConfigurarBancoInicial;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmPrincipal: TdtmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
   procedure TdtmPrincipal.DataModuleCreate(Sender: TObject);
begin
  dtmPrincipalDB.Params.Clear;
  dtmPrincipalDB.Params.Add('DriverID=MSSQL');
  dtmPrincipalDB.Params.Add('Server=DC-TR-01-VM\SERVERCURSO');
  dtmPrincipalDB.Params.Add('Database=BIBLIOTECA');
  dtmPrincipalDB.Params.Add('OSAuthent=Yes');
  dtmPrincipalDB.LoginPrompt := False;
  dtmPrincipalDB.Connected := True;

end;

end.
