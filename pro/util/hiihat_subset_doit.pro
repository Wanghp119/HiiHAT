PRO hiihat_subset_doit, in_fid, selected_bands, $
  out_filename, r_fid=r_fid

  r_fid = -1L

  title='hiihat_subsetting_image'
  debug =  hiihat_get_config_parm('debug')

  ENVI_FILE_QUERY, fid, nl=m_lines, $
    ns=n_samples, nb=n_bands, dims=dims,$
    wl=wl,data_type=dt, offset=offset,$
    map_info = map_info,   $
    bnames = bnames,     $
    wavelength_units = wu, $
    fwhm = fwhm,$
    sensor_type = sensor_type, $
    file_type = file_type

  n_selected_bands = n_elements(selected_bands)

  if n_selected_bands eq n_bands then begin
    r_fid = in_fid
    goto, cleanup
  endif

  ;; Open Write File
  openw, lun, out_filename, /GET_LUN
  if lun eq -1 then begin
    print, 'Save File Failed.'
    goto, cleanup
  endif

  envi_report_init, "Subsetting image", base=base, /INTERRUPT, title=title
  envi_report_inc, base, n_selected_bands-1
  for i=0,n_selected_bands-1 do begin
    envi_report_stat, base, i, n_selected_bands-1, cancel=cancel
    if cancel then goto, cleanup

    img = envi_get_data(FID=in_fid, dims=dims, pos=selected_bands[i])

    writeu, lun, img
  endfor

  close, lun  ;close file

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