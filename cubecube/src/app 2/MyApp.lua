
require("config")
require("cocos.init")
require("framework.init")

require("app.scenes.contacts.CubeRes")
require("app.scenes.utils.CommonUtils")
MusicConfig = require("app.scenes.utils.MusicConfig")


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    math.randomseed((os.time()%1000)*(os.time()%1000)*(os.time()%1000))
    hue_position_color = math.random(1,25)
    f_scale = 640/750
    print("hue_position_color:",hue_position_color)

    self:initConfigs()
end

function MyApp:initConfigs()
	local record = cc.UserDefault:getInstance():getStringForKey("cube_record") 
	if not record or #record<=0 then
		record = "0"
		cc.UserDefault:getInstance():setStringForKey("cube_record", record)
	end

	local hasBgm = cc.UserDefault:getInstance():getStringForKey("cube_bgm") 
	if not hasBgm or #hasBgm<=0 then
		hasBgm = "1"
		cc.UserDefault:getInstance():setStringForKey("cube_bgm", hasBgm)
	end

	local hasMusic = cc.UserDefault:getInstance():getStringForKey("cube_music") 
	if not hasMusic or #hasMusic<=0 then
		hasMusic = "1"
		cc.UserDefault:getInstance():setStringForKey("cube_music", hasMusic)
	end
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("GameMenuScene")
end

return MyApp
