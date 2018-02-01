-- Small utilty commands that return static text and don't fit anywhere else.
booms = 0
last_boom = os.time()
last_unboom = os.time()

-- Bot's code repository
plugin.code = function (target, from, arg)
  irc.say(target, "My source code can be found at https://github.com/jinks/LuaMeat")
end
plugin.source = plugin.code

plugin.ping = function (target, from, arg)
  irc.say(target, "PONG")
end

plugin.say = function(target, from, arg)
  if from == "jinks___" then
    local sp = arg:find("%s") or 1
    local ch = arg:sub(1,sp-1)
    for channel in irc.channels() do
      if (channel.name == ch) then
          print(arg)
          target = channel
          arg = arg:sub(sp+1)
          print(arg)
          break
      end
    end
    irc.say(target, arg)
  end
end

plugin.join = function (target, from, arg)
    if (from == "jinks___") then
        irc.join(arg)
    end
end

plugin.part = function (target, from, arg)
    if (from == "jinks___") then
        if arg:len() > 0 then
            irc.part(arg)
        else
            irc.part(target)
        end
    end
end

plugin.hail = function (target, from, arg)
    irc.say(target, "HAIL HYDRATION! And our lord and savior Crop Rotation. But really: http://bit.ly/1ipyhGd")
end

plugin.score = function (target, from, arg)
    irc.say(target, "BOOM counter is " .. booms)
end

plugin.unboom = function (target, from, arg)
    now = os.time()
    if now-last_unboom > 20 then
        last_unboom = now
        booms = booms - 1
        irc.say(target, "BOOM counter is now " .. booms)
    end
end

plugin.boom = function (target, from, arg)
    now = os.time()
    if now-last_boom > 20 then
        last_boom = now
        booms = booms + 1
        irc.say(target, "BOOM counter is now " .. booms)
    end
end

plugin.resetboom = function (target, from, arg)
    if (from == "jinks___" or from == "4kbshort") then
        booms = 0
        irc.say(target, "BOOM counter reset.")
    end
end

plugin.setboom = function (target, from, arg)
    if (from == "jinks___" or from == "4kbshort") then
        num = tonumber(arg)
        if num ~= nil then
            booms = num
        end
        irc.say(target, "BOOM counter is " .. booms)
    end
end
