pro hiihat_get_neutral_region_doit,fileName,$
  SegmentFile,out_filename,ratioed_out_filename


  COMPILE_OPT IDL2
  compile_opt strictarr
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'
  
 
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
  debug = hiihat_get_config_parm('debug')
  verbose = hiihat_get_config_parm('verbose')
  gui_status = hiihat_get_config_parm('gui_status')
  ; do a new segmentation, if required
  seg_in_memory = 0
 ; if (seg_fid eq -1) then begin
 ;   if verbose then print,"Performing segmentation"
 ;   hiihat_segment_ask_params, c=c, min_size=min_size, $
 ;     dist_metric=dist_metric, $
 ;     segment_cancel=segment_cancel

;    if segment_cancel then begin
 ;     dialog = 'Segmentation cancelled'
 ;     if not gui_status then print, dialog else ok = dialog_message(dialog, title=title)
 ;     goto, CLEANUP
;    endif
;    hiihat_segment_felzenszwalb, img_fid, c, min_size, dist_metric, $
 ;     r_fid=seg_fid, use_dims = use_dims, /in_memory

 ;  seg_in_memory = 1
 ; endif
  
  ; call the neutral region routine
  hiihat_get_neutral_region, img_fid=img_fid, seg_fid=seg_fid, $
    roi_out_id = roi_out_id, spectrum_out_filename=out_filename,$
    ratioed_out_filename=ratioed_out_filename,$
    coalesce_threshold=coalesce_threshold, use_dims = use_dims,$
    verbose=verbose

  cleanup:
  ; clean up
  if (seg_in_memory) then envi_file_mng, id=seg_fid, /remove
 ; if debug then print, "Exiting "+title
  ENVI_BATCH_EXIT
  
end