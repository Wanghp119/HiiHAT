pro hiihat_segment_spectra_doit,fileName,SegmentFile,out_filename
  COMPILE_OPT IDL2
  compile_opt strictarr
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'
  
  debug = hiihat_get_config_parm('debug')
  verbose = hiihat_get_config_parm('verbose')
  ;fileName='C:\Users\华硕\Desktop\RSAreialHyperX\can_tmr.img'
  ;SegmentFile='C:\Users\华硕\Desktop\RSAreialHyperX\stcan_tmr.img'

  ; out_filename='C:\Users\华硕\Desktop\RSAreialHyperX\out_filename'
  ;ratioed_out_filename='C:\Users\华硕\Desktop\RSAreialHyperX\ratioed_out_filename.img'
  ENVI_OPEN_FILE, fileName, R_FID=img_fid,/NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF img_fid EQ -1 then RETURN
  ENVI_FILE_QUERY, img_fid, DIMS=use_dims,nb = nb , nl = nl

  ENVI_OPEN_FILE, SegmentFile, R_FID=Seg_fid,/NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF Seg_fid EQ -1 then RETURN
  ENVI_FILE_QUERY, Seg_fid, DIMS=Seg_dims2,nb1 = nb1 , n2 = n2

  hiihat_segment_spectra, img_fid, Seg_fid, spectra=spectra, $
    r_fid = r_fid, verbose=verbose, mean_fid=mean_fid, $
    mean_image_name=out_filename, return_image=1
      ENVI_BATCH_EXIT
end