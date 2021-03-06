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
if object_id ('[dbo].[sp_d11_base_main]', 'P') is not null
  drop procedure [dbo].[sp_d11_base_main];
go

create procedure [dbo].[sp_d11_base_main]
    @p_yymm            varchar(4),       -- YYMM
    @p_basis           varchar(50),      -- basis : fc / mcev
    @p_dataBaseName    varchar(100),     -- database 명
    @p_inputPath_if    varchar(100),     -- input if 경로
    @p_inputPath_1mnb  varchar(100),     -- input 1mnb 경로
    @p_inputPath_1ynb  varchar(100)      -- input 1ynb 경로
as
begin
  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d11_base_main                                                                */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'Begin sp_d11_base_main script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';

  declare @p_app              varchar(3),         -- application 명
          @p_type             varchar(4),         -- type 명
          @sqlDropTable       varchar(2000),      -- 테이블 drop문
          @from_dataBaseName  varchar(100),       -- database 명
          @to_dataBaseName    varchar(100)        -- database 명
	
  
	set @from_dataBaseName = @p_dataBaseName
  set @to_dataBaseName = ltrim(replace(@p_dataBaseName,'_temp','')) + '_base'
  set @sqlDropTable = 'DROP TABLE [' + @to_dataBaseName + '].[dbo].[tbl_cf]'
  begin try
    print @sqlDropTable
    exec(@sqlDropTable)
	end try 
  
  begin catch
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  end catch
  -- =========================================================================
  -- 테이블 생성 프로시져(@p_dataBaseName : 데이터베이스
  -- =========================================================================
  exec dbo.sp_d12_base_create @p_dataBaseName
  
  

  /* =========================================================================
  -- INSERT 프로시져 : cursor를 활용하여 application별 파일을 로드하여 한개 파일로 생성.
             step1. *_CF~main.dbf 파일을 insert (by app X if/1ynb/1mnb)
             step2. dbo.tbl_ann_temp_if/1ynb/1mnb
                dbo.tbl_dex_temp_if/1ynb/1mnb
                dbo.tbl_edu_temp_if/1ynb/1mnb
                dbo.tbl_isp_temp_if/1ynb/1mnb    >> dbo.tbl_cf_temp 로 insert
                dbo.tbl_trd_temp_if/1ynb/1mnb
                dbo.tbl_tul_temp_if/1ynb/1mnb
                dbo.tbl_var_temp_if/1ynb/1mnb
             step3. app X if/1ynb/1mnb table drop
             step4. dbo.tbl_cf_temp > dbo.tbl_cf(index key 생성(factor,appl,channel,...block))
             step5. dbo.tbl_cf_temp drop
  -- ========================================================================= */
  -- cursor 생성
  declare cursor_app  cursor for

      select 'trd'      
      union all
      select 'ann'
      union all
      select 'edu'
      union all
      select 'isp'
      union all
      select 'var'
      union all
      select 'tul'
      union all
      select 'dex'
      

  -- cursor 활성화
  open cursor_app

  -- cursor 반환
  fetch next from cursor_app into @p_app

  while (@@FETCH_STATUS = 0)
     begin 
        
        declare cursor_type  cursor for
          select 'if'
          union all
          select '1mnb'
          union all
          select '1ynb'
      
        -- cursor 활성화
        open cursor_type

        -- cursor 반환
        fetch next from cursor_type into @p_type        
        
        while (@@FETCH_STATUS = 0)
          begin
          
          if(@p_type =  'if' )
            begin
              /* step1 */
              exec dbo.sp_d12_base_importComm @p_dataBaseName, 'if', @p_inputPath_if, @p_app
              /* step2 */
              if ( @p_app = 'trd')
                exec dbo.sp_d12_base_insertTrd @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app  
              if ( @p_app = 'ann')
                exec dbo.sp_d12_base_insertAnn @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app
              if ( @p_app = 'edu')
                exec dbo.sp_d12_base_insertEdu @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app
              if ( @p_app = 'isp')
                exec dbo.sp_d12_base_insertIsp @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app
              if ( @p_app = 'var')
                exec dbo.sp_d12_base_insertVar @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app
              if ( @p_app = 'tul')
                exec dbo.sp_d12_base_insertTul @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app
              if ( @p_app = 'dex')
                exec dbo.sp_d12_base_insertDex @p_yymm, @p_basis, @p_dataBaseName, 'if', @p_app
            end
          else if(@p_type =  '1mnb' )
            begin
              /* step1 */
              exec dbo.sp_d12_base_importComm @p_dataBaseName, '1mnb', @p_inputPath_1mnb, @p_app
              /* step2 */
              if ( @p_app = 'trd')
                exec dbo.sp_d12_base_insertTrd @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app 
              if ( @p_app = 'ann')
                exec dbo.sp_d12_base_insertAnn @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app
              if ( @p_app = 'edu')
                exec dbo.sp_d12_base_insertEdu @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app
              if ( @p_app = 'isp')
                exec dbo.sp_d12_base_insertIsp @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app
              if ( @p_app = 'var')
                exec dbo.sp_d12_base_insertVar @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app
              if ( @p_app = 'tul')
                exec dbo.sp_d12_base_insertTul @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app
              if ( @p_app = 'dex')
                exec dbo.sp_d12_base_insertDex @p_yymm, @p_basis, @p_dataBaseName, '1mnb', @p_app              
            end
          else if(@p_type =  '1ynb' )
            begin
              /* step1 */
              exec dbo.sp_d12_base_importComm @p_dataBaseName, '1ynb', @p_inputPath_1ynb, @p_app
              /* step2 */
              if ( @p_app = 'trd')
                exec dbo.sp_d12_base_insertTrd @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app 
              if ( @p_app = 'ann')
                exec dbo.sp_d12_base_insertAnn @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app
              if ( @p_app = 'edu')
                exec dbo.sp_d12_base_insertEdu @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app
              if ( @p_app = 'isp')
                exec dbo.sp_d12_base_insertIsp @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app
              if ( @p_app = 'var')
                exec dbo.sp_d12_base_insertVar @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app
              if ( @p_app = 'tul')
                exec dbo.sp_d12_base_insertTul @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app
              if ( @p_app = 'dex')
                exec dbo.sp_d12_base_insertDex @p_yymm, @p_basis, @p_dataBaseName, '1ynb', @p_app
            end
                                            
              
        fetch next from cursor_type into @p_type
        end
        -- cursor 해제
        CLOSE cursor_type

        -- cursor 비활성화
        deallocate cursor_type
        
        

        fetch next from cursor_app into @p_app
     end

  -- cursor 해제
  CLOSE cursor_app

  -- cursor 비활성화
  deallocate cursor_app

  /*-- cursor 정보
  SELECT @@CURSOR_ROWS
  SELECT @@FETCH_STATUS
  */
  --/* step4 */
  exec dbo.sp_d12_base_insertRslt @from_dataBaseName, @to_dataBaseName
  

  print '/* =============================================================================== */';
  print '/*                                                                                 */';
  print '/* sp_d11_base_main end                                                            */';
  print '/*                                                                                 */';
  print '/* =============================================================================== */';
  print ' ';
  print 'End sp_d11_base_main script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  print ' ';

end

