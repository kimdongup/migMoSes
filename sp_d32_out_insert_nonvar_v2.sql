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
IF OBJECT_ID ('[dbo].[sp_d32_out_insert_nonvar]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d32_out_insert_nonvar];
GO

CREATE PROCEDURE [dbo].[sp_d32_out_insert_nonvar]
  @p_outputPath_d   varchar(max),  -- output 경로 상세
  @p_dataBaseName varchar(max),    -- dataBaseName 명
  @p_loadTable    varchar(max),    -- load table
  @p_file         varchar(300),    -- excel file 컬럼 (where 조건절)
  @p_sheet      varchar(300),      -- excel sheet 컬럼 (where 조건절)
  @p_excelFile    varchar(300),    -- excel file
  @p_excelSheet   varchar(300)     -- excel sheet
AS
BEGIN
	
  if(@p_sheet = '')
  begin 
	set @p_sheet = @p_file 
  end
  
  PRINT '/* ==== sp_d32_out_insert_nonvar ====================================================== */';
  declare @sqlInsert       varchar(max)   -- select sql문
  if(@p_excelFile = 'total' and @p_excelSheet = 'total')
    begin
    set @sqlInsert = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database='
                    + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
                    + 'select  case when time like ''P%'' then time else ''M'' + LTRIM(time) end period,cal_year,cal_month,sum(prem_sgl),sum(prem_ini),sum(prem_1yr),sum(prem_2yr)
                             ,sum(prem_3yr),sum(prem_4yr),sum(prem_total),sum(comm_fm_ac),sum(comm_fm)
                             ,sum(comm_fy),sum(comm_rn2),sum(comm_rn3),sum(comm_rn4),sum(comm_rn),sum(comp_oth)
                             ,sum(comm_claw),sum(comm_total),sum(exp_acq),sum(exp_maint),sum(exp_coll)
                             ,sum(exp_total),sum(inv_exp_di),sum(inv_exp_in),sum(inv_exp),sum(surp_int)
                             ,sum(inv_total),sum(clm_mat),sum(clm_surv),sum(clm_ann),sum(clm_waiver)
                             ,sum(clm_death),sum(clm_acc),sum(clm_dis),sum(clm_diag),sum(clm_surg)
                             ,sum(clm_hosp),sum(clm_outp),sum(clm_recup),sum(clm_h_ann),sum(clm_other)
                             ,sum(clm_retire),sum(clm_surr),sum(clm_total),sum(res_incr),sum(dac_incr)
                             ,sum(surp_bef),sum(surp_tax),sum(div_int),sum(dividend),sum(surp_aft)
                             ,sum(res_data),sum(res_basic),sum(res_bas_sv),sum(res_bas_rk)
                             ,sum(res_u_prem),sum(reserve),sum(sv_data),sum(surr_val)
                             ,sum(dac_assets),sum(newdac_tax),sum(rlstic_dac),sum(dac_taxble)
                             ,sum(sum_at_rsk),sum(sm_reserve),sum(sm_rp_risk),sum(solv_marg)
                             ,sum(solv_int),sum(transfers),sum(g_prem_l),sum(g_int_av)
                             ,sum(g_int_cr),sum(g_inv_ex_d),sum(g_inv_ex_i),sum(g_inv_exp)
                             ,sum(g_sur_pft),sum(gaap_dpl_i),sum(gaap_url_i),sum(g_benrsv_i)
                             ,sum(gaap_res_i),sum(gaap_dac_i),sum(g_surp_bef),sum(g_egp_exp)
                             ,sum(gaap_egp),sum(g_comm_d),sum(g_exp_d),sum(g_newdac)
                             ,sum(g_pl_ult),sum(g_newdpl),sum(g_newurl),sum(gaap_dac)
                             ,sum(gaap_asset),sum(g_pv_prem),sum(g_pv_clm),sum(g_pv_d_exp)
                             ,sum(g_pv_nd_ex),sum(g_benrsv_t),sum(gaap_dpl),sum(gaap_url)
                             ,sum(gaap_res),sum(gaap_surp),sum(g_gpv_r),sum(gaap_def)
                             ,sum(g_benrsv),sum(g_mer),sum(gaap_upr),sum(g_pv_fel)
                             ,sum(g_pv_def),sum(g_pv_egp),sum(re_ced_prm),sum(re_clms)
                             ,sum(re_exp),sum(re_pr_comm),sum(re_result),sum(aos_int_cr)
                             ,sum(aos_re_prf),sum(aos_dth_a),sum(aos_acdt_a),sum(aos_dis_a)
                             ,sum(aos_diag_a),sum(aos_surg_a),sum(aos_hosp_a),sum(aos_outp_a)
                             ,sum(aos_recu_a),sum(aos_hann_a),sum(aos_reti_a),sum(aos_waiv_a)
                             ,sum(aos_othc_a),sum(aos_dth_e),sum(aos_dth_r),sum(aos_acdt_e)
                             ,sum(aos_dis_e),sum(aos_diag_e),sum(aos_surg_e),sum(aos_hosp_e)
                             ,sum(aos_outp_e),sum(aos_recu_e),sum(aos_hann_e),sum(aos_reti_e)
                             ,sum(aos_waiv_e),sum(aos_othc_e),sum(exp_alpha),sum(exp_beta)
                             ,sum(prem_disc),sum(exp_gamma),sum(aos_prm_ld),sum(aos_exp)
                             ,sum(aos_sur),sum(aos_other),sum(aos_surp),sum(net_prem_r)
                             ,sum(risk_prem),sum(prem_load),sum(load_alpha),sum(load_beta)
                             ,sum(load_gamma),sum(prem_data),sum(prem_if_b),sum(prem_nb)
                             ,sum(fa_data),sum(face_val),sum(face_nb),sum(face_dth)
                             ,sum(face_mat),sum(face_lapse),sum(face_if_e),sum(num_pols_b)
                             ,sum(num_nb),sum(num_dth),sum(num_mat),sum(num_lapse)
                             ,sum(pol_data),sum(policies_b),sum(g_inv_ic),sum(res_b_act)
                             ,sum(mgr_res),sum(prem_sav),sum(g_pv_def_d),sum(g_pv_eg_d)
                             ,sum(g_pv_fel_d),sum(prm_sg_col),sum(prm_m1_col),sum(prm_y1_col)
                             ,sum(prm_y2_col),sum(prm_y3_col),sum(prm_y4_col),sum(prm_totcol)
                             ,sum(cl_mat_col),sum(cl_srv_col),sum(cl_dth_col),sum(cl_sur_col)
                             ,sum(cl_tot_col),sum(gres_i_col),sum(tran_rider),sum(opt_new)
                             ,sum(opt_amort),sum(opt_bal),sum(opt_res),sum(opt_rtrn_p)
                             ,sum(opt_rtrn_s),sum(g_dpl_amor),sum(g_dpl_int),sum(g_url_amor)
                             ,sum(g_url_int),sum(g_dac_amor),sum(g_dac_int),sum(g_soe_exp)
                             ,sum(g_soe_inv),sum(g_soe_lps),sum(g_soe_risk),sum(g_soe_rein)
                             ,sum(g_soe_oth),sum(soe_exp),sum(soe_invest),sum(soe_lapse)
                             ,sum(soe_risk),sum(soe_reins),sum(soe_other),sum(ann_assure)
                             ,sum(n_ann_rv_e),sum(n_ann_p_e),sum(ann_base)
                             ,sum(res_gmdb),sum(res_gmsb),sum(exp_claim)
                             ,sum(prm_h_p_am),sum(prm_h_p)
                          from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] group by case when time like ''P%'' then time else ''M'' + LTRIM(time) end ,cal_year,cal_month
                          order by case when cal_year is null then 1 else 0 end, cal_year, cal_month'

      print 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database='
                    + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
                    + '....from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + ']  order by time,cal_year,cal_month'    
    end
  else if(@p_excelFile <> 'total' and @p_excelSheet = 'total')
    begin
    set @sqlInsert = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database='
                    + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
                    + 'select  case when time like ''P%'' then time else ''M'' + LTRIM(time) end period,cal_year,cal_month,sum(prem_sgl),sum(prem_ini),sum(prem_1yr),sum(prem_2yr)
                             ,sum(prem_3yr),sum(prem_4yr),sum(prem_total),sum(comm_fm_ac),sum(comm_fm)
                             ,sum(comm_fy),sum(comm_rn2),sum(comm_rn3),sum(comm_rn4),sum(comm_rn),sum(comp_oth)
                             ,sum(comm_claw),sum(comm_total),sum(exp_acq),sum(exp_maint),sum(exp_coll)
                             ,sum(exp_total),sum(inv_exp_di),sum(inv_exp_in),sum(inv_exp),sum(surp_int)
                             ,sum(inv_total),sum(clm_mat),sum(clm_surv),sum(clm_ann),sum(clm_waiver)
                             ,sum(clm_death),sum(clm_acc),sum(clm_dis),sum(clm_diag),sum(clm_surg)
                             ,sum(clm_hosp),sum(clm_outp),sum(clm_recup),sum(clm_h_ann),sum(clm_other)
                             ,sum(clm_retire),sum(clm_surr),sum(clm_total),sum(res_incr),sum(dac_incr)
                             ,sum(surp_bef),sum(surp_tax),sum(div_int),sum(dividend),sum(surp_aft)
                             ,sum(res_data),sum(res_basic),sum(res_bas_sv),sum(res_bas_rk)
                             ,sum(res_u_prem),sum(reserve),sum(sv_data),sum(surr_val)
                             ,sum(dac_assets),sum(newdac_tax),sum(rlstic_dac),sum(dac_taxble)
                             ,sum(sum_at_rsk),sum(sm_reserve),sum(sm_rp_risk),sum(solv_marg)
                             ,sum(solv_int),sum(transfers),sum(g_prem_l),sum(g_int_av)
                             ,sum(g_int_cr),sum(g_inv_ex_d),sum(g_inv_ex_i),sum(g_inv_exp)
                             ,sum(g_sur_pft),sum(gaap_dpl_i),sum(gaap_url_i),sum(g_benrsv_i)
                             ,sum(gaap_res_i),sum(gaap_dac_i),sum(g_surp_bef),sum(g_egp_exp)
                             ,sum(gaap_egp),sum(g_comm_d),sum(g_exp_d),sum(g_newdac)
                             ,sum(g_pl_ult),sum(g_newdpl),sum(g_newurl),sum(gaap_dac)
                             ,sum(gaap_asset),sum(g_pv_prem),sum(g_pv_clm),sum(g_pv_d_exp)
                             ,sum(g_pv_nd_ex),sum(g_benrsv_t),sum(gaap_dpl),sum(gaap_url)
                             ,sum(gaap_res),sum(gaap_surp),sum(g_gpv_r),sum(gaap_def)
                             ,sum(g_benrsv),sum(g_mer),sum(gaap_upr),sum(g_pv_fel)
                             ,sum(g_pv_def),sum(g_pv_egp),sum(re_ced_prm),sum(re_clms)
                             ,sum(re_exp),sum(re_pr_comm),sum(re_result),sum(aos_int_cr)
                             ,sum(aos_re_prf),sum(aos_dth_a),sum(aos_acdt_a),sum(aos_dis_a)
                             ,sum(aos_diag_a),sum(aos_surg_a),sum(aos_hosp_a),sum(aos_outp_a)
                             ,sum(aos_recu_a),sum(aos_hann_a),sum(aos_reti_a),sum(aos_waiv_a)
                             ,sum(aos_othc_a),sum(aos_dth_e),sum(aos_dth_r),sum(aos_acdt_e)
                             ,sum(aos_dis_e),sum(aos_diag_e),sum(aos_surg_e),sum(aos_hosp_e)
                             ,sum(aos_outp_e),sum(aos_recu_e),sum(aos_hann_e),sum(aos_reti_e)
                             ,sum(aos_waiv_e),sum(aos_othc_e),sum(exp_alpha),sum(exp_beta)
                             ,sum(prem_disc),sum(exp_gamma),sum(aos_prm_ld),sum(aos_exp)
                             ,sum(aos_sur),sum(aos_other),sum(aos_surp),sum(net_prem_r)
                             ,sum(risk_prem),sum(prem_load),sum(load_alpha),sum(load_beta)
                             ,sum(load_gamma),sum(prem_data),sum(prem_if_b),sum(prem_nb)
                             ,sum(fa_data),sum(face_val),sum(face_nb),sum(face_dth)
                             ,sum(face_mat),sum(face_lapse),sum(face_if_e),sum(num_pols_b)
                             ,sum(num_nb),sum(num_dth),sum(num_mat),sum(num_lapse)
                             ,sum(pol_data),sum(policies_b),sum(g_inv_ic),sum(res_b_act)
                             ,sum(mgr_res),sum(prem_sav),sum(g_pv_def_d),sum(g_pv_eg_d)
                             ,sum(g_pv_fel_d),sum(prm_sg_col),sum(prm_m1_col),sum(prm_y1_col)
                             ,sum(prm_y2_col),sum(prm_y3_col),sum(prm_y4_col),sum(prm_totcol)
                             ,sum(cl_mat_col),sum(cl_srv_col),sum(cl_dth_col),sum(cl_sur_col)
                             ,sum(cl_tot_col),sum(gres_i_col),sum(tran_rider),sum(opt_new)
                             ,sum(opt_amort),sum(opt_bal),sum(opt_res),sum(opt_rtrn_p)
                             ,sum(opt_rtrn_s),sum(g_dpl_amor),sum(g_dpl_int),sum(g_url_amor)
                             ,sum(g_url_int),sum(g_dac_amor),sum(g_dac_int),sum(g_soe_exp)
                             ,sum(g_soe_inv),sum(g_soe_lps),sum(g_soe_risk),sum(g_soe_rein)
                             ,sum(g_soe_oth),sum(soe_exp),sum(soe_invest),sum(soe_lapse)
                             ,sum(soe_risk),sum(soe_reins),sum(soe_other),sum(ann_assure)
                             ,sum(n_ann_rv_e),sum(n_ann_p_e),sum(ann_base)
                             ,sum(res_gmdb),sum(res_gmsb),sum(exp_claim)
                             ,sum(prm_h_p_am),sum(prm_h_p)
                          from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' group by case when time like ''P%'' then time else ''M'' + LTRIM(time) end ,cal_year,cal_month
                          order by case when cal_year is null then 1 else 0 end, cal_year, cal_month'

      print 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database='
                    + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
                    + '....from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' order by time,cal_year,cal_month'
    end
  else if(@p_excelFile <> 'total' and @p_excelSheet <> 'total')
    begin
    set @sqlInsert = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database='
                    + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
                    + 'select  case when time like ''P%'' then time else ''M'' + LTRIM(time) end period
                             ,cal_year,cal_month
                             ,prem_sgl,prem_ini
                             ,prem_1yr,prem_2yr
                             ,prem_3yr,prem_4yr
                             ,prem_total,comm_fm_ac
                             ,comm_fm,comm_fy
                             ,comm_rn2,comm_rn3
                             ,comm_rn4,comm_rn
                             ,comp_oth,comm_claw
                             ,comm_total,exp_acq
                             ,exp_maint,exp_coll
                             ,exp_total,inv_exp_di
                             ,inv_exp_in,inv_exp
                             ,surp_int,inv_total
                             ,clm_mat,clm_surv
                             ,clm_ann,clm_waiver
                             ,clm_death,clm_acc
                             ,clm_dis,clm_diag
                             ,clm_surg,clm_hosp
                             ,clm_outp,clm_recup
                             ,clm_h_ann,clm_other
                             ,clm_retire,clm_surr
                             ,clm_total,res_incr
                             ,dac_incr,surp_bef
                             ,surp_tax,div_int
                             ,dividend,surp_aft
                             ,res_data,res_basic
                             ,res_bas_sv,res_bas_rk
                             ,res_u_prem,reserve
                             ,sv_data,surr_val
                             ,dac_assets,newdac_tax
                             ,rlstic_dac,dac_taxble
                             ,sum_at_rsk,sm_reserve
                             ,sm_rp_risk,solv_marg
                             ,solv_int,transfers
                             ,g_prem_l,g_int_av
                             ,g_int_cr,g_inv_ex_d
                             ,g_inv_ex_i,g_inv_exp
                             ,g_sur_pft,gaap_dpl_i
                             ,gaap_url_i,g_benrsv_i
                             ,gaap_res_i,gaap_dac_i
                             ,g_surp_bef,g_egp_exp
                             ,gaap_egp,g_comm_d
                             ,g_exp_d,g_newdac
                             ,g_pl_ult,g_newdpl
                             ,g_newurl,gaap_dac
                             ,gaap_asset,g_pv_prem
                             ,g_pv_clm,g_pv_d_exp
                             ,g_pv_nd_ex,g_benrsv_t
                             ,gaap_dpl,gaap_url
                             ,gaap_res,gaap_surp
                             ,g_gpv_r,gaap_def
                             ,g_benrsv,g_mer
                             ,gaap_upr,g_pv_fel
                             ,g_pv_def,g_pv_egp
                             ,re_ced_prm,re_clms
                             ,re_exp,re_pr_comm
                             ,re_result,aos_int_cr
                             ,aos_re_prf,aos_dth_a
                             ,aos_acdt_a,aos_dis_a
                             ,aos_diag_a,aos_surg_a
                             ,aos_hosp_a,aos_outp_a
                             ,aos_recu_a,aos_hann_a
                             ,aos_reti_a,aos_waiv_a
                             ,aos_othc_a,aos_dth_e
                             ,aos_dth_r,aos_acdt_e
                             ,aos_dis_e,aos_diag_e
                             ,aos_surg_e,aos_hosp_e
                             ,aos_outp_e,aos_recu_e
                             ,aos_hann_e,aos_reti_e
                             ,aos_waiv_e,aos_othc_e
                             ,exp_alpha,exp_beta
                             ,prem_disc,exp_gamma
                             ,aos_prm_ld,aos_exp
                             ,aos_sur,aos_other
                             ,aos_surp,net_prem_r
                             ,risk_prem,prem_load
                             ,load_alpha,load_beta
                             ,load_gamma,prem_data
                             ,prem_if_b,prem_nb
                             ,fa_data,face_val
                             ,face_nb,face_dth
                             ,face_mat,face_lapse
                             ,face_if_e,num_pols_b
                             ,num_nb,num_dth
                             ,num_mat,num_lapse
                             ,pol_data,policies_b
                             ,g_inv_ic,res_b_act
                             ,mgr_res,prem_sav
                             ,g_pv_def_d,g_pv_eg_d
                             ,g_pv_fel_d,prm_sg_col
                             ,prm_m1_col,prm_y1_col
                             ,prm_y2_col,prm_y3_col
                             ,prm_y4_col,prm_totcol
                             ,cl_mat_col,cl_srv_col
                             ,cl_dth_col,cl_sur_col
                             ,cl_tot_col,gres_i_col
                             ,tran_rider,opt_new
                             ,opt_amort,opt_bal
                             ,opt_res,opt_rtrn_p
                             ,opt_rtrn_s,g_dpl_amor
                             ,g_dpl_int,g_url_amor
                             ,g_url_int,g_dac_amor
                             ,g_dac_int,g_soe_exp
                             ,g_soe_inv,g_soe_lps
                             ,g_soe_risk,g_soe_rein
                             ,g_soe_oth,soe_exp
                             ,soe_invest,soe_lapse
                             ,soe_risk,soe_reins
                             ,soe_other,ann_assure
                             ,n_ann_rv_e,n_ann_p_e
                             ,ann_base,res_gmdb
                             ,res_gmsb,exp_claim
                             ,prm_h_p_am,prm_h_p
                          from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' and '
                                 + @p_sheet + '=''' + @p_excelSheet + 
                          ''' order by time,cal_year,cal_month'
      print 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database='
                    + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
                    + '....from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' and '
                                 + @p_sheet + '=''' + @p_excelSheet
                      + ''' order by time,cal_year,cal_month'

      end
  --print @sqlInsert
  EXEC(@sqlInsert)

  PRINT '/* ==== sp_d32_out_insert_nonvar end =================================================== */';

END

SET ANSI_PADDING OFF
GO

