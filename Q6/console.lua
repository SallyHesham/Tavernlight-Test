--[[ Added these lines in the console.lua file in the client's console module
  I added them so that I can use the spell like a dash (as in the video) and not have to type it each time ]]--

-- function to be called on pressing the shortcut
function doSomething()
  g_game.talk('dash')
end

function init()

  -- adding the shortcut
  g_keyboard.bindKeyDown("Ctrl+x", doSomething)

end

function terminate()

  -- removing the shortcut
  g_keyboard.unbindKeyDown("Ctrl+x", doSomething)

end
