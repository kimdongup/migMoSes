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
-- Description:	Import Data - VAR
-- =============================================
IF OBJECT_ID ('[dbo].[sp_d12_base_insertVar]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_insertVar];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_insertVar]
  @p_yymm         VARCHAR(4),    -- YYMM
  @p_basis        VARCHAR(50),   -- basis : fc / mcev
  @p_dataBaseName VARCHAR(100),  -- database 명
  @p_type         VARCHAR(50),   -- run type : if / 1ynb / 1mnb
  @p_app          VARCHAR(4)     -- application 명
AS
BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_insertVar                                                           */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d12_base_insertVar script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

  DECLARE @DataBaseName VARCHAR(200),    --데이터베이스명
          @fromTalbeName VARCHAR(200),   --테이블명(from)
          @toTalbeName VARCHAR(200),     --테이블명(to)
          @joinTableName VARCHAR(200),   --테이블명(join)
          @sqlInsertTable  VARCHAR(max)  --테이블 insert문

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
							cast(0 as float) as clm_hosp,
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
							cast(0 as float) as div_int,
							cast(0 as float) as dividend,
							surp_aft,
							res_data,
							reserve as res_basic,
							cast(0 as float) as res_bas_sv,
							cast(0 as float) as res_bas_rk,
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
							cast(0 as float) as g_inv_ex_d,
							cast(0 as float) as g_inv_ex_i,
							cast(0 as float) as g_inv_exp,
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
							reserve   as g_benrsv_t,
							cast(0 as float) as gaap_dpl,
							gaap_url,
							gaap_res,
							gaap_surp,
							cast(0 as float) as g_gpv_r,
							cast(0 as float) as gaap_def,
							reserve as g_benrsv,
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
							cast(0 as float) as aos_acdt_a,
							cast(0 as float) as aos_dis_a,
							cast(0 as float) as aos_diag_a,
							cast(0 as float) as aos_surg_a,
							cast(0 as float) as aos_hosp_a,
							cast(0 as float) as aos_outp_a,
							cast(0 as float) as aos_recu_a,
							cast(0 as float) as aos_hann_a,
							cast(0 as float) as aos_reti_a,
							cast(0 as float) as aos_waiv_a,
							cast(0 as float) as aos_othc_a,
							aos_dth_e,
							cast(0 as float) as aos_dth_r,
							cast(0 as float) as aos_acdt_e,
							cast(0 as float) as aos_dis_e,
							cast(0 as float) as aos_diag_e,
							cast(0 as float) as aos_surg_e,
							cast(0 as float) as aos_hosp_e,
							cast(0 as float) as aos_outp_e,
							cast(0 as float) as aos_recu_e,
							cast(0 as float) as aos_hann_e,
							cast(0 as float) as aos_reti_e,
							cast(0 as float) as aos_waiv_e,
							cast(0 as float) as aos_othc_e,
							exp_alpha,
							exp_beta,
							prem_disc,
							exp_gamma,
							aos_prm_ld,
							aos_exp,
							aos_sur,
							aos_other,
							aos_surp,
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
							cast(0 as float) as res_b_act,
							cast(0 as float) as mgr_res,
							cast(0 as float) as prem_sav,
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
							cast(0 as float) as g_soe_lps,
							g_soe_risk,
							g_soe_rein,
							g_soe_oth,
							soe_exp,
							cast(0 as float) as soe_invest,
							soe_lapse,
							soe_risk,
							soe_reins,
							cast(0 as float) as soe_other,
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
							g_int_ot,
							g_clm_prf,
							g_oth_pft,
							g_int_pft,
							ph_load,
							prem_if_c,
							fund_alloc,
							fund_b,
							fee_maint,
							fee_fixed,
							fee_riskp,
							fee_rp_tot,
							fund_int_b,
							fund_m,
							fund_death,
							fund_lapse,
							fee_gmab,
							fee_gmdb,
							fee_mgt,
							fund_mgt_a,
							fund_int_e,
							fund_e,
							fund_int,
							fund_incr,
							fund_mat,
							fundsurprf,
							claim_gmab,
							claim_gmdb,
							resgmabinc,
							res_gmab_e,
							resgmab_ic,
							resgmab_ie,
							res_gmdb_e,
							resgmdbinc,
							resgmdb_ic,
							resgmdb_ie,
							cl_add_dth,
							ad_dth_b,
							ad_dth_e,
							g_exp_prf,
							g_fe_load,
							g_soe_lap,
							soe_inv,
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
  PRINT '/* sp_d12_base_insertVar end                                                       */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'End sp_d12_base_insertVar script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';
	
END
	
SET ANSI_PADDING OFF
GO	
