require "luarocks.loader"
local irc = require 'irc'
sqlite3 = require "lsqlite3"


plugin = {}
callback = {}
on_join = {}
on_part = {}

DB = sqlite3.open("bot.db")

require('config')

irc.DEBUG = true

irc.register_callback("connect", function()
    irc.send("CAP REQ  :twitch.tv/membership") -- request twitch to send join/paty notices...
    for i,v in ipairs(defaulChannels) do
        irc.join(v)
    end
end)

irc.register_callback("channel_msg", function(channel, from, message)
    local is_cmd, cmd, arg = message:match("^(@)(%w+)%s*(.*)$")
    if is_cmd and plugin[cmd] then
        plugin[cmd](channel.name, from, arg)
    end
    for k,v in pairs(callback) do
        if type(v) == "function" then
            v(channel.name, from, message)
        end
    end
end)

irc.register_callback("join", function(channel, from)
                        for k,v in pairs(on_join) do
                          if type(v) == "function" then
                            v(channel.name, from)
                          end
                        end
end)

irc.register_callback("part", function(channel, from, message)
                        for k,v in pairs(on_part) do
                          if type(v) == "function" then
                            v(channel.name, from)
                          end
                        end
end)


-- irc.register_callback("private_msg", function(from, message)
--     local is_cmd, cmd, arg = message:match("^(!)(%w+) (.*)$")
--     if is_cmd and plugin[cmd] then
--         plugin[cmd](from, from, arg)
--     end
--     for k,v in pairs(callback) do
--         if type(v) == "function" then
--             v(from, from, message)
--         end
--     end
-- end)
--[[
irc.register_callback("nick_change", function(from, old_nick)
end)
--]]

irc.connect{network = network, port = port, nick = nick, username = username, realname = realname, pass = password}

