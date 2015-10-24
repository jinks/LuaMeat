
local function pluralize (val, str)
  if val > 1 or val == 0 then
    return val.." "..str.."s"
  else
    return val.." "..str
  end
end

function elapsed (datestring)
  local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z"
  local year,month,day,hour,min,sec = datestring:match(pattern)
  local start = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec, isdst = false })
  local utcnow = os.time(os.date("!*t"))
  local diff = utcnow-start
  local days = math.floor(diff/86400)
  local hours = math.floor(diff/3600 - days*24)
  local mins = math.floor(diff/60 - hours*60 - days*24)
  local rval = ""
  if days > 0 then
    rval = pluralize(days, "day").." "
  end
  if hours > 0 then
    rval = rval..pluralize(hours,"hour").." and "..pluralize(mins,"minute")
  else
    rval = rval..pluralize(mins,"minute")
  end
  return rval
end
