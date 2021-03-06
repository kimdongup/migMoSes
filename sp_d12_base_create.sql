USE master
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- ===========================================================================================
-- Author:    SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description: create table
-- ===========================================================================================
IF OBJECT_ID ('[dbo].[sp_d12_base_create]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d12_base_create];
GO

CREATE PROCEDURE [dbo].[sp_d12_base_create]
    @p_dataBaseName VARCHAR(200)   -- 데이터베이스명
AS
DECLARE
    @DataBaseName    VARCHAR(200),       -- 데이터베이스명
    @tableName       VARCHAR(200),       -- 테이블명
    @sqlCreateTable  VARCHAR(max),       -- 테이블 create문
    @sqlDropTable    VARCHAR(max)        -- 테이블 drop문

BEGIN

  PRINT '/* =============================================================================== */';
  PRINT '/*                                                                                 */';
  PRINT '/* sp_d12_base_create                                                              */';
  PRINT '/*                                                                                 */';
  PRINT '/* =============================================================================== */';
  PRINT ' ';
  PRINT 'Begin sp_d11_base_main script at '+RTRIM(CONVERT(varchar(24),GETDATE(),121))+''
  PRINT ' ';

  SET @DataBaseName = @p_dataBaseName
  SET @tableName =  'tbl_cf_temp'
  SET @sqlDropTable = 'DROP TABLE [' + @DataBaseName + '].' + '[dbo].[' +  @tableName + ']'
  
  BEGIN TRY 
    EXEC(@sqlDropTable)
	END TRY 
  
  BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ERROR_NUMBER
         , ERROR_LINE()    AS ERROR_LINE
         , ERROR_MESSAGE() AS ERROR_MESSAGE
  END CATCH 
  

  SET @sqlCreateTable = 'CREATE TABLE [' + @DataBaseName + '].' + '[dbo].[' +  @tableName + '](
      [type][char](4) null,
      [product] [char](8) NULL,
      [purpose] [char](8) NULL,
      [groupkey] [char](95) NULL,
      [disc_rate] [numeric](5, 2) NULL,
      [time] [char](10) NULL,
      [t_from] [numeric](5, 0) NULL,
      [t_to] [numeric](5, 0) NULL,
      [period] [char](15) NULL,
      [cal_year] [float] NULL,
      [cal_month] [float] NULL,
      [prem_sgl] [float] NULL,
      [prem_ini] [float] NULL,
      [prem_1yr] [float] NULL,
      [prem_2yr] [float] NULL,
      [prem_3yr] [float] NULL,
      [prem_4yr] [float] NULL,
      [prem_total] [float] NULL,
      [comm_fm_ac] [float] NULL,
      [comm_fm] [float] NULL,
      [comm_fy] [float] NULL,
      [comm_rn2] [float] NULL,
      [comm_rn3] [float] NULL,
      [comm_rn4] [float] NULL,
      [comm_rn] [float] NULL,
      [comp_oth] [float] NULL,
      [comm_claw] [float] NULL,
      [comm_total] [float] NULL,
      [exp_acq] [float] NULL,
      [exp_maint] [float] NULL,
      [exp_coll] [float] NULL,
      [exp_total] [float] NULL,
      [inv_exp_di] [float] NULL,
      [inv_exp_in] [float] NULL,
      [inv_exp] [float] NULL,
      [surp_int] [float] NULL,
      [inv_total] [float] NULL,
      [clm_mat] [float] NULL,
      [clm_surv] [float] NULL,
      [clm_ann] [float] NULL,
      [clm_waiver] [float] NULL,
      [clm_death] [float] NULL,
      [clm_acc] [float] NULL,
      [clm_dis] [float] NULL,
      [clm_diag] [float] NULL,
      [clm_surg] [float] NULL,
      [clm_hosp] [float] NULL,
      [clm_outp] [float] NULL,
      [clm_recup] [float] NULL,
      [clm_h_ann] [float] NULL,
      [clm_other] [float] NULL,
      [clm_retire] [float] NULL,
      [clm_surr] [float] NULL,
      [clm_total] [float] NULL,
      [res_incr] [float] NULL,
      [dac_incr] [float] NULL,
      [surp_bef] [float] NULL,
      [surp_tax] [float] NULL,
      [div_int] [float] NULL,
      [dividend] [float] NULL,
      [surp_aft] [float] NULL,
      [res_data] [float] NULL,
      [res_basic] [float] NULL,
      [res_bas_sv] [float] NULL,
      [res_bas_rk] [float] NULL,
      [res_u_prem] [float] NULL,
      [reserve] [float] NULL,
      [sv_data] [float] NULL,
      [surr_val] [float] NULL,
      [dac_assets] [float] NULL,
      [newdac_tax] [float] NULL,
      [rlstic_dac] [float] NULL,
      [dac_taxble] [float] NULL,
      [sum_at_rsk] [float] NULL,
      [sm_reserve] [float] NULL,
      [sm_rp_risk] [float] NULL,
      [solv_marg] [float] NULL,
      [solv_int] [float] NULL,
      [transfers] [float] NULL,
      [g_prem_l] [float] NULL,
      [g_int_av] [float] NULL,
      [g_int_cr] [float] NULL,
      [g_inv_ex_d] [float] NULL,
      [g_inv_ex_i] [float] NULL,
      [g_inv_exp] [float] NULL,
      [g_sur_pft] [float] NULL,
      [gaap_dpl_i] [float] NULL,
      [gaap_url_i] [float] NULL,
      [g_benrsv_i] [float] NULL,
      [gaap_res_i] [float] NULL,
      [gaap_dac_i] [float] NULL,
      [g_surp_bef] [float] NULL,
      [g_egp_exp] [float] NULL,
      [gaap_egp] [float] NULL,
      [g_comm_d] [float] NULL,
      [g_exp_d] [float] NULL,
      [g_newdac] [float] NULL,
      [g_pl_ult] [float] NULL,
      [g_newdpl] [float] NULL,
      [g_newurl] [float] NULL,
      [gaap_dac] [float] NULL,
      [gaap_asset] [float] NULL,
      [g_pv_prem] [float] NULL,
      [g_pv_clm] [float] NULL,
      [g_pv_d_exp] [float] NULL,
      [g_pv_nd_ex] [float] NULL,
      [g_benrsv_t] [float] NULL,
      [gaap_dpl] [float] NULL,
      [gaap_url] [float] NULL,
      [gaap_res] [float] NULL,
      [gaap_surp] [float] NULL,
      [g_gpv_r] [float] NULL,
      [gaap_def] [float] NULL,
      [g_benrsv] [float] NULL,
      [g_mer] [float] NULL,
      [gaap_upr] [float] NULL,
      [g_pv_fel] [float] NULL,
      [g_pv_def] [float] NULL,
      [g_pv_egp] [float] NULL,
      [re_ced_prm] [float] NULL,
      [re_clms] [float] NULL,
      [re_exp] [float] NULL,
      [re_pr_comm] [float] NULL,
      [re_result] [float] NULL,
      [aos_int_cr] [float] NULL,
      [aos_re_prf] [float] NULL,
      [aos_dth_a] [float] NULL,
      [aos_acdt_a] [float] NULL,
      [aos_dis_a] [float] NULL,
      [aos_diag_a] [float] NULL,
      [aos_surg_a] [float] NULL,
      [aos_hosp_a] [float] NULL,
      [aos_outp_a] [float] NULL,
      [aos_recu_a] [float] NULL,
      [aos_hann_a] [float] NULL,
      [aos_reti_a] [float] NULL,
      [aos_waiv_a] [float] NULL,
      [aos_othc_a] [float] NULL,
      [aos_dth_e] [float] NULL,
      [aos_dth_r] [float] NULL,
      [aos_acdt_e] [float] NULL,
      [aos_dis_e] [float] NULL,
      [aos_diag_e] [float] NULL,
      [aos_surg_e] [float] NULL,
      [aos_hosp_e] [float] NULL,
      [aos_outp_e] [float] NULL,
      [aos_recu_e] [float] NULL,
      [aos_hann_e] [float] NULL,
      [aos_reti_e] [float] NULL,
      [aos_waiv_e] [float] NULL,
      [aos_othc_e] [float] NULL,
      [exp_alpha] [float] NULL,
      [exp_beta] [float] NULL,
      [prem_disc] [float] NULL,
      [exp_gamma] [float] NULL,
      [aos_prm_ld] [float] NULL,
      [aos_exp] [float] NULL,
      [aos_sur] [float] NULL,
      [aos_other] [float] NULL,
      [aos_surp] [float] NULL,
      [net_prem_r] [float] NULL,
      [risk_prem] [float] NULL,
      [prem_load] [float] NULL,
      [load_alpha] [float] NULL,
      [load_beta] [float] NULL,
      [load_gamma] [float] NULL,
      [prem_data] [float] NULL,
      [prem_if_b] [float] NULL,
      [prem_nb] [float] NULL,
      [fa_data] [float] NULL,
      [face_val] [float] NULL,
      [face_nb] [float] NULL,
      [face_dth] [float] NULL,
      [face_mat] [float] NULL,
      [face_lapse] [float] NULL,
      [face_if_e] [float] NULL,
      [num_pols_b] [float] NULL,
      [num_nb] [float] NULL,
      [num_dth] [float] NULL,
      [num_mat] [float] NULL,
      [num_lapse] [float] NULL,
      [pol_data] [float] NULL,
      [policies_b] [float] NULL,
      [g_inv_ic] [float] NULL,
      [res_b_act] [float] NULL,
      [mgr_res] [float] NULL,
      [prem_sav] [float] NULL,
      [g_pv_def_d] [float] NULL,
      [g_pv_eg_d] [float] NULL,
      [g_pv_fel_d] [float] NULL,
      [prm_sg_col] [float] NULL,
      [prm_m1_col] [float] NULL,
      [prm_y1_col] [float] NULL,
      [prm_y2_col] [float] NULL,
      [prm_y3_col] [float] NULL,
      [prm_y4_col] [float] NULL,
      [prm_totcol] [float] NULL,
      [cl_mat_col] [float] NULL,
      [cl_srv_col] [float] NULL,
      [cl_dth_col] [float] NULL,
      [cl_sur_col] [float] NULL,
      [cl_tot_col] [float] NULL,
      [gres_i_col] [float] NULL,
      [tran_rider] [float] NULL,
      [opt_new] [float] NULL,
      [opt_amort] [float] NULL,
      [opt_bal] [float] NULL,
      [opt_res] [float] NULL,
      [opt_rtrn_p] [float] NULL,
      [opt_rtrn_s] [float] NULL,
      [g_dpl_amor] [float] NULL,
      [g_dpl_int] [float] NULL,
      [g_url_amor] [float] NULL,
      [g_url_int] [float] NULL,
      [g_dac_amor] [float] NULL,
      [g_dac_int] [float] NULL,
      [g_soe_exp] [float] NULL,
      [g_soe_inv] [float] NULL,
      [g_soe_lps] [float] NULL,
      [g_soe_risk] [float] NULL,
      [g_soe_rein] [float] NULL,
      [g_soe_oth] [float] NULL,
      [soe_exp] [float] NULL,
      [soe_invest] [float] NULL,
      [soe_lapse] [float] NULL,
      [soe_risk] [float] NULL,
      [soe_reins] [float] NULL,
      [soe_other] [float] NULL,
      [ann_assure] [float] NULL,
      [n_ann_rv_e] [float] NULL,
      [n_ann_p_e] [float] NULL,
      [ann_base] [float] NULL,
      [res_gmdb] [float] NULL,
      [res_gmsb] [float] NULL,
      [exp_claim] [float] NULL,
      [prm_h_p_am] [float] NULL,
      [prm_h_p] [float] NULL,
      [res_actual] [float] NULL,
      [g_int_ot] [float] NULL,
      [g_clm_prf] [float] NULL,
      [g_oth_pft] [float] NULL,
      [g_int_pft] [float] NULL,
      [ph_load] [float] NULL,
      [prem_if_c] [float] NULL,
      [fund_alloc] [float] NULL,
      [fund_b] [float] NULL,
      [fee_maint] [float] NULL,
      [fee_fixed] [float] NULL,
      [fee_riskp] [float] NULL,
      [fee_rp_tot] [float] NULL,
      [fund_int_b] [float] NULL,
      [fund_m] [float] NULL,
      [fund_death] [float] NULL,
      [fund_lapse] [float] NULL,
      [fee_gmab] [float] NULL,
      [fee_gmdb] [float] NULL,
      [fee_mgt] [float] NULL,
      [fund_mgt_a] [float] NULL,
      [fund_int_e] [float] NULL,
      [fund_e] [float] NULL,
      [fund_int] [float] NULL,
      [fund_incr] [float] NULL,
      [fund_mat] [float] NULL,
      [fundsurprf] [float] NULL,
      [claim_gmab] [float] NULL,
      [claim_gmdb] [float] NULL,
      [resgmabinc] [float] NULL,
      [res_gmab_e] [float] NULL,
      [resgmab_ic] [float] NULL,
      [resgmab_ie] [float] NULL,
      [res_gmdb_e] [float] NULL,
      [resgmdbinc] [float] NULL,
      [resgmdb_ic] [float] NULL,
      [resgmdb_ie] [float] NULL,
      [cl_add_dth] [float] NULL,
      [ad_dth_b] [float] NULL,
      [ad_dth_e] [float] NULL,
      [g_exp_prf] [float] NULL,
      [g_fe_load] [float] NULL,
      [g_soe_lap] [float] NULL,
      [soe_inv] [float] NULL,
      [soe_oth] [float] NULL,
      [r] [float] NULL
) ON [PRIMARY]'

  PRINT('CREATE TABLE:  [' + @DataBaseName + '].' + '[dbo].[' +  @tableName + ']')
  PRINT('[' + @DataBaseName + '].' + '[dbo].[' +  @tableName + '] 테이블이 생성되었습니다.')
  EXEC(@sqlCreateTable)

  PRINT ' ';
END


SET ANSI_PADDING OFF
GO