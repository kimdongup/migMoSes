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
-- Description: Import Data grossup factor
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d01_setting_grossupFactor]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d01_setting_grossupFactor];
GO

CREATE PROCEDURE [dbo].[sp_d01_setting_grossupFactor]
  @p_yymm            VARCHAR(4),       -- YYMM
  @p_basis           VARCHAR(50),      -- basis : fc / mcev
  @p_setPath         VARCHAR(1000),    -- setting table 경로
  @p_grossupFileName VARCHAR(1000)     -- grossup file 명
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d01_setting_grossupFactor                                                    */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d01_setting_grossupFactor script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

  DECLARE
      @tableName       VARCHAR(1000),  -- 테이블명
      @sqlInsertTable  VARCHAR(max),   -- 테이블 insert문
      @sqlDropTable    VARCHAR(max),   -- 테이블 drop문
      @sqlCreateIndex  VARCHAR(max),   -- 테이블 index create문
      @DBType          VARCHAR(500),   -- DB타입
      @inputPath       VARCHAR(1000),  -- input 경로
      @indexName       VARCHAR(1000)   -- index 명

  SET @tableName = 'tbl_' + @p_yymm + '_' + @p_basis + '_grossup_factor'
  SET @inputPath = @p_setPath
  SET @DBType = 'Microsoft.Jet.OLEDB.4.0'
  SET @indexName = 'idx_grossup_factor'
  SET @sqlDropTable = 'drop table [master].[dbo].[' + @tableName + ']'
  PRINT 'import grossup factor table: '

  
  BEGIN TRY 
    PRINT @sqlDropTable
    EXEC(@sqlDropTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  --file upload
  SET @sqlInsertTable = 'select distinct rtrim(ltrim(type)) as type, rtrim(ltrim(factor)) as factor, cast(rate as float) as rate into [master].[dbo].[' + @tableName + '] from openrowset('''
                        + @DBType + ''',''Excel 8.0;Database=' + @inputPath + @p_grossupFileName + ';HDR=YES'',''select * from [grossup$]'')'

  PRINT @sqlInsertTable
  EXEC(@sqlInsertTable)

  --index 생성
    SET @sqlCreateIndex= 'CREATE INDEX '+ @indexName +
    ' ON [master].' + '[dbo].[' +  @tableName + ']([type],[factor] ASC)
    WITH(
        PAD_INDEX = ON
      , FILLFACTOR = 50
      )'

  PRINT(@sqlCreateIndex)
  PRINT('인덱스' + @indexName + '가 생성 되었습니다')
  EXEC(@sqlCreateIndex)

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d01_setting_grossupFactor end                                                */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d01_setting_grossupFactor script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

END

SET ANSI_PADDING OFF
GO
