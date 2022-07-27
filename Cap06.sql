
-- DDL (Create, Alter, Drop)
-- DML (Select, Update, Delete, Insert)
-- DCL (Grant, Deny, Revoke)

Grupo1 ->  Tabela1 (G)
  |
User1  ->  Tabela1 (D)   -- Explicita é prioritaria

-- Sequencia de Acesso

-- Login de acesso a instancia
Create Login Carlos 
  With Password = '123', Check_Policy = Off

-- Usuário de acesso ao BD
Create User Carlos For Login Carlos

-- Grupo de permissões de um BD
Create Role Vendedores

-- Conceder permissão para uma tabela ao grupo
Grant Select On Pedidos To Vendedores

-- Incluir usuário no grupo
Alter Role Vendedores Add Member Carlos

-- Restrição linhas (gambiarra)

Create View....
  Select... Where <>

-- Funcão de Acesso Condicional

Create Table VendasPorEstado(Cod int, Estado varchar(2), Qtd Int)

Insert Into VendasPorEstado (Cod, Estado, Qtd) Values (1, 'MG', 10)
Insert Into VendasPorEstado (Cod, Estado, Qtd) Values (2, 'MG', 20)
Insert Into VendasPorEstado (Cod, Estado, Qtd) Values (3, 'AM', 30)
Insert Into VendasPorEstado (Cod, Estado, Qtd) Values (4, 'AM', 40)

Create User MG Without Login
Create User AM Without Login

Grant Select On VendasPorEstado To MG
Grant Select On VendasPorEstado To AM
Go

-- Criar Esquema

Create Schema Schema_Vendas
Go

Create Function Schema_Vendas.FN_SecurityPredicate(@Usuario As Varchar(2))
  Returns Table With SchemaBinding As
    Return Select 1 As FN_SecuritPredicate_Result
	  Where @Usuario = User_Name()
Go

Create Security Policy Schema_Vendas.FiltroEstado
  Add Filter Predicate Schema_Vendas.FN_SecurityPredicate(Estado)
    On dbo.VendasPorEstado
	  With (State = On)
Go

-- Executar

Execute As User = 'MG';
Select * From VendasPorEstado
Revert

Execute As User = 'AM';
Select * From VendasPorEstado
Revert
