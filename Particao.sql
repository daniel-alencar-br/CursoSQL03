
-- Tabelas

Create Table Clientes
   (cod int not null primary key, nome char(500)) 

Create NonClustered Index idxNome On Clientes(nome)

Create Table Alunos
   (cod int not null primary key, nome char(500)) 

Create NonClustered Index idxNome2 On Alunos(nome)


declare @ict int
set @ict = 1
while @ict < 5000
begin
  insert into Clientes (cod, nome)
     values (@ict, Concat('A', CONVERT(char(100), @ict)))
  set @ict = @ict + 1
end
Go
declare @ict int
set @ict = 1
while @ict < 5000
begin
  insert into Alunos (cod, nome)
     values (@ict, Concat('A', CONVERT(char(100), @ict)))
  set @ict = @ict + 1
end

-- Ver Fragmentação

dbcc showcontig(Clientes)

dbcc showcontig(Clientes, idxNome)

dbcc showcontig(Alunos)

dbcc showcontig(Alunos, idxNome2)

-- Defragmentar

Alter Index idxNome on Clientes Reorganize 

Alter Index idxNome on Clientes Rebuild

Alter Index idxNome on Clientes 
  Rebuild With (FillFactor = 50)

-- Truncar Log

dbcc shrinkfile(Curso)
dbcc shrinkfile(Curso_Log)

-- Particionar Tabela
-- filegroup e campo de data

Alter Database Curso Add Filegroup Historico

Alter Database Curso Add File
  (Name = 'DadosHist', 
   Filename = 'c:\bd\dadoshist.ndf', 
   Size = 10) To Filegroup Historico

Alter Table Clientes 
  Add DtCadastro DateTime Not Null Default GetDate()
  
Update Clientes 
  Set DtCadastro = GetDate() - 
    ((Select Max(Cod) From Clientes) - Cod)

-- função de particionar os dados Horizontalmente

Create Partition Function Historico (datetime)  
  As Range Right For Values ('2022-01-01')

Create Partition Scheme ListaLocais
  As Partition Historico
    To (Historico, [Primary]);  

Alter Table Clientes Drop Constraint xxx

Alter Table Clientes Add Constraint pkCli 
  Primary Key Clustered (dtCadastro)
	On ListaLocais(dtCadastro)

 