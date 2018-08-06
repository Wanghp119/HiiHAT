;+
; Normalize an input image by the L1, L2, or L Inf norm
;
; :Categories:
;   util
;
; :Params:
;   image, in, required, type="fltarr(ns,nl,nb)"
;    image to normalize
;   norm_type, in, required, type=string
;    normalization function to use
;
; :Returns:
;   normalized copy of image
;
; :Examples:
;   The following code will normalize bands of the the input image I by the L2 norm
;
;   normalize_image, I, 'Euclidean (L 2)'
;
; :Author: Lukas Mandrake and Brian Bue
; :History:
;   2009 (LM): code initially written in hiihat_preprocess.pro
;
;   Dec 05, 2010 (BDB): routine created from proprocessing code
;
; :Copyright:
;  Copyright 2010, by the California Institute of Technology. ALL RIGHTS
;  RESERVED. United States Government Sponsorship acknowledged. Any commercial
;  use must be negotiated with the Office of Technology Transfer at the
;  California Institute of Technology.
;
;  This software may be subject to U.S. export control laws and regulations. By
;  accepting this document, the user agrees to comply with all applicable U.S.
;  export laws and regulations.  User has the responsibility to obtain export
;  licenses, or other export authority as may be required before exporting such
;  information to foreign countries or providing access to foreign persons.
;-
pro hiihat_normalize_image_doit, fid, norm_type,$
  out_filename, r_fid=r_fid
  
  COMPILE_OPT IDL2
  
  r_fid = -1L;
  
  title='hiihat_normalize_image'
  debug =  hiihat_get_config_parm('debug')
  if debug then print, "Entering "+title
 
  ;; FIXME: this can probably be vectorized easily...
  ENVI_FILE_QUERY, fid, nl=n_lines, $
    ns=n_samples, nb=n_bands, dims=dims,$
    wl=wl,data_type=dt, offset=offset,$
    map_info = map_info,   $
    bnames = bnames,     $
    wavelength_units = wu, $
    fwhm = fwhm,$
    sensor_type = sensor_type, $
    file_type = file_type

  if norm_type eq "None" then goto, cleanup
  
  pos = indgen(n_bands)
  
  openw, lun, out_filename, /GET_LUN
  if lun eq -1 then begin
    print, 'Write Normalize image file failed.'
    goto, cleanup
  endif
  
  ;; Read File By BIL Tile
  tile_id = ENVI_INIT_TILE(fid, pos, NUM_TILES=num_tiles, INTERLEAVE=1);BIL  
  envi_report_init, "Normalizing Image", base=base, /INTERRUPT, title=title
  envi_report_inc, base, num_tiles-1

  for i=0, num_tiles-1 do begin
    envi_report_stat, base, i, num_tiles-1, cancel=cancel
    if cancel then goto, cleanup
    
    img_tile = ENVI_GET_TILE(tile_id, i)
    sz_tile = size(img_tile);
    
    for j=0, sz_tile[1]-1 do begin
      img_tile[j,*] = hiihat_normalize_array(img_tile[j,*], norm_type)
    endfor
    
    writeu, lun, img_tile; write by bil
  endfor
  
  img_tile = 0;
  free_lun, lun, /FORCE;CLOSE LUN
  
  ; Write Head File
  ENVI_SETUP_HEAD, fname=out_filename,  $
    ns=n_samples, nl=n_lines, $
    nb=n_bands, wl=wl, $
    interleave=1, data_type=dt,         $;BIL
    offset=offset, map_info=map_info,   $
    bnames = bnames,                    $
    wavelength_units = wu,              $
    fwhm = fwhm,                        $
    sensor_type = sensor_type,          $
    file_type = file_type,              $
    /write, /open, r_fid = r_fid
  
  cleanup:
  envi_report_init, base=base, /finish
  if debug then print, "Exiting "+title
end