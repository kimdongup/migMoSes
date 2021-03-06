USE master
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*- ================================================================================
-- Author:    SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description: insert Data
-- ================================================================================= */
IF OBJECT_ID ('[dbo].[sp_d32_out_insert]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d32_out_insert];
GO

CREATE PROCEDURE [dbo].[sp_d32_out_insert]
  @p_outputPath_d          varchar(max),    -- output 경로 상세  
  @p_dataBaseName          varchar(max),    -- dataBaseName 명
  @p_loadTable             varchar(max),    -- load table
  @p_file                  varchar(300),    -- excel file 컬럼 (where 조건절)
  @p_sheet                 varchar(300),    -- excel sheet 컬럼 (where 조건절)
  @p_excelFile             varchar(300),    -- excel file
  @p_excelSheet            varchar(300),    -- excel sheet
  @p_var_dvsn              varchar(6)       -- var dvsn : var / nonvar 
AS
BEGIN

  PRINT '/* ==== sp_d32_out_insert ====================================================== */';  
  IF(@p_var_dvsn = 'nonvar')        
		 EXEC dbo.sp_d32_out_insert_nonvar @p_outputPath_d,@p_dataBaseName,@p_loadTable,@p_file,@p_sheet,@p_excelFile,@p_excelSheet
  IF(@p_var_dvsn = 'var')
     EXEC dbo.sp_d32_out_insert_var @p_outputPath_d,@p_dataBaseName,@p_loadTable,@p_file,@p_sheet,@p_excelFile,@p_excelSheet
  PRINT '/* ==== sp_d32_out_insert end =================================================== */';

END

SET ANSI_PADDING OFF
GO

