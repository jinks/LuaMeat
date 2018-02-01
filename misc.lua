
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
  local years = math.floor(diff / 31557600)
  local remainder = diff % 31557600
  local months = math.floor(remainder / 2629800)
  local remainder = diff % 2629800
  local days = math.floor(remainder / 86400)
  local remainder = diff % 86400
  local hours = math.floor(remainder / 3600)
  local remainder = diff % 3600
  local mins = math.floor(remainder / 60)
  local rval = ""
  if years > 0 then
    rval = rval..pluralize(years, "year").." "
  end
  if months > 0 then
    rval = rval..pluralize(months, "month").." "
  end
  if days > 0 then
    rval = rval..pluralize(days, "day").." "
  end
  if hours > 0 then
    rval = rval..pluralize(hours,"hour").." and "..pluralize(mins,"minute")
  else
    rval = rval..pluralize(mins,"minute")
  end
  return rval
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
