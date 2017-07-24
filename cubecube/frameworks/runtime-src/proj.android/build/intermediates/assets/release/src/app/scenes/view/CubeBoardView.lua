--
-- Author: xlook
-- Date: 2017-07-05 16:07:04
--
local CubeShape = require("app.scenes.view.CubeShapeView")
local CubePoint = require("app.scenes.view.CubePointView")
local CubeBoardView = class("CubeBoardView", function()
		return ccui.Layout:create()
	end)

local n_cubes = 10
local n_space = 3
local n_cubes_length = 55
local color_cube = cc.c4f(0.6, 0.6, 0.6, 0.4)

function CubeBoardView:ctor(params)
	-- 计算宽度
	self.f_width = n_cubes_length*n_cubes+n_space*(n_cubes-1)
	self.f_height = n_cubes_length*n_cubes+n_space*(n_cubes-1)
	self.cubelength = n_cubes_length
	self.cubespace = n_space

	print("self.f_width:",self.f_width)
	print("self.f_height:",self.f_height)

	self:setContentSize(self.f_width,self.f_height)

	self:drawBoard()

	self.score = 0
	self.combale = 0

end

-- 画出背景的10*10面板
function CubeBoardView:drawBoard()
	self.mboard = {}

	for i=1,n_cubes do
		self.mboard[i] = {}
		for j=1,n_cubes do
			self.mboard[i][j] = {}
			local draw = cc.DrawNode:create():addTo(self,10)
			-- draw:drawSolidRect(cc.p((i-1)*(n_cubes_length+n_space),(j-1)*(n_cubes_length+n_space)),cc.p((i-1)*(n_cubes_length+n_space)+n_cubes_length,(j-1)*(n_cubes_length+n_space)+n_cubes_length),color_cube)
			local rect = cc.rect((i-1)*(n_cubes_length+n_space),(j-1)*(n_cubes_length+n_space),n_cubes_length,n_cubes_length)
			drawNodeRoundRect(draw, rect, 0, 3, color_cube, color_cube)
		end
	end
end

-- 测试shape在对应位置是否可以放入
function CubeBoardView:testPutin(start,shape)
	local count_h = #shape.shapeStruct
	local count_v = #shape.shapeStruct[1]

	-- out of bounds
	if start.x+count_h-1>10 or start.y+count_v-1>10 then
		print("board.struct:",start.x,start.y)
		print("Error:CubeBoardView out of bounds")
		return false
	end
	-- point conflict
	for i=start.x,start.x+count_h-1 do
		for j=start.y,start.y+count_v-1 do
			if shape.shapeStruct[i-start.x+1][j-start.y+1]==1 and (self.mboard[i][j] and self.mboard[i][j].cubetype) then
				return false
			end
		end
	end
	-- 计算放入方块的加分
	-- print("addScore: ",score)
	-- self.score = shape.cubetype.score*10 + self.score

	return true
end

-- 将shape放入到board中
function CubeBoardView:putinShape(start,shape)
	local count_shapeh = #shape.shapeStruct
	local count_shapev = #shape.shapeStruct[1]
	for i=1,count_shapeh do
		for j=1,count_shapev do
			if shape.struct_points[i][j] and shape.struct_points[i][j].cubetype then
				local point = CubePoint.new({
						color = shape.cubecolor,
						cubetype = shape.cubetype,
						cubelength = shape.cubelength
				})
				point:pos(shape:getPositionX()-self:getPositionX()+(i-1)*(n_cubes_length+n_space), shape:getPositionY()-self:getPositionY()+(j-1)*(n_cubes_length+n_space))
				point:addTo(self,11)
				self.mboard[start.x+i-1][start.y+j-1] = point
				local action = cc.MoveTo:create(0.2, cc.p((start.x+i-2)*(n_cubes_length+n_space),(start.y+j-2)*(n_cubes_length+n_space)))
				self.mboard[start.x+i-1][start.y+j-1]:runAction(action)
			end
		end
	end
	MusicConfig.playSound(Res.music_putdown,false)
	self:addScore(shape.cubetype.score*10)
	self:reduceCubes()
end

-- 检测是否不能继续放入shape 用于检测游戏结束
function CubeBoardView:outOfMoves(arr_shapes)
	local canPutin = false
	for i,v in ipairs(arr_shapes) do
		local count_h = #v.shapeStruct
		local count_v = #v.shapeStruct[1]
		for j=1,n_cubes-count_h+1 do
			for k=1,n_cubes-count_v+1 do
				if self:testPutin(cc.p(j,k),v) then
					canPutin = true
					break
				end
			end		
		end
	end
	return canPutin
end

function CubeBoardView:clearBoard()
	self.score = 0
	for i=1,n_cubes do
		for j=1,n_cubes do
			if self.mboard[i][j] and self.mboard[i][j].cubetype then
				self.mboard[i][j]:removeSelf()
				self.mboard[i][j] = {}
			end
		end
	end
end

function CubeBoardView:reduceCubes()
	local arr_points = {}
	-- 是否可以消除
	local shouldReduce = false
	-- 构建消除数据结构 这里构建横排消除的结构
	for i=1,n_cubes do
		local hasHToReduce = true
		for j=1,n_cubes do
			-- print("self.mboard[i][j].cubetype:",self.mboard[i][j].cubetype)
			if not self.mboard[i][j].cubetype then
				hasHToReduce = false
			end
		end
		if hasHToReduce then
			arr_points[i] = {1,1,1,1,1,1,1,1,1,1}
			shouldReduce = true
		else
			arr_points[i] = {0,0,0,0,0,0,0,0,0,0}
		end
	end

	--这里构建竖排消除的结构 
	for i=1,n_cubes do
		local hasVToReduce = true
		for j=1,n_cubes do
			if not self.mboard[j][i].cubetype then
				hasVToReduce = false
			end
		end
		if hasVToReduce then
			shouldReduce = true
			for k=1,n_cubes do
				arr_points[k][i] = 1
			end
		end
	end

	-- 消除以及消除动画
	if shouldReduce then
		MusicConfig.playSound(Res.music_deleterow,false)
		-- 玩家连续消除
		self.combale = self.combale + 1
		-- 玩家一次消除多行
		local multi = 0
		-- 消除横排
		for i=1,n_cubes do
			local count = 0
			for k=1,n_cubes do 
				count = arr_points[i][k] + count
			end
			if count==10 then
				print("remove h:",i)
				multi = multi+1
				for j=1,n_cubes do
					local point = self.mboard[i][j]
					local action1 = cc.MoveTo:create(0.5, cc.p(point:getPositionX(),point:getPositionY()+640))
					point:runAction(action1)
					point:performWithDelay(function( )
						point:removeSelf()
					end, 0.6)
					self.mboard[i][j] = {}
					arr_points[i][j] = 0
				end
			end
		end
		-- 消除竖排
		for j=1,n_cubes do
			local count = 0
			for k=1,n_cubes do 
				count = arr_points[k][j] + count
			end
			if count>0 then
				print("remove v:",j)
				multi = multi+1
				for i=1,n_cubes do
					local point = self.mboard[i][j]
					if point.cubetype then
						local action1 = cc.MoveTo:create(0.5, cc.p(point:getPositionX()+640,point:getPositionY()))
						point:runAction(action1)
						point:performWithDelay(function( )
							point:removeSelf()
						end, 0.6)
						self.mboard[i][j] = {}
						arr_points[i][j] = 0
					end
				end
			end
		end

		local mutilScore = {100,300,600,1200,2400,4800}
		self:addScore(self.combale*20+mutilScore[multi])
	else
		-- 每次放入之后如果没有combale 则combale 清零
		self.combale = 0
	end
end

function CubeBoardView:addScore(score)
	print("addScore: ",score)
	self.score = score + self.score
end

return CubeBoardView