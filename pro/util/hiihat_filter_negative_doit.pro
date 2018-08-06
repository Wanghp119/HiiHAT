;+
; :Author: Apple
;-

PRO hiihat_filter_negative_doit, fid, out_filename, r_fid=r_fid
  COMPILE_OPT IDL2

  r_fid = -1L

  title = 'hiihat_filter_negative'
  debug =  hiihat_get_config_parm('debug')
  finite_max = hiihat_get_config_parm('finite_max')
  if finite_max eq 0 then finite_max = 10000.0

  ;; Open Write File
  openw, lun, out_filename, /GET_LUN
  if lun eq -1 then begin
    print, 'Save File Failed.'
    goto, cleanup
  endif

  ENVI_FILE_QUERY, fid, nl=n_lines, $
    ns=n_samples, nb=n_bands, dims=dims,$
    wl=wl,data_type=dt, offset=offset,$
    map_info = map_info,   $
    bnames = bnames,     $
    wavelength_units = wu, $
    fwhm = fwhm,$
    sensor_type = sensor_type, $
    file_type = file_type

  img = fltarr(n_samples, n_lines)
  envi_report_init, "Filtering negative values", base=base, /INTERRUPT, title=title
  envi_report_inc, base, n_bands-1
  for i=0,n_bands-1 do begin
    envi_report_stat, base, i, n_bands-1, cancel=cancel
    if cancel then goto, cleanup

    img[*,*] = envi_get_data(fid=fid, dims=dims, pos=i)
    bad_idx = where(img lt 0)
    if bad_idx[0] ne -1 then begin
      if verbose then print, "Setting ", n_elements(bad_idx), " negative elements to zero"
      img[bad_idx] = 0.0
    endif

    writeu, lun, img  ;write temp
  endfor

  free_lun, lun, /FORCE  ;;close

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
END