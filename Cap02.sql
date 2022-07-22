
-- Criar Banco de Dados
-- MDF/NDF : MasterDataFile / LDF : LogDataFile

Create Database Curso On
  (Name = 'DadosCurso', 
   FileName = 'c:\bd\dadoscurso.mdf', 
   Size = 10, MaxSize = 100)
Log On
  (Name = 'LogCurso', 
   FileName = 'c:\bd\dadoslog.ldf', 
   Size = 5, MaxSize = 50)

-- Opções

Select SERVERPROPERTY('')
sp_dboption

-- Criar Tabela (+ Performance)

Use Curso

Create Table Alunos (Cod Int, Nome Varchar(30))
Insert Into Alunos (Cod, Nome) Values (1, 'Joao')

Dbcc Showcontig (Alunos)

-- Filegroups

sp_helpfilegroup   -- exibi filegroups

Alter Database Curso Add Filegroup RH

Alter Database Curso Add File
  (Name = 'DadosRH', 
   Filename = 'c:\bd\dadosrh.ndf', 
   Size = 10) To Filegroup RH

select * from sys.sysfiles  -- arquivos

-- Nova Tabela RH

Create Table Funcionarios 
   (cod int, nome char(5000)) on RH

declare @ict int
set @ict = 5001
while @ict < 100000
begin
  insert into Funcionarios (cod, nome)
     values (@ict, 'A')
  set @ict = @ict + 1
end

dbcc showcontig(Funcionarios)

-- Informação de UM objeto qualquer 
select * from sys.objects
  where object_id = object_id('Funcionarios')

-- Informações de UMA tabela e INDICES dela
select * from sys.indexes
  where object_id = object_id('Funcionarios')

-- Banco de Snapshot (backup online)

Create Database CursoProducao On
  (Name = 'DadosCursoProd', 
   FileName = 'c:\bd\dadoscursoProd.mdf', 
   Size = 10, MaxSize = 100)
Log On
  (Name = 'LogCursoProd', 
   FileName = 'c:\bd\dadoslogProd.ldf', 
   Size = 5, MaxSize = 50)

Use CursoProducao

Create Table Clientes 
     (Cod Int Not Null Primary Key,
      Nome Varchar(40))

Insert Into Clientes(Cod, Nome) Values (1, 'Joao')
Insert Into Clientes(Cod, Nome) Values (2, 'Maria')
Insert Into Clientes(Cod, Nome) Values (3, 'Carlos')
Insert Into Clientes(Cod, Nome) Values (4, 'Sandra')

Select * From Clientes 

-- Criação do Snapshot

Create Database Versao2107_2126 On
  (Name = 'DadosCursoProd', FileName = 'c:\bd\back.ss')
    As Snapshot Of CursoProducao 

Select * From CursoProducao.dbo.Clientes
Select * From Versao2107_2126.dbo.Clientes

Update Clientes Set Nome = 'Maria Silva' Where Cod = 2
Delete From clientes Where cod = 4
Insert Into Clientes(Cod, Nome) Values (5, 'Gabriel')

Use Master

Restore Database CursoProducao 
  From Database_Snapshot = 'Versao2107_2126'

Drop Database Versao2107_2126

Begin Transaction
--
--
--
-- Commit 
   
-- Alterações (Aumentar)

Alter Database Curso Modify File
  (Name = 'DadosCurso', Size = 300)

-- Diminuir

DBCC ShrinkDatabase(Curso)   -- Reorganizar e Cortar
DBCC ShrinkDatabase(Curso, NoTruncate)   -- Reorganizar
DBCC ShrinkDatabase(Curso, Truncateonly) -- Cortar
