# hs-huion-scroll

make the huion h610pro aka monoprice scroll using the second button.
I've chosen to only track vertical scrolling, but it would be easy enough to track the x motion of the stylus as well.


I set the config (in the huion driver) to have this button emit cmd-shift-option-/ (slash)
and this runs in hammerspoon

Install hammerspoon
put the enclosed file in ~/hammerspoon/init.lua
start hammerspoon or tell it to reload the init file.
