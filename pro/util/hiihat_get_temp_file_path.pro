FUNCTION hiihat_get_temp_file_path, filename, suffix=suffix
  if ~keyword_set(suffix) then suffix = '_tmp'
  
  dotpos = filename.LastIndexOf('.',/FOLD_CASE)
  if dotpos gt -1 then begin
    temp_file_path = strmid(filename, 0, dotpos) + suffix + strmid(filename, dotpos);
  endif else begin
    temp_file_path = filename + suffix 
  endelse
  
  return, temp_file_path
END