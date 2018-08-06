pro hiihat_apply_metric_doit,fileName,matrixfile,out_filename

  COMPILE_OPT IDL2
  compile_opt strictarr
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'
  
  ENVI_OPEN_FILE, fileName, R_FID=img_fid,/NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF img_fid EQ -1 then RETURN
  ENVI_FILE_QUERY, img_fid, DIMS=use_dims,nb = nb , nl = nl, pos=pos

  ENVI_OPEN_FILE, matrixfile, R_FID=matrix_fid,/NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF matrix_fid EQ -1 then RETURN
  
  in_memory=0
  if verbose then print, "Applying metric"
  hiihat_apply_metric, fileName, matrix_fid, out_filename, in_memory=in_memory,$
    pos=pos, use_dims=use_dims
    ENVI_BATCH_EXIT

end