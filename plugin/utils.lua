-- Small utilty commands that return static text and don't fit anywhere else.

-- Bot's code repository
plugin.code = function (target, from, arg)
  irc.say(target, "My source code can be found at https://github.com/jinks/LuaMeat")
end
plugin.source = plugin.code
