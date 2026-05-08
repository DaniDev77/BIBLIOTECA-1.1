inherited frmCadLivro: TfrmCadLivro
  Caption = 'frmCadLivro'
  ClientWidth = 823
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Times New Roman'
  ExplicitWidth = 839
  PixelsPerInch = 96
  TextHeight = 14
  inherited pgcPrincipal: TPageControl
    Width = 823
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 823
    inherited TabListagem: TTabSheet
      inherited Listagem: TPanel
        Width = 815
        Height = 73
        ExplicitWidth = 815
        ExplicitHeight = 73
        inherited lblIndice: TLabel
          Left = 18
          Top = 2
          Width = 149
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Height = -19
          Font.Name = 'Times New Roman'
          ParentFont = False
          ExplicitLeft = 18
          ExplicitTop = 2
          ExplicitWidth = 149
          ExplicitHeight = 21
        end
        object btnExportarCSV: TBitBtn [1]
          Left = 383
          Top = 18
          Width = 90
          Height = 39
          Caption = '&EXPORTAR'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnExportarCSVClick
        end
        object btnImportarXLSX: TBitBtn [2]
          Left = 487
          Top = 18
          Width = 90
          Height = 39
          Caption = '&IMPORTAR'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnImportarXLSXClick
        end
        inherited mskPesquisar: TMaskEdit
          Left = 19
          Top = 27
          Width = 166
          ExplicitLeft = 19
          ExplicitTop = 27
          ExplicitWidth = 166
        end
        inherited btnPesquisar: TBitBtn
          Left = 217
          Top = 18
          Width = 96
          Height = 39
          Font.Charset = ANSI_CHARSET
          Font.Name = 'Times New Roman'
          ParentFont = False
          ExplicitLeft = 217
          ExplicitTop = 18
          ExplicitWidth = 96
          ExplicitHeight = 39
        end
      end
      inherited grdListagem: TDBGrid
        Top = 73
        Width = 815
        Height = 167
        Font.Charset = ANSI_CHARSET
        Font.Name = 'Times New Roman'
        ParentFont = False
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'titulo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'autor'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'genero'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'resumo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ano_de_publicacao'
            Visible = True
          end>
      end
    end
    inherited TabManutencao: TTabSheet
      object edtLivroId: TLabeledEdit
        Tag = 1
        Left = 25
        Top = 40
        Width = 72
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'C'#243'digo:'
        Enabled = False
        NumbersOnly = True
        TabOrder = 0
      end
      object edtTitulo: TLabeledEdit
        Left = 150
        Top = 40
        Width = 272
        Height = 21
        EditLabel.Width = 35
        EditLabel.Height = 13
        EditLabel.Caption = 'T'#237'tulo:'
        TabOrder = 1
      end
      object edtAutor: TLabeledEdit
        Left = 25
        Top = 82
        Width = 227
        Height = 21
        EditLabel.Width = 34
        EditLabel.Height = 13
        EditLabel.Caption = 'Autor:'
        MaxLength = 255
        TabOrder = 3
      end
      object edtGenero: TLabeledEdit
        Left = 346
        Top = 82
        Width = 184
        Height = 21
        EditLabel.Width = 43
        EditLabel.Height = 13
        EditLabel.Caption = 'G'#234'nero:'
        MaxLength = 100
        TabOrder = 4
      end
      object edtAnoPub: TLabeledEdit
        Left = 450
        Top = 40
        Width = 72
        Height = 21
        EditLabel.Width = 99
        EditLabel.Height = 13
        EditLabel.Caption = 'Ano de Publica'#231#227'o:'
        MaxLength = 255
        NumbersOnly = True
        TabOrder = 2
      end
      object edtResumo: TLabeledEdit
        Left = 130
        Top = 131
        Width = 332
        Height = 21
        EditLabel.Width = 46
        EditLabel.Height = 13
        EditLabel.Caption = 'Resumo:'
        TabOrder = 5
      end
    end
  end
  inherited Rodape: TPanel
    Width = 823
  end
  inherited FDQListagem: TFDQuery
    Active = True
    SQL.Strings = (
      ' SELECT '
      '  id,'
      '  titulo,  '
      '  autor,'
      '  genero,'
      '  resumo, '
      '  ano_de_publicacao'
      'FROM BIBLIOTECA.dbo.livros'
      ''
      'ORDER BY titulo')
    Top = 168
    object FDQListagemid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDQListagemtitulo: TStringField
      DisplayLabel = 'T'#237'tulo'
      FieldName = 'titulo'
      Origin = 'titulo'
      Required = True
      Size = 255
    end
    object FDQListagemautor: TStringField
      DisplayLabel = 'Autor'
      FieldName = 'autor'
      Origin = 'autor'
      Required = True
      Size = 255
    end
    object FDQListagemgenero: TStringField
      DisplayLabel = 'G'#234'nero'
      FieldName = 'genero'
      Origin = 'genero'
      Required = True
      Size = 100
    end
    object FDQListagemresumo: TMemoField
      DisplayLabel = 'Resumo'
      FieldName = 'resumo'
      Origin = 'resumo'
      BlobType = ftMemo
    end
    object FDQListagemano_de_publicacao: TIntegerField
      DisplayLabel = 'Ano de Publica'#231#227'o'
      FieldName = 'ano_de_publicacao'
      Origin = 'ano_de_publicacao'
      Required = True
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = '|*.csv'
    Left = 564
    Top = 216
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.xlsx'
    Left = 500
    Top = 216
  end
end
