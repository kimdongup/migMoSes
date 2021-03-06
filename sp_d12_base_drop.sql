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
-- Description:	Drop table by app
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d12_base_drop]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_drop];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_drop]
	@p_dataBaseName VARCHAR(100)  -- database 명	
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_drop                                                                */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d12_base_drop script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
			
	DECLARE 
	  @DataBaseName VARCHAR(200),    --데이터베이스명
		@talbeName VARCHAR(200),   --테이블명(from)
		@sqlDropTable  VARCHAR(max) --테이블 insert문
	    	    
	SET @DataBaseName = @p_dataBaseName
	SET @talbeName = 'tbl_cf_temp'		
	
	SET @sqlDropTable = 'drop table [' + @DataBaseName + '].[DBO].[' + @talbeName + ']'							
	PRINT @sqlDropTable
	EXEC(@sqlDropTable)
	
  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_drop end                                                            */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d12_base_drop script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

END
	
SET ANSI_PADDING OFF
GO	
