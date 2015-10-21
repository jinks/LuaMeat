-- Getting information out of Twitch

local json = require("json")
local https = require("ssl.https")
local ltn12 = require("ltn12")

local function fetch_data (endpoint)
  local response = {}
  local r,c,h = https.request{url = "https://api.twitch.tv/kraken/"..endpoint,
                              headers = { accept = "application/vnd.twitchtv.v3+json"},
                              sink = ltn12.sink.table(response)}
  return json.decode(table.concat(response))
end

local function elapsed (datestring)
  local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z"
  local year,month,day,hour,min,sec = datestring:match(pattern)
  local start = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec, isdst = false })
  local utcnow = os.time(os.date("!*t"))
  local diff = utcnow-start
  local hours = math.floor(diff/3600)
  local mins = math.floor(diff/60 - hours*60)
  h = hours > 1 and " hours" or " hour"
  m = mins > 1 and " minutes" or " minute"
  if hours > 0 then
    return hours..h.." and "..mins..m
  else
    return mins..m
  end
end

plugin.uptime = function (target, from, arg)
  local channel = string.sub(target, 2)
  if arg and arg ~= "" then
    channel = arg
  end
  local j = fetch_data("streams/"..channel)
  if j.stream then
    if j.stream ~= json.decode("null") then
      irc.say(target, j.stream.channel.display_name.." is streaming ["..j.stream.game.."] for "..elapsed(j.stream.created_at)..".")
    else
      irc.say(target, channel.." is not streaming anything right now.")
    end
  else
    irc.say(target, "Stream "..channel.." not found.")
  end
end
