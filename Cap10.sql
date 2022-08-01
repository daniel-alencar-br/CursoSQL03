
-- Trigger (Insert, Update, Delete)

-- DDL Trigger (Create, Alter, Drop)

Create Trigger NaoCriaTabela On Database  -- On All Server
  For Create_Table, Drop_Table As
Begin
  Raiserror('Não pode criar/apagar tabela', 16, 1)
  Rollback
End

Create Table ABC (Cod Int)  / Drop Table ABC

Drop Trigger NaoCriaTabela On Database 

-- Trigger que pega qualquer evento DDL no BD

Go

-- Log para guardar eventos DDL

Create Table LogEventos (cod int identity(1, 1), dataevento datetime,
                         usuario varchar(100), evento varchar(100), 
						 comando varchar(1000))

Go

Create Trigger AuditoriaDB On Database For DDL_Database_Level_Events As
Begin
  declare @dados XML
  set @dados = EVENTDATA()
  
  Insert Into LogEventos (dataevento, usuario, evento, comando)
    Values (GETDATE(), SUSER_NAME(), 
	        @dados.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(100)'),
			@dados.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'varchar(1000)'))

End

create table nova (cod int)
create view vnova as select * from nova
drop view vnova

select * from LogEventos

-- Tarefas de DBA / Analista de Dados

* Backup (Diario, Semanal, Por Hora)
- Analise de Logs
* Disco enchendo (BD, Arq. Log, Temp DB)
* Shrink qdo necessário
- Updates, Paths ????
* Fragmentação Indices / Tabelas
- Indices necessários ???
- Analise Fisica 
- Planejamento de capacidade
- Conectividades entre servidores (ex. trocou a senha de dominio)
- Sincronização de Horario
* Replicação ???
- Excesso de Locks ???
- Rotinas extremamente pesadas ???
- Particionamentos ???











