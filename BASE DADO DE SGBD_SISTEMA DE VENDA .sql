								CREATE DATABASE SistemaVendasMercado;
GO

USE SistemaVendasMercado;


-- Tabela de Roles/Níveis de acesso
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    NomeRole VARCHAR(20) NOT NULL UNIQUE
);
select *from Roles;

INSERT INTO Roles (NomeRole) VALUES ('Admin'), ('Gestor'), ('Vendedor');



CREATE TABLE Usuarios(
ID INT IDENTITY(1,1) PRIMARY KEY ,
Login VARCHAR(50)NOT NULL UNIQUE,
Senha VARCHAR(50)NOT NULL,
Nome VARCHAR(50)NOT NULL,
Nivel VARCHAR(50)NOT NULL
)
INSERT INTO Usuarios(Login,Senha,Nome,Nivel)
VALUES('simao','1234','Kiassisua Simão','Admin');

select *from Funcionarios;



DELETE FROM Funcionarios WHERE FuncionarioID=7;






---para ver se a tabela existe--

IF OBJECT_ID('dbo.Usuarios','U') IS NOT NULL
PRINT 'A tabela Usuarrios EXISTE'
ELSE
PRINT 'A tabela Usuarios NÃO EXISTE'













-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    FuncionarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefone VARCHAR(20) NOT NULL UNIQUE,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Senha VARCHAR(100) NOT NULL,
    RoleID INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleID),
    DataCadastro DATETIME DEFAULT GETDATE(),
    Ativo BIT DEFAULT 1
);

select TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME ;

-- Inserir Admin padrão: user=admin, senha=123
INSERT INTO Funcionarios (Nome, Email, Telefone, Username, Senha, RoleID)
VALUES ('Administrador', 'kiasisuasimaop@gmail.com', '942989381', 'Simão', '1234', 1);
GO
select * from Funcionarios;
-- Tabela de Clientes
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Telefone VARCHAR(20) NOT NULL UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Endereco VARCHAR(200)
);


-- Tabela de Produtos
CREATE TABLE Produtos (
    ProdutoID INT IDENTITY(1,1) PRIMARY KEY,
    NomeProduto VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50),
    PrecoUnitario DECIMAL(18,2) NOT NULL,
    QuantidadeStock INT NOT NULL DEFAULT 0,
    DataCadastro DATETIME DEFAULT GETDATE()
);
GO

-- Tabela de Vendas
CREATE TABLE Vendas (
    VendaID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
    FuncionarioID INT FOREIGN KEY REFERENCES Funcionarios(FuncionarioID),
    DataVenda DATETIME DEFAULT GETDATE(),
    TotalVenda DECIMAL(18,2) NOT NULL
);
GO

-- Tabela de Itens da Venda
CREATE TABLE DetalhesVenda (
    DetalheID INT IDENTITY(1,1) PRIMARY KEY,
    VendaID INT FOREIGN KEY REFERENCES Vendas(VendaID),
    ProdutoID INT FOREIGN KEY REFERENCES Produtos(ProdutoID),
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(18,2) NOT NULL,
    SubTotal AS (Quantidade * PrecoUnitario)
);
GO

-- Stored Procedure para login
CREATE PROC sp_Login
@Username VARCHAR(50),
@Senha VARCHAR(100)
AS
BEGIN
    SELECT F.FuncionarioID, F.Nome, R.NomeRole, F.RoleID
    FROM Funcionarios F
    INNER JOIN Roles R ON F.RoleID = R.RoleID
    WHERE F.Username = @Username AND F.Senha = @Senha AND F.Ativo = 1
END
GO
