USE master
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- =============================================
-- Author:    SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description: Import Data group
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d01_setting_group]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d01_setting_group];
GO

CREATE PROCEDURE [dbo].[sp_d01_setting_group]
  @p_setPath VARCHAR(1000)     -- setting table 경로
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d01_setting_group                                                            */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d01_setting_group script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

  DECLARE
      @tableName VARCHAR(1000),       --테이블명
      @sqlInsertTable  VARCHAR(max),  --테이블 insert문
      @sqlDropTable    VARCHAR(max),  --테이블 drop문
      @sqlCreateIndex  VARCHAR(max),  --테이블 index create문
      @DBType    VARCHAR(500),        --DB 타입
      @inputPath VARCHAR(1000),       --input 경로
      @indexName VARCHAR(1000),       --index 명
      @inputDataName varchar(1000)    --Input Data 명


  SET @tableName = 'tbl_group'
  SET @inputPath = @p_setPath
  SET @DBType = 'Microsoft.Jet.OLEDB.4.0'
  SET @inputDataName = 'group.xls'
  SET @sqlDropTable = 'drop table [master].[dbo].[' + @tableName + ']'



  BEGIN TRY 
    PRINT @sqlDropTable
    EXEC(@sqlDropTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  
  PRINT 'import group table: '

  SET @sqlInsertTable = 'select * into [master].[dbo].[' + @tableName + '] from openrowset('''
                        + @DBType + ''',''Excel 8.0;Database=' + @inputPath + @inputDataName + ';HDR=YES'',''select group_no, group_name, group_script, file_name, sheet_name from [group$]'')'

  PRINT @sqlInsertTable
  EXEC(@sqlInsertTable)


  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d01_setting_group end                                                        */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d01_setting_group script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';


END

SET ANSI_PADDING OFF
GO
