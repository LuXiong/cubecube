--
-- Author: xlook
-- Date: 2017-07-14 09:44:37
--
local ResumeView = class("ResumeView", function()
		return cc.Layer:create()
	end)

function ResumeView:ctor(params)
	self.f_width = 660*f_scale
	self.f_height = 400*f_scale

	self:setContentSize(self.f_width,self.f_height)
	local draw = cc.DrawNode:create():addTo(self)
	local rect = cc.rect(0,0,self.f_width,self.f_height)
	drawNodeRoundRect(draw,rect, 2, 10, Res.color_blue, Res.color_black)
	draw:drawLine(cc.p(30*f_scale,self.f_height-95*f_scale), cc.p(self.f_width-30*f_scale,self.f_height-95*f_scale), Res.color_white07)

	self.lbl_title = cc.Label:createWithTTF("暂停",Res.font_pingf_bold,56*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, self.f_width/2, self.f_height-50*f_scale)
				   		    :addTo(self)

	self.lbl_bgm = cc.Label:createWithTTF("背景音乐:",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 150*f_scale, self.f_height-140*f_scale)
				   		    :addTo(self)
	local texturebgm = Res.img_switch_on
	local hasBgm = cc.UserDefault:getInstance():getStringForKey("cube_bgm")
	if hasBgm == "0" then
		texturebgm = Res.img_switch_off
	end
	self.btn_bgm_switch = ccui.Button:create(texturebgm,texturebgm)
	self.btn_bgm_switch:align(display.CENTER_LEFT, 360*f_scale, self.f_height-140*f_scale)
	self.btn_bgm_switch:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			self:switchBgmConfig()
		end
	end)
	self.btn_bgm_switch:addTo(self) 

	local record = cc.UserDefault:getInstance():getStringForKey("cube_record") or "0"

	self.lbl_music = cc.Label:createWithTTF("音      效:",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 150*f_scale, self.f_height-210*f_scale)
				   		    :addTo(self)
	local texturemusic = Res.img_switch_on
	local hasBgm = cc.UserDefault:getInstance():getStringForKey("cube_music")
	if hasBgm == "0" then
		texturemusic = Res.img_switch_off
	end
	self.btn_music_switch = ccui.Button:create(texturemusic,texturemusic)
	self.btn_music_switch:align(display.CENTER_LEFT, 360*f_scale, self.f_height-210*f_scale)
	self.btn_music_switch:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			self:switchMusicConfig()
		end
	end)
	self.btn_music_switch:addTo(self)

	self.btn_play = ccui.Button:create(Res.img_start_small,Res.img_start_small_pressed)
	self.btn_play:align(display.CENTER, 165*f_scale, self.f_height-300*f_scale)
	self.btn_play:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			if self.callb_btnclick then
				self.callb_btnclick("play")
			end
		end
	end)
	self.btn_play:addTo(self) 

	self.lbl_play = cc.Label:createWithTTF("继续游戏",Res.font_pingf_bold,28*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, 165*f_scale, self.f_height-360*f_scale)
				   		    :addTo(self)

	self.btn_replay = ccui.Button:create(Res.img_replay,Res.img_replay)
	self.btn_replay:align(display.CENTER, 330*f_scale, self.f_height-300*f_scale)
	self.btn_replay:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			if self.callb_btnclick then
				self.callb_btnclick("replay")
			end
		end
	end)
	self.btn_replay:addTo(self) 

	self.lbl_replay = cc.Label:createWithTTF("重新开始",Res.font_pingf_bold,28*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, 330*f_scale, self.f_height-360*f_scale)
				   		    :addTo(self)

	self.btn_exit = ccui.Button:create(Res.img_quit,Res.img_quit)
	self.btn_exit:align(display.CENTER, 495*f_scale, self.f_height-300*f_scale)
	self.btn_exit:addTouchEventListener(function (sender,event)
		if event == ccui.TouchEventType.ended then
			if self.callb_btnclick then
				self.callb_btnclick("exit")
			end
		end
	end)
	self.btn_exit:addTo(self) 

	self.lbl_exit = cc.Label:createWithTTF("退出游戏",Res.font_pingf_bold,28*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, 495*f_scale, self.f_height-360*f_scale)
				   		    :addTo(self)
end

function ResumeView:switchBgmConfig()
	local hasBgm = cc.UserDefault:getInstance():getStringForKey("cube_bgm")
	if hasBgm == "1" then
		hasBgm = "0"
		cc.UserDefault:getInstance():setStringForKey("cube_bgm", hasBgm)
		self.btn_bgm_switch:loadTextures(Res.img_switch_off,"","")
		MusicConfig.closeBackgroundMusic()
	elseif hasBgm == "0" then
		hasBgm = "1"
		cc.UserDefault:getInstance():setStringForKey("cube_bgm", hasBgm)
		self.btn_bgm_switch:loadTextures(Res.img_switch_on,"","")
		MusicConfig.openBackgroundMusic()
	end
end

function ResumeView:switchMusicConfig()
	local hasMusic = cc.UserDefault:getInstance():getStringForKey("cube_music")
	if hasMusic == "1" then
		hasMusic = "0"
		cc.UserDefault:getInstance():setStringForKey("cube_music", hasMusic)
		self.btn_music_switch:loadTextures(Res.img_switch_off,"","")
	elseif hasMusic == "0" then
		hasMusic = "1"
		cc.UserDefault:getInstance():setStringForKey("cube_music", hasMusic)
		self.btn_music_switch:loadTextures(Res.img_switch_on,"","")
	end
end

function ResumeView:setButtonClickCallback(callb)
	self.callb_btnclick = callb
end

return ResumeView