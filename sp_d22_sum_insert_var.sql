USE master
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*- ================================================================================
-- Author:		SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description:	Import Data 
-- * VARCHAR 타입의 문장길이는 8000이 한계이기 때문에 한번에 QUERY문을 작성할 수 없다.
   따라서 c1,c2..등으로 컬럼명을 줄여서 sum 쿼리문을 실행 한 후 cursor를 이용하여
   컬럼명을 바꿔주었다.
-- ================================================================================= */
IF OBJECT_ID ('[dbo].[sp_d22_sum_insert_var]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d22_sum_insert_var];
GO

CREATE PROCEDURE [dbo].[sp_d22_sum_insert_var]
	@p_from_dataBaseName  VARCHAR(100),     -- from database 명
  @p_to_dataBaseName    VARCHAR(100),     -- to database 명  
	@p_group              VARCHAR(300),     -- group name 
	@p_groupScript        VARCHAR(300)      -- group script 
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d22_sum_insert_var                                                           */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d22_sum_insert_var script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';  
			
	DECLARE 
		  @fromTalbeName   VARCHAR(200),    --테이블명(from)
		  @toTalbeName     VARCHAR(200),    --테이블명(to)
		  @sqlInsertTable  VARCHAR(max),    --테이블 insert문
		  @sqlDropTable    VARCHAR(max),    --테이블 drop문
	    @alterColumns    VARCHAR(300),
	    @beofreC         VARCHAR(300),
	    @afterC          VARCHAR(300)
	    	   	
	SET @fromTalbeName = 'tbl_CF'
	SET @toTalbeName = 'tbl_var_' +  @p_group
	SET @sqlDropTable = 'drop table [' + @p_to_dataBaseName + '].[DBO].[' + @toTalbeName + ']'
	
	PRINT @sqlDropTable
	EXEC(@sqlDropTable)
	PRINT 'sum ' + @p_group + ': ' 	
	
	SET @sqlInsertTable = 'select ' + @p_groupScript + 
						  ' ,time,
						    cal_year,
						    cal_month,
						    sum(prem_sgl*r) as c1,
                sum(prem_ini*r) as c2,
                sum(prem_1yr*r) as c3,
                sum(prem_2yr*r) as c4,
                sum(prem_3yr*r) as c5,
                sum(prem_4yr*r) as c6,
                sum(prem_total*r) as c7,
                sum(comm_fm_ac*r) as c8,
                sum(comm_fm*r) as c9,
                sum(comm_fy*r) as c10,
                sum(comm_rn2*r) as c11,
                sum(comm_rn3*r) as c12,
                sum(comm_rn4*r) as c13,
                sum(comm_rn*r) as c14,
                sum(comp_oth*r) as c15,
                sum(comm_claw*r) as c16,
                sum(comm_total*r) as c17,
                sum(exp_acq*r) as c18,
                sum(exp_maint*r) as c19,
                sum(exp_total*r) as c20,
                sum(inv_exp_di*r) as c21,
                sum(inv_exp_in*r) as c22,
                sum(inv_exp*r) as c23,
                sum(surp_int*r) as c24,
                sum(inv_total*r) as c25,
                sum(clm_mat*r) as c26,
                sum(clm_surv*r) as c27,
                sum(clm_ann*r) as c28,
                sum(clm_waiver*r) as c29,
                sum(clm_death*r) as c30,
                sum(clm_acc*r) as c31,
                sum(clm_dis*r) as c32,
                sum(clm_diag*r) as c33,
                sum(clm_surg*r) as c34,
                sum(clm_hosp*r) as c35,
                sum(clm_outp*r) as c36,
                sum(clm_recup*r) as c37,
                sum(clm_h_ann*r) as c38,
                sum(clm_other*r) as c39,
                sum(clm_retire*r) as c40,
                sum(clm_surr*r) as c41,
                sum(clm_total*r) as c42,
                sum(res_incr*r) as c43,
                sum(dac_incr*r) as c44,
                sum(surp_bef*r) as c45,
                sum(surp_tax*r) as c46,
                sum(surp_aft*r) as c47,
                sum(res_data*r) as c48,
                sum(res_basic*r) as c49,
                sum(res_u_prem*r) as c50,
                sum(reserve*r) as c51,
                sum(sv_data*r) as c52,
                sum(surr_val*r) as c53,
                sum(res_actual*r) as c54,
                sum(dac_assets*r) as c55,
                sum(newdac_tax*r) as c56,
                sum(rlstic_dac*r) as c57,
                sum(dac_taxble*r) as c58,
                sum(sum_at_rsk*r) as c59,
                sum(sm_reserve*r) as c60,
                sum(sm_rp_risk*r) as c61,
                sum(solv_marg*r) as c62,
                sum(solv_int*r) as c63,
                sum(transfers*r) as c64,
                sum(g_prem_l*r) as c65,
                sum(g_int_av*r) as c66,
                sum(g_int_ot*r) as c67,
                sum(g_clm_prf*r) as c68,
                sum(g_sur_pft*r) as c69,
                sum(g_oth_pft*r) as c70,
                sum(g_int_cr*r) as c71,
                sum(g_inv_ex_d*r) as c72,
                sum(g_inv_ex_i*r) as c73,
                sum(g_inv_exp*r) as c74,
                sum(gaap_url_i*r) as c75,
                sum(g_benrsv_i*r) as c76,
                sum(gaap_res_i*r) as c77,
                sum(gaap_dac_i*r) as c78,
                sum(g_surp_bef*r) as c79,
                sum(g_egp_exp*r) as c80,
                sum(gaap_egp*r) as c81,
                sum(g_int_pft*r) as c82,
                sum(g_comm_d*r) as c83,
                sum(g_exp_d*r) as c84,
                sum(g_newdac*r) as c85,
                sum(g_pl_ult*r) as c86,
                sum(g_newurl*r) as c87,
                sum(gaap_dac*r) as c88,
                sum(gaap_asset*r) as c89,
                sum(g_benrsv_t*r) as c90,
                sum(gaap_url*r) as c91,
                sum(gaap_res*r) as c92,
                sum(gaap_surp*r) as c93,
                sum(g_gpv_r*r) as c94,
                sum(g_benrsv*r) as c95,
                sum(g_mer*r) as c96,
                sum(gaap_upr*r) as c97,
                sum(g_pv_fel*r) as c98,
                sum(g_pv_def*r) as c99,
                sum(g_pv_egp*r) as c100,
                sum(exp_alpha*r) as c101,
                sum(exp_beta*r) as c102,
                sum(prem_disc*r) as c103,
                sum(exp_gamma*r) as c104,
                sum(re_ced_prm*r) as c105,
                sum(re_clms*r) as c106,
                sum(re_exp*r) as c107,
                sum(re_pr_comm*r) as c108,
                sum(re_result*r) as c109,
                sum(tran_rider*r) as c110,
                sum(ph_load*r) as c111,
                sum(aos_prm_ld*r) as c112,
                sum(aos_exp*r) as c113,
                sum(aos_sur*r) as c114,
                sum(aos_other*r) as c115,
                sum(aos_surp*r) as c116,
                sum(aos_re_prf*r) as c117,
                sum(net_prem_r*r) as c118,
                sum(risk_prem*r) as c119,
                sum(prem_load*r) as c120,
                sum(load_alpha*r) as c121,
                sum(load_beta*r) as c122,
                sum(load_gamma*r) as c123,
                sum(prem_data*r) as c124,
                sum(prem_if_b*r) as c125,
                sum(prem_nb*r) as c126,
                sum(fa_data*r) as c127,
                sum(face_val*r) as c128,
                sum(face_nb*r) as c129,
                sum(face_dth*r) as c130,
                sum(prem_if_c*r) as c131,
                sum(face_lapse*r) as c132,
                sum(face_if_e*r) as c133,
                sum(num_pols_b*r) as c134,
                sum(num_nb*r) as c135,
                sum(num_dth*r) as c136,
                sum(num_mat*r) as c137,
                sum(num_lapse*r) as c138,
                sum(pol_data*r) as c139,
                sum(policies_b*r) as c140,
                sum(g_inv_ic*r) as c141,
                sum(fund_alloc*r) as c142,
                sum(fund_b*r) as c143,
                sum(fee_maint*r) as c144,
                sum(fee_fixed*r) as c145,
                sum(fee_riskp*r) as c146,
                sum(fee_rp_tot*r) as c147,
                sum(fund_int_b*r) as c148,
                sum(fund_m*r) as c149,
                sum(fund_death*r) as c150,
                sum(fund_lapse*r) as c151,
                sum(fee_gmab*r) as c152,
                sum(fee_gmdb*r) as c153,
                sum(fee_mgt*r) as c154,
                sum(fund_mgt_a*r) as c155,
                sum(fund_int_e*r) as c156,
                sum(fund_e*r) as c157,
                sum(fund_int*r) as c158,
                sum(fund_incr*r) as c159,
                sum(fund_mat*r) as c160,
                sum(fundsurprf*r) as c161,
                sum(claim_gmab*r) as c162,
                sum(claim_gmdb*r) as c163,
                sum(resgmabinc*r) as c164,
                sum(res_gmab_e*r) as c165,
                sum(resgmab_ic*r) as c166,
                sum(resgmab_ie*r) as c167,
                sum(res_gmdb_e*r) as c168,
                sum(resgmdbinc*r) as c169,
                sum(resgmdb_ic*r) as c170,
                sum(resgmdb_ie*r) as c171,
                sum(cl_add_dth*r) as c172,
                sum(ad_dth_b*r) as c173,
                sum(ad_dth_e*r) as c174,
                sum(g_exp_prf*r) as c175,
                sum(g_fe_load*r) as c176,
                sum(g_pv_def_d*r) as c177,
                sum(g_pv_eg_d*r) as c178,
                sum(g_pv_fel_d*r) as c179,
                sum(prm_sg_col*r) as c180,
                sum(prm_m1_col*r) as c181,
                sum(prm_y1_col*r) as c182,
                sum(prm_y2_col*r) as c183,
                sum(prm_y3_col*r) as c184,
                sum(prm_y4_col*r) as c185,
                sum(prm_totcol*r) as c186,
                sum(cl_mat_col*r) as c187,
                sum(cl_srv_col*r) as c188,
                sum(cl_dth_col*r) as c189,
                sum(cl_sur_col*r) as c190,
                sum(cl_tot_col*r) as c191,
                sum(gres_i_col*r) as c192,
                sum(g_url_amor*r) as c193,
                sum(g_url_int*r) as c194,
                sum(g_dac_amor*r) as c195,
                sum(g_dac_int*r) as c196,
                sum(g_soe_risk*r) as c197,
                sum(g_soe_lap*r) as c198,
                sum(g_soe_inv*r) as c199,
                sum(g_soe_exp*r) as c200,
                sum(g_soe_rein*r) as c201,
                sum(g_soe_oth*r) as c202,
                sum(soe_risk*r) as c203,
                sum(soe_lapse*r) as c204,
                sum(soe_inv*r) as c205,
                sum(soe_exp*r) as c206,
                sum(soe_reins*r) as c207,
                sum(soe_oth*r) as c208,
                sum(ann_assure*r) as c209,
                sum(n_ann_rv_e*r) as c210,
                sum(n_ann_p_e*r) as c211,
                sum(ann_base*r) as c212,
                sum(exp_claim*r) as c213,
                sum(prm_h_p_am*r) as c214,
                sum(prm_h_p*r) as c215
               into [' + @p_to_dataBaseName + '].[DBO].[' + @toTalbeName +
						  '] from [' + @p_from_dataBaseName + '].[DBO].[' + @fromTalbeName + ']
						  where var_tp = ''var'' and (cal_year is not null or  time like ''PV%'')                                             
					    group by ' + @p_groupScript + '
						     ,time,
						     cal_year,
                             cal_month' 
	
	EXEC(@sqlInsertTable)
	PRINT 'insert into [' + @p_to_dataBaseName + '].[DBO].[' + @toTalbeName + '] '
	PRINT 'selct..sum(value * grossfactor) group by ' + @p_groupScript + ',time,cal_year,cal_month'
	
  -- cursor 생성 
	DECLARE cursor_chngColumn  CURSOR FOR
		select before,after from master.dbo.tbl_column_map_var
		
	-- cursor 활성화 
	open cursor_chngColumn
		
	-- cursor 반환 
	FETCH NEXT FROM cursor_chngColumn INTO @beofreC,@afterC	
	
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
		
			SET @alterColumns = '[' + @p_to_dataBaseName + '].[DBO].[' + @toTalbeName + '].[' + @beofreC +']' 	
		
			--MESSAGE:  주의: 개체 이름 부분을 변경하면 스크립트 및 저장 프로시저를 손상시킬 수 있습니다. .. 무시해도 됨.
			EXEC SP_RENAME @alterColumns,@afterC,'COLUMN';
			FETCH NEXT FROM cursor_chngColumn INTO @beofreC,@afterC	
        END
    
    -- cursor 해제 
	CLOSE cursor_chngColumn

	-- cursor 비활성화 
	DEALLOCATE cursor_chngColumn
	
  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d22_sum_insert_var end                                                       */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d22_sum_insert_var script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
	
END
	
SET ANSI_PADDING OFF
GO	

