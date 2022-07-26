
-- Hot (quente) Backup 
-- Estratégia Backup => Estratégia Restore

-- Opção de BD : Simple (DADOS) / Full (DADOS / LOG)

-- Full : Completo
-- Arquivo de Backup PODE conter vários Backups

Backup Database Producao 
  To Disk = 'C:\BD\Backup\Back2507.bak'

Backup Database Curso
  To Disk = 'C:\BD\Backup\Back2507.bak'

Backup Database Curso
  To Disk = 'C:\BD\Backup\Back2507.bak'
    With Differential

Backup Log Curso
  To Disk = 'C:\BD\Backup\Back2507.bak'

-- Backup de Copia (Full que não interfere na sequencia)

Backup Database Curso
  To Disk = 'C:\BD\Backup\Back2507.bak'
    With Copy_Only

-- Ver arquivo a ser restaurado (backups / valido / arquivos)

Restore HeaderOnly From Disk = 'C:\BD\Backup\Back2507.bak'

Restore VerifyOnly From Disk = 'C:\BD\Backup\Back2507.bak'

Restore FileListOnly From Disk = 'C:\BD\Backup\Back2507.bak'
  With File = 4   -- ver 4° backup
-- Arquivos Fisicos sempre voltam para o mesmo local

-- Restaurar BD (banco completo)

Restore Database Producao 
  From Disk = 'C:\BD\Backup\Back2507.bak'
    With File = 3   -- SE TIVER + QUE UM

Restore Database Producao 
  From Disk = 'C:\BD\Backup\Back2507.bak'
    With File = 3, Replace   -- Substitui o banco mesmo sem backup de log

-- Restauração a terminar

Restore Database Curso 
  From Disk = 'C:\BD\Backup\Back2507.bak'
    With File = 4, NoRecovery   -- Restaura e AINDA FALTA

Restore Database Curso 
  From Disk = 'C:\BD\Backup\Back2507.bak'
    With File = 5, Recovery   -- Restaura e TERMINA

-- Restaurar um banco de DEV (Banco NOVO)

Restore FileListOnly From Disk = 'C:\BD\Backup\Back2507.bak'
  With File = 3

Restore Database ProducaoDEV
  From Disk = 'C:\BD\Backup\Back2507.bak'
    With File = 3,
	     Move 'Producao' To 'D:\DEV\Producao.mdf',
		 Move 'Producao_log' To 'D:\DEV\Producao.ldf'

-- Restaurar sem ter o caminho original

Backup Database ProducaoDEV 
  To Disk = 'C:\BD\Backup\BackDEV2507.bak'

-- Apaga a pasta DEV

Restore FileListOnly From Disk = 'C:\BD\Backup\BackDEV2507.bak'
  
Restore Database ProducaoDEV 
  From Disk = 'C:\BD\Backup\BackDEV2507.bak'
    With Move 'Producao' To 'D:\DEV2\Producao.mdf',
		 Move 'Producao_log' To 'D:\DEV2\Producao.ldf'

-- With Filegroup = 'atual'
-- With Restart               -- TALVEZ continue pós problema
-- With CheckSum              -- CONFIRMA Consistencia
-- With Password = 'abc'	  -- Senha Back/Restore

-- Estudo de Caso

Create Table Alunos (Cod Int, Nome Varchar(50))

Insert Into Alunos (Cod, Nome) Values (1, 'Joao')

Backup Database Producao
  To Disk = 'C:\BD\Backup\BackProdFull.bak'  -- Apenas 01

Insert Into Alunos (Cod, Nome) Values (2, 'Maria')

Backup Database Producao
  To Disk = 'C:\BD\Backup\BackProDiff.bak'  -- Até o 02
    With Differential

Insert Into Alunos (Cod, Nome) Values (3, 'Carlos')  -- 21:21
Insert Into Alunos (Cod, Nome) Values (4, 'Manoel')  -- 21:22

Backup Log Producao
  To Disk = 'C:\BD\Backup\BackLog.bak'		-- Até o 04

-- Banco foi para o Vinagre

-- Quais as POSSIBILIDADES de Restore??????

-- 1° Opção (Apenas o Full)

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProdFull.bak'

Select * From Producao.dbo.Alunos 

-- 2° Opção (Restaurar o Full + Diferencial)

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProdFull.bak'
    With NoRecovery

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProDiff.bak'
    With Recovery

Select * From Producao.dbo.Alunos 

-- 3° Opção (Restaurar o Full + Diferencial + Log)

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProdFull.bak'
    With NoRecovery

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProDiff.bak'
    With NoRecovery

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackLog.bak'   -- Pode ter + que um
    With Recovery

Select * From Producao.dbo.Alunos 

-- 4° Opção (Restaurar o Full + Diferencial + 
--           Log ATÉ CERTO PONTO NO TEMPO, EVITANDO O CRASH )

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProdFull.bak'
    With NoRecovery

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackProDiff.bak'
    With NoRecovery

Set Dateformat DMY

Restore Database Producao
  From Disk = 'C:\BD\Backup\BackLog.bak'
    With Recovery, StopAt = '25/07/2022 21:21:59'

Select * From Producao.dbo.Alunos 
