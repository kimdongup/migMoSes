sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ad Hoc Distributed Queries', 1;
GO
RECONFIGURE;
GO
exec sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE;
GO

sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO


-- << 기본세팅 >>
use master 
go

  /*=============================================== */
  /* Import Group file                              */
  /*=============================================== */
  exec sp_d01_setting_group 'I:\MSDB\src\' -- @p_setPath: DB서버경로

  /*=============================================== */
  /* Import column_mapping file                     */
  /*=============================================== */
  exec sp_d01_setting_column_mapping_nonvar 'I:\MSDB\src\' -- @p_setPath: DB서버경로
  go
  exec sp_d01_setting_column_mapping_var 'I:\MSDB\src\' -- @p_setPath: DB서버경로
  go
