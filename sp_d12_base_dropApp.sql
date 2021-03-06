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
IF OBJECT_ID ('[dbo].[sp_d12_base_dropApp]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_dropApp];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_dropApp]
	@p_dataBaseName    varchar(100),   -- database 명
	@p_type varchar(50),               -- run type : if / 1ynb / 1mnb
	@p_app  varchar(3)                 -- application 명
AS
begin
  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d12_base_dropApp                                                             */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'Begin sp_d12_base_dropApp script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';
				
	DECLARE 
	  @DataBaseName VARCHAR(200), --데이터베이스명
		@talbeName VARCHAR(200),    --테이블명
		@sqlDropTable  VARCHAR(max) --테이블 insert문
	    	    
	SET @DataBaseName = @p_dataBaseName
	SET @talbeName = 'tbl_' + @p_app + '_temp_' + @p_type
	
	PRINT 'drop ' + @talbeName + ': '	
	
	SET @sqlDropTable = 'drop table [' + @DataBaseName + '].[DBO].[' + @talbeName + ']'							
	PRINT @sqlDropTable
	EXEC(@sqlDropTable)
	
  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d12_base_dropApp end                                                         */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'End sp_d12_base_dropApp script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';
	
END
	
SET ANSI_PADDING OFF
GO	
