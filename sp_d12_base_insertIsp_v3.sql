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
-- Description:	Import Data - ISP
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d12_base_insertIsp]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_insertIsp];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_insertIsp]
  @p_yymm         VARCHAR(4),    -- YYMM
  @p_basis        VARCHAR(50),   -- basis : fc / mcev
  @p_dataBaseName VARCHAR(100),  -- database 명
  @p_type         VARCHAR(50),   -- run type : if / 1ynb / 1mnb
  @p_app          VARCHAR(4)     -- application 명
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_insertIsp                                                           */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d12_base_insertIsp script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
				
	DECLARE 
	    @DataBaseName    VARCHAR(200),   --데이터베이스명
		  @fromTalbeName   VARCHAR(200),   --테이블명(from)
		  @toTalbeName     VARCHAR(200),   --테이블명(to)
		  @joinTableName   VARCHAR(200),   --테이블명(join)
		  @sqlInsertTable  VARCHAR(max)    --테이블 insert문
	    
	    
  SET @DataBaseName  = @p_dataBaseName
  SET @fromTalbeName = 'tbl_' + @p_app + '_temp_' + @p_type
  SET @toTalbeName   = 'tbl_cf_temp'
  SET @joinTableName = 'tbl_' + @p_yymm + '_' + @p_basis + '_grossup_factor'
  PRINT @p_app + ': '
	
  SET @sqlInsertTable = 'insert into [' + @DataBaseName + '].[DBO].[' + @toTalbeName +
              '] select ''' + @p_type + ''' as type, product,   
							purpose,
							groupkey,
							disc_rate,
							time,
							t_from,
							t_to,
							period,
							cal_year,
							cal_month,
							prem_sgl,
							prem_ini,
							prem_1yr,
							prem_2yr,
							prem_3yr,
							prem_4yr,
							prem_total,
							comm_fm_ac,
							comm_fm,
							comm_fy,
							comm_rn2,
							comm_rn3,
							comm_rn4,
							comm_rn,
							comp_oth,
							comm_claw,
							comm_total,
							exp_acq,
							exp_maint,
							exp_coll,
							exp_total,
							inv_exp_di,
							inv_exp_in,
							inv_exp,
							surp_int,
							inv_total,
							clm_mat,
							clm_surv,
							clm_ann,
							clm_waiver,
							clm_death,
							clm_acc,
							clm_dis,
							clm_diag,
							clm_surg,
							clm_hosp,
							clm_outp,
							clm_recup,
							cast(0 as float) as clm_h_ann,
							clm_other,
							clm_retire,
							clm_surr,
							clm_total,
							res_incr,
							dac_incr,
							surp_bef,
							surp_tax,
							div_int,
							dividend,
							surp_aft,
							res_data,
							reserve as res_basic,
							res_bas_sv,
							res_bas_rk,
							res_u_prem,
							reserve,
							sv_data,
							surr_val,
							dac_assets,
							newdac_tax,
							rlstic_dac,
							dac_taxble,
							sum_at_rsk,
							sm_reserve,
							sm_rp_risk,
							solv_marg,
							solv_int,
							transfers,
							g_prem_l,
							g_int_av,
							g_int_cr,
							g_inv_ex_d,
							g_inv_ex_i,
							g_inv_exp,
							g_sur_pft,
							cast(0 as float) as gaap_dpl_i,
							gaap_url_i,
							res_incr as g_benrsv_i,
							gaap_res_i,
							gaap_dac_i,
							g_surp_bef,
							g_egp_exp,
							gaap_egp,
							g_comm_d,
							g_exp_d,
							g_newdac,
							g_pl_ult,
							cast(0 as float) as g_newdpl,
							g_newurl,
							gaap_dac,
							gaap_asset,
							cast(0 as float) as g_pv_prem,
							cast(0 as float) as g_pv_clm,
							cast(0 as float) as g_pv_d_exp,
							cast(0 as float) as g_pv_nd_ex,
							reserve as g_benrsv_t,
							cast(0 as float) as gaap_dpl,
							gaap_url,
							gaap_res,
							gaap_surp,
							cast(0 as float) as g_gpv_r,
							cast(0 as float) as gaap_def,
							reserve  as g_benrsv,
							cast(0 as float) as g_mer,
							gaap_upr,
							g_pv_fel,
							g_pv_def,
							g_pv_egp,
							re_ced_prm,
							re_clms,
							re_exp,
							re_pr_comm,
							re_result,
							aos_int_cr,
							aos_re_prf,
							aos_dth_a,
							aos_acdt_a,
							aos_dis_a,
							aos_diag_a,
							aos_surg_a,
							aos_hosp_a,
							aos_outp_a,
							aos_recu_a,
							cast(0 as float) as aos_hann_a,
							aos_reti_a,
							aos_waiv_a,
							aos_othc_a,
							aos_dth_e,
							aos_dth_r,
							aos_acdt_e,
							aos_dis_e,
							aos_diag_e,
							aos_surg_e,
							aos_hosp_e,
							aos_outp_e,
							aos_recu_e,
							cast(0 as float) as aos_hann_e,
							aos_reti_e,
							aos_waiv_e,
							aos_othc_e,
							exp_alpha,
							exp_beta,
							prem_disc,
							exp_gamma,
							aos_prm_ld,
							aos_exp,
							aos_sur,
							aos_other,
							cast(0 as float) as aos_surp,
							net_prem_r,
							risk_prem,
							prem_load,
							load_alpha,
							load_beta,
							load_gamma,
							prem_data,
							prem_if_b,
							prem_nb,
							fa_data,
							face_val,
							face_nb,
							face_dth,
							face_mat,
							face_lapse,
							face_if_e,
							num_pols_b,
							num_nb,
							num_dth,
							num_mat,
							num_lapse,
							pol_data,
							policies_b,
							g_inv_ic,
							reserve as res_b_act,
							mgr_res,
							prem_sav,
							g_pv_def_d,
							g_pv_eg_d,
							g_pv_fel_d,
							prm_sg_col,
							prm_m1_col,
							prm_y1_col,
							prm_y2_col,
							prm_y3_col,
							prm_y4_col,
							prm_totcol,
							cl_mat_col,
							cl_srv_col,
							cl_dth_col,
							cl_sur_col,
							cl_tot_col,
							gres_i_col,
							tran_rider,
							cast(0 as float) as opt_new,
							cast(0 as float) as opt_amort,
							cast(0 as float) as opt_bal,
							cast(0 as float) as opt_res,
							cast(0 as float) as opt_rtrn_p,
							cast(0 as float) as opt_rtrn_s,
							cast(0 as float) as g_dpl_amor,
							cast(0 as float) as g_dpl_int,
							g_url_amor,
							g_url_int,
							g_dac_amor,
							g_dac_int,
							g_soe_exp,
							g_soe_inv,
							g_soe_lps,
							g_soe_risk,
							g_soe_rein,
							g_soe_oth,
							soe_exp,
							soe_invest,
							soe_lapse,
							soe_risk,
							soe_reins,
							soe_other,
							ann_assure,
							n_ann_rv_e,
							n_ann_p_e,
							ann_base,
							cast(0 as float) as res_gmdb,
							cast(0 as float) as res_gmsb,
							exp_claim,
							prm_h_p_am,
							prm_h_p,
							reserve  as res_actual,
							cast(0 as float) as g_int_ot,
							cast(0 as float) as g_clm_prf,
							cast(0 as float) as g_oth_pft,
							cast(0 as float) as g_int_pft,
							cast(0 as float) as ph_load,
							cast(0 as float) as prem_if_c,
							cast(0 as float) as fund_alloc,
							cast(0 as float) as fund_b,
							cast(0 as float) as fee_maint,
							cast(0 as float) as fee_fixed,
							cast(0 as float) as fee_riskp,
							cast(0 as float) as fee_rp_tot,
							cast(0 as float) as fund_int_b,
							cast(0 as float) as fund_m,
							cast(0 as float) as fund_death,
							cast(0 as float) as fund_lapse,
							cast(0 as float) as fee_gmab,
							cast(0 as float) as fee_gmdb,
							cast(0 as float) as fee_mgt,
							cast(0 as float) as fund_mgt_a,
							cast(0 as float) as fund_int_e,
							cast(0 as float) as fund_e,
							cast(0 as float) as fund_int,
							cast(0 as float) as fund_incr,
							cast(0 as float) as fund_mat,
							cast(0 as float) as fundsurprf,
							cast(0 as float) as claim_gmab,
							cast(0 as float) as claim_gmdb,
							cast(0 as float) as resgmabinc,
							cast(0 as float) as res_gmab_e,
							cast(0 as float) as resgmab_ic,
							cast(0 as float) as resgmab_ie,
							cast(0 as float) as res_gmdb_e,
							cast(0 as float) as resgmdbinc,
							cast(0 as float) as resgmdb_ic,
							cast(0 as float) as resgmdb_ie,
							cast(0 as float) as cl_add_dth,
							cast(0 as float) as ad_dth_b,
							cast(0 as float) as ad_dth_e,
							cast(0 as float) as g_exp_prf,
							cast(0 as float) as g_fe_load,
							cast(0 as float) as g_soe_lap,
							cast(0 as float) as soe_inv,
							cast(0 as float) as soe_oth,
							rate
							from [' + @DataBaseName + '].[DBO].[' + @fromTalbeName + '] 
							inner join [master].[DBO].[' + @joinTableName + '] on rtrim(substring(groupkey,5,64)) = factor 
              where upper(rtrim(type)) = upper(''' + @p_type + ''')'  

	PRINT 'insert into :  [' + @DataBaseName + '].[DBO].[' + @fromTalbeName + '] >> [' + @DataBaseName + '].[DBO].[' + @toTalbeName +']'
	PRINT 'grossup factor join type ' + @p_type	

  BEGIN TRY 
    EXEC(@sqlInsertTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 

  BEGIN TRY 
    PRINT 'drop table : ' + @fromTalbeName
    EXEC dbo.sp_d12_base_dropApp  @p_dataBaseName, @p_type, @p_app 
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  
  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_insertIsp end                                                       */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d12_base_insertIsp script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

END
	
SET ANSI_PADDING OFF
GO	
