/* professor, eu (Vinícius e o Caio) gostariamos de pedir perdão pro senhor, te falar bem a verdade nós subestimamos o projetos de 
Data WHere House, e não conseguimos terminar ele a tempo, tivemos uma dificuldade insana de vários dias que não conseguimos inserir
os dados na tabela FatoVendas sem ter os dados Nulos, e quando conseguimos mesmo os dados nulos terem entrado na tabela e
também eu não sei o exato problema eu pensei em deixar para desenvolver mais metricas a partir da tabela fato estivesse pronta, mas as poucas
que criei também não funcionam, eu nem sei mais oq dizer pro sr, perdão. */


-- Criando o banco de dados AnaliseDeDados --
Create Database AnaliseDeDadosI
Go

Alter Database AnaliseDeDadosI
Set Recovery Bulk_logged
Go

-- Acessando o Banco de Dados --
Use AnaliseDeDadosI
Go

-- Passo 1 Criando a Tabela de Acidentes para armazenar dados transacionais --
Create Table Acidentes
(
    CodigoAcidente int Null,
    CodigoMotivoAcidente Int Null,
    CodigoOperador Int Null,
    CodigoLocal Int Null,
    TimeID Int Null,
	RegiaoAcidente nVarchar (15) Null,
	MunicipioAcidente nVarChar(100) Null,
	UFAcidente Char (02) Null,
    MetricaContadorDeAcidentes Int,
	MetricaRazaoAcidente nVarChar(100) Null,
	MetricaModeloAeronave nVarChar(50) Null,
)
Go


-- Passo 2 - Criando a Tabela de Histórico de Acidentes para trabalhar como área de Staging --
Create Table Historico_de_Acidentes
(
    CodigoAcidentes int Identity (1,1) Primary Key,
    CodigoLocal int Not Null,
    CodigoOperador int Not Null,
    CodigoAcidente int Not Null,
    CodigoMotivoAcidente int Not Null,
    TimeID int Not Null,
    ContadorAcidentesRegiao tinyint,
    ContadorAcidentesUF tinyint,
    ContadorAcidentesMunicipio tinyint,
    ContadorAcidentesDia tinyint,
    ContadorAcidentesHR tinyint,
    ContadorMarcaAero tinyint,
    ContadorMotivoAcidente tinyint
)
Go

-- Passo 3 Criando as Dimensões --

-- Criando a Dimensão Tempo - DimTime --
CREATE TABLE DimTime
(
    TimeID int Identity(1,1) Not Null Primary Key Clustered,
    Data Date Not Null,
	Hora Time not null,
    Dia tinyint Not Null,
    DiaDaSemana tinyint Not Null,
    DiaDaSemanaPorExtenso Varchar(15) Not Null,
    DiaDoMes tinyint Not Null,
    DiaNoAno smallint Not Null,
    Semana tinyint Not Null,
    SemanaNoMes tinyint Not Null,
    SemanaNoAno tinyint Not Null,
    PrimeiroDiaDaSemana tinyint Not Null,
    UltimoDiaDaSemana tinyint Not Null,
    Mes tinyint Not Null,
    MesPorExtenso Varchar(15) Not Null,
    Quartil tinyint Not Null,
    MesQuartil tinyint Not Null,
    QuartilPorExtenso Varchar(20) Not Null,
    Ano int Not Null,
    AnoPorExtenso Varchar(40) Not Null,
    DataAtual Date Not Null,
    HoraAtual Time Not Null,
    Horas tinyint Not Null,
    Minutos tinyint Not Null,
    Segundos tinyint Not Null,
    FeriadoPorExtenso Varchar(15) Not Null
)
go

-- Criando a Dimensão Onde - DimWhere --
Create Table DimWhere
(
    CodigoLocal int Identity (1,1) Primary Key Clustered not null,
    RegiaoAcidente Varchar (12) Not Null,
    UfAcidente Char(2) Not Null,
    Municipio nvarchar(100) Not Null,
)
Go


-- Criando a Dimensão Quem - DimWho --
Create Table DimWho
(
    CodigoOperador int Identity (1,1) Primary Key Clustered not null, 
    NomeFabricante Varchar (100) Not Null, -- Nome da Instituição da Aeronave --
    NomeOperador nvarchar(255) Not Null, -- Nome do Piloto da Aeronave -- 
)
Go

-- Criando a Dimensão O Que - DimWhat --
Create Table DimWhat
(
    CodigoAcidente int Identity (1,1) Primary Key Clustered not null,
    FaseDaOperacao nvarchar (50) Not Null, -- Tipo de Vôo realizado no Acidente --
    TipoDeOperacao nvarchar (50) Not Null, -- Operação -- 
    DanosAeronave Varchar (20) Not Null, -- Danos a Aeronave -- 
    ModeloAeronave nvarchar (50) Not Null, -- Modelo do Fabricante -- 
)
Go

-- Criando a Dimensão Porquê - DimWhy --
Create Table DimWhy
(
    CodigoMotivoAcidente int Identity (1,1) Primary Key Clustered not null,
    ClassDoAcidente Varchar(20) Not Null, -- Classificação da Ocorrência -- 
    MotivoAcidente Varchar(100) Not Null, -- Descrição do Tipo -- 
)
Go

-- Passo 4 - Criando a Tabela FatoAcidentes e seus Respectivos relacionamentos --
-- Criando a Tabela FatoAcidentes e estabelecendo Métricas (Insira o Nome das Métricas) --
Create Table FatoAcidentes 
(
    CodigoFatoAcidentes BigInt Identity (1,1) Primary Key Clustered not null,
    CodigoAcidente int Null,
    CodigoMotivoAcidente Int Null,
    CodigoOperador Int  Null,
    CodigoLocal Int  Null,
    TimeID Int Null,
	RegiaoAcidente nVarchar (15) Null,
	MunicipioAcidente nVarChar(100) Null,
	UFAcidente Char (02) Null,
    MetricaContadorDeAcidentes Int,
	MetricaRazaoAcidente nVarChar(100) Null,
	MetricaModeloAeronave nVarChar(50) Null
)
Go

--Passo 5
-- Inserção na DimTime
INSERT INTO DimTime (Data, Hora, Dia, DiaDaSemana, DiaDaSemanaPorExtenso, DiaDoMes, DiaNoAno, Semana, SemanaNoMes, SemanaNoAno, PrimeiroDiaDaSemana, UltimoDiaDaSemana, Mes, MesPorExtenso, Quartil, MesQuartil, QuartilPorExtenso, Ano, AnoPorExtenso, DataAtual, HoraAtual, Horas, Minutos, Segundos, FeriadoPorExtenso)
SELECT 
    CONVERT(date, Data_da_Ocorrencia) as Data,
	CONVERT(time, Hora_da_Ocorrencia) as time,
    DAY(Data_da_Ocorrencia) AS Dia,
    DATEPART(WEEKDAY, Data_da_Ocorrencia) AS DiaDaSemana,
    CASE DATEPART(WEEKDAY, Data_da_Ocorrencia)
        WHEN 1 THEN 'Domingo'
        WHEN 2 THEN 'Segunda-feira'
        WHEN 3 THEN 'Terça-feira'
        WHEN 4 THEN 'Quarta-feira'
        WHEN 5 THEN 'Quinta-feira'
        WHEN 6 THEN 'Sexta-feira'
        WHEN 7 THEN 'Sábado'
    END AS DiaDaSemanaPorExtenso,
    DAY(Data_da_Ocorrencia) AS DiaDoMes,
    DATEPART(DAYOFYEAR, Data_da_Ocorrencia) AS DiaNoAno,
    DATEPART(WEEK, Data_da_Ocorrencia) AS Semana,
    DATEPART(WEEK, Data_da_Ocorrencia) AS SemanaNoMes,
    DATEPART(WEEK, Data_da_Ocorrencia) AS SemanaNoAno,
    DATEPART(WEEKDAY, DATEADD(DAY, 1-DATEPART(WEEKDAY, Data_da_Ocorrencia), Data_da_Ocorrencia)) AS PrimeiroDiaDaSemana,
    DATEPART(WEEKDAY, DATEADD(DAY, 7-DATEPART(WEEKDAY, Data_da_Ocorrencia), Data_da_Ocorrencia)) AS UltimoDiaDaSemana,
    MONTH(Data_da_Ocorrencia) AS Mes,
    DATENAME(MONTH, Data_da_Ocorrencia) AS MesPorExtenso,
    DATEPART(QUARTER, Data_da_Ocorrencia) AS Quartil,
    CASE
        WHEN MONTH(Data_da_Ocorrencia) IN (1, 2, 3) THEN 1
        WHEN MONTH(Data_da_Ocorrencia) IN (4, 5, 6) THEN 2
        WHEN MONTH(Data_da_Ocorrencia) IN (7, 8, 9) THEN 3
        WHEN MONTH(Data_da_Ocorrencia) IN (10, 11, 12) THEN 4
    END AS MesQuartil,
    CASE DATEPART(QUARTER, Data_da_Ocorrencia)
        WHEN 1 THEN 'Primeiro Quartil'
        WHEN 2 THEN 'Segundo Quartil'
        WHEN 3 THEN 'Terceiro Quartil'
        WHEN 4 THEN 'Quarto Quartil'
    END AS QuartilPorExtenso,
    YEAR(Data_da_Ocorrencia) AS Ano,
    'Dois mil e Vinte e Quatro' AS AnoPorExtenso,
    CONVERT(DATE, Data_da_Ocorrencia) AS DataAtual,
    CONVERT(TIME, Hora_da_Ocorrencia) AS HoraAtual,
    DATEPART(HOUR, Hora_da_Ocorrencia) AS Horas,
    DATEPART(MINUTE, Hora_da_Ocorrencia) AS Minutos,
    DATEPART(SECOND, Hora_da_Ocorrencia) AS Segundos,
    'Não é feriado' AS FeriadoPorExtenso
FROM AcidenteAeronave
go 

--Inserção DimWhere
Insert into DimWhere (RegiaoAcidente, UfAcidente, Municipio)
select Regiao, UF, Municipio
from AcidenteAeronave
go

--Inserção DimWho
Insert INto DimWho (NomeFabricante, NomeOperador)
select Nome_do_Fabricante, Operador
from AcidenteAeronave
go

--Inserção DimWhat
Insert Into DimWhat(FaseDaOperacao, TipoDeOperacao, DanosAeronave, ModeloAeronave)
select Fase_da_Operacao, Operacao, Danos_a_Aeronave, Modelo
from AcidenteAeronave
go

--Inserção DimWhy
Insert into DimWhy(ClassDoAcidente, MotivoAcidente)
select Classificacao_da_Ocorrencia, Descricao_do_Tipo
from AcidenteAeronave
go

CREATE PROCEDURE InsertAcidentes
AS
BEGIN
    -- Desabilitar a verificação de chave estrangeira temporariamente se necessário
    -- ALTER TABLE Acidentes NOCHECK CONSTRAINT ALL;

    -- Insert Into Acidentes com dados da tabela DimTime
    INSERT INTO FatoAcidentes (CodigoAcidente, CodigoMotivoAcidente, CodigoOperador, CodigoLocal, TimeID, MetricaContadorDeAcidentes)
    SELECT TimeID, TimeID, TimeID, TimeID, TimeID, 1
    FROM DimTime
    WHERE TimeID IS NOT NULL;
    
    -- Insert Into Acidentes com dados da tabela DimWhy
    INSERT INTO FatoAcidentes (MetricaRazaoAcidente)
    SELECT DISTINCT MotivoAcidente
    FROM DimWhy
    WHERE MotivoAcidente IS NOT NULL;
    
    -- Insert Into Acidentes com dados da tabela DimWhat
    INSERT INTO FatoAcidentes (MetricaModeloAeronave)
    SELECT DISTINCT ModeloAeronave
    FROM DimWhat
    WHERE ModeloAeronave IS NOT NULL;

    -- Insert Into Acidentes com dados da tabela DimWhere
    INSERT INTO FatoAcidentes (RegiaoAcidente, MunicipioAcidente, UFAcidente)
    SELECT RegiaoAcidente, Municipio, UfAcidente
    FROM DimWhere
    WHERE RegiaoAcidente IS NOT NULL AND Municipio IS NOT NULL AND UfAcidente IS NOT NULL;

    -- Habilitar a verificação de chave estrangeira novamente se necessário
    -- ALTER TABLE Acidentes CHECK CONSTRAINT ALL;
END;
GO

Exec InsertAcidentes
Go

-- Relacionamentos entre as dimensões e a tabela FatoAcidentes --

Alter Table FatoAcidentes
Add Constraint FK_FatoAcidentes_DimTime_TimeId Foreign Key (TimeID)
References DimTime(TimeID)
Go

Alter Table FatoAcidentes
Add Constraint FK_FatoAcidentes_DimWhere_CodigoLocal Foreign Key (CodigoLocal)
References DimWhere(CodigoLocal)
Go

Alter Table FatoAcidentes
Add Constraint FK_FatoAcidentes_DimWho_CodigoOperador Foreign Key (CodigoOperador)
References DimWho(CodigoOperador)
Go

Alter Table FatoAcidentes
Add Constraint FK_FatoAcidentes_DimWhy_CodigoMotivoAcidente Foreign Key (CodigoMotivoAcidente)
References DimWhy(CodigoMotivoAcidente)
Go

Alter Table FatoAcidentes
Add Constraint FK_FatoAcidentes_DimWhat_CodigoAcidente Foreign Key (CodigoAcidente)
References DimWhat (CodigoAcidente)
Go

Select CodigoFatoAcidentes, CodigoAcidente, CodigoMotivoAcidente, CodigoOperador, CodigoLocal, TimeID, 
           Count(MetricaContadorDeAcidentes) As SomaGeralDeAcidentes,
		   Count(MetricaRazaoAcidente) As SomaGeralDeAcidentesRealizados,
		   Count(MetricaModeloAeronave) As SomaGeralDeAcidentesRealizadosPorUF
From FatoAcidentes
Group By CodigoFatoAcidentes, CodigoAcidente, CodigoMotivoAcidente, CodigoOperador, CodigoLocal, TimeID
Order By CodigoFatoAcidentes, CodigoAcidente, CodigoMotivoAcidente, CodigoOperador, CodigoLocal, TimeID
Go

Select Min(MetricaContadorDeAcidentes) As MenorQntDeAcidentesPorRegiao, Max(MetricaContadorDeAcidentes) As MaiorQntDeAcidentesPorRegiao
From FatoAcidentes
Group By CodigoFatoAcidentes
Go

Select MetricaRazaoAcidente, MetricaModeloAeronave
From FatoAcidentes
Where MetricaModeloAeronave Is Not Null And MetricaRazaoAcidente is Not Null
Go