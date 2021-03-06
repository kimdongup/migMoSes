USE master
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- =============================================
-- Author:		SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description:	Import Data by app
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d12_base_importComm]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_importComm];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_importComm]
	@p_dataBaseName VARCHAR(100),            -- database 명
	@p_type         VARCHAR(50),           -- run type : if / 1ynb / 1mnb
	@p_inputPath    VARCHAR(100),          -- input 경로
	@p_app          VARCHAR(4)             -- application 명
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_importComm                                                          */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d12_base_importComm script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
			
	DECLARE 
	    @DataBaseName VARCHAR(200),      --데이터베이스명
		  @tableName VARCHAR(200),         --테이블명
		  @sqlInsertTable  VARCHAR(5000),  --테이블 insert문
	    @DBType    VARCHAR(100),         --DB 타입
	    @inputPath VARCHAR(100),         --input 경로
	    @inputDataName varchar(200),     --Input Data 명
	    @sqlDropTable varchar(500),      --drop sql
	    @alterColumns varchar(100)       --컬럼명변경(column : group)
	    
	SET @DataBaseName = @p_dataBaseName
	SET @tableName = 'tbl_' +  @p_app + '_temp_' + @p_type
	SET @inputPath = @p_inputPath
	SET @DBType = 'VFPOLEDB'
	SET @inputDataName = @p_app + '_CF~MAIN.DBF'			
	SET @alterColumns = '[' + @DataBaseName + '].[dbo].[' + @tableName + '].[group]'	
	SET @sqlDropTable = 'DROP TABLE [' + @DataBaseName + '].[dbo].[' + @tableName + ']'
	
  BEGIN TRY 
    EXEC(@sqlDropTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  
	PRINT 'import ' + @p_app + ': [' + @DataBaseName + '].[dbo].[' + @tableName + '] 생성'	
	
	SET @sqlInsertTable = 'select * into [' + @DataBaseName + '].[dbo].[' + @tableName + '] from openrowset('''
	                    + @DBType + ''',''' + @inputPath + @inputDataName + ''';'''';'''',''select * from ' + @p_app +'_CF~MAIN'')'
                        
	--SET @sqlInsertTable = 'Insert into [' + @DataBaseName + '].[dbo].[' + @tableName + '] select ''' + @p_type + ''' as type,* from openrowset('''
	--                      + @DBType + ''',''' + @inputPath + @inputDataName + ''';'''';'''',''select * from ' + @p_app +'_CF~MAIN'')'	


  BEGIN TRY 
	  PRINT @sqlInsertTable  
	  EXEC(@sqlInsertTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
	--MESSAGE:  주의: 개체 이름 부분을 변경하면 스크립트 및 저장 프로시저를 손상시킬 수 있습니다. .. 무시해도 됨.
  -- 컬럼명이 group 이면 예약어로 인식하여 다른 쿼리에서 에러가 발생한다. 그래서 컬럼명을 groupkey 로 바꿔주었음.      
  BEGIN TRY 
  print @alterColumns  
  exec sp_rename @alterColumns, 'groupkey', 'COLUMN'; 
	END TRY 

  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
    
  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_importComm end                                                      */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d12_base_importComm script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
	
	
END
	
SET ANSI_PADDING OFF
GO	
