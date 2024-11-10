local utils = require 'mp.utils'

local duration, undo_position, seek_unit, low, high, mid


function binary_seek_mode()
   mp.commandv("show-text", "Binary seek mode")

   -- Seek variables.
   duration = mp.get_property_number("duration")
   seek_unit = duration and "absolute" or "absolute-percent"
   undo_position = mp.get_property("time-pos")
   -- Binary search algorithm variables.
   low = 0
   high = duration or 100
   mid = (low + high) / 2

   mp.commandv("seek", utils.to_string(mid), seek_unit)

   mp.remove_key_binding("binary_seek_mode")
   mp.add_forced_key_binding("h", "binary_seek_before", binary_seek_before)
   mp.add_forced_key_binding("LEFT", "binary_seek_before", binary_seek_before)
   mp.add_forced_key_binding("l", "binary_seek_after", binary_seek_after)
   mp.add_forced_key_binding("RIGHT", "binary_seek_after", binary_seek_after)
   mp.add_forced_key_binding("q", "binary_seek_undo", binary_seek_undo)
   mp.add_forced_key_binding("ESC", "binary_seek_undo", binary_seek_undo)
   mp.add_forced_key_binding("k", "binary_seek_accept", binary_seek_accept)
   mp.add_forced_key_binding("ENTER", "binary_seek_accept", binary_seek_accept)
end


function binary_seek_before()
   high = mid - 1
   mid = (low + high) / 2
   mp.commandv("seek", utils.to_string(mid), seek_unit)
end


function binary_seek_after()
   low = mid + 1
   mid = (low + high) / 2
   mp.commandv("seek", utils.to_string(mid), seek_unit)
end


function exit_binary_seek_mode()
   -- Reset keybindings.
   mp.remove_key_binding("binary_seek_before")
   mp.remove_key_binding("binary_seek_after")
   mp.remove_key_binding("binary_seek_undo")
   mp.remove_key_binding("binary_seek_accept")
   mp.add_key_binding(nil, "binary_seek_mode", binary_seek_mode)

   -- Set initial state.
   low = 0
   high = duration or 100
   mid = (low + high) / 2
end


function binary_seek_undo()
   exit_binary_seek_mode()
   mp.commandv("seek", undo_position, "absolute")
   mp.commandv("show-text", "Undid seek")
end


function binary_seek_accept()
   exit_binary_seek_mode()
   mp.commandv("show-text", "Applied seek")
end


mp.add_key_binding(nil, "binary_seek_mode", binary_seek_mode)
