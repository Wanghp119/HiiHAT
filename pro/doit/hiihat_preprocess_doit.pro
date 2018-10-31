;
;in_fname='D:\\Temp\\cup95eff.int'
;out_filename='D:\\Temp\\cup95eff.int_pp.img'
;median_filter_width=2
;norm_type='None'
;div_type='None'
;lowpass_filter=1
;filter_negative=0
;image_type = "Generic"
;

PRO HIIHAT_PREPROCESS_DOIT, in_fname, out_filename,$
	median_filter_width, norm_type, div_type, $
	lowpass_filter, filter_negative, image_type

  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'

  verbose =  HIIHAT_GET_CONFIG_PARM('verbose')
  debug =  HIIHAT_GET_CONFIG_PARM('debug')
  gui_status =  HIIHAT_GET_CONFIG_PARM('gui_status')

  title='hiihat_event_preprocess'

  IF debug THEN PRINT, "Entering "+title

  ;;default values

  in_memory = 0

  ; load an image (code from the envi user guide)
  ;  ENVI_SELECT, fid=in_file_id, title="Select an input image", dims=use_dims, /NO_SPEC
  ENVI_OPEN_FILE,in_fname, R_FID = in_file_id
  IF (in_file_id EQ -1) THEN BEGIN
    IF debug THEN PRINT, 'ENVI Open File Failed. -- ' + in_fname
    GOTO, cleanup
  ENDIF
  ENVI_FILE_QUERY, in_file_id, descrip=descrip, dims=use_dims

  HIIHAT_PREPROCESS, in_file_id, $
    out_filename=out_filename, $
    image_type = image_type, $
    filter_negative = filter_negative, $
    median_filter_width = median_filter_width, $
    norm_type = norm_type, $
    div_type = div_type, $
    lowpass_filter = lowpass_filter, $
    use_dims = use_dims, $
    in_memory=in_memory,$
    verbose = verbose

  CLEANUP:
  IF debug THEN PRINT, "Exiting "+title
  if in_file_id ne -1 then ENVI_FILE_MNG, id=in_file_id, /REMOVE
  ENVI_BATCH_EXIT  
END