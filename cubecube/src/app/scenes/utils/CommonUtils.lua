--
-- Author: xlook
-- Date: 2017-07-05 20:48:18
--



function generateColor()
	print("math.randomseed(os.time()):",os.time(),hue_position_color)
	local color = Res["color_hue_"..hue_position_color]
	hue_position_color = (hue_position_color%Res.color_hue_count)+1
	return color
end

--判断point是否在目标view内部
function rectContainsPointByWorld(worldPoint,targetNode,cascadeBound)
  local startPoint = targetNode:convertToWorldSpace(cc.p(0,0))
  local boundingBox = cascadeBound and targetNode:getCascadeBoundingBox() or targetNode:getBoundingBox()
  local newRect = cc.rect(startPoint.x-40,startPoint.y-40,boundingBox.width+80,boundingBox.height+80)
  if cc.rectContainsPoint(newRect, worldPoint) then
      return true
  end
  return false
end

-- 判断shape与board的包含关系
function testShapeInBoard(shape,board)
    local shapeLBPX = shape:getPositionX()
    local shapeLBPY = shape:getPositionY()
    local shapeRTPX = shape:getPositionX()+shape.f_width
    local shapeRTPY = shape:getPositionY()+shape.f_height

    local boardLBPX = board:getPositionX()-board.cubelength/2
    local boardLBPY = board:getPositionY()-board.cubelength/2
    local boardRTPX = board:getPositionX()+board.f_width+board.cubelength/2
    local boardRTPY = board:getPositionY()+board.f_height+board.cubelength/2

    if shapeLBPX > boardLBPX and shapeLBPY > boardLBPY and shapeRTPX < boardRTPX and shapeRTPY < boardRTPY then
        print("testShapeInBoard: true")
        return true
    else
    	print("testShapeInBoard: false")
        return false
    end
end

function generateShapePosition(shape,board)
	local positionx = math.floor((shape:getPositionX() - board:getPositionX() + board.cubelength/2)/(board.cubelength+board.cubespace))+1
	local positiony = math.floor((shape:getPositionY() - board:getPositionY() + board.cubelength/2)/(board.cubelength+board.cubespace))+1
	print("generateShapePosition:",(shape:getPositionX() - board:getPositionX() + board.cubelength/2)/(board.cubelength+board.cubespace))
	print("generateShapePosition:",(shape:getPositionY() - board:getPositionY() + board.cubelength/2)/(board.cubelength+board.cubespace))
	print("generateShapePosition:",positionx,positiony)
	return cc.p(positionx,positiony)
end

-- 1~104 随机前面的13种类型 105~110随机后面的两种类型
--[[
0.03
0.055
0.06
0.05
0.045
0.11
0.11
0.1
0.1
0.1
0.09
0.05
0.06
0.02
0.02
]]
function randomExchanger()
	local number = math.random(1,10000)%1000+1
	local numbers = {30,55,60,50,45,110,110,100,100,100,90,50,60,20,21}
	local index = 1

	while (number-numbers[index])>0 do
		number = number - numbers[index]
		index = index + 1
	end
	return index
	
end

function rotateShape(structs,direction)
	if direction <= 1 then
		return structs
	end

	local r_structs = {}
	local count_h = #structs
	local count_v = #structs[1]

	for j=1,count_v do
		r_structs[j] = {}
		for k=1,count_h do
			r_structs[j][k] = {}
		end
	end

	for j=1,count_h do
		for k=1,count_v do
			r_structs[k][count_h+1-j] = structs[j][k]
		end
	end

	return rotateShape(r_structs,direction-1)
end

-- 传入DrawNode对象，画圆角矩形
function drawNodeRoundRect(drawNode, rect, borderWidth, radius, color, fillColor)
	-- segments表示圆角的精细度，值越大越精细
	local segments    = 100
	local origin      = cc.p(rect.x, rect.y)
	local destination = cc.p(rect.x + rect.width, rect.y + rect.height)
	local points      = {}

	-- 算出1/4圆
	local coef     = math.pi / 2 / segments
	local vertices = {}

	for i=0, segments do
	local rads = (segments - i) * coef
	local x    = radius * math.sin(rads)
	local y    = radius * math.cos(rads)

	table.insert(vertices, cc.p(x, y))
	end

	local tagCenter      = cc.p(0, 0)
	local minX           = math.min(origin.x, destination.x)
	local maxX           = math.max(origin.x, destination.x)
	local minY           = math.min(origin.y, destination.y)
	local maxY           = math.max(origin.y, destination.y)
	local dwPolygonPtMax = (segments + 1) * 4
	local pPolygonPtArr  = {}

	-- 左上角
	tagCenter.x = minX + radius;
	tagCenter.y = maxY - radius;

	for i=0, segments do
	local x = tagCenter.x - vertices[i + 1].x
	local y = tagCenter.y + vertices[i + 1].y

	table.insert(pPolygonPtArr, cc.p(x, y))
	end

	-- 右上角
	tagCenter.x = maxX - radius;
	tagCenter.y = maxY - radius;

	for i=0, segments do
	local x = tagCenter.x + vertices[#vertices - i].x
	local y = tagCenter.y + vertices[#vertices - i].y

	table.insert(pPolygonPtArr, cc.p(x, y))
	end

	-- 右下角
	tagCenter.x = maxX - radius;
	tagCenter.y = minY + radius;

	for i=0, segments do
	local x = tagCenter.x + vertices[i + 1].x
	local y = tagCenter.y - vertices[i + 1].y

	table.insert(pPolygonPtArr, cc.p(x, y))
	end

	-- 左下角
	tagCenter.x = minX + radius;
	tagCenter.y = minY + radius;

	for i=0, segments do
	local x = tagCenter.x - vertices[#vertices - i].x
	local y = tagCenter.y - vertices[#vertices - i].y

	table.insert(pPolygonPtArr, cc.p(x, y))
	end

	if fillColor == nil then
	fillColor = cc.c4f(0, 0, 0, 0)
	end

	-- drawNode:drawPolygon(pPolygonPtArr, #pPolygonPtArr, fillColor, borderWidth, color)
	drawNode:drawPolygon(pPolygonPtArr, {["fillColor"] = fillColor,
										["borderWidth"] = borderWidth,
										["borderColor"] = color})
end

