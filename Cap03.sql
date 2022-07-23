
-- Indices

Create Table Clientes (Cod Int Not Null,
                       Nome Varchar(40))

Insert Into Clientes (Cod, Nome) Values (1,	'A')
Insert Into Clientes (Cod, Nome) Values (2,	'D')
Insert Into Clientes (Cod, Nome) Values (3,	'B')
Insert Into Clientes (Cod, Nome) Values (4,	'C')

Alter Table Clientes 
   Add Constraint pkCli Primary Key(Cod)

Create NonClustered Index idxNome On Clientes(Nome)

Drop Index Clientes.idxNome

-- Tipos de Varredura
-- Table Scan [Nenhum Indice] : Varre a tabela TODA
-- Index Scan [Existe um Indice ] : Varre o indice TODO 
-- Index Seek [Mais Eficiente] : Varre parte do Indice

Select * From Clientes Order By Nome 
Select * From Clientes Where Cod > 0
Select * From Clientes Where Nome = 'A'
Select Nome From Clientes Where Nome = 'A'
Select * From Clientes Where Nome <> 'F'

-- Informações de Indices

Select *
  From sys.dm_db_index_physical_stats(db_id('curso'),
                                      object_id('Clientes'),
									  null, null, 'sampled')

Select *
  from sys.dm_db_index_usage_stats
    where object_id = object_id('Clientes')

Set DateFormat DMY
Select * From Clientes Where dtcadastro > '31/10/2021'

-- Composto + 1 coluna
-- Unique Index : Dados não repetem
-- Include : Colocar + colunas, mas não são indexadas

-- Locks
-- S : Shared
-- X : eXclusive

sp_lock

Begin Transaction
update clientes set nome = 'Joao22' where cod = 4

update alunos set nome = 'Joao22' where cod = 4

rollback 
commit

-- nivel de isolamento transacional

Set Transaction Isolation Level ReadCommitted    -- Default
Set Transaction Isolation Level ReadUnCommitted  -- Leitura Suja

-- Dirty Read (Leitura Suja = Update) (Phanton = Insert)
select *  from clientes with (nolock) where cod = 2

-- tempo maximo de espera de lock

set lock_timeout -1   -- default sem limite, senão em milisegundos

-- deadlock

-- Travamento simultaneo de dois lados (1 cai)






