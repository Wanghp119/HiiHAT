;+
; :Params:
;   in_fname: in, required, input image file, string
;   endmember_fname: in, required, endmember file, string
;   method: in, required, classification method, int same with CLASS_DOIT
;   class_out_filename: out, required, classifciation file, string
;   rule_out_filename: out, required, rule file, string
;-
PRO HIIHAT_CLASS_DOIT, in_fname, endmember_fname,$
  method, class_out_filename, rule_out_filename

  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, log_file='batch.txt'

  title = 'hiihat_class'

  class_in_memory = 0
  rule_in_memory = 0
    
  ;; default parameters
  verbose = HIIHAT_GET_CONFIG_PARM('verbose')
  debug = HIIHAT_GET_CONFIG_PARM('debug')
  gui_status = HIIHAT_GET_CONFIG_PARM('gui_status')
  robust_means = HIIHAT_GET_CONFIG_PARM('robust_means')

  IF debug THEN PRINT, "Entering " + title

  ;
  ; 1. Open Input Image File
  ;
  ENVI_OPEN_FILE, in_fname, R_FID = img_fid, /NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF (img_fid EQ -1) THEN BEGIN
    dialog = 'Invalid input image'
    IF NOT gui_status THEN PRINT, dialog ELSE ok=DIALOG_MESSAGE(dialog, title=title)
    GOTO, cleanup
  ENDIF
  ENVI_FILE_QUERY, img_fid, wl = img_wl, bnames = img_bnames, $
    dims = img_dims, wavelength_units = wavelength_units, $
    fwhm = img_fwhm

  ;
  ; 2. Open endmembers File
  ;
  ENVI_OPEN_FILE, endmember_fname, R_FID = endmember_fid, /NO_REALIZE, /NO_INTERACTIVE_QUERY,/INVISIBLE
  IF (endmember_fid EQ -1) THEN BEGIN
    dialog = 'Invalid endmember file'
    IF NOT gui_status THEN PRINT, dialog ELSE ok=DIALOG_MESSAGE(dialog, title=title)
    GOTO, cleanup
  ENDIF
  ENVI_FILE_QUERY, endmember_fid, ns = ns, nl = n_endmembers, dims = endmember_dims
  endmembers = ENVI_GET_DATA(fid = endmember_fid, dims = endmember_dims, pos=0)
  
  ;
  ; 3. Class Doit
  ; class color
  ;
  HIIHAT_GENERATE_CLASS_COLORS, n_endmembers, class_names = class_names, $
    colors=colors
  pos = INDGEN(ns) ;; ns is the number of bands in the spectral library    
  
  ;
  ; classification methods From CLASS_DOIT description
  ;
  class_method = ['0: Parallelepiped (supervised)', $
    '1: Minimum distance (supervised)', $
    '2: Maximum likelihood (supervised)', $
    '3: SAM (supervised)', $
    '4: ISODATA (unsupervised)', $
    '5: Mahalanobis (supervised)', $
    '6: Binary Encoding (supervised)', $
    '7: K-Means (unsupervised)', $
    '8: SID (supervised)']
  if verbose then print, "Classifying using method ",class_method[method]
  
  ;
  ; class doit
  ;
  ENVI_DOIT, 'CLASS_DOIT', fid = img_fid, mean = endmembers,$
    class_names = class_names, r_fid = r_fid, dims = img_dims, $
    method = method, out_name = class_out_filename, in_memory = class_in_memory, $
    pos=pos, lookup=colors, rule_in_memory = rule_in_memory, $
    rule_fid = rule_fid, rule_out_name = rule_out_filename
    
  CLEANUP:
  IF debug THEN PRINT, "Exiting " + title
  ENVI_BATCH_EXIT
END