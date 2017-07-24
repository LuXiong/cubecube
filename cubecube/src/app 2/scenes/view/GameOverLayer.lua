--
-- Author: xlook
-- Date: 2017-07-10 16:25:22
--
local GameOverLayer = class("GameOverLayer", function()
		-- return cc.LayerColor:create(cc.c4f(255, 0, 0, 255))
		return cc.Layer:create()
	end)

function GameOverLayer:ctor(params)
	self.f_width = 660*f_scale
	self.f_height = 340*f_scale
	if params then
		self.score = params.score or 0
	else
		self.score = 0
	end

	self:setContentSize(self.f_width,self.f_height)
	local draw = cc.DrawNode:create():addTo(self)
	local rect = cc.rect(0,0,self.f_width,self.f_height)
	drawNodeRoundRect(draw,rect, 2, 10, Res.color_blue, Res.color_black05)
	draw:drawLine(cc.p(30*f_scale,self.f_height-95*f_scale), cc.p(self.f_width-30*f_scale,self.f_height-95*f_scale), Res.color_white07)


	self.lbl_title = cc.Label:createWithTTF("Out of moves!",Res.font_pingf_bold,56*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, self.f_width/2, self.f_height-50*f_scale)
				   		    :addTo(self)
	self.lbl_score = cc.Label:createWithTTF("your score:",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 150*f_scale, self.f_height-140*f_scale)
				   		    :addTo(self)
	self.lbl_score_content = cc.Label:createWithTTF(self.score,Res.font_impact,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 360*f_scale, self.f_height-140*f_scale)
				   		    :addTo(self)
	self.lbl_newbest = cc.Label:createWithTTF("* new best! *",Res.font_impact,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 360*f_scale, self.f_height-140*f_scale)
				   		    :addTo(self):hide()
	local record = cc.UserDefault:getInstance():getStringForKey("cube_record") or "0"

	self.lbl_record = cc.Label:createWithTTF("your best  :    ",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 150*f_scale, self.f_height-185*f_scale)
				   		    :addTo(self)
	self.lbl_record_content = cc.Label:createWithTTF(record,Res.font_impact,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER_LEFT, 360*f_scale, self.f_height-185*f_scale)
				   		    :addTo(self)		
	
	self.btn_submit = ccui.Button:create(Res.btn_submit.normal,Res.btn_submit.pressed)
								:align(display.CENTER, self.f_width/2, 70*f_scale)
	self.btn_submit:setTouchEnabled(true)
	self.btn_submit:addTouchEventListener(function (sender,event)
						if event == ccui.TouchEventType.ended then
							if self.callb_restart then
								self.callb_restart()
							end
							-- self:removeSelf()
						end
					end)
	self.btn_submit:addTo(self)	
	self.lbl_submit = cc.Label:createWithTTF("Start Again",Res.font_pingf_bold,34*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, self.btn_submit:getContentSize().width/2, self.btn_submit:getContentSize().height/2+5*f_scale)
				   		    :addTo(self.btn_submit)	   		    

end

function GameOverLayer:showAnimation()

end

function GameOverLayer:hideAnimation()

end

function GameOverLayer:updateInfo(score,reason)
	self.lbl_title:setString(reason or "You Fail")
	self.lbl_score_content:setString(tostring(score))
	local record = cc.UserDefault:getInstance():getStringForKey("cube_record") or "0"
	self.lbl_record_content:setString(record)
	if checknumber(score)>checknumber(record) then
		cc.UserDefault:getInstance():setStringForKey("cube_record",tostring(score))
		self.lbl_newbest:show()
		self.lbl_newbest:pos(360*f_scale+self.lbl_score_content:getContentSize().width+10*f_scale, self.f_height-140*f_scale)
	else
		self.lbl_newbest:hide()
	end

	
end

function GameOverLayer:setRestartCallback(callb)
	self.callb_restart = callb
end

return GameOverLayer