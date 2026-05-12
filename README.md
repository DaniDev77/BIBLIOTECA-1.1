# 📚 BIBLIOTECA 1.1

## Objetivo

Sistema de gestão de biblioteca desenvolvido como **Desafio de Estágio - Daniel**.

O projeto implementa um **Sistema de Biblioteca de Livros** com importação de dados a partir de arquivo **XLSX** e exportação de relatórios em formato **CSV**.

**Combinação Sorteada:** Biblioteca de Livros | Entrada: XLSX | Saída: CSV

---

## Tecnologias Utilizadas

- **Linguagem**: Pascal (Delphi 11)
- **Interface**: VCL (Visual Component Library)
- **Banco de Dados**: SQL Server
- **ORM/Acesso a Dados**: FireDAC
- **Importação**: COM Automation (Excel)
- **Exportação**: TStringList com UTF-8

---

## Como Executar

### 📋 Pré-requisitos

1. **Delphi 11** ou superior instalado
2. **SQL Server** (Express ou superior)
3. **Microsoft Excel** instalado (para importação XLSX)
4. Acesso à rede ou instância local do SQL Server

### 🚀 Passo 1: Preparar o Banco de Dados

Execute o script SQL fornecido no caminho `ScriptSQL/Script SQL para criar tabela.txt`:

```sql
CREATE TABLE livros (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    ano_de_publicacao INTEGER NOT NULL,
    resumo TEXT,
    editora VARCHAR(255) NOT NULL,
    
    -- Regra específica: Não permitir o mesmo título para o mesmo autor
    CONSTRAINT uq_titulo_autor UNIQUE (titulo, autor)
);
```

**Passos:**
1. Abra o **SQL Server Management Studio**
2. Crie um novo banco de dados chamado `BIBLIOTECA`
3. Execute o script acima no contexto do banco `BIBLIOTECA`

### 🔧 Passo 2: Configurar a Conexão

Edite o arquivo `DataModule/uDTMConexao.pas`:

```pascal
procedure TdtmPrincipal.DataModuleCreate(Sender: TObject);
begin
  dtmPrincipalDB.Params.Clear;
  dtmPrincipalDB.Params.Add('DriverID=MSSQL');
  dtmPrincipalDB.Params.Add('Server=SEU_SERVIDOR');        // Altere para seu servidor
  dtmPrincipalDB.Params.Add('Database=BIBLIOTECA');
  dtmPrincipalDB.Params.Add('OSAuthent=Yes');              // Use autenticação Windows
  dtmPrincipalDB.LoginPrompt := False;
  dtmPrincipalDB.Connected := True;
end;
```

**Exemplo:**
- Servidor local: `Server=localhost\SQLEXPRESS`
- Rede corporativa: `Server=DC-TR-01-VM\SERVERCURSO`

### ▶️ Passo 3: Compilar e Executar

1. Abra `Bibliotecas.dproj` no Delphi
2. Menu **Build** → **Compile**
3. Pressione **F9** ou clique em **Run**
4. A tela principal (MenuPrincipal) será exibida

---

## Como Importar/Exportar Dados

### 📥 Importar Dados (XLSX)

#### Formato Esperado do Arquivo XLSX

O arquivo deve conter uma planilha com:

| Coluna | Campo | Tipo | Obrigatório | Observações |
|--------|-------|------|-------------|-------------|
| A | Título | Texto | ✅ | Máximo 255 caracteres |
| B | Autor | Texto | ✅ | Máximo 255 caracteres |
| C | Gênero | Texto | ✅ | Máximo 100 caracteres |
| D | Resumo | Texto | ❌ | Aceita texto longo |
| E | Ano | Número | ✅ | Entre 1000 e 2100 |
| F | Editora | Texto | ✅ | Máximo 255 caracteres |

**Exemplo de Arquivo XLSX:**

```
| Título                    | Autor              | Gênero        | Resumo                          | Ano  | Editora    |
|---------------------------|--------------------|---------------|---------------------------------|------|------------|
| Dom Casmurro              | Machado de Assis   | Romance       | Uma história de amor e obsessão | 1900 | Companhia  |
| Grande Sertão: Veredas    | Guimarães Rosa     | Romance       | Narrativa do sertão brasileiro  | 1956 | Globo      |
| O Cortiço                 | Aluísio Azevedo    | Romance       | Retrato social do Rio de Janeiro| 1890 | Editora A  |
```

#### Passos para Importar

1. Abra a aplicação e clique em **CADASTRO** → **LIVROS**
2. Clique no botão **Importar XLSX**
3. Selecione o arquivo `.xlsx` desejado
4. O sistema validará e importará automaticamente:
   - ✅ Verifica campos obrigatórios
   - ✅ Evita duplicidades (título + autor)
   - ✅ Trata erros de importação
   - ✅ Exibe mensagem com total de registros importados

#### Validações de Importação

- Arquivo deve ter extensão `.xlsx`
- Todas as colunas (A-F) devem estar preenchidas
- Títulos duplicados para o mesmo autor **não serão importados**
- Ano deve ser um número válido entre 1000 e 2100
- Em caso de erro, a transação é revertida

### 📤 Exportar Dados (CSV)

#### Formato Gerado

O arquivo CSV é gerado com:
- Separador: **`;` (ponto-e-vírgula)**
- Codificação: **UTF-8**
- Cabeçalho: `sep=;` (compatível com Excel/LibreOffice)
- Estrutura:

```
sep=;
ID;Titulo;Autor;Genero;Ano;Resumo;Editora
1;"Dom Casmurro";"Machado de Assis";"Romance";1900;"Uma história de amor e obsessão";"Companhia"
2;"Grande Sertão: Veredas";"Guimarães Rosa";"Romance";1956;"Narrativa do sertão brasileiro";"Globo"
```

#### Passos para Exportar

1. Abra a tela de **Cadastro de Livros**
2. (Opcional) Aplique **filtros** por autor, gênero ou ano
3. (Opcional) Ordene por título, autor, gênero ou ano
4. Clique no botão **Exportar CSV**
5. Escolha local e nome do arquivo
6. Arquivo é salvo com sucesso

#### Características da Exportação

- ✅ Respeita filtros aplicados em tela
- ✅ Respeita ordenação aplicada em tela
- ✅ Inclui todos os registros ou apenas os filtrados
- ✅ Suporta títulos, resumos e nomes com acentuação
- ✅ Compatível com Excel, LibreOffice, Google Sheets

---

## Funcionalidades

### ✅ Escopo Obrigatório - Checklist Completo

- [x] **Importar dados** a partir do formato XLSX
- [x] **Persistir dados** em banco de dados SQL Server
- [x] **Cadastrar novos registros** manualmente via interface
- [x] **Consultar registros** cadastrados
- [x] **Editar registros** existentes
- [x] **Excluir registros** com confirmação
- [x] **Listar registros** com paginação via DBGrid
- [x] **Filtrar registros** por: Autor, Gênero, Ano de Publicação
- [x] **Ordenar registros** por: Título, Autor, Gênero, Ano
- [x] **Exportar dados** no formato CSV
- [x] **Validar campos** obrigatórios (título, autor, gênero, editora, ano)
- [x] **Tratar erros** de importação, validação e persistência
- [x] **README detalhado** com instruções de execução

### 📊 Detalhes das Funcionalidades

#### 1. Menu Principal
- Acesso rápido via botão ou menu
- Interface simples e intuitiva

#### 2. Tela de Cadastro de Livros
- **Campos de Entrada:**
  - ID (apenas leitura, auto-gerado)
  - Título *
  - Autor *
  - Gênero *
  - Editora *
  - Ano de Publicação *
  - Resumo (texto longo)

#### 3. Operações CRUD Completas
```
CREATE → Novo (inserir registro)
READ   → Consultar e listar
UPDATE → Alterar (edit record)
DELETE → Excluir (com confirmação)
```

#### 4. Busca com Filtros
- Filtro por Autor
- Filtro por Gênero
- Filtro por Ano
- Combinação de múltiplos filtros

#### 5. Ordenação
- Padrão: Título (A-Z)
- Alterável para: Autor, Gênero, Ano

#### 6. Paginação
- DBGrid com suporte nativo
- Navegação fluida entre registros

---

## Estrutura de Dados

### Tabela: `livros`

| Campo | Tipo | Restrição | Descrição |
|-------|------|-----------|-----------|
| `id` | INTEGER | PRIMARY KEY | Identificador único, auto-incrementado |
| `titulo` | VARCHAR(255) | NOT NULL | Título do livro |
| `autor` | VARCHAR(255) | NOT NULL | Nome do autor |
| `genero` | VARCHAR(100) | NOT NULL | Gênero literário |
| `editora` | VARCHAR(255) | NOT NULL | Editora (adicionado ao escopo) |
| `ano_publicacao` | INTEGER | NOT NULL | Ano de publicação (1000-2100) |
| `resumo` | TEXT | NULL | Resumo ou sinopse (aceita texto longo) |

### Restrição de Negócio

```sql
CONSTRAINT uq_titulo_autor UNIQUE (titulo, autor)
```

- ✅ Não permite livro com **mesmo título** do **mesmo autor**
- ✅ Protege contra duplicidades
- ✅ Validada no banco e na aplicação

---

## Decisões Técnicas

### 1. Por que Delphi/VCL?

- Compatibilidade com SQL Server via FireDAC
- Interface gráfica moderna e responsiva
- Suporte nativo a OLE Automation (Excel)
- Compilação para executável standalone (.exe)

### 2. Por que SQL Server?

- Suporte robusto a transactions
- Constraint UNIQUE para garantir integridade
- Melhor performance em leitura e escrita
- Suporte a TEXT para resumos longos

### 3. Por que FireDAC?

- ORM moderno e eficiente
- Suporte a múltiplos bancos de dados
- Cache automático de dados
- Transaction control integrado

### 4. Por que COM Automation para Excel?

- Leitura nativa de .xlsx
- Não requer biblioteca externa
- Integração com Excel instalado no SO
- Tratamento automático de tipos

### 5. Importação com Validações

```pascal
- Validação de campos obrigatórios
- Verificação de duplicidade (titulo + autor)
- Rollback automático em caso de erro
- Feedback visual do usuário
```

### 6. Exportação Respeitando Filtros

```pascal
- Export consome o DataSet atual (filtrado)
- Ordena conforme seleção do usuário
- Formato CSV com separador ; (Excel-friendly)
- Codificação UTF-8 para acentos
```

---

## Tratamento de Erros

### Validações Implementadas

#### ✅ Campos Obrigatórios
- Título não pode estar vazio
- Autor não pode estar vazio
- Gênero não pode estar vazio
- Editora não pode estar vazio
- Ano deve ser um número válido (1000-2100)

#### ✅ Duplicidade
- Verifica UNIQUE constraint `(titulo, autor)`
- Não importa livro com mesmo título de mesmo autor
- Mensagem clara ao usuário

#### ✅ Erros de Importação
- Arquivo inválido (não .xlsx)
- Linha sem dados obrigatórios
- Tipo de dados incorreto (ano não é número)
- Conexão com banco falhou
- Transaction com Rollback automático

#### ✅ Erros de Persistência
- Falha ao inserir (banco indisponível)
- Falha ao atualizar (registro não existe)
- Falha ao excluir (integridade referencial)
- Mensagens descritivas para cada caso

#### ✅ Tratamento de Exceções

```pascal
try
  // Operação
  FDQ.ExecSQL;
  dtmPrincipalDB.Commit;
  Result := True;
except
  on E: Exception do begin
    dtmPrincipalDB.Rollback;
    ShowMessage('Erro: ' + E.Message);
    Result := False;
  end;
end;
```

---

## Arquitetura do Projeto

### 📁 Estrutura de Pastas

```
BIBLIOTECA-1.1/
├── Bibliotecao.pas             # Formulário Principal (Menu)
├── Bibliotecao.dfm             # Design do Menu
│
├── Classes/
│   └── cCadLivro.pas           # Classe de Negócio (CRUD)
│
├── Cadastro/
│   ├── uCadLivro.pas           # Tela de Cadastro (UI)
│   └── uCadLivro.dfm           # Design da Tela
│
├── DataModule/
│   ├── uDTMConexao.pas         # Conexão com Banco
│   └── uDTMConexao.dfm         # Design do DataModule
│
├── ScriptSQL/
│   └── Script SQL para criar tabela.txt    # Script de Criação
│
└── README.md                   # Este arquivo
```

### 🔄 Fluxo de Dados

```
Menu Principal (Bibliotecao.pas)
    ↓
Tela Cadastro (uCadLivro.pas)
    ↓
Classe Negócio (cCadLivro.pas) ← CRUD
    ↓
DataModule (uDTMConexao.pas) ← Conexão
    ↓
SQL Server (BIBLIOTECA)
```

---

## Requisitos de Execução

### Sistema Operacional
- Windows 7 ou superior
- Windows Server 2008 R2 ou superior

### Software Necessário
- SQL Server (Express, Standard ou Enterprise)
- Microsoft Excel 2007 ou superior (para importar XLSX)
- Acesso ao banco de dados via rede ou localhost

### Permissões
- Usuário deve ter acesso de escrita à pasta do `.exe`
- Usuário deve ter permissões no SQL Server (SELECT, INSERT, UPDATE, DELETE na tabela `livros`)

---

## Como Testar

### 🧪 Teste 1: Criar Registros Manualmente

1. Abra a tela de Cadastro
2. Clique em **Novo**
3. Preencha os campos:
   - Título: "Test Book"
   - Autor: "Test Author"
   - Gênero: "Test"
   - Editora: "Test Pub"
   - Ano: 2024
   - Resumo: "Test"
4. Clique em **Gravar**
5. Verificar se aparece na listagem

### 🧪 Teste 2: Importar XLSX

1. Crie um arquivo `exemplo.xlsx` seguindo o formato documentado acima
2. Clique em **Importar XLSX**
3. Selecione o arquivo
4. Verifique se os registros aparecem na tela

### 🧪 Teste 3: Exportar CSV

1. Com dados na tela, clique em **Exportar CSV**
2. Escolha local e nome do arquivo
3. Abra o arquivo em Excel ou editor de texto
4. Verifique se o formato está correto

### 🧪 Teste 4: Validações

1. Tente gravar com campo obrigatório vazio
2. Tente importar arquivo duplicado
3. Tente importar arquivo com extensão errada
4. Verificar mensagens de erro

---

## Troubleshooting

### Erro: "FireDAC Comp Clnt 512"
**Causa:** Conexão com banco não inicializada
**Solução:** Verifique `DataModule/uDTMConexao.pas` - configure servidor correto

### Erro: "Access Violation"
**Causa:** DataModule não criado antes de acessar
**Solução:** Certifique-se que `FormCreate` é chamado em `Bibliotecao.pas`

### Erro ao Importar XLSX: "COM Error"
**Causa:** Excel não instalado ou arquivo corrompido
**Solução:** Instale Microsoft Excel e use arquivo válido

### Erro ao Importar: "Constraint UNIQUE"
**Causa:** Título + Autor já existem no banco
**Solução:** Sistema ignora duplicatas automaticamente (comportamento esperado)

### Erro de Conexão: "Cannot connect to Server"
**Causa:** SQL Server offline ou endereço incorreto
**Solução:** Verifique:
- SQL Server está rodando (Services)
- Endereço do servidor em `uDTMConexao.pas`
- Firewall está bloqueando?

---

## Cronograma de Desenvolvimento

| Data | Etapa |
|------|-------|
| 04-15 mai | Desenvolvimento |
| 18 mai | **Data limite de entrega** |
| 18-22 mai | Preparativos para apresentação |
| 25-27 mai | Apresentação dos projetos |
| 28-29 mai | Resultado final |

---

## Critérios de Avaliação

- ✅ Projeto executa sem erros
- ✅ README explica claramente como rodar
- ✅ Estrutura do banco foi entregue (script SQL)
- ✅ Importação (XLSX) funciona corretamente
- ✅ Exportação (CSV) funciona corretamente
- ✅ CRUD completo com tratamento de dados inválidos
- ✅ Listagem com filtros (autor, gênero, ano)
- ✅ Listagem com ordenação (título, autor, gênero, ano)
- ✅ Exportação respeita filtros e ordenação
- ✅ Validações de campos obrigatórios
- ✅ Mensagens claras ao usuário
- ✅ Código organizado e bem estruturado

---

## Licença

Projeto desenvolvido como atividade de estágio em 2026.

---

## Autor

**Daniel** - Desafio de Estágio 2026

---

## Contato e Suporte

Para dúvidas sobre o projeto:

- 💻 GitHub: [@DaniDev77](https://github.com/DaniDev77)

---

**Última atualização:** 11 de maio de 2026
