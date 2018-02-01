local https = require("ssl.https")
local json = require("json")
local ltn12 = require("ltn12")

local function fetch_title (videoid)
  --local response = {}
  local r,c,h = https.request("https://www.googleapis.com/youtube/v3/videos?id="..videoid.."&key="..yt_api_key.."&part=snippet&fields=items(snippet(title))")
  local j = json.decode(r)
  if j and j.items and next(j.items) then
    return j.items[1].snippet.title
  end
end

callback.youtube = function (target, from, message)
  local ytid = message:match(".*https?://w?w?w?%.?youtube.com/watch%?v=(%g*)(#?.*)%s*.*")
  local ybid = message:match(".*https?://w?w?w?%.?youtu.be/(%g*)%s*.*")
  if ybid then
      ytid = ybid
  end
  if not ytid then return end
  if ytid:find("#") then
     ytid = ytid:match("(.*)#")
  end
  local t = fetch_title(ytid)
  if t then
    irc.say(target, "Youtube video title: "..t)
  end
end
