-- Getting information out of Twitch

local json = require("json")
local https = require("ssl.https")
local ltn12 = require("ltn12")
local msc = require("misc")

local function fetch_data (endpoint)
  local response = {}
  local r,c,h = https.request{url = "https://api.twitch.tv/kraken/"..endpoint,
                              headers = { accept = "application/vnd.twitchtv.v3+json"},
                              sink = ltn12.sink.table(response)}
  return json.decode(table.concat(response))
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
