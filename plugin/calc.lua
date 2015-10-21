--  Nice plugin that uses google's calculator
--  Google's calculator is fun!
--  How to use:
--  !calc <Operation>
--  Example:
--  !calc 1+1
--  !calc sin(0.5)
--  !calc speed of light / sin(0.5)

local socket = require("socket")
local url = require("socket.url")
local json = require("json")

plugin.calc = function (target, from, arg)
  local sb_env= {ipairs = ipairs,
                 next = next,
                 pairs = pairs,
                 pcall = pcall,
                 tonumber = tonumber,
                 tostring = tostring,
                 type = type,
                 unpack = unpack,
                 coroutine = { create = coroutine.create, resume = coroutine.resume,
                               running = coroutine.running, status = coroutine.status,
                               wrap = coroutine.wrap },
                 string = { byte = string.byte, char = string.char, find = string.find,
                            format = string.format, gmatch = string.gmatch, gsub = string.gsub,
                            len = string.len, lower = string.lower, match = string.match,
                            rep = string.rep, reverse = string.reverse, sub = string.sub,
                            upper = string.upper },
                 table = { insert = table.insert, maxn = table.maxn, remove = table.remove,
                           sort = table.sort },
                 math = { abs = math.abs, acos = math.acos, asin = math.asin,
                          atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos,
                          cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor,
                          fmod = math.fmod, frexp = math.frexp, huge = math.huge,
                          ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max,
                          min = math.min, modf = math.modf, pi = math.pi, pow = math.pow,
                          rad = math.rad, random = math.random, sin = math.sin, sinh = math.sinh,
                          sqrt = math.sqrt, tan = math.tan, tanh = math.tanh },
                 os = { clock = os.clock, difftime = os.difftime, time = os.time },}
  local func = load("return function() return "..arg.." end", "IIRC", "t", sb_env)
  local status, result
  if func then
    status, result = pcall(func())
  else
    status = true
    result = "INVALID CALL"
  end

  local r
  if status then
    if not result then result = "nil" end
    r = arg .. " = " .. tostring(result)
  else
    r = "ERROR: " .. result
  end
  irc.say(target,r)
end
