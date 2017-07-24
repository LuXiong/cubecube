--
-- Author: xlook
-- Date: 2017-07-05 16:07:45
--
local CubePoint = require("app.scenes.view.CubePointView")
local CubeShapeView = class("CubeShapeView", function()
		return cc.Layer:create()
	end)

local n_space = 3
local n_cubes_lenght = 55

function CubeShapeView:ctor(params)
	-- dump(params, "CubeShapeView:ctor", 6)
	self.cubetype = params.cubetype or Res.CUBT_TYPE_1
	self.direction = params.direction or 1
	self.cubelength = params.cubelength or n_cubes_lenght
	self.cubespace = params.cubespace or n_space

	self.struct_points = {}
	
	self.position_start = cc.p(0,0)
	self.cubecolor = generateColor()

	-- 根据要求旋转这个图形的结构构成最终数据结构
	-- dump(self.cubetype.struct, "rotateShape before", 6)
	self.shapeStruct = rotateShape(self.cubetype.struct,self.direction)
	-- dump(self.cubetype.struct, "rotateShape after", 6)
	-- dump(Res.CUBT_TYPE_4.struct, "rotateShape after", 6)

	-- 画出图形
	local count_h = #self.shapeStruct
	local count_v = #self.shapeStruct[1]
	self.f_width = count_h*self.cubelength+(count_h-1)*self.cubespace
	self.f_height = count_v*self.cubelength+(count_v-1)*self.cubespace

	self:setContentSize(self.f_width,self.f_height)

	for i=1,count_h do
		self.struct_points[i] = {}
		for j=1,count_v do
			self.struct_points[i][j] = {}
			if self.shapeStruct[i][j] == 1 then
				self.struct_points[i][j] = CubePoint.new({
						color = self.cubecolor,
						cubetype = self.cubetype,
						cubelength = self.cubelength
				})
				self.struct_points[i][j]:pos((i-1)*(self.cubelength+self.cubespace),(j-1)*(self.cubelength+self.cubespace))
				self.struct_points[i][j]:addTo(self)
			end
			 
		end
	end
end

return CubeShapeView