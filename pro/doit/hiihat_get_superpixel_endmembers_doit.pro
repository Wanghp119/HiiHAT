;
;  method="SMACC"
;  coalesce_threshold=0
;  base_filename="D:\Temp\cup95eff.int"
;  seg_file="D:\Temp\cup95eff.int_seg.img"
;  n_endmembers=10
;  roi_out_filename="D:\Temp\cup95eff.int_endm.roi"
;  out_filename="D:\Temp\cup95eff.int_endm.sli"
;
pro hiihat_get_superpixel_endmembers_doit, $
  base_filename, seg_file,$
  out_filename,roi_out_filename,$
  n_endmembers, coalesce_threshold,method
    
  ;Set compiler and debug options
  compile_opt idl2
  compile_opt strictarr

  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'
  
  debug = hiihat_get_config_parm('debug')
  verbose = hiihat_get_config_parm('verbose')
  gui_status = hiihat_get_config_parm('gui_status')

  ENVI_OPEN_FILE, base_filename, R_FID=img_fid, /NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF img_fid EQ -1 then goto, cleanup
  ENVI_FILE_QUERY, img_fid, DIMS=use_dims,nb = nb , nl = nl
    
  ENVI_OPEN_FILE, seg_file, R_FID=seg_fid, /NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF seg_fid EQ -1 then goto, cleanup
  envi_file_query, seg_fid, nb = nb_seg, nl = nl_seg
    
  use_nfindr = (method eq "NFINDR")
  if roi_out_filename ne "" then begin
    ;; call the endmember routine and write ROIs
    hiihat_get_superpixel_endmembers, img_fid, seg_fid=seg_fid, $
      n_endmembers = n_endmembers, out_name_roi = roi_out_filename, $
      out_name_sli =out_filename, coalesce_threshold=coalesce_threshold, $
      use_dims = use_dims, verbose=verbose, use_nfindr=use_nfindr

  endif else begin
    ;; get endmembers without writing ROIs
    hiihat_get_superpixel_endmembers, img_fid, seg_fid=seg_fid, n_endmembers = n_endmembers, $
      out_name_sli =out_filename, coalesce_threshold=coalesce_threshold, $
      use_dims = use_dims, verbose=verbose, use_nfindr=use_nfindr

  endelse

  if verbose then print,"Endmember ROI's and spectra are now available"
  
  cleanup:
  ; clean up
  ;;if seg_in_memory then envi_file_mng, id=seg_fid, /remove
  if debug then print,'Exiting '+"result"
  ENVI_BATCH_EXIT
end
