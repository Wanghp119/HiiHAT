pro LearnRoIDialog,reg_parms=reg_parms, max_samples=max_samples,reg_tune=reg_tune
  
  
compile_opt strictarr
    debug = hiihat_get_config_parm('debug')
    gui_status = hiihat_get_config_parm('gui_status')

    title = 'hiihat_learn_metric_ask_params'
    if debug then print, "Entering "+title

    ;; don't cancel unless user bails out
    learn_metric_cancel = 0


    ;if not keyword_set(base_filename) then begin 
     ;  def_filename='hiihat_learn_metric'
   ; endif else begin
   ;    def_filename=hiihat_strreplace(base_filename,'.img','',ignore_case=1)+'_lda'
   ; endelse

    ;base = widget_auto_base(title='度量学习参数设置') 
    ;nil = widget_param(base, dt=3, field=3, floor=1, default=string(max_samples), $
     ;       prompt='每类的最大采样数', uvalue='max_samples', /auto)  
    ;nil = widget_sslider(base, dt=3, floor=0, ceil=100, min=0, max=100, value=reg_tune, $
    ;        title='规则化比例(%)', uvalue='reg_tune', field=0, /auto)  
    ;nil = widget_outfm(base, prompt="输出文件", uvalue='outf', $
    ;                   default=def_filename+'.img', /auto)
    ;nil = widget_outfm(base, prompt="矩阵输出文件", uvalue='outf_mat', $
    ;                   default=def_filename+'_matrix.img', /auto)
    

   ; result = auto_wid_mng(base) 

    ;if (result.accept eq 0) then begin 
    ;   learn_metric_cancel = 1
    ;   goto, cleanup
    ;endif  

    ; select an output file



    reg_type = 'constant' 
    lambda_min = 0.0
    lambda_max = 1.0
    fold_min = 2
    fold_max = 10
    delta_min = 0.01
    delta_max = 0.25

    num_folds = fold_min+fix((fold_max-fold_min)*reg_tune)
    lambda_delta = delta_min+((delta_max-delta_min)*(1.0-reg_tune))

    ;lambda_delta = float(result.lambda_delta)
    ;num_folds = fix(result.num_folds)
    
    reg_parms = {reg_type:reg_type, lambda:lambda_min, lambda_min:lambda_min,$
                 lambda_max:lambda_max, lambda_delta:lambda_delta, num_folds:num_folds}
 
   
end