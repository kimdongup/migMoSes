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
-- Description:	index key 추가
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d12_base_insertRslt]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_insertRslt];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_insertRslt]
	@p_from_dataBaseName VARCHAR(100),  -- from database 명	
  @p_to_dataBaseName VARCHAR(100)   -- to database 명	
  
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_insertRslt                                                          */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d12_base_insertRslt script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
  
	DECLARE 	    
		  @toTableName     VARCHAR(200),    -- 테이블명
		  @sqlInsertTable  VARCHAR(max),    -- 테이블 insert문
	    @fromTableName   VARCHAR(200),    -- Input Data 명
	    @sqlDropTable    VARCHAR(500),    -- drop sql
      @indexName       VARCHAR(200),    -- INDEX 명
	    @sqlCreateIndex  VARCHAR(max)     -- 테이블 index create문
      	    	
	SET @toTableName = 'tbl_CF'
	SET @fromTableName = 'tbl_CF_temp'
	SET @indexName = 'idx_CF'
  SET @sqlDropTable = 'DROP TABLE [' + @p_to_dataBaseName + '].[dbo].[' + @toTableName + ']'
  
  BEGIN TRY 
    EXEC(@sqlDropTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  
	PRINT 'Add index key: '	
	
	SET @sqlInsertTable = 'select rtrim(substring(groupkey,5,64))as factor,
							rtrim(substring(groupkey,1,3))as appl,
							rtrim(substring(groupkey,5,2))as channel,
							rtrim(substring(groupkey,8,4))as lob,
							rtrim(substring(groupkey,13,3))as nlob,
							rtrim(substring(groupkey,17,3))as prod,
							rtrim(substring(groupkey,21,1))as br,
							rtrim(substring(groupkey,23,2))as rs,
							rtrim(substring(groupkey,26,3))as sfas,
							rtrim(substring(groupkey,30,5))as cohort,
							rtrim(substring(groupkey,36,3))as div,
							case when rtrim(substring(groupkey,13,3)) = ''wol''  then ''wol''
								 when rtrim(substring(groupkey,13,3)) in (''hlt'',''acc'',''ltc'') then ''hal''
								 when rtrim(substring(groupkey,13,3)) in (''end'',''rok'',''rof'') then ''end''
								 when rtrim(substring(groupkey,13,3)) in (''dan'',''ian'',''nic'') then ''ann''
								 when rtrim(substring(groupkey,13,3)) in (''eia'',''eie'') then ''ein'' 
								 when rtrim(substring(groupkey,13,3)) in (''vli'',''van'',''vlu'',''vul'') then ''var'' 
								 else '''' end clob,
							case when rtrim(substring(groupkey,8,4)) = ''hlt'' and rtrim(substring(groupkey,30,5)) <= ''20041'' then ''b''	 
							     when rtrim(substring(groupkey,8,4)) = ''hlt'' and rtrim(substring(groupkey,30,5)) > ''20041'' then ''g''
								 when rtrim(substring(groupkey,8,4)) <> ''hlt'' and rtrim(substring(groupkey,30,5)) <= ''20031'' then ''b''	
								 when rtrim(substring(groupkey,8,4)) <> ''hlt'' and rtrim(substring(groupkey,30,5)) > ''20031'' then ''g''	
								 else '''' end block,
							case when len(rtrim(substring(groupkey,39,10))) = 10 then rtrim(substring(groupkey,40,9)) else ''n/a'' end fss,
                            case when rtrim(substring(groupkey,13,3)) in (''vli'',''van'',''vlu'',''vul'') then ''var'' else ''nva'' end var_tp,
                            case when rtrim(substring(groupkey,26,3)) = ''t60'' then ''f60ins'' 
                                 when rtrim(substring(groupkey,26,3)) = ''v97'' then ''f97var''
                                 when rtrim(substring(groupkey,26,3)) = ''nic'' then ''f97inv''
                                 else ''f97ins'' end sfas_grp,
							case when rtrim(substring(groupkey,13,3)) = ''wol''  then ''wol''
								 when rtrim(substring(groupkey,13,3)) in (''acc'') then ''acc''
								 when rtrim(substring(groupkey,13,3)) in (''hlt'',''ltc'') then ''hal''
								 when rtrim(substring(groupkey,13,3)) in (''end'',''rok'',''rof'') then ''end''
								 when rtrim(substring(groupkey,13,3)) in (''dan'',''ian'',''nic'') then ''ann''
								 when rtrim(substring(groupkey,13,3)) in (''eia'',''eie'') then ''ein'' 
								 when rtrim(substring(groupkey,13,3)) in (''vli'',''van'',''vlu'',''vul'') then ''var'' 
								 else '''' end az_lob
			                ''def'' as ann_tp,                   
                   *
						    into [' + @p_to_dataBaseName + '].[dbo].[' + @toTableName + '] from ['+ @p_from_dataBaseName + '].[dbo].[' +  @fromTableName + ']'
	
	PRINT @sqlInsertTable
	EXEC(@sqlInsertTable)
	
	SET @sqlCreateIndex= 'CREATE INDEX '+ @indexName +
	' ON [' + @p_to_dataBaseName + '].' + '[dbo].[' +  @toTableName + ']([groupkey],[factor],
	[appl],[channel],[lob],[prod],[br],[rs],[sfas],[cohort],[div],[clob],[block],[fss],[var_tp],[sfas_grp],[az_lob] ASC)
	WITH(
			PAD_INDEX = ON 
		,	FILLFACTOR = 50
		)'	
						
	PRINT(@sqlCreateIndex)
	PRINT('인덱스' + @indexName + '가 생성 되었습니다')
	EXEC(@sqlCreateIndex)

  BEGIN TRY 
    EXEC dbo.sp_d12_base_drop @p_from_dataBaseName
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  
  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_insertRslt end                                                      */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d12_base_insertRslt script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
	
	
END
	
SET ANSI_PADDING OFF
GO	
