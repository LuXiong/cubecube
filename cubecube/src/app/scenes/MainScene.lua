local CubeBoard = require("app.scenes.view.CubeBoardView")
local CubeShape = require("app.scenes.view.CubeShapeView")
local GameOverLayer = require("app.scenes.view.GameOverLayer")
local ResumeView = require("app.scenes.view.ResumeView")
local scheduler = require("framework.scheduler")
local TouchEventHandler = require("app.scenes.TouchEventHandler")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local scale_factor = 30/55
local TIME_LIMIT = 180
-- gameState 100 未开始 101开始 102暂停 110结束

local STATE_PREPARE = 100
local STATE_RUNNING = 101
local STATE_PAUSE = 102
local STATE_OVER = 110

function MainScene:ctor()
	self.currentShape = nil
	self.arr_shapes = {}
	self.shouldResponseToTouch = true
	self.isPause = false
	self.gameState = STATE_PREPARE

	self.isGameStart = false
	self.time = TIME_LIMIT

	self:initMainViews()
	self:addMainTouchListener()
	self:addChangeToBackGroundListener()
end

function MainScene:addMainTouchListener()
      -- 给屏幕添加事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(TouchEventHandler.onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(TouchEventHandler.onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(TouchEventHandler.onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end

function MainScene:addChangeToBackGroundListener()
	local listenerCustom=cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT",function ()
        print("切换到后台")
        if self.gameState == STATE_RUNNING then
        	self.shouldResponseToTouch = false
			self.isPause = true
			self.resumeView:show()

			if self.currentShape then
				local action1 = cc.MoveTo:create(0.2, self.currentShape.orignPosition)
			    local action2 = cc.ScaleTo:create(0.2, scale_factor, scale_factor, 1)
			    self.currentShape:runAction(action1)
			    self.currentShape:runAction(action2)				
			end
        end
    end)  
    local customEventDispatch=cc.Director:getInstance():getEventDispatcher()
    customEventDispatch:addEventListenerWithFixedPriority(listenerCustom, 1)
end

function MainScene:initMainViews()
	self.img_bg = display.newSprite(Res.img_game_bg)
	:align(display.CENTER, display.cx, display.cy)
	:addTo(self)

	-- 上方面板
	self.board = CubeBoard:new()
	self.board:pos((display.width-self.board.f_width)/2,display.height-self.board.f_height-200*f_scale)
	self.board:addTo(self)

	self.draw = cc.DrawNode:create():addTo(self)
	local itemsHeight = display.height-100*f_scale
	local itemsLeft = 40*f_scale
	local scoreColor = Res.color_gray02
	local rectScore = cc.rect(itemsLeft,itemsHeight-30*f_scale,200*f_scale,60*f_scale)
	drawNodeRoundRect(self.draw, rectScore, 0, 30*f_scale, scoreColor, scoreColor)

	local img_score = cc.ui.UIImage.new(Res.img_score)
					:align(display.CENTER, itemsLeft + 30*f_scale, itemsHeight)
					:addTo(self)

	self.lbl_score = cc.Label:createWithTTF("0",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	      :align(display.CENTER_LEFT, itemsLeft+60*f_scale, itemsHeight)
	          :addTo(self)
	local itemsLeft = 250*f_scale
	local rectScore = cc.rect(itemsLeft,itemsHeight-30*f_scale,200*f_scale,60*f_scale)
	drawNodeRoundRect(self.draw, rectScore, 0, 30*f_scale, scoreColor, scoreColor)
	local img_time = cc.ui.UIImage.new(Res.img_time)
					:align(display.CENTER, itemsLeft + 30*f_scale, itemsHeight)
					:addTo(self)

	self.btn_pause = ccui.Button:create(Res.img_pause,Res.img_pause)
	self.btn_pause:align(display.CENTER_LEFT, display.width-105*f_scale, itemsHeight)
	self.btn_pause:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			self.gameState = STATE_PAUSE
			self.shouldResponseToTouch = false
			self.isPause = true
			self.resumeView:show()
		end
	end)
	self.btn_pause:addTo(self) 


	self.lbl_time = cc.Label:createWithTTF("03:00",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	      :align(display.CENTER_LEFT, itemsLeft+60*f_scale, itemsHeight)
	          :addTo(self)

	self:generateShapes()
	self.gameOverLayer = GameOverLayer.new()
	self.gameOverLayer:setOpacity(123)
	self.gameOverLayer:pos(display.cx-self.gameOverLayer.f_width/2,display.height-self.gameOverLayer.f_height-400)
	self.gameOverLayer:setRestartCallback(function ()
		self:restart()
	end)
	self.gameOverLayer:addTo(self,10):hide()

	self.resumeView = ResumeView.new()
	self.resumeView:setOpacity(123)
	self.resumeView:pos(display.cx-self.resumeView.f_width/2,display.height-self.resumeView.f_height-400)
	self.resumeView:setButtonClickCallback(function(action)
		if action == "play" then
			self.shouldResponseToTouch = true
			self.isPause = false
			self.resumeView:hide()
			self.gameState = STATE_RUNNING
		elseif action == "replay" then
			self:restart()
			self.resumeView:hide()
		elseif action == "exit" then
			self:stopScheduler()
			app:enterScene("GameMenuScene", {})
		end
	end)
	self.resumeView:addTo(self,10):hide()

	self:setLimitTime()

	MusicConfig.preloadBackgroundMusic(Res.music_bgm)
	MusicConfig.playBackgroundMusic(Res.music_bgm)
	local hasBgm = cc.UserDefault:getInstance():getStringForKey("cube_music")
	if hasBgm == "0" then
		MusicConfig.closeBackgroundMusic()
	end

end

function MainScene:startGame()
	self.gameState = STATE_RUNNING
	self.isGameStart = true
	self:startScheduler()
end

function MainScene:restart()
    self.shouldResponseToTouch = true
    self.gameState = STATE_PREPARE
    self.isPause = false
    -- self.time = TIME_LIMIT
    self:stopScheduler()
    self.board:clearBoard()
    self:generateShapes()
    self.gameOverLayer:hide()
    self.lbl_score:setString(self.board.score)
    self.isGameStart = false
    -- self:startScheduler()
end

function MainScene:gameOver(reason)
	self.gameState = STATE_OVER
	self.shouldResponseToTouch = false
	self.gameOverLayer:show()
	self.gameOverLayer:updateInfo(self.board.score,reason)
	self:stopScheduler()
	MusicConfig.playSound(Res.music_gameover,false)
end

function MainScene:startScheduler()
	if not self.scheduler_time then
        self.scheduler_time = scheduler.scheduleGlobal(function()
        	if self.time>=0 then
        		if not self.isPause then
        			self.time = self.time-1
        		end
        		self:setLimitTime()
        	else
        		self:gameOver("时间到!")
        	end
        end,1)
    end
end

function MainScene:stopScheduler()
	if self.scheduler_time then
		scheduler.unscheduleGlobal(self.scheduler_time)
		self.scheduler_time = nil
    end
    self.time = TIME_LIMIT
    self:setLimitTime()
end

function MainScene:setLimitTime()
	local minute = self.time/60
    local second = self.time%60
	self.lbl_time:setString(string.format("%02d",minute)..":"..string.format("%02d",second))
end


function MainScene:generateShapes()
  -- 下面的三个图形
	for i=1,#self.arr_shapes do
		if self.arr_shapes[i].cubetype then
			self.arr_shapes[i]:removeSelf()
		end
	end

	self.arr_shapes = {}

	local leftType = Res["CUBT_TYPE_"..randomExchanger()]
	self.shapeLeft = CubeShape.new({
		cubetype = leftType,
		direction = math.random(1,leftType.directions),
		cubelength = self.board.cubelength
	})
	self.shapeLeft:pos(160-self.shapeLeft.f_width/2,180-self.shapeLeft.f_height/2)
	self.shapeLeft:addTo(self)
	self.shapeLeft.shapename = "leftCubes"
	self.shapeLeft.orignPosition = cc.p(160-self.shapeLeft.f_width/2,180-self.shapeLeft.f_height/2)
	self.shapeLeft:setScale(scale_factor, scale_factor)
	table.insert(self.arr_shapes,self.shapeLeft)

	local middleType = Res["CUBT_TYPE_"..randomExchanger()]
	self.shapeMiddle = CubeShape.new({
		cubetype = middleType,
		direction = math.random(1,middleType.directions),
		cubelength = self.board.cubelength
	})
	self.shapeMiddle:pos(320-self.shapeMiddle.f_width/2,180-self.shapeMiddle.f_height/2)
	self.shapeMiddle:addTo(self)
	self.shapeMiddle.shapename = "middleCubes"
	self.shapeMiddle:setScale(scale_factor, scale_factor)
	self.shapeMiddle.orignPosition = cc.p(320-self.shapeMiddle.f_width/2,180-self.shapeMiddle.f_height/2)
	table.insert(self.arr_shapes,self.shapeMiddle)

	local rightType = Res["CUBT_TYPE_"..randomExchanger()]
	self.shapeRight = CubeShape.new({
		cubetype = rightType,
		direction = math.random(1,rightType.directions),
		cubelength = self.board.cubelength
	})
	self.shapeRight:pos(480-self.shapeRight.f_width/2,180-self.shapeRight.f_height/2)
	self.shapeRight:addTo(self)
	self.shapeRight.shapename = "rightCubes"
	self.shapeRight:setScale(scale_factor, scale_factor)
	self.shapeRight.orignPosition = cc.p(480-self.shapeRight.f_width/2,180-self.shapeRight.f_height/2)
	table.insert(self.arr_shapes,self.shapeRight)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
