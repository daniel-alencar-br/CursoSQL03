
-- Fragmentação de Tabelas / Indices

Dbcc ShowContig ()   //  Alter Index Reorganize / Rebuild

-- Concorrencia de Acesso

sp_lock -- Intencional, eXclusive...

-- Qtd atividades simultanea

Backup  == Fechamento

-- Otimização das Consultas

- Normalizado / PK / FK / Tabelas Segmentadas (criação)

- Estatisticas
- Indices  (qtd adequada)
- Select Col1, Col2 (evitar *)
- Where (qdo possível)
- Like (evitar)  / Ex. utilizar LINQ .Net
- Criar Procedures para rotinas frequentes

select * from pedidos 

sp_who

- Transaction (evitar longas)

-- Mensagens  (DtEvento) 
-- UltMengDia  01/07/2022 - 12345656757
--             02/07/2022 - 12345898977
--Begin Tran
--	............. where cod < 12345898977
--Commit

-- DMV : Dynamic Management View (desde o ultimo restart)

select * from sys.dm_db_index_usage_stats

- Maiores Tabelas
  


  Select * From Sys.sysindexes
    Where indid = 1

- Select... 
    Where C

-- Lista de Maiores Tabelas

Select O.Name As Nome, (I.dpages * 8) as KB
  From sys.objects O inner join Sys.sysindexes I
       On O.object_id = I.id
    Where type_desc = 'USER_TABLE' and
                      I.indid = 1   -- PK (Tabela)
      Order By KB Desc

















