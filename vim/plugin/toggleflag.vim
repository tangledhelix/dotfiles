" Toggle the value of a flag in a flag option (e.g. complete)
function ToggleFlag(option, flag, feature)
  exec ('let lopt = &' . a:option)
  if lopt =~ (".*" . a:flag . ".*")
    exec ('set ' . a:option . '-=' . a:flag)
    echo a:feature . ' disabled'
  else
    exec ('set ' . a:option . '+=' . a:flag)
    echo a:feature . ' enabled'
  endif
endfunction

