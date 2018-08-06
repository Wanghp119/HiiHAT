;+
; Divide image by mean or mean column spectrum
;
; :Categories: util
;
; :Params:
;   image, in, required, type="fltarr(ns,nl,nb)"
;    image to filter
;   div_type, in, required, type=string
;    type of division to perform, "None", "Spatial Mean", "Spectral
;    Mean", or "Spectrum"
;
; :Returns:
;   filtered copy of image
;
; :Examples:
;   The following code divides the mean spectrum out of image I
;
;   hiihat_divide_mean, I, "Spectral Mean"
;
; :Author: Lukas Mandrake and Brian Bue
;
; :History:
;   2009 (LM): code initially written in hiihat_preprocess.pro
;
;   Dec 05, 2010 (BDB): routine created from proprocessing code
;
; :Copyright:
;  Copyright 2009, by the California Institute of Technology. ALL RIGHTS
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
pro hiihat_divide_mean_doit, fid, div_type, out_filename,$
  denom_spectrum=denom_spectrum, r_fid=r_fid

  r_fid = -1L

  title='hiihat_divide_mean'
  debug =  hiihat_get_config_parm('debug')
  if debug then print, "Entering "+title

  if div_type eq "None" then goto, cleanup

  ENVI_FILE_QUERY, fid, nl=n_lines, $
    ns=n_samples, nb=n_bands, dims=dims,$
    wl=wl,data_type=dt, offset=offset,$
    map_info = map_info,   $
    bnames = bnames,     $
    wavelength_units = wu, $
    fwhm = fwhm,$
    sensor_type = sensor_type, $
    file_type = file_type

  envi_report_init, "Mean Division", base=base, /INTERRUPT, title=title
  envi_report_inc, base, n_bands-1

  mod_step = round(n_bands/10)

  ;;
  openw, lun, out_filename, /get_lun
  if lun eq -1 then begin
    print, 'open file failed.'
    goto, cleanup
  endif
  
  ;; divide by mean spectrum
  ;; but you've got to do better than this...
  ;; you can't let negative values into your averaging, unfortunately,
  ;; making the entire calculation take a ton more time
  if div_type eq "Spatial Mean" then begin
    img = fltarr(n_samples, n_lines)

    for j=0,(n_bands-1) do begin
      band_mean   = 0.0
      if j mod mod_step eq 0 then begin
        envi_report_stat, base, j, n_bands-1, cancel=cancel
        if cancel then goto, cleanup
      endif
      img = envi_get_data(FID=fid, dims=dims, pos=j);
      idx = where(img gt 0.0)
      band_mean = mean(img[idx])
      img = img / band_mean
      
      writeu, lun, img
    endfor;by bands    
  endif else if div_type eq "Spectral Mean" then begin
    ;; divide by mean spectrum FOR EACH COLUMN
    ;; but you've got to do better than this...
    ;; you can't let negative values into your averaging, unfortunately,
    ;; making the entire calculation take a ton more time
    ;; column dependence is to remove striping noise effects
    img = fltarr(n_samples, n_lines)
    for j=0,(n_bands-1) do begin
      if j mod mod_step eq 0 then begin
        envi_report_stat, base, j, n_bands-1, cancel=cancel
        if cancel then goto, cleanup
      endif
      for x=0,n_samples-1 do begin
        ;; print, x, j
        band_mean = 0.0
        img = envi_get_data(FID=fid, dims=dims, pos=j)
        idx = where(img[x,*] gt 0.0)
        band_mean = mean(image[x,idx])
        img[x,*] = img[x,*]/band_mean
      endfor;by samples
      
      writeu, lun, img
    endfor;by bands
  endif else if div_type eq "Spectrum" then begin
    ;; divide the image by the given spectrum
    if keyword_set(denom_spectrum) then begin
      img = fltarr(n_samples, n_lines)
      for j=0,(n_bands-1) do begin
        img = envi_get_data(FID=fid, dims=dims, pos=j)
        img = img / denom_spectrum[j]
        
        writeu, lun, img
      endfor
    endif else begin
      print, "Denominator spectrum is not specified."
    endelse
  endif else begin
    print, "Unknown div_type: ", div_type
  endelse

  img = 0;
  free_lun, lun, /FORCE;

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
