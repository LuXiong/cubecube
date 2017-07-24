-- local sharedEngine = cc.SimpleAudioEngine:getInstance()
local MusicConfig = {}


-- 背景音乐文件较大 需要预加载
function MusicConfig.preloadBackgroundMusic(filename)
	if filename then
		print("preload background music")
		audio.preloadMusic(filename)
	else
		printf("MusicConfig Background music can't be null")
	end
end

-- -- 较大的音效文件
-- function MusicConfig.preloadEffect(filename)
-- 	if filename then
-- 		sharedEngine:preloadEffect(filename)
-- 	else
-- 		printf("MusicConfig effect music can't be null")
-- 	end
-- end

-- function MusicConfig.stopAllEffects()
-- 	sharedEngine:stopAllEffects()
-- end

function MusicConfig.playBackgroundMusic(filename)
	-- sharedEngine:playBackgroundMusic(filename,true)
	print("play background music")
	audio.playMusic(filename, true)
end

function MusicConfig.playSound(soundFile,isloop)

	local hasMusic = cc.UserDefault:getInstance():getStringForKey("cube_music") 
	if hasMusic == "1" then
		print("play sound",soundFile)
		audio.playSound(soundFile,isloop)
	end
end

-- 关闭背景音乐
function MusicConfig.closeBackgroundMusic()
	-- sharedEngine:setBackgroundMusicVolume(0)
	audio.setMusicVolume(0)
end

-- 关闭背景音乐
function MusicConfig.openBackgroundMusic()
	-- sharedEngine:setBackgroundMusicVolume(1)
	audio.setMusicVolume(1)
end

return MusicConfig