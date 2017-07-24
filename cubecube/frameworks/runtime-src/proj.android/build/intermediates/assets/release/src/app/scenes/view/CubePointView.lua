--
-- Author: xlook
-- Date: 2017-07-06 09:44:03
--
local CubePointView = class("CubePointView", function()
		return cc.Layer:create()
	end)

local n_cubes_lenght = 30

function CubePointView:ctor(params)
	-- dump(params, "desciption", 6)
	self.bgcolor = params.color or Res["color_hue_"..hue_position_color]
	self.cubetype = params.cubetype or Res.CUBT_TYPE_1
	self.cubelength = params.cubelength or n_cubes_lenght

	self:setContentSize(self.cubelength,self.cubelength)

	self.bgcolor.a = 0.8
	self.drawbg = cc.DrawNode:create():addTo(self,10)
	-- self.drawbg:drawSolidRect(cc.p(0,0), cc.p(self.cubelength,self.cubelength), self.bgcolor)
	local rect = cc.rect(0,0,self.cubelength,self.cubelength)
	drawNodeRoundRect(self.drawbg, rect, 0, 3, self.bgcolor, self.bgcolor)

	self.bgcolor.a = 1
	rect = cc.rect(self.cubelength/5,self.cubelength/5,self.cubelength*3/5,self.cubelength*3/5)
	drawNodeRoundRect(self.drawbg, rect, 0, 3, self.bgcolor, self.bgcolor)
	-- self.drawbg:drawSolidRect(cc.p(self.cubelength/5,self.cubelength/5), cc.p(self.cubelength*4/5,self.cubelength*4/5), self.bgcolor)
end

function CubePointView:animDisappear()

end

function CubePointView:animAppear()

end

return CubePointView