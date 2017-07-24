--
-- Author: xlook
-- Date: 2017-07-10 14:58:00
--
local SettingsLayer = require("app.scenes.view.SettingsLayer")
local GameRuleView = require("app.scenes.view.GameRuleView")

local GameMenuScene = class("GameMenuScene", function()
    return display.newScene("GameMenuScene")
end)

function GameMenuScene:ctor()
	self:initViews()
	self.hasLayerUpside = false
	

end

function GameMenuScene:initViews()
	self.lbl_name = cc.ui.UILabel.new({
		text = "奇妙方块",
		align = cc.ui.TEXT_ALIGN_CENTER,
		size = 84*0.853,
		color = cc.c4f(255, 255, 255, 255)})
	:align(display.CENTER, display.cx, display.height-260)
	:addTo(self)

	local record = cc.UserDefault:getInstance():getStringForKey("cube_record") 

	self.lbl_record = cc.ui.UILabel.new({
		text = "最新记录:0",
		align = cc.ui.TEXT_ALIGN_CENTER,
		size = 32*0.853,
		color = cc.c4f(178, 178, 178, 255)})
	:align(display.CENTER, display.cx, display.cy-280*f_scale)
	:addTo(self)
	self.lbl_record:setString("最新记录 : "..record.." 分")

	self.btn_start = ccui.Button:create(Res.img_start_big,Res.img_start_big_pressed)
	self.btn_start:align(display.CENTER, display.cx, display.cy)
	self.btn_start:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			if not self.hasLayerUpside then
				app:enterScene("MainScene", {})
			end
		end
	end)
	self.btn_start:addTo(self)

	self.settingLayer = SettingsLayer.new()
	self.settingLayer:pos(display.cx-self.settingLayer.f_width/2,display.height-self.settingLayer.f_height-400)
	self.settingLayer:setRestartCallback(function ( )
		self.hasLayerUpside = false
		self.settingLayer:hide()
	end)
	self.settingLayer:addTo(self):hide()

	self.gameRuleView = GameRuleView.new()
	self.gameRuleView:pos(display.cx-self.settingLayer.f_width/2,display.height-self.settingLayer.f_height-400)
	self.gameRuleView:setRestartCallback(function()
		self.hasLayerUpside = false
		self.gameRuleView:hide()
	end)
	self.gameRuleView:addTo(self):hide()


	self.btn_setting = ccui.Button:create(Res.img_setting,Res.img_setting_pressed)
	self.btn_setting:align(display.CENTER, display.width-62*f_scale, 62*f_scale)
	self.btn_setting:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			if not self.hasLayerUpside then
				self.settingLayer:show()
				self.hasLayerUpside = true
			end
		end
	end)
	self.btn_setting:addTo(self)

	self.btn_rule = ccui.Button:create(Res.img_rule,Res.img_rule_pressed)
	self.btn_rule:align(display.CENTER, 62*f_scale, 62*f_scale)
	self.btn_rule:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			if not self.hasLayerUpside then
				self.gameRuleView:show()
				self.hasLayerUpside = true
			end
		end
	end)
	self.btn_rule:addTo(self)

	MusicConfig.preloadBackgroundMusic(Res.music_bgm)
	MusicConfig.playBackgroundMusic(Res.music_bgm)
	local hasBgm = cc.UserDefault:getInstance():getStringForKey("cube_music")
	if hasBgm == "0" then
		MusicConfig.closeBackgroundMusic()
	end
end

return GameMenuScene