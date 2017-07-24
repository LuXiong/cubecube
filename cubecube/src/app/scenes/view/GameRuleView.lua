--
-- Author: xlook
-- Date: 2017-07-18 17:21:03
--
local GameRuleView = class("GameRuleView", function()
		-- return cc.LayerColor:create(cc.c4f(255, 0, 0, 255))
		return cc.Layer:create()
	end)

function GameRuleView:ctor(params)
	self.f_width = 660*f_scale
	self.f_height = 400*f_scale
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


	self.lbl_title = cc.Label:createWithTTF("游戏规则",Res.font_pingf_bold,56*f_scale,cc.size(0, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.CENTER, self.f_width/2, self.f_height-50*f_scale)
				   		    :addTo(self)

	self.lbl_rule = cc.Label:createWithTTF(" 奇妙方块为一款益智类方块游戏，玩家需要通过对不同的方块进行拼接，从而达到消除整行的目的；游戏时长3分钟，游戏时间到或者无法再放下方块都视为游戏结束。赶紧发挥智力开始游戏吧~",Res.font_pingf_bold,28*f_scale,cc.size(600*f_scale, 0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
							:align(display.TOP_LEFT, 30*f_scale, self.f_height-120*f_scale)
				   		    :addTo(self)

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

function GameRuleView:setRestartCallback(callb)
	self.callb_restart = callb
end
return GameRuleView