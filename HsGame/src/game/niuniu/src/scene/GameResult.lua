------------------------------------------
--解算界面
------------------------------------------
local GameResult = class("GameResult",cc.Layer)
local GameResultResPath = "game/niuniu/res/GameLayout/NiuNiu/result/"
local NiuNiuRule=cc.exports.lib.rule.NiuNiuRule:getInstance()

local TXT_COLOR = cc.c3b(255, 198, 178)--信息
local TXT_COLOR1 = cc.c3b(255, 198, 178)--id
local TXT_COLOR2 = cc.c3b(246, 212, 94)--胜利和当庄次数 赢总成绩
local TXT_COLOR3 = cc.c3b(14, 224, 255)--输总成绩

GameResult.SHAREBTN = 11 				--分享
GameResult.QUITBTN = 12 				--退出

function GameResult:ctor()
	self:enableNodeEvents()
end

function GameResult:initAllResult(arr,playerArr,tableid,playerNum,playerInfoData)
	local bgAllResult = display.newSprite(GameResultResPath.."allBg.png")
	bgAllResult:setPosition(667,375)
	self:addChild(bgAllResult,9999)

	local x,y = bgAllResult:getContentSize().width, bgAllResult:getContentSize().height

	-- local title = display.newSprite(GameResultResPath.."title_all.png")
	-- title:setPosition(x/2,y-60)
	-- bgAllResult:addChild(title)

	local roomId = cc.Label:createWithSystemFont("房间号:"..tostring(tableid),SYSFONT,26)
	roomId:setColor(TXT_COLOR)
	roomId:setAnchorPoint(0.0,0.5)
	roomId:setPosition(220,y-140)
	bgAllResult:addChild(roomId)
	local num = tostring(arr.curGameNum.."/"..arr.GameNum)
	local gameNum = cc.Label:createWithSystemFont("局数:"..num,SYSFONT,26)
	gameNum:setColor(TXT_COLOR)
	gameNum:setAnchorPoint(0.0,0.5)
	gameNum:setPosition(420,y-140)
	bgAllResult:addChild(gameNum)

	local playing = cc.Label:createWithSystemFont("玩法:",SYSFONT,26)
	playing:setColor(TXT_COLOR)
	playing:setAnchorPoint(0.0,0.5)
	playing:setPosition(600,y-140)
	bgAllResult:addChild(playing)
	local data = NiuNiuRule:parseRule(arr.rule)
	if data then
		local difen = cc.Label:createWithSystemFont("底分"..data.GameBet..",",SYSFONT,26)
		difen:setColor(TXT_COLOR)
		difen:setAnchorPoint(0.0,0.5)
		difen:setPosition(665,y-140)
		bgAllResult:addChild(difen)

		local suanniu = cc.Label:createWithSystemFont("",SYSFONT,26)
		if data.AccountType == 0 then
			suanniu:setString("自动算牛")
		elseif data.AccountType == 1 then
			suanniu:setString("手动算牛")
		end
		suanniu:setColor(TXT_COLOR)
		suanniu:setAnchorPoint(0.0,0.5)
		suanniu:setPosition(745,y-140)
		bgAllResult:addChild(suanniu)
	end 

	local curTime = os.date("%Y-%m-%d %H:%M")
	local curTimeTxt = cc.Label:createWithSystemFont("时间:"..curTime,SYSFONT,26)
	curTimeTxt:setColor(TXT_COLOR)
	curTimeTxt:setAnchorPoint(0.0,0.5)
	curTimeTxt:setPosition(x/2+220,y-140)
	bgAllResult:addChild(curTimeTxt)

    --分享按钮
	local shareBtn = ccui.Button:create(GameResultResPath.."bt_share_0.png",GameResultResPath.."bt_share_1.png")
	shareBtn:setTag(GameResult.SHAREBTN)
	shareBtn:setPosition(x/2-150,60)
	bgAllResult:addChild(shareBtn)
	shareBtn:addClickEventListener(function(sender) self:onButtonClickedEvent(sender) end)
	--退出按钮
	local quitBtn = ccui.Button:create(GameResultResPath.."bt_quit_0.png",GameResultResPath.."bt_quit_1.png")
	quitBtn:setTag(GameResult.QUITBTN)
	quitBtn:setPosition(x/2+150,60)
	bgAllResult:addChild(quitBtn)
	quitBtn:addClickEventListener(function(sender) self:onButtonClickedEvent(sender) end)

	
	local tempNode=cc.Node:create()
    bgAllResult:addChild(tempNode)
    local tempPos=240
    for i = 1, playerNum do
        local item=self:createAllItem(i,playerArr,playerInfoData)
        item:setPosition(tempPos*(i-1),0)
        tempNode:addChild(item)
    end
    tempNode:setPosition(x/2-tempPos*(playerNum-1)/2,y/2-15)

    return bgAllResult
end

function GameResult:createAllItem(index,playerArr,playerData)
	if playerArr==nil or playerData == nil then
		return
	end
	local playerAllBg = display.newSprite(GameResultResPath.."player_allBg.png")
	local x,y = playerAllBg:getContentSize().width,playerAllBg:getContentSize().height

	local info = playerData[playerArr[index].uid]

	local paramTab = {}
	paramTab.avatarUrl = info.avatar or ""
	paramTab.stencilFile = GameResultResPath.."head_clip_allBg.png"
	paramTab.defalutFile = GameUtils.getDefalutHeadFileByGender(info.gender)
	paramTab.frameFile = GameResultResPath.."head_allBg.png"

	local headnode = lib.node.Avatar:create(paramTab)
	headnode:setPosition(x/2-50,y-105)
	playerAllBg:addChild(headnode)

	local effect = display.newSprite(GameResultResPath.."siren_resultEffect.png")
	effect:setPosition(x/2,y/2)
	playerAllBg:addChild(effect)

	local winner = display.newSprite(GameResultResPath.."winner.png")
	winner:setPosition(50,y-45-8)
	playerAllBg:addChild(winner)

	local palyerName = cc.Label:createWithSystemFont(string.getMaxLen(info.nickName),SYSFONT,28)
	palyerName:setPosition(x/2,y/2+45)
	playerAllBg:addChild(palyerName)

	local palyerID = cc.Label:createWithSystemFont("ID:"..playerArr[index].uid,SYSFONT,26)
	palyerID:setColor(TXT_COLOR1)
	palyerID:setPosition(x/2,y/2+10)
	playerAllBg:addChild(palyerID)

	local palyerGard = cc.Label:createWithSystemFont(playerArr[index].bankerCount,SYSFONT,26)
	palyerGard:setColor(TXT_COLOR2)
	palyerGard:setPosition(x/2+15,y/2-25)
	playerAllBg:addChild(palyerGard)

	local palyerVic = cc.Label:createWithSystemFont(playerArr[index].vicCount,SYSFONT,26)
	palyerVic:setColor(TXT_COLOR2)
	palyerVic:setPosition(x/2+15,y/2-75)
	playerAllBg:addChild(palyerVic)

	local palyerScore = cc.Label:createWithSystemFont(playerArr[index].allSocre,SYSFONT,26)
	palyerScore:setColor(TXT_COLOR2)
	palyerScore:setPosition(x/4*3-18-10,50)
	playerAllBg:addChild(palyerScore)

	if playerArr[index].allSocre >= 0 then
		palyerScore:setString("+"..playerArr[index].allSocre)
	else
		palyerScore:setString(playerArr[index].allSocre)
		palyerScore:setColor(TXT_COLOR3)
	end

	local dayingjia = false
	for i,v in ipairs(playerArr) do
		if playerArr[index].allSocre >= v.allSocre  and playerArr[index].allSocre > 0 then
			dayingjia = true
		end
	end

	winner:setVisible(dayingjia)
	effect:setVisible(dayingjia)
	return playerAllBg
end

function GameResult:onButtonClickedEvent(sender)
	local tag = sender:getTag()
	if tag == GameResult.SHAREBTN then
		self:ShareResult()
	elseif tag == GameResult.QUITBTN then
		GameUtils.popDownNode(self,function()
			GameUtils.removeNode(self)
		end)
		self:backLobbyScene()
	end
end

function GameResult:ShareResult()
	local shareImageTab = {}     
	shareImageTab.callback = self:_onCallback(result)

 	ShareManager:shareImage(UserData.loginType, shareImageTab)
end
function GameResult:_onCallback(result)
	if result then
		print("结算分享回掉",result)
	end
end

-- 申请返回大厅
function GameResult:backLobbyScene()
	require("Lobby.src.lobby.scene.LobbyScene"):create():runWithScene()
end

function GameResult:onEnter()
	GameUtils.popUpNode(self)
	local event = cc.EventCustom:new(config.EventConfig.EVENT_GAME_RESULT_FINISH)
	lib.EventUtils.dispatch(event)
end
function GameResult:onExit()

end

return GameResult