;+
; Perform low-pass image filtering on the given image
;
; :Categories: util
;
; :Params:
;   fid, in, required,
;    image to filter
;   filt_size, in, required, type=fix
;    size of filter
;
;
; :Returns:
;   filtered copy of image
;
; :Examples:
;   The following code filter bands with a kernel of size 5
;
;   hiihat_lowpass_image_filter, I, 5
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
pro hiihat_lowpass_image_filter_doit, fid, filt_size,$
  out_filename, r_fid=r_fid

  title='hiihat_lowpass_image_filter'
  debug = hiihat_get_config_parm('debug')
  if debug then print, "Entering "+title

  if filt_size le 0 then goto, cleanup

  ENVI_FILE_QUERY, fid, nl=n_lines, $
    ns=n_samples, nb=n_bands, dims=dims,$
    wl=wl,data_type=dt, offset=offset,$
    map_info = map_info,   $
    bnames = bnames,     $
    wavelength_units = wu, $
    fwhm = fwhm,$
    sensor_type = sensor_type, $
    file_type = file_type

  ;; Open Write File
  openw, lun, out_filename, /GET_LUN
  if lun eq -1 then begin
    print, 'Save File Failed.'
    goto, cleanup
  endif

  envi_report_init, "Lowpass Filtering", base=base, /INTERRUPT, title=title
  envi_report_inc, base, n_bands-1

  kernelSize = [filt_size, filt_size]
  kernel = replicate((1./(kernelSize[0]*kernelSize[1])), $
    kernelSize[0], kernelSize[1])
  for i=0,(n_bands-1) do begin
    envi_report_stat, base, i, n_bands-1, cancel=cancel
    if cancel then goto, cleanup

    img = envi_get_data(FID=fid, DIMS=dims, pos=i)
    
    img[*,*] = convol(float(img[*,*]), kernel, $
      /center, /edge_truncate)

    writeu, lun, img
  endfor

  img = 0;
  free_lun, lun, /FORCE  ;close file

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