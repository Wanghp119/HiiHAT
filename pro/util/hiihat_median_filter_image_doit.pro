;+
; Median filter image
;
; :Categories:
;   util
;
; :Params:
;   img, in, required, type="fltarr(ns,nl,nb)"
;    image to median filter
;   median_filter_width, in, required, type=fix
;    width in bands of median filter to use
;
; :Returns:
;   median filtered image
;
; :Examples:
;   The following code will median filter the bands of the the input image I
;   with a width 3 filter
;
;   hiihat_median_filter_image, I, 3
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
pro hiihat_median_filter_image_doit, fid, median_filter_width, $
  out_filename, r_fid=r_fid

  COMPILE_OPT IDL2
  
  r_fid = -1L;

  title='hiihat_median_filter_image'

  debug =  hiihat_get_config_parm('debug')
  if debug then print, "Entering "+title

  ENVI_FILE_QUERY, fid, nl=n_lines, $
    ns=n_samples, nb=n_bands, dims=dims,$
    wl=wl,data_type=dt, offset=offset,$
    map_info = map_info,   $
    bnames = bnames,     $
    wavelength_units = wu, $
    fwhm = fwhm,$
    sensor_type = sensor_type, $
    file_type = file_type

  envi_report_init, "Median Filtering", base=base, /INTERRUPT, title=title
  envi_report_inc, base, n_bands-1

  if median_filter_width le 0 then goto, cleanup

  mod_step = round(n_bands/10)

  img_filtered = fltarr(n_samples, n_lines)
  img = fltarr(n_samples, n_lines, median_filter_width*2+1)

  openw, lun, out_filename, /GET_LUN
  if lun lt 1 then begin
    print, 'save ', out_filename, ' Failed.'
    goto, cleanup
  endif

  for j=0,n_bands-1 do begin
    if j mod mod_step eq 0 then begin
      envi_report_stat, base, j, n_bands-1, cancel=cancel
      if cancel then goto, cleanup
    endif

    ;; determine safe boundaries near edges
    min_band = max([j - median_filter_width, 0        ])
    max_band = min([j + median_filter_width, n_bands-1])

    ;;print,j, n_bands-1
    band_range = lindgen(max_band-min_band+1)+min_band

    for i=0,n_elements(band_range)-1 do begin
      img[*,*,i] = envi_get_data(FID=fid, pos=band_range[i], dims=dims)
    endfor

    img_filtered[*,*] = median(img[*,*,lindgen(max_band-min_band+1)], dimension=3)

    ;; write file
    WRITEU, lun, img_filtered
  endfor

  img = 0     ;free
  img_filtered = 0  ;free
  free_lun, lun  ;close unit

  ; Write Head File
  ENVI_SETUP_HEAD, fname=out_filename,  $
    ns=n_samples, nl=n_lines, $
    nb=n_bands, wl=wl, $
    interleave=0, data_type=dt,         $
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
