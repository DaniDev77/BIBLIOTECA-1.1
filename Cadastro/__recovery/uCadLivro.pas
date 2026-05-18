unit uCadLivro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls,
  cCadLivro, uEnum, uDTMConexao,System.IOUtils, ComObj, System.UITypes, Vcl.Mask, Vcl.Imaging.pngimage,DateUtils;

type
  TfrmCadLivro = class(THeranca)
    SaveDialog1: TSaveDialog;
    btnExportarCSV: TBitBtn;
    OpenDialog1: TOpenDialog;
    btnImportarXLSX: TBitBtn;
    Image1: TImage;
    Panel1: TPanel;
    edtLivroId: TLabeledEdit;
    edtTitulo: TLabeledEdit;
    edtAutor: TLabeledEdit;
    edtGenero: TLabeledEdit;
    edtAnoPub: TLabeledEdit;
    edtResumo: TLabeledEdit;
    edtEditora: TLabeledEdit;
    FDQListagemid: TIntegerField;
    FDQListagemtitulo: TStringField;
    FDQListagemautor: TStringField;
    FDQListagemgenero: TStringField;
    FDQListagemeditora: TStringField;
    FDQListagemresumo: TMemoField;
    FDQListagemano_de_publicacao: TIntegerField;
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
    procedure btnExportarCSVClick(Sender: TObject);
    procedure btnImportarXLSXClick(Sender: TObject);
   
   
  private
    { Private declarations }
    oLivro: TLivro;
    procedure ExportarCSV(ADataset: TDataSet);
    procedure ImportarExcel(AFileName: string); // Instância da nossa classe de negócio
  public
    { Public declarations }
    // Sobrescrevendo os métodos da tela de herança
    function Apagar: Boolean; override;
    function Gravar(EstadoDoCadastro: TEstadoCadastro): Boolean; override;
  end;

var
  frmCadLivro: TfrmCadLivro;

implementation

uses Bibliotecao; // Para acessar o dtmPrincipal


{$R *.dfm}

{$REGION 'Metodos de Persistencia'}

function TfrmCadLivro.Apagar: Boolean;
begin
  // Pegamos o ID diretamente da Query de listagem
  if oLivro.Selecionar(FDQListagem.FieldByName('id').AsInteger) then
    Result := oLivro.Apagar
  else
    Result := False;
end;

function TfrmCadLivro.Gravar(EstadoDoCadastro: TEstadoCadastro): Boolean;
begin
  // 1. Passa os dados da tela para o objeto oLivro
  if edtLivroId.Text <> EmptyStr then
    oLivro.id := StrToInt(edtLivroId.Text)
  else
    oLivro.id := 0;

  oLivro.titulo         := edtTitulo.Text;
  oLivro.autor          := edtAutor.Text;
  oLivro.genero         := edtGenero.Text;
  oLivro.editora        := edtEditora.Text;
  oLivro.resumo         := edtResumo.Text;
  oLivro.ano_publicacao := StrToIntDef(edtAnoPub.Text, 0);

  // 2. Validações de Campos Obrigatórios
  if Trim(oLivro.titulo) = '' then
  begin
    MessageDlg('O título do livro é obrigatório!', mtWarning, [mbOK], 0);
    edtTitulo.SetFocus;
    Abort;
  end
  else if Trim(oLivro.autor) = '' then
  begin
    MessageDlg('O nome do autor é obrigatório!', mtWarning, [mbOK], 0);
    edtAutor.SetFocus;
    Abort;
  end
  else if Trim(oLivro.genero) = '' then
  begin
    MessageDlg('O gênero do livro é obrigatório!', mtWarning, [mbOK], 0);
    edtGenero.SetFocus;
    Abort;
  end
   else if Trim(oLivro.editora) = '' then
  begin
    MessageDlg('A editora do livro é obrigatória!', mtWarning, [mbOK], 0);
    edtEditora.SetFocus;
    Abort;
  end
  else if (oLivro.ano_publicacao <= 0) or (oLivro.ano_publicacao > 2100) then
  begin
    MessageDlg('Por favor, informe um ano de publicação válido!', mtWarning, [mbOK], 0);
    edtAnoPub.SetFocus;
    Abort;
  end;



  // 3. Decide se Insere ou Atualiza
  if (EstadoDoCadastro = ecInserir) then
    Result := oLivro.Inserir
  else if (EstadoDoCadastro = ecAlterar) then
    Result := oLivro.Atualizar;
end;

{$ENDREGION}

{$REGION ' Form'}

procedure TfrmCadLivro.FormCreate(Sender: TObject);
begin
  // 1. Primeiro, dizemos para a Query qual é a conexão dela
  // Isso resolve o erro [FireDAC][Comp][Clnt]-512
  FDQListagem.Connection := dtmPrincipal.dtmPrincipalDB;

  // 2. Depois, criamos o objeto oLivro
  // Agora que o dtmPrincipal está no topo da lista (Passo 1), não dará mais Access Violation
  oLivro := TLivro.Create(dtmPrincipal.dtmPrincipalDB);

  // 3. Agora podemos abrir a busca com segurança
  FDQListagem.Open;

  IndiceAtual := 'titulo'; // Define o índice padrão para busca/exportação

  inherited;
end;

procedure TfrmCadLivro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(oLivro) then
    FreeAndNil(oLivro);
end;

{$ENDREGION}

{$REGION 'Botoes de Ação'}

procedure TfrmCadLivro.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtTitulo.SetFocus;
end;

procedure TfrmCadLivro.btnAlterarClick(Sender: TObject);
begin
  inherited;
  // Carrega os dados do banco para os campos da tela
  if oLivro.Selecionar(FDQListagem.FieldByName('id').AsInteger) then
  begin
    edtLivroId.Text := IntToStr(oLivro.id);
    edtTitulo.Text  := oLivro.titulo;
    edtAutor.Text   := oLivro.autor;
    edtGenero.Text  := oLivro.genero;
    edtEditora.Text := oLivro.editora;
    edtAnoPub.Text  := IntToStr(oLivro.ano_publicacao);
    edtResumo.Text  := oLivro.resumo;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;
end;

procedure TfrmCadLivro.btnFecharClick(Sender: TObject);
begin
  inherited;

end;



{$ENDREGION}



{$REGION 'Exporta'}
procedure TfrmCadLivro.ExportarCSV(ADataset: TDataSet);
var
  Lista: TStringList;
  Linha: string;
begin
  Lista := TStringList.Create;
  try
    Lista.Add('sep=;');  // <- faz o Excel/WPS abrir corretamente
    Lista.Add('ID;Titulo;Autor;Genero;Ano;Resumo;Editora');

    ADataset.DisableControls;
    ADataset.First;
    try
      while not ADataset.Eof do
      begin
        Linha :=
          ADataset.FieldByName('id').AsString                + ';' +
          '"' + ADataset.FieldByName('titulo').AsString      + '";' +
          '"' + ADataset.FieldByName('autor').AsString       + '";' +
          '"' + ADataset.FieldByName('genero').AsString      + '";' +
          ADataset.FieldByName('ano_de_publicacao').AsString + ';' +
          '"' + ADataset.FieldByName('resumo').AsString      + '"'+
           '"' + ADataset.FieldByName('editora').AsString      + '";' ;

        Lista.Add(Linha);
        ADataset.Next;
      end;
    finally
      ADataset.EnableControls;
    end;

    SaveDialog1.FileName   := 'CatalogoLivros.csv';
    SaveDialog1.DefaultExt := 'csv';
    SaveDialog1.Filter     := 'Arquivo CSV (*.csv)|*.csv';

    if SaveDialog1.Execute then
    begin
      TFile.WriteAllText(SaveDialog1.FileName, Lista.Text, TEncoding.UTF8);
      ShowMessage('Exportação concluída! ' +
                  IntToStr(Lista.Count - 2) + ' registro(s) exportado(s).');
    end;
  finally
    Lista.Free;
  end;
end;

procedure TfrmCadLivro.btnExportarCSVClick(Sender: TObject);
begin
  // Recarrega o dataset para garantir que não está em EOF
  FDQListagem.Close;
  FDQListagem.Open;

  if FDQListagem.IsEmpty then
  begin
    ShowMessage('Não há dados para exportar o arquivo.');
    Exit;
  end;

  ExportarCSV(FDQListagem);
end;


{$ENDREGION}

{$REGION 'Importar'}
procedure TfrmCadLivro.ImportarExcel(AFileName: string);
var
  Excel, Planilha: Variant;
  Linha: Integer;
  Titulo, Autor, Genero, Editora, Resumo: string;
  Ano: Integer;
  QryConsulta: TFDQuery;
  CelVal: string;
  Contador, Ignorados: Integer;
  Erros: TStringList;
begin
  Contador := 0;
  Ignorados := 0;
  Erros := TStringList.Create;
  QryConsulta := TFDQuery.Create(nil);
  QryConsulta.Connection := dtmPrincipal.dtmPrincipalDB;

  try
    Excel := CreateOleObject('Excel.Application');
    Excel.Visible       := False;
    Excel.DisplayAlerts := False;
    Excel.Workbooks.Open(AFileName);
    Planilha := Excel.Workbooks[1].Sheets[1];

    Linha := 2;

    while True do
    begin
      CelVal := Trim(VarToStr(Planilha.Cells[Linha, 1].Value));
      if CelVal = '' then Break;

      Titulo  := Trim(VarToStr(Planilha.Cells[Linha, 1].Value));
      Autor   := Trim(VarToStr(Planilha.Cells[Linha, 2].Value));
      Genero  := Trim(VarToStr(Planilha.Cells[Linha, 3].Value));
      Resumo  := Trim(VarToStr(Planilha.Cells[Linha, 4].Value));
      Ano     := StrToIntDef(VarToStr(Planilha.Cells[Linha, 5].Value), 0);
      Editora := Trim(VarToStr(Planilha.Cells[Linha, 6].Value));

      // ============================================================
      // BARRAMENTO DE VALIDAÇÕES
      // ============================================================

      // 1. Título obrigatório
      if Titulo = '' then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Título vazio — linha ignorada.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // 2. Título muito curto
      if Length(Titulo) < 2 then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Título "' + Titulo + '" muito curto — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // 3. Título muito longo (banco é varchar(255))
      if Length(Titulo) > 255 then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Título muito longo (máx 255 caracteres) — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // 4. Autor obrigatório
      if Autor = '' then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Autor vazio para "' + Titulo + '" — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // 5. Autor muito longo (varchar(255))
      if Length(Autor) > 255 then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Autor muito longo para "' + Titulo + '" — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // 6. Gênero obrigatório
      if Genero = '' then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Gênero vazio para "' + Titulo + '" — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // 7. Gênero muito longo (varchar(100))
      if Length(Genero) > 100 then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': Gênero muito longo para "' + Titulo + '" — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

     // 8. Editora obrigatória
    if Editora = '' then
      begin
      Erros.Add('Linha ' + IntToStr(Linha) + ': Editora vazia para "' + Titulo + '" — ignorado.');
      Inc(Ignorados);
      Linha := Linha + 1;
      Continue;
     end;

     // 9. Editora muito longa (varchar(255))
    if Length(Editora) > 255 then
      begin
      Erros.Add('Linha ' + IntToStr(Linha) + ': Editora muito longa para "' + Titulo + '" — ignorado.');
      Inc(Ignorados);
      Linha := Linha + 1;
      Continue;
      end;

     // 10. Ano inválido (entre 1000 e ano atual)
    if (Ano < 1000) or (Ano > YearOf(Now)) then
      begin
      Erros.Add('Linha ' + IntToStr(Linha) + ': Ano ' + IntToStr(Ano) +
                ' inválido para "' + Titulo + '" — ignorado.');
      Inc(Ignorados);
      Linha := Linha + 1;
      Continue;
      end;

      // ============================================================
      // VERIFICA DUPLICIDADE NO BANCO
      // ============================================================
      QryConsulta.Close;
      QryConsulta.SQL.Text := 'SELECT id FROM BIBLIOTECA.dbo.livros WHERE titulo = :t';
      QryConsulta.ParamByName('t').AsString := Titulo;
      QryConsulta.Open;

      if not QryConsulta.IsEmpty then
      begin
        Erros.Add('Linha ' + IntToStr(Linha) + ': "' + Titulo + '" já existe no banco — ignorado.');
        Inc(Ignorados);
        Linha := Linha + 1;
        Continue;
      end;

      // ============================================================
      // GRAVA NO BANCO
      // ============================================================
      oLivro.id             := 0;
      oLivro.titulo         := Titulo;
      oLivro.autor          := Autor;
      oLivro.genero         := Genero;
      oLivro.resumo         := Resumo;
      oLivro.ano_publicacao := Ano;
      oLivro.editora        := Editora;

      if oLivro.Inserir then
        Inc(Contador)
      else
        Erros.Add('Linha ' + IntToStr(Linha) + ': Erro ao gravar "' + Titulo + '" no banco.');

      Linha := Linha + 1;
    end;

    // ============================================================
    // RELATÓRIO FINAL
    // ============================================================
    if Erros.Count > 0 then
      ShowMessage('Importação concluída com avisos:' + #13#13 + Erros.Text);

    ShowMessage('Resultado da importação:' + #13 +
                '? Gravados: '  + IntToStr(Contador)  + #13 +
                '? Ignorados: ' + IntToStr(Ignorados) + #13 +
                '?? Total lido: ' + IntToStr(Contador + Ignorados));

    FDQListagem.Refresh;

  finally
    if not VarIsEmpty(Excel) and not VarIsNull(Excel) then
    begin
      Excel.Workbooks.Close;
      Excel.Quit;
      Excel := Unassigned;
    end;
    Erros.Free;
    QryConsulta.Free;
  end;
end;

procedure TfrmCadLivro.btnImportarXLSXClick(Sender: TObject);
begin
  OpenDialog1.Title      := 'Selecionar Planilha Excel';
  OpenDialog1.Filter     := 'Planilha Excel (*.xlsx)|*.xlsx';
  OpenDialog1.DefaultExt := 'xlsx';

  if OpenDialog1.Execute then
  begin
    if not SameText(ExtractFileExt(OpenDialog1.FileName), '.xlsx') then
    begin
      ShowMessage('Arquivo inválido! Selecione apenas arquivos .xlsx');
      Exit;
    end;

    ImportarExcel(OpenDialog1.FileName);
    FDQListagem.Close;
    FDQListagem.Open;
  end;
end;
{$ENDREGION}

end.
