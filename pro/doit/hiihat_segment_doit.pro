;
; C=0.001 float
; min_size=20 fix
; dist_metric='Euclidean'
; out_filename='C:\Users\Desktop\RSAreialHyperX\can_tmr_3.img'
; filename='C:\Users\Desktop\RSAreialHyperX\can_tmr.img'
;
PRO hiihat_segment_doit, c, min_size, dist_metric, $
  filename, out_filename
     
  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'
  
   in_memory=0
   segment_cancel=0

  ENVI_OPEN_FILE, filename, R_FID=img_fid,/NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF img_fid EQ -1 then RETURN
  ENVI_FILE_QUERY, img_fid, DIMS=use_dims,nb = nb , nl = nl
  
  in_file_id=img_fid
  compile_opt strictarr
  debug = hiihat_get_config_parm('debug')
  verbose = hiihat_get_config_parm('verbose')
 ;; gui_status = hiihat_get_config_parm('gui_status')

  title='hiihat_event_segment'
  if debug then print, "Entering "+title
  
  if segment_cancel then begin
    dialog='Segmentation cancelled'
    if not gui_status then print,dialog else ok=dialog_message(dialog,title=title)
    goto, CLEANUP
  endif
  if verbose then print, "Computing segmentation"
  hiihat_segment_felzenszwalb, in_file_id, c, min_size, dist_metric, M=M, $
    out_filename=out_filename, r_fid=segments_fid, use_dims=use_dims, $
    verbose=verbose, in_memory=in_memory, /permute_segments

  CLEANUP:
  if debug then print, "Exiting "+title
  ENVI_BATCH_EXIT
end