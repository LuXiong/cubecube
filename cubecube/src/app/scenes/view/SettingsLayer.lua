--
-- Author: Your Name
-- Date: 2017-07-11 22:20:36
--
local SettingsLayer = class("SettingsLayer", function()
		-- return cc.LayerColor:create(cc.c4f(255, 0, 0, 255))
		return cc.Layer:create()
	end)

function SettingsLayer:ctor(params)
	self.f_width = 660*f_scale
	self.f_height = 360*f_scale
	if params then
		self.score = params.score or 0
	else
		self.score = 0
	end

	self:setContentSize(self.f_width,self.f_height)
	local draw = cc.DrawNode:create():addTo(self)
	local rect = cc.rect(0,0,self.f_width,self.f_height)
	drawNodeRoundRect(draw,rect, 2, 10, Res.color_blue, Res.color_black)
	draw:drawLine(cc.p(30*f_scale,self.f_height-95*f_scale), cc.p(self.f_width-30*f_scale,self.f_height-95*f_scale), Res.color_white07)


	self.lbl_title = cc.Label:createWithTTF("设置",Res.font_pingf_bold,56*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, self.f_width/2, self.f_height-50*f_scale)
				   		    :addTo(self)
	self.lbl_score = cc.Label:createWithTTF("背景音乐:",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
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

	local record = cc.UserDefault:getInstance():getStringForKey("cube_socre_record") or "0"

	self.lbl_record = cc.Label:createWithTTF("音      效:",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
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
	
	self.btn_submit = ccui.Button:create(Res.btn_submit.normal,Res.btn_submit.pressed)
								:align(display.CENTER, self.f_width/2, 60*f_scale)
	self.btn_submit:setTouchEnabled(true)
	self.btn_submit:addTouchEventListener(function (sender,event)
						if event == ccui.TouchEventType.ended then
							if self.callb_restart then
								self.callb_restart()
							end
						end
					end)
	self.btn_submit:addTo(self)	
	self.lbl_submit = cc.Label:createWithTTF("确定",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, self.btn_submit:getContentSize().width/2, self.btn_submit:getContentSize().height/2+5*f_scale)
				   		    :addTo(self.btn_submit)	   		    

end

function SettingsLayer:switchBgmConfig()
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

function SettingsLayer:switchMusicConfig()
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

function SettingsLayer:setRestartCallback(callb)
	self.callb_restart = callb
end
return SettingsLayer