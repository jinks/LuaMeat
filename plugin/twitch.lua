-- Getting information out of Twitch

local json = require("json")
local https = require("ssl.https")
local ltn12 = require("ltn12")
local msc = require("misc")
--local curl = require("cURL")

local function fetch_data(endpoint)
  local response = {}
  hdrs = { Accept = "application/vnd.twitchtv.v3+json", ["Client-ID"] = cid }
  local r,c,h = https.request{url = "https://api.twitch.tv/kraken/"..endpoint,
                              headers = hdrs,
                              sink = ltn12.sink.table(response)}
  return json.decode(table.concat(response))
end

--[[
local function fetch_data_curl (url)
    t = {}
    curl.easy()
      :setopt_url("https://api.twitch.tv/kraken/"..url)
      :setopt_httpheader{
          "Accept: application/vnd.twitchtv.v3+json",
          "Client-ID:".. cid
      }
      :setopt_writefunction(function(buf)
          table.insert(t,buf)
          return #buf
      end)
      :perform()
    return json.decode(table.concat(t))
end
]]

local COLOR = true

local ON = true
local outfile = io.output()

local function _message(msg_type, msg, color)
    if ON then
        local endcolor = ""
        if COLOR and outfile == io.stdout then
            color = color or "\027[1;30m"
            endcolor = "\027[0m"
        else
            color = ""
            endcolor = ""
        end
        outfile:write(color .. msg_type .. ": " .. msg .. endcolor .. "\n")
    end
end
-- }}}
function red(msg)
    _message("ERR", msg, "\027[0;31m")
end

function yellow(msg)
    _message("WARN", msg, "\027[0;33m")
end

local function match_any( str, pattern_list )
    for _, pattern in ipairs( pattern_list ) do
        local w = string.match( str, pattern )
        if w then return w end
    end
end

plugin.uptime = function (target, from, arg)
  local channel = string.sub(target, 2)
  if arg and arg ~= "" then
    channel = arg
  end
  local j = fetch_data("streams/"..channel)
  --print_r(j)
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

plugin.followage = function (target, from, arg)
  local channel = string.sub(target, 2)
  if arg and arg ~= "" then
    user = arg
  else
    user = from
  end
  local j = fetch_data("users/"..user.."/follows/channels/"..channel)
  --print_r(j)
  if j.channel and j.created_at then
    if j.created_at ~= json.decode("null") then
      irc.say(target, user.." is following "..j.channel.display_name.." for "..elapsed(j.created_at)..".")
    end
  elseif j.message then
    irc.say(target, "Error: " .. j.message)
  else
    irc.say(target, "Error: Could not find any data.")
  end

end

plugin.dilfa = function (target, from, arg)
    irc.say(target, "!img https://i.imgur.com/2rUOXMT.png")
end

plugin.owl = function (target, from, arg)
    irc.say(target, "!img https://i.imgur.com/C5Uz6Pv.gif")
end

plugin.bus = function (target, from, arg)
    irc.say(target, "!img https://memeguy.com/photos/images/short-bus-243553.jpg")
end

--[[
callback.fospam = function (target, from, message)
  local patterns = {
      ".*son%s.*%svillain.*",
      ".*son%s.*%sbadguy.*",
      ".*son%s.*%sbad%sguy.*",
      "have.*to.*bomb%s.*boston.*",
      "have.*to.*nuke%s.*boston.*",
      "have.*to.*bomb%s.*commonwealth.*",
      "have.*to.*nuke%s.*commonwealth.*",
  }

  local spam = match_any(message:lower(), patterns)
  if spam then
      irc.say(target, ".ban "..from)
      yellow("Banned "..from.." for spoliers ["..spam.."]!")
  end
end
]]
