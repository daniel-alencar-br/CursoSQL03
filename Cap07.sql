
-- Mensagens personalizadas

select * from sys.sysmessages
Go

sp_addmessage 50001, 1, 'Erro...'

-- Tarefas mais comuns

-- Backup (Full, Diferencial, Log)
-- Shrink Log
-- Atualização de Tabelas
-- Atualizar Estatistica
-- Rebuild / Reorganize de Indices
-- Recompilação de Procedures
Go

sp_updatestats 
sp_recompile 

-- Estatisticas
-- AutoCreateStatistics : Ligado
-- AutoUpdateStatistics : Desligado

Create Table Alunos (Cod Int Not Null Primary Key,
                     Estado Char(2), Cidade Varchar(20))

Insert Into Alunos (Cod, Estado, Cidade) Values (1, 'SP', 'São Paulo')
Insert Into Alunos (Cod, Estado, Cidade) Values (2, 'SP', 'Araraquara')
Insert Into Alunos (Cod, Estado, Cidade) Values (3, 'SP', 'Ourinhos')
Insert Into Alunos (Cod, Estado, Cidade) Values (4, 'SP', 'Santo André')
Insert Into Alunos (Cod, Estado, Cidade) Values (5, 'RJ', 'Rio de Janeiro')
Insert Into Alunos (Cod, Estado, Cidade) Values (6, 'RJ', 'Petropolis')
Insert Into Alunos (Cod, Estado, Cidade) Values (7, 'RJ', 'Campos')
Insert Into Alunos (Cod, Estado, Cidade) Values (8, 'AM', 'Manaus')

-- Ver estatisticas (NAME LIKE _WA_Sys_000...) e indices
Select * From Sys.sysindexes Where id = OBJECT_ID('Alunos')

-- Cria baseado na clausula WHERE
Select * From Alunos Where Estado = 'SP'
Select * From Alunos Where Cidade = 'Campos'

-- Exibe as estatisticas de uma tabela
dbcc show_statistics ('alunos', _WA_Sys_00000002_5BE2A6F2)
dbcc show_statistics ('alunos', _WA_Sys_00000003_5BE2A6F2)

-- Atualiza as estatisticas
sp_updatestats


