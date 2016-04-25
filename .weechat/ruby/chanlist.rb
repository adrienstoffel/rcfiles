# -*- coding: utf-8 -*-
#
# chanlist.rb
# Ruby script listing all buffer, sorted by servers.
#
#
# Author: Kevin Lemonnier, aka Ulrar
# Email: lemonnier.k@gmail.com
# Feel free to send me emails about encoutered bugs
#
# BSD License :
# Copyright 2011 Kevin Lemonnier. All rights reserved.

# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:

#    1. Redistributions of source code must retain the above copyright notice, this list of
#       conditions and the following disclaimer.

#    2. Redistributions in binary form must reproduce the above copyright notice, this list
#       of conditions and the following disclaimer in the documentation and/or other materials
#       provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY KEVIN LEMONNIER ''AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL KEVIN LEMONNIER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# The views and conclusions contained in the software and documentation are those of the
# authors and should not be interpreted as representing official policies, either expressed
# or implied, of Kevin Lemonnier.

#
# Usage : This script add a bar on left of the screen, containing all Weechat buffers, sorted by servers.
#         You MUST do this : /set irc.look.server_buffer independent
#         The script can not work without that (yet).
#
#         By default, the UTF8 mode is off. To turn it on (better looks), only if you terminal is UTF8 compatible :
#         /set plugins.var.ruby.chanlist.utf8 on
#         If this show lots of "?" on the ChanList, it means that your terminal is not UTF8 compatible, so turn that option off.
#

def weechat_init
  Weechat.register("chanlist", "Ulrar", "1.1", "BSD", "Script showing all chans sorted by servers", "", "")
  Weechat.bar_item_new("ChanList_bar", "build_bar", "")
  Weechat.bar_new("chanlist", "0", "0", "root", "", "left", "horizontal", "vertical", "0", "0", "default", "default", "default", "1", "ChanList_bar")
  Weechat.bar_item_update("ChanList_bar")
  if (Weechat.config_get_plugin("utf8").nil?)
    Weechat.config_set_plugin("utf8", "off")
  end
  Weechat.hook_signal("buffer_*", "signal_buffer_hook", "")
  Weechat.hook_signal("hotlist_*", "signal_buffer_hook", "")
  Weechat.hook_config("plugins.var.ruby.ChanList.*", "signal_buffer_hook", "")
  return Weechat::WEECHAT_RC_OK
end

def build_list
  buffers = Weechat.infolist_get("buffer", "", "")
  servers = Hash.new()
  list = Hash.new();
  while (Weechat.infolist_next(buffers) > 0)
    buff = Weechat.buffer_search(Weechat.infolist_string(buffers, "plugin"), Weechat.infolist_string(buffers, "name"))
    name = Weechat.buffer_get_string(buff, "name")
    if (name != "weechat")
      bufname = name[/\.(.*)/, 1]
      serv = name[/(.[^\.]*)\./, 1]
      if (serv != nil && serv != "server")
        if (list[serv] == nil)
          list[serv] = Array.new()
        end
        list[serv].push(buff)
      elsif (serv == "server" && list[bufname] == nil)
        list[bufname] = Array.new()
      elsif (serv == nil && name != nil)
        if (list["specials"] == nil)
          list["specials"] = Array.new();
        end
        list["specials"].push(buff);
      end
      if (name != nil)
        if (serv == nil)
          servers["specials" + name] = buff;
        else
          servers[name] = buff
        end
      end
    end
  end
  Weechat.infolist_free(buffers)
  return list, servers
end

def build_server_name(servers, utf8, name, current)
  color = nil
  if (name != "specials" && current == Weechat.buffer_get_integer(servers["server." + name], "number"))
    color = "white,red"
  end
  final = ""
  if (utf8 == "on")
    final += "├── "
  else
    final += "|--- "
  end
  if (color != nil)
    final += Weechat.color(color) + name + Weechat.color("reset")
  else
    final += name
  end
  #if (name != "specials")
    #final +=  "  " + Weechat.color("green") + "%02d" % Weechat.buffer_get_integer(servers["server." + name], "number") + Weechat.color("reset")
  #else
    #final += "  "
  #end
  final += "\n"
  #if (utf8 == "on")
    #final += "\n  │    │\n"
  #else
    #final += "\n  |    |\n"
  #end
  return (final)
end

def build_chan_name(name, color, num, utf8, current)
  if (num == current)
    color = "white,red"
  end
  #final = "  "
  final = ""
  if (utf8 == "on")
    final += "│ "
  else
    final += "| "
  end
  final += Weechat.color("green") + "%02d" % num + Weechat.color("reset")
  if (utf8 == "on")
    final += " ├─ "
  else
    final += " |- "
  end
  if (color != nil)
    if (color == "default")
      color = "white"
    end
    final += Weechat.color(color)
  end
  final += name
  if (color != nil)
    final += Weechat.color("reset")
  end
  final += "\n"
  return (final)
end

def build_core(current, utf8)
  if (utf8 == "on")
    #final = Weechat.color("green") + "01" + Weechat.color("reset") + "├── "
    final = "├── "
  else
    final = Weechat.color("green") + "01" + Weechat.color("reset") + "|--- "
  end
  if (current == 1)
    final += Weechat.color("white,red") + "Core" + Weechat.color("reset")
  else
    final += "Core"
  end
  final += "\n"
  return (final)
end

def print_list(list, servers)
  count = 2
  utf8 = Weechat.config_get_plugin("utf8")
  hotlist = update_hotlist()
  current = Weechat.buffer_get_integer(Weechat.current_buffer(), "number")
  final = build_core(current, utf8)
  list.sort.each do |name, serv|
    if (name != "specials")
      Weechat.buffer_set(servers["server." + name], "number", count.to_s)
      count += 1
    end
    current = Weechat.buffer_get_integer(Weechat.current_buffer(), "number")
    final += build_server_name(servers, utf8, name, current)
    serv.each do |buffer|
      buf_name = Weechat.buffer_get_string(buffer, "name")
      color = hotlist[buf_name]
      if (name != "specials")
        buf_name = buf_name[/\.(.*)/, 1]
      end
      if (buf_name != nil)
        Weechat.buffer_set(buffer, "number", count.to_s)
        count += 1
        num = Weechat.buffer_get_integer(buffer, "number")
        current = Weechat.buffer_get_integer(Weechat.current_buffer(), "number")
        final += build_chan_name(buf_name, color, num, utf8, current)
      end
    end
  end
  return (final)
end

def update_hotlist
  list = Weechat.infolist_get("hotlist", "", "")
  hotlist = Hash.new()
  while (Weechat.infolist_next(list) > 0)
    hotlist[Weechat.infolist_string(list, "buffer_name")] = Weechat.infolist_string(list, "color")
  end
  Weechat.infolist_free(list)
  return (hotlist)
end

def build_bar(data, buffer, args)
  list, servers = build_list()
  return (print_list(list, servers))
end

def signal_buffer_hook(data, signal, signal_data)
  Weechat.bar_item_update("ChanList_bar")
  return (Weechat::WEECHAT_RC_OK)
end
