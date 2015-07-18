-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start() 
physics.pause()
physics.setGravity( 0, 50 )

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create triceratops
	-- local dino = display.newImageRect("images/trex-wireframe.png", 760, 303)
	-- dino.anchorX = 0;
	-- dino.anchorY = 1;
	-- dino.x, dino.y = 0, display.contentHeight;
	
	local dinoSheet = graphics.newImageSheet( "images/ceratosaurus.png", {
	    width = 200,
	    height = 200,
	    numFrames = 3,
	    sheetContentWidth = 600,  -- width of original 1x size of entire sheet
	    sheetContentHeight = 200  -- height of original 1x size of entire sheet
	})

	local sequenceData =
	{
	    name="stance",
	    start=1,
	    count=3,
	    time = 500,
	    loopCount = 0
	}

	local dino = display.newSprite( dinoSheet, sequenceData )
	dino.x, dino.y = 200, display.contentHeight - 200
	dino:play("walking")
	physics.addBody(dino, { density=3.0, friction=0.5, bounce=0.3 })

	local movingRight = false
	local function handleMoveRight( event )
	   if ( movingRight == true ) then
	     	dino.x = dino.x + 20
	   end
	end
	Runtime:addEventListener( "enterFrame", handleMoveRight )

	local movingLeft = false
	local function handleMoveLeft( event )
	   if ( movingLeft == true ) then
	     	dino.x = dino.x - 20
	   end
	end
	Runtime:addEventListener( "enterFrame", handleMoveLeft )

	-- Called when a key event has been received
	local function onKeyEvent( event )
		-- Print which key was pressed down/up
	    -- local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase

	    if(event.keyName == "l" and event.phase == "down") then
	    	movingRight = true
	    end

	    if(event.keyName == "l" and event.phase == "up") then
	    	movingRight = false
	    end

	    if(event.keyName == "j" and event.phase == "down") then
	    	movingLeft = true
	    end

	    if(event.keyName == "j" and event.phase == "up") then
	    	movingLeft = false
	    end

	    if(event.keyName == "b" and event.phase == "down") then
	    	if(dino.y <= (display.contentHeight - 150)) then
				dino:setLinearVelocity( 0, 3000 )
			end
	    end

	    dino:play()
	    return false
	end

	-- -- Add the key event listener
	Runtime:addEventListener( "key", onKeyEvent )
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "images/grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	-- sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( dino )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene