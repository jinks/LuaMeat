DB:exec([[CREATE TABLE IF NOT EXISTS seen (
  nick VARCHAR(100) PRIMARY KEY,
  channel VARCHAR(100) NOT NULL,
  action VARCHAR(20) NOT NULL,
  time INTEGER NOT NULL)]])

local function update (channel, from, action)
  local stmt = DB:prepare("INSERT OR REPLACE INTO seen VALUES (?, ?, ?, ?)")
  stmt:bind_values(from, channel, action, os.time())
  stmt:step()
  stmt:finalize()
end

on_join.seen = function(target, from)
  update(target, from, "joining")
end

on_part.seen = function (target, from, msg)
  update(target, from, "leaving")
end

callback.seen = function (target, from, msg)
  update(target, from, "talking")
end

plugin.seen = function (target, from, arg)
  if not arg or arg == "" then
    irc.say(target, "Give me a name plz!")
    return
  end
  local stmt = DB:prepare("SELECT * FROM seen WHERE NICK = ?")
  stmt:bind_values(arg:lower())
  local status = stmt:step()
  local result = nil
  if status == sqlite3.ROW then result = stmt:get_named_values() end
  stmt:finalize()
  if status and result then
    local c = " "
    if result.action == "talking" then
      c = " in "
    end
    irc.say(target, result.nick.." was last seen "..result.action..c..result.channel.." "..elapsed(os.date("!%Y-%m-%dT%H:%M:%SZ",result.time)).." ago.")
  else
    irc.say(target, "I cannot find anything about "..arg)
  end
end
