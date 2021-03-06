use master
go

set ansi_nulls on
go

set quoted_identifier on
go

set ansi_padding on
go
-- ===========================================================================================
-- Author:    SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description:
-- ===========================================================================================
if object_id ('[dbo].[sp_d01_setting_creatDB]', 'P') is not null
  drop procedure [dbo].[sp_d01_setting_creatDB];
go

create procedure [dbo].[sp_d01_setting_creatDB]
          @p_yymm             varchar(4),           -- YYMM
          @p_basis            varchar(50),          -- basis : fc / mcev
          @p_basis_subname    varchar(50),          -- database name
          @p_subname          varchar(50)           -- subname

as
begin
  declare @DataBaseName    varchar(200),       -- 데이터베이스명
          @sqlCreateDataBase varchar(200),       -- 데이터베이스생성 sql
          @sqlDropDataBase   varchar(200)        -- 데이터베이스drop sql

  if(@p_basis_subname = '')  
    set @DataBaseName =  '[DB_' + @p_yymm + '_' + @p_basis + '_' + @p_subname + ']'
  else
    set @DataBaseName =  '[DB_' + @p_yymm + '_' + @p_basis + '_' + @p_basis_subname + '_' + @p_subname + ']'
    
  set @sqlCreateDataBase = 'create database ' + @DataBaseName
  set @sqlDropDataBase = 'drop database ' + @DataBaseName

  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d01_setting_creatDB                                                          */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'Begin sp_d01_setting_creatDB script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';


  begin

    begin try
      --데이터베이스 초기화
      exec(@sqlDropDataBase)
      print 'drop database ' + @DataBaseName
      print ' ';
    end try

    begin catch
      SELECT ERROR_NUMBER()  AS ERROR_NUMBER
           , ERROR_LINE()    AS ERROR_LINE
           , ERROR_MESSAGE() AS ERROR_MESSAGE
    end catch
    
    --데이터베이스 생성
    exec(@sqlCreateDataBase)
    print 'create database ' + @DataBaseName    

  end

  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d01_setting_creatDB end                                                      */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'End sp_d01_setting_creatDB script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';
end