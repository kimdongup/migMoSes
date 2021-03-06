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
-- Description:	
-- ===========================================================================================
if object_id ('[dbo].[sp_d21_sum_main]', 'P') is not null
  drop procedure [dbo].[sp_d21_sum_main];
go
create procedure [dbo].[sp_d21_sum_main]
	 @p_from_dataBaseName  varchar(100),   -- from database 명
   @p_to_dataBaseName  varchar(100),     -- to database 명
   @p_var_dvsn      varchar(6),          -- var dvsn : all / var / nonvar
   @p_group_seq     varchar(max)         -- all / group_no
   --@p_drop_yn       varchar(1)           -- table drop yn : y/n
   --@p_outputPath    varchar(max)         -- output 경로
as
begin
  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d21_sum_main                                                                 */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'Begin sp_d21_sum_main script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';  
    
  if(@p_var_dvsn <> 'nonvar' and @p_var_dvsn <> 'var')
  print 'var_dvsn error'  

 	/* =========================================================================
	-- summary 프로시져 : tbl_group 을 순차적으로 읽으면서 group별로 sum을 한다.
	-- ========================================================================= */
  declare @sqlDrop      as varchar(max)
  declare @sqlSelect    as varchar(max)
  declare @DataBaseName as varchar(200)
  declare @talbeName    as varchar(200)  
	declare @group_name   as nvarchar(255)
	declare @group_script as nvarchar(max)	
	declare @TmpiD As Integer, @MaxiD As Integer		
	
	--테이블 변수 선언
	Declare @tmpGroup Table
	( 
    TmpiD        int identity(1,1) Not Null, -- 자동증가(sequence)
	  groupname    varchar(200)      Not Null,
	  groupScript  varchar(max)      Not Null	 
	 )
      
  if(@p_group_seq = 'all')
    begin
      Insert into @tmpGroup(groupname, groupScript)
  	  Select group_name, group_script From master.dbo.tbl_group 
    end
  if(@p_group_seq <> 'all')
    begin
      set @sqlSelect  = 'Select group_name, group_script From master.dbo.tbl_group where group_no in ('+@p_group_seq+')'     
      Insert into @tmpGroup(groupname, groupScript)
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
		 Select  @group_name = groupname,
				 @group_script = groupScript
		  from @tmpGroup
		 where TmpiD = @TmpiD

		 
		 --작업할 프로시져 실행
     if(@p_var_dvsn = 'all') 
     begin
      exec dbo.sp_d22_sum_insert_nonvar @p_from_dataBaseName, @p_to_dataBaseName, @group_name, @group_script
      exec dbo.sp_d22_sum_insert_var @p_from_dataBaseName, @p_to_dataBaseName, @group_name, @group_script      
     end
     else if(@p_var_dvsn = 'nonvar')     
     begin
		  exec dbo.sp_d22_sum_insert_nonvar @p_from_dataBaseName, @p_to_dataBaseName, @group_name, @group_script     
     end
     else if(@p_var_dvsn = 'var') 
     begin
		  exec dbo.sp_d22_sum_insert_var @p_from_dataBaseName, @p_to_dataBaseName, @group_name, @group_script
     end 
     
     --exec sp_d22_sum_out  @p_yymm, @p_type, @p_outputPath, @group_name, @p_var_dvsn
     
     --if(@p_drop_yn='y')
     --begin
     --  set @DataBaseName = @p_dataBaseName
     --  set @talbeName = 'tbl_' + @p_var_dvsn + '_' + @group_name     
     --  set @sqlDrop = 'drop table [' + @DataBaseName + '].[DBO].[' + @talbeName + ']'          
     --  exec(@sqlDrop)
     --end
     
		 --다음행을 읽어들이기위해 1증가
		 Set @TmpiD = @TmpiD + 1
	 
	end

  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d21_sum_main end                                                             */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'End sp_d21_sum_main script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';

end
