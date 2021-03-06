use master
go

set ansi_nulls on
go

set quoted_identifier on
go

set ansi_padding on
go
-- ===========================================================================================
-- Author:		SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description:	sum 테이블들의 excel file,sheet 리스트를 엑셀로 출력하는 프로시져
-- ===========================================================================================
if object_id ('[dbo].[sp_d22_sum_out]', 'P') is not null
  drop procedure [dbo].[sp_d22_sum_out];
go
create procedure [dbo].[sp_d22_sum_out]
   @p_yymm             varchar(4),       -- YYMM
   @p_basis            varchar(50),      -- basis : fc / mcev
   @p_to_dataBaseName  varchar(100),     -- to database 명
   @p_var_dvsn         varchar(6),       -- var dvsn : all / var / nonvar
   @p_group_seq        varchar(max),     -- all / group_no
   @p_outputPath       varchar(max)      -- output 기본경로      
as
begin
  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d22_sum_out                                                                  */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'Begin sp_d22_sum_out script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';  
    
  if(@p_var_dvsn <> 'nonvar' and @p_var_dvsn <> 'var')
  print 'var_dvsn error'  
  declare @sqlSelect    as varchar(max)  
	declare @group_name   as varchar(255)
	declare @group_script as varchar(max)
  declare @file_name    as varchar(500)
  declare @sheet_name   as varchar(500)
  declare @delScript    as sysname
  declare @copyScript   as sysname
  declare @insertScript as varchar(max)
  declare @groupFile    as varchar(500)
	declare @TmpiD as Integer, @MaxiD as Integer		
	
  --set @groupFile = ltrim(replace(@p_to_dataBaseName,'_out','')) +'_' + 'group_data.xls'
  set @groupFile = @p_yymm + '_' + @p_basis + '_' + 'group_data.xls'
  set @delScript = 'del ' + @p_outputPath + @groupFile
  set @copyScript = 'copy ' + @p_outputPath + 'group_data_template.xls '+ @p_outputPath + @groupFile
  
  --group data 기존파일 삭제 및 tempate 복사
  exec master..xp_cmdshell @delScript
  print @delScript 
  exec master..xp_cmdshell @copyScript
  print @copyScript
  
	--테이블 변수 선언
	Declare @tmpGroup Table
	( 
    TmpiD        int identity(1,1) Not Null, -- 자동증가(sequence)
	  groupname    varchar(max)      Not Null,
	  groupScript  varchar(max)      Not Null,
    file_name    varchar(500)      Not Null,
    sheet_name   varchar(500)      Null
	 )
      
  if(@p_group_seq = 'all')
    begin
      Insert into @tmpGroup(groupname, groupScript, file_name, sheet_name)
  	  Select group_name, group_script, file_name, sheet_name From master.dbo.tbl_group 
    end
    
  if(@p_group_seq <> 'all')
    begin
      set @sqlSelect  = 'Select group_name, group_script, file_name, sheet_name From master.dbo.tbl_group where group_no in ('+@p_group_seq+')'     
      Insert into @tmpGroup(groupname, groupScript, file_name, sheet_name)
	    exec(@sqlSelect) 
      print @sqlSelect
	 end
   
  --테이블변수의 최소iD, 최대iD를 읽는다.
  Select distinct @TmpiD = Min(TmpiD), @MaxiD = Max(TmpiD) From @tmpGroup
  print @TmpiD
  print @MaxiD
	While @TmpID <= @MaxiD --변수가 최대값이내일 때까지 실행
	
	begin

		 --1개 Row 읽어들이고,
		 Select  @group_name   = groupname,
				     @group_script = groupScript,
             @file_name    = file_name,
             @sheet_name   = sheet_name
		  from @tmpGroup
		 where TmpiD = @TmpiD
    print @TmpiD
    print @group_name
    
    if(@sheet_name is null)
      set @sheet_name = @file_name
    
    if(@p_var_dvsn = 'all')
      begin
        set @insertScript = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'', ''Excel 8.0;Database='+ @p_outputPath + @groupFile + ';'', ''SELECT * FROM [group$]'')
                           select a.group_name,a.excelFile,a.excelSheet,a.var_tp
                           from
                           (
                             select ''' + @group_name + ''' as group_name,  ''total''  as excelFile, ''total'' as excelSheet, 3 as seq, ''nva'' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_nonvar_' + @group_name + ']
                             union all
                             select ''' + @group_name + ''' as group_name,' + @file_name + ' as excelFile, ''total'' as excelSheet, 1 as seq, ''nva'' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_nonvar_' + @group_name + ']
                             union all
                             select ''' + @group_name + ''' as group_name,' + @file_name + ' as excelFile,' + @sheet_name + ' as excelSheet, 2 as seq, ''nva'' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_nonvar_' + @group_name + ']
                           ) a 
                           group by  a.group_name,a.var_tp,a.excelFile, a.seq, a.excelSheet
                           order by  a.group_name,a.var_tp,a.excelFile, a.seq, a.excelSheet'
                           
        begin try
        print(@insertScript)
        exec(@insertScript)         
      	end try 
        
        begin catch
          SELECT ERROR_NUMBER()  AS ERROR_NUMBER
               , ERROR_LINE()    AS ERROR_LINE
               , ERROR_MESSAGE() AS ERROR_MESSAGE
        end catch
   
        set @insertScript = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'', ''Excel 8.0;Database='+ @p_outputPath + @groupFile + ';'', ''SELECT * FROM [group$]'')
                           select a.group_name,a.excelFile,a.excelSheet,a.var_tp
                           from
                           (
                             select ''' + @group_name + ''' as group_name,  ''total''  as excelFile, ''total'' as excelSheet, 3 as seq, ''var'' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_var_' + @group_name + ']
                             union all
                             select ''' + @group_name + ''' as group_name,' + @file_name + ' as excelFile, ''total'' as excelSheet, 1 as seq, ''var''  as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_var_' + @group_name + ']
                             union all
                             select ''' + @group_name + ''' as group_name,' + @file_name + ' as excelFile,' + @sheet_name + ' as excelSheet, 2 as seq, ''var''  as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_var_' + @group_name + ']
                           ) a 
                           group by  a.group_name,a.var_tp,a.excelFile, a.seq, a.excelSheet
                           order by  a.group_name,a.var_tp,a.excelFile, a.seq, a.excelSheet'
                           
        begin try
         print(@insertScript)
         exec(@insertScript)         
      	end try 
        
        begin catch
          SELECT ERROR_NUMBER()  AS ERROR_NUMBER
               , ERROR_LINE()    AS ERROR_LINE
               , ERROR_MESSAGE() AS ERROR_MESSAGE
        end catch
        
       end
     else
       begin
       
        set @insertScript = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'', ''Excel 8.0;Database='+ @p_outputPath + @groupFile + ';'', ''SELECT * FROM [group$]'')
                           select a.group_name,a.excelFile,a.excelSheet,a.var_tp
                           from
                           (
                             select ''' + @group_name + ''' as group_name,  ''total''  as excelFile, ''total'' as excelSheet, 3 as seq, ''' + @p_var_dvsn + ''' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_var_' + @group_name + ']
                             union all
                             select ''' + @group_name + ''' as group_name,' + @file_name + ' as excelFile, ''total'' as excelSheet, 1 as seq, ''' + @p_var_dvsn + ''' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_var_' + @group_name + ']
                             union all
                             select ''' + @group_name + ''' as group_name,' + @file_name + ' as excelFile,' + @sheet_name + ' as excelSheet, 2 as seq, ''' + @p_var_dvsn + ''' as var_tp from [' + @p_to_dataBaseName + '].[dbo].[tbl_var_' + @group_name + ']
                           ) a 
                           group by  a.group_name,a.var_tp,a.excelFile, a.seq, a.excelSheet
                           order by  a.group_name,a.var_tp,a.excelFile, a.seq, a.excelSheet'
                           
        begin try         
         print(@insertScript)
         exec(@insertScript)
      	end try 
        
        begin catch
          SELECT ERROR_NUMBER()  AS ERROR_NUMBER
               , ERROR_LINE()    AS ERROR_LINE
               , ERROR_MESSAGE() AS ERROR_MESSAGE
        end catch
        
       end
		 --다음행을 읽어들이기위해 1증가
		 Set @TmpiD = @TmpiD + 1
	 
	end

  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d22_sum_out end                                                             */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'End sp_d22_sum_out script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';

end
