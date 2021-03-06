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
-- Description:	insert Data 
-- ================================================================================= */
IF OBJECT_ID ('[dbo].[sp_d32_out_insert_var]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d32_out_insert_var];
GO

CREATE PROCEDURE [dbo].[sp_d32_out_insert_var]
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
  
	PRINT '/* ==== sp_d32_out_insert_var ====================================================== */';
	declare @sqlInsert       varchar(max)   -- select sql문          
  if(@p_excelFile = 'total' and @p_excelSheet = 'total')
        begin
  	    set @sqlInsert = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database=' 
  	                + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
  	                + 'select  case when time like ''P%'' then time else ''M'' + LTRIM(time) end period,cal_year,cal_month
  				                   ,sum(prem_sgl),sum(prem_ini),sum(prem_1yr),sum(prem_2yr),sum(prem_3yr),sum(prem_4yr)
                             ,sum(prem_total),sum(comm_fm_ac)
                             ,sum(comm_fm),sum(comm_fy)
                             ,sum(comm_rn2),sum(comm_rn3)
                             ,sum(comm_rn4),sum(comm_rn)
                             ,sum(comp_oth),sum(comm_claw)
                             ,sum(comm_total),sum(exp_acq)
                             ,sum(exp_maint),sum(exp_total)
                             ,sum(inv_exp_di),sum(inv_exp_in)
                             ,sum(inv_exp),sum(surp_int)
                             ,sum(inv_total),sum(clm_mat)
                             ,sum(clm_surv),sum(clm_ann)
                             ,sum(clm_waiver),sum(clm_death)
                             ,sum(clm_acc),sum(clm_dis)
                             ,sum(clm_diag),sum(clm_surg)
                             ,sum(clm_hosp),sum(clm_outp)
                             ,sum(clm_recup),sum(clm_h_ann)
                             ,sum(clm_other),sum(clm_retire)
                             ,sum(clm_surr),sum(clm_total)
                             ,sum(res_incr),sum(dac_incr)
                             ,sum(surp_bef),sum(surp_tax)
                             ,sum(surp_aft),sum(res_data)
                             ,sum(res_basic),sum(res_u_prem)
                             ,sum(reserve),sum(sv_data)
                             ,sum(surr_val),sum(res_actual)
                             ,sum(dac_assets),sum(newdac_tax)
                             ,sum(rlstic_dac),sum(dac_taxble)
                             ,sum(sum_at_rsk),sum(sm_reserve)
                             ,sum(sm_rp_risk),sum(solv_marg)
                             ,sum(solv_int),sum(transfers)
                             ,sum(g_prem_l),sum(g_int_av)
                             ,sum(g_int_ot),sum(g_clm_prf)
                             ,sum(g_sur_pft),sum(g_oth_pft)
                             ,sum(g_int_cr),sum(g_inv_ex_d)
                             ,sum(g_inv_ex_i),sum(g_inv_exp)
                             ,sum(gaap_url_i),sum(g_benrsv_i)
                             ,sum(gaap_res_i),sum(gaap_dac_i)
                             ,sum(g_surp_bef),sum(g_egp_exp)
                             ,sum(gaap_egp),sum(g_int_pft)
                             ,sum(g_comm_d),sum(g_exp_d)
                             ,sum(g_newdac),sum(g_pl_ult)
                             ,sum(g_newurl),sum(gaap_dac)
                             ,sum(gaap_asset),sum(g_benrsv_t)
                             ,sum(gaap_url),sum(gaap_res)
                             ,sum(gaap_surp),sum(g_gpv_r)
                             ,sum(g_benrsv),sum(g_mer)
                             ,sum(gaap_upr),sum(g_pv_fel)
                             ,sum(g_pv_def),sum(g_pv_egp)
                             ,sum(exp_alpha),sum(exp_beta)
                             ,sum(prem_disc),sum(exp_gamma)
                             ,sum(re_ced_prm),sum(re_clms)
                             ,sum(re_exp),sum(re_pr_comm)
                             ,sum(re_result),sum(tran_rider)
                             ,sum(ph_load),sum(aos_prm_ld)
                             ,sum(aos_exp),sum(aos_sur)
                             ,sum(aos_other),sum(aos_surp)
                             ,sum(aos_re_prf),sum(net_prem_r)
                             ,sum(risk_prem),sum(prem_load)
                             ,sum(load_alpha),sum(load_beta)
                             ,sum(load_gamma),sum(prem_data)
                             ,sum(prem_if_b),sum(prem_nb)
                             ,sum(fa_data),sum(face_val)
                             ,sum(face_nb),sum(face_dth)
                             ,sum(prem_if_c),sum(face_lapse)
                             ,sum(face_if_e),sum(num_pols_b)
                             ,sum(num_nb),sum(num_dth)
                             ,sum(num_mat),sum(num_lapse)
                             ,sum(pol_data),sum(policies_b)
                             ,sum(g_inv_ic),sum(fund_alloc)
                             ,sum(fund_b),sum(fee_maint)
                             ,sum(fee_fixed),sum(fee_riskp)
                             ,sum(fee_rp_tot),sum(fund_int_b)
                             ,sum(fund_m),sum(fund_death)
                             ,sum(fund_lapse),sum(fee_gmab)
                             ,sum(fee_gmdb),sum(fee_mgt)
                             ,sum(fund_mgt_a),sum(fund_int_e)
                             ,sum(fund_e),sum(fund_int)
                             ,sum(fund_incr),sum(fund_mat)
                             ,sum(fundsurprf),sum(claim_gmab)
                             ,sum(claim_gmdb),sum(resgmabinc)
                             ,sum(res_gmab_e),sum(resgmab_ic)
                             ,sum(resgmab_ie),sum(res_gmdb_e)
                             ,sum(resgmdbinc),sum(resgmdb_ic)
                             ,sum(resgmdb_ie),sum(cl_add_dth)
                             ,sum(ad_dth_b),sum(ad_dth_e)
                             ,sum(g_exp_prf),sum(g_fe_load)
                             ,sum(g_pv_def_d),sum(g_pv_eg_d)
                             ,sum(g_pv_fel_d),sum(prm_sg_col)
                             ,sum(prm_m1_col),sum(prm_y1_col)
                             ,sum(prm_y2_col),sum(prm_y3_col)
                             ,sum(prm_y4_col),sum(prm_totcol)
                             ,sum(cl_mat_col),sum(cl_srv_col)
                             ,sum(cl_dth_col),sum(cl_sur_col)
                             ,sum(cl_tot_col),sum(gres_i_col)
                             ,sum(g_url_amor),sum(g_url_int)
                             ,sum(g_dac_amor),sum(g_dac_int)
                             ,sum(g_soe_risk),sum(g_soe_lap)
                             ,sum(g_soe_inv),sum(g_soe_exp)
                             ,sum(g_soe_rein),sum(g_soe_oth)
                             ,sum(soe_risk),sum(soe_lapse)
                             ,sum(soe_inv),sum(soe_exp)
                             ,sum(soe_reins),sum(soe_oth)
                             ,sum(ann_assure),sum(n_ann_rv_e)
                             ,sum(n_ann_p_e),sum(ann_base)
                             ,sum(exp_claim),sum(prm_h_p_am)
                             ,sum(prm_h_p)
  		                     from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] group by case when time like ''P%'' then time else ''M'' + LTRIM(time) end ,cal_year,cal_month 
                          order by case when cal_year is null then 1 else 0 end, cal_year, cal_month'
        print 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database=' 
  	                + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
  	                + '.... from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] order by time,cal_year,cal_month'		    
        end
    else if(@p_excelFile <> 'total' and @p_excelSheet = 'total')         
        begin
  	    set @sqlInsert = 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database=' 
  	                + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
  	                + 'select  case when time like ''P%'' then time else ''M'' + LTRIM(time) end period,cal_year,cal_month
  				                   ,sum(prem_sgl),sum(prem_ini),sum(prem_1yr),sum(prem_2yr),sum(prem_3yr),sum(prem_4yr)
                             ,sum(prem_total),sum(comm_fm_ac)
                             ,sum(comm_fm),sum(comm_fy)
                             ,sum(comm_rn2),sum(comm_rn3)
                             ,sum(comm_rn4),sum(comm_rn)
                             ,sum(comp_oth),sum(comm_claw)
                             ,sum(comm_total),sum(exp_acq)
                             ,sum(exp_maint),sum(exp_total)
                             ,sum(inv_exp_di),sum(inv_exp_in)
                             ,sum(inv_exp),sum(surp_int)
                             ,sum(inv_total),sum(clm_mat)
                             ,sum(clm_surv),sum(clm_ann)
                             ,sum(clm_waiver),sum(clm_death)
                             ,sum(clm_acc),sum(clm_dis)
                             ,sum(clm_diag),sum(clm_surg)
                             ,sum(clm_hosp),sum(clm_outp)
                             ,sum(clm_recup),sum(clm_h_ann)
                             ,sum(clm_other),sum(clm_retire)
                             ,sum(clm_surr),sum(clm_total)
                             ,sum(res_incr),sum(dac_incr)
                             ,sum(surp_bef),sum(surp_tax)
                             ,sum(surp_aft),sum(res_data)
                             ,sum(res_basic),sum(res_u_prem)
                             ,sum(reserve),sum(sv_data)
                             ,sum(surr_val),sum(res_actual)
                             ,sum(dac_assets),sum(newdac_tax)
                             ,sum(rlstic_dac),sum(dac_taxble)
                             ,sum(sum_at_rsk),sum(sm_reserve)
                             ,sum(sm_rp_risk),sum(solv_marg)
                             ,sum(solv_int),sum(transfers)
                             ,sum(g_prem_l),sum(g_int_av)
                             ,sum(g_int_ot),sum(g_clm_prf)
                             ,sum(g_sur_pft),sum(g_oth_pft)
                             ,sum(g_int_cr),sum(g_inv_ex_d)
                             ,sum(g_inv_ex_i),sum(g_inv_exp)
                             ,sum(gaap_url_i),sum(g_benrsv_i)
                             ,sum(gaap_res_i),sum(gaap_dac_i)
                             ,sum(g_surp_bef),sum(g_egp_exp)
                             ,sum(gaap_egp),sum(g_int_pft)
                             ,sum(g_comm_d),sum(g_exp_d)
                             ,sum(g_newdac),sum(g_pl_ult)
                             ,sum(g_newurl),sum(gaap_dac)
                             ,sum(gaap_asset),sum(g_benrsv_t)
                             ,sum(gaap_url),sum(gaap_res)
                             ,sum(gaap_surp),sum(g_gpv_r)
                             ,sum(g_benrsv),sum(g_mer)
                             ,sum(gaap_upr),sum(g_pv_fel)
                             ,sum(g_pv_def),sum(g_pv_egp)
                             ,sum(exp_alpha),sum(exp_beta)
                             ,sum(prem_disc),sum(exp_gamma)
                             ,sum(re_ced_prm),sum(re_clms)
                             ,sum(re_exp),sum(re_pr_comm)
                             ,sum(re_result),sum(tran_rider)
                             ,sum(ph_load),sum(aos_prm_ld)
                             ,sum(aos_exp),sum(aos_sur)
                             ,sum(aos_other),sum(aos_surp)
                             ,sum(aos_re_prf),sum(net_prem_r)
                             ,sum(risk_prem),sum(prem_load)
                             ,sum(load_alpha),sum(load_beta)
                             ,sum(load_gamma),sum(prem_data)
                             ,sum(prem_if_b),sum(prem_nb)
                             ,sum(fa_data),sum(face_val)
                             ,sum(face_nb),sum(face_dth)
                             ,sum(prem_if_c),sum(face_lapse)
                             ,sum(face_if_e),sum(num_pols_b)
                             ,sum(num_nb),sum(num_dth)
                             ,sum(num_mat),sum(num_lapse)
                             ,sum(pol_data),sum(policies_b)
                             ,sum(g_inv_ic),sum(fund_alloc)
                             ,sum(fund_b),sum(fee_maint)
                             ,sum(fee_fixed),sum(fee_riskp)
                             ,sum(fee_rp_tot),sum(fund_int_b)
                             ,sum(fund_m),sum(fund_death)
                             ,sum(fund_lapse),sum(fee_gmab)
                             ,sum(fee_gmdb),sum(fee_mgt)
                             ,sum(fund_mgt_a),sum(fund_int_e)
                             ,sum(fund_e),sum(fund_int)
                             ,sum(fund_incr),sum(fund_mat)
                             ,sum(fundsurprf),sum(claim_gmab)
                             ,sum(claim_gmdb),sum(resgmabinc)
                             ,sum(res_gmab_e),sum(resgmab_ic)
                             ,sum(resgmab_ie),sum(res_gmdb_e)
                             ,sum(resgmdbinc),sum(resgmdb_ic)
                             ,sum(resgmdb_ie),sum(cl_add_dth)
                             ,sum(ad_dth_b),sum(ad_dth_e)
                             ,sum(g_exp_prf),sum(g_fe_load)
                             ,sum(g_pv_def_d),sum(g_pv_eg_d)
                             ,sum(g_pv_fel_d),sum(prm_sg_col)
                             ,sum(prm_m1_col),sum(prm_y1_col)
                             ,sum(prm_y2_col),sum(prm_y3_col)
                             ,sum(prm_y4_col),sum(prm_totcol)
                             ,sum(cl_mat_col),sum(cl_srv_col)
                             ,sum(cl_dth_col),sum(cl_sur_col)
                             ,sum(cl_tot_col),sum(gres_i_col)
                             ,sum(g_url_amor),sum(g_url_int)
                             ,sum(g_dac_amor),sum(g_dac_int)
                             ,sum(g_soe_risk),sum(g_soe_lap)
                             ,sum(g_soe_inv),sum(g_soe_exp)
                             ,sum(g_soe_rein),sum(g_soe_oth)
                             ,sum(soe_risk),sum(soe_lapse)
                             ,sum(soe_inv),sum(soe_exp)
                             ,sum(soe_reins),sum(soe_oth)
                             ,sum(ann_assure),sum(n_ann_rv_e)
                             ,sum(n_ann_p_e),sum(ann_base)
                             ,sum(exp_claim),sum(prm_h_p_am)
                             ,sum(prm_h_p)
  		                     from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' group by case when time like ''P%'' then time else ''M'' + LTRIM(time) end ,cal_year,cal_month 
                          order by case when cal_year is null then 1 else 0 end, cal_year, cal_month'
        print 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database=' 
  	                + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
  	                + '.... from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' order by time,cal_year,cal_month'		
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
                             ,exp_maint,exp_total
                             ,inv_exp_di,inv_exp_in
                             ,inv_exp,surp_int
                             ,inv_total,clm_mat
                             ,clm_surv,clm_ann
                             ,clm_waiver,clm_death
                             ,clm_acc,clm_dis
                             ,clm_diag,clm_surg
                             ,clm_hosp,clm_outp
                             ,clm_recup,clm_h_ann
                             ,clm_other,clm_retire
                             ,clm_surr,clm_total
                             ,res_incr,dac_incr
                             ,surp_bef,surp_tax
                             ,surp_aft,res_data
                             ,res_basic,res_u_prem
                             ,reserve,sv_data
                             ,surr_val,res_actual
                             ,dac_assets,newdac_tax
                             ,rlstic_dac,dac_taxble
                             ,sum_at_rsk,sm_reserve
                             ,sm_rp_risk,solv_marg
                             ,solv_int,transfers
                             ,g_prem_l,g_int_av
                             ,g_int_ot,g_clm_prf
                             ,g_sur_pft,g_oth_pft
                             ,g_int_cr,g_inv_ex_d
                             ,g_inv_ex_i,g_inv_exp
                             ,gaap_url_i,g_benrsv_i
                             ,gaap_res_i,gaap_dac_i
                             ,g_surp_bef,g_egp_exp
                             ,gaap_egp,g_int_pft
                             ,g_comm_d,g_exp_d
                             ,g_newdac,g_pl_ult
                             ,g_newurl,gaap_dac
                             ,gaap_asset,g_benrsv_t
                             ,gaap_url,gaap_res
                             ,gaap_surp,g_gpv_r
                             ,g_benrsv,g_mer
                             ,gaap_upr,g_pv_fel
                             ,g_pv_def,g_pv_egp
                             ,exp_alpha,exp_beta
                             ,prem_disc,exp_gamma
                             ,re_ced_prm,re_clms
                             ,re_exp,re_pr_comm
                             ,re_result,tran_rider
                             ,ph_load,aos_prm_ld
                             ,aos_exp,aos_sur
                             ,aos_other,aos_surp
                             ,aos_re_prf,net_prem_r
                             ,risk_prem,prem_load
                             ,load_alpha,load_beta
                             ,load_gamma,prem_data
                             ,prem_if_b,prem_nb
                             ,fa_data,face_val
                             ,face_nb,face_dth
                             ,prem_if_c,face_lapse
                             ,face_if_e,num_pols_b
                             ,num_nb,num_dth
                             ,num_mat,num_lapse
                             ,pol_data,policies_b
                             ,g_inv_ic,fund_alloc
                             ,fund_b,fee_maint
                             ,fee_fixed,fee_riskp
                             ,fee_rp_tot,fund_int_b
                             ,fund_m,fund_death
                             ,fund_lapse,fee_gmab
                             ,fee_gmdb,fee_mgt
                             ,fund_mgt_a,fund_int_e
                             ,fund_e,fund_int
                             ,fund_incr,fund_mat
                             ,fundsurprf,claim_gmab
                             ,claim_gmdb,resgmabinc
                             ,res_gmab_e,resgmab_ic
                             ,resgmab_ie,res_gmdb_e
                             ,resgmdbinc,resgmdb_ic
                             ,resgmdb_ie,cl_add_dth
                             ,ad_dth_b,ad_dth_e
                             ,g_exp_prf,g_fe_load
                             ,g_pv_def_d,g_pv_eg_d
                             ,g_pv_fel_d,prm_sg_col
                             ,prm_m1_col,prm_y1_col
                             ,prm_y2_col,prm_y3_col
                             ,prm_y4_col,prm_totcol
                             ,cl_mat_col,cl_srv_col
                             ,cl_dth_col,cl_sur_col
                             ,cl_tot_col,gres_i_col
                             ,g_url_amor,g_url_int
                             ,g_dac_amor,g_dac_int
                             ,g_soe_risk,g_soe_lap
                             ,g_soe_inv,g_soe_exp
                             ,g_soe_rein,g_soe_oth
                             ,soe_risk,soe_lapse
                             ,soe_inv,soe_exp
                             ,soe_reins,soe_oth
                             ,ann_assure,n_ann_rv_e
                             ,n_ann_p_e,ann_base
                             ,exp_claim,prm_h_p_am
                             ,prm_h_p
  		                     from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' and ' 
  		                           + @p_sheet + '=''' + @p_excelSheet +
        		              ''' order by time,cal_year,cal_month'
        print 'insert into openrowset (''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;Database=' 
  	                + @p_outputPath_d + @p_excelFile + '.xls;'','' SELECT * FROM [' + @p_excelSheet + '$]'')'
  	                + '.... from [' + @p_dataBaseName +'].[dbo].['+ @p_loadTable + '] where ' + @p_file + '=''' + @p_excelFile + ''' and ' 
  		                           + @p_sheet + '=''' + @p_excelSheet 
                      + ''' order by time,cal_year,cal_month'		
        end                    
	EXEC(@sqlInsert)	
	
	PRINT '/* ==== sp_d32_out_insert_var end =================================================== */';

END
	
SET ANSI_PADDING OFF
GO	

