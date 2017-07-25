--
-- Author: Your Name
-- Date: 2017-07-11 22:01:11
--
local TouchEventHandler = class("TouchEventHandler")
local isMovingCube = false
function TouchEventHandler.onTouchBegan(touch, event)
	
	local scene = display.getRunningScene()
	--禁用多点触控
	if isMovingCube then
		return false
	end

	if not scene.shouldResponseToTouch then
		return true
	end
	if not scene.isGameStart then
		scene:startGame()
	end
	scene.location_begin = cc.p(touch:getLocation().x,touch:getLocation().y)
	

	local current = nil

	for i,v in ipairs(scene.arr_shapes) do
		-- dump(scene.arr_shapes, "desciption", 6)	
		if rectContainsPointByWorld(scene.location_begin,v) then
			current = v
			break
		end
	end

	-- dump(current.shapeStruct, "MainScene.onTouchBegan", 6)

	if current then
		local scale = scene.board.cubelength/current.cubelength
		scene.currentShape = current
		local action = cc.ScaleTo:create(0.2, 1, 1, 1)
		scene.currentShape:runAction(action)
		return true
	else
		scene.currentShape = nil
		return false
	end
end

function TouchEventHandler.onTouchMoved(touch, event)
	isMovingCube = true
	local scene = display.getRunningScene()
	if not scene.shouldResponseToTouch then
		return 
	end
	local location = cc.p(touch:getLocation().x,touch:getLocation().y)
	local shape = scene.currentShape
	if shape then
		shape:pos((shape.orignPosition.x+(touch:getLocation().x-scene.location_begin.x)*2),(shape.orignPosition.y+(touch:getLocation().y-scene.location_begin.y)*2))
	end
end

function TouchEventHandler.onTouchEnded(touch, event)
	isMovingCube = false
	local scene = display.getRunningScene()
	local scale_factor = 30/55
	if not scene.shouldResponseToTouch then
		return 
	end
	-- print("MainScene.onTouchEnded:",touch:getLocation().x,touch:getLocation().y)
	local board = scene.board
	local shape = scene.currentShape

	if shape and testShapeInBoard(shape,board) and board:testPutin(generateShapePosition(shape,board),shape) then
		board:putinShape(generateShapePosition(shape,board),shape)
      
		for i,v in ipairs(scene.arr_shapes) do
			-- print("shapename:",v.shapename,shape.shapename)
			if v.shapename and v.shapename == shape.shapename then
				-- print("remove shape:",i)
				table.remove(scene.arr_shapes,i)
				shape:removeSelf()
				break
			end
		end

		scene.lbl_score:setString(board.score)
		local record = cc.UserDefault:getInstance():getStringForKey("cube_socre_record")

		if #scene.arr_shapes == 0 then
			scene:generateShapes()
		end

		if not board:outOfMoves(scene.arr_shapes) then
			scene:gameOver("放不下啦!")
		end
	else
		print("TouchEventHandler.onTouchEnded(touch, event)")
	    local action1 = cc.MoveTo:create(0.2, shape.orignPosition)
	    local action2 = cc.ScaleTo:create(0.2, scale_factor, scale_factor, 1)
	    shape:runAction(action1)
	    shape:runAction(action2)
	end

end
return TouchEventHandler