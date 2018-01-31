--[[
    名称  :   LoginManager   登录请求处理
    作者  :   Xiaxb   
    描述  :   处理登录相关事宜
    时间  :   2017-7-28
--]]

local LoginManager = {}

local NovicesRewardLayer = require "lobby/layer/NovicesRewardLayer"
local LoginScene = require "lobby/scene/LoginScene"

LoginManager.isAutoLogin = AUTO_LOGIN

LoginManager.LoginType_Guest            = 0     -- 游客登录
LoginManager.LoginType_Wechat           = 1     -- 微信登录
LoginManager.LoginType_QQ               = 2     -- QQ登录

LoginManager.LoginResult_Success        = 1     -- 登录成功
LoginManager.LoginResult_Fail           = 2     -- 登录失败
LoginManager.LoginResult_Cancel         = 3     -- 登录取消

LoginManager.LoginResultCode = {}
LoginManager.LoginResultCode[1] = "登录成功!"               -- 登录成功
LoginManager.LoginResultCode[2] = "登录失败!"               -- 登录失败
LoginManager.LoginResultCode[3] = "登录取消!"               -- 登录取消
LoginManager.LoginResultCode[4] = "登录中!"                 -- 登录成功
LoginManager.LoginResultCode[5] = "登录超时!"               -- 登录成功
LoginManager.LoginResultCode[6] = "客户端不支持登录!"       -- 登录成功
LoginManager.LoginResultCode[7] = "未安装客户端!"           -- 登录成功
LoginManager.LoginResultCode[8] = "未知错误!"               -- 登录成功

LoginManager.LoginResultErr = "登录异常!"                   -- 登录返回数据异常


function LoginManager:ctor( ... )

end


function LoginManager:new( ... )

end

-- 登录前初始化登录sdk
function LoginManager:initSDK( ... )
    MultiPlatform:getInstance():thirdPartyConfig(LoginManager.LoginType_Wechat, config.SDKConfig.WeChat)
    MultiPlatform:getInstance():thirdPartyConfig(LoginManager.LoginType_QQ, config.SDKConfig.QQ)
end

-- 自动登录
function LoginManager:autoLogin( ... )
    if not LoginManager.isAutoLogin then
        -- self:enterLogin()
        return 
    end

    local token = cc.UserDefault:getInstance():getStringForKey("token", "")
    if "" == token then
        -- 进入登录
        -- self:enterLogin()
        return
    end
    -- token登录
    local loginURL = config.SDKConfig.getTokenLoginURL() .. token
    -- print("xiaxb-----------loginURL:" .. loginURL)
    self:login(loginURL)
end

-- 第三方登录
function LoginManager:thirdPartyLogin(plat, loginScene)
    local function loginCallBack(result)
        if type(result) == "string" and string.len(result) > 0 then
            local ok, _result = pcall(function()
                    return lib.JsonUtil:decode(result)
            end)
            -- print("xiaxb-------------ok:", ok)
            -- dump(_result, "xiaxb-----------_result")
            if ok and type(_result) == "table" then
                local result = _result["result"]
                if LoginManager.LoginResult_Success == result then
                    if LoginManager.LoginType_Guest == _result["plat"] then
                        -- 游客获取硬件码
                        local msg = _result["msg"]
                        print("xiaxb-------------游客成功获取code：" .. msg)
                        -- local loginURL = config.SDKConfig.getGuestLoginURL() .. msg
                        if  msg then HttpClient:getInstance().MachineCode =  msg end
                        local loginURL = config.SDKConfig.getGuestLoginURL()
                        -- print("xiaxb-----------loginURL:" .. loginURL) 
                        self:login(loginURL, loginScene)

                    elseif LoginManager.LoginType_Wechat == _result["plat"] then
                        -- 微信成功获取code
                        local msg = _result["msg"]
                        print("xiaxb-------------微信成功获取code：" .. msg)
                        local loginURL = config.SDKConfig.getWeChatLoginURL() .. msg
                        -- print("xiaxb-----------loginURL:" .. loginURL)
                        self:login(loginURL, loginScene)

                    elseif LoginManager.LoginType_QQ == _result["plat"] then
                        -- QQ成功获取opneid
                        print("xiaxb-------------QQ成功获取openid：" .. _result["openid"])
                        local loginURL = config.SDKConfig.getQQLoginURL() .. _result["access_token"] .. "/" .. _result["openid"]
                        -- print("xiaxb-----------loginURL:" .. loginURL)
                        self:login(loginURL, loginScene)
                    else
                        -- print("xiaxb-------------unknow data：" .. _result)
                        GameUtils.showMsg(LoginManager.LoginResultErr)
                        if loginScene then
                            print("xiaxb", "showLoginBtns")
                            loginScene:showLoginBtns()
                        end
                    end
                else
                    -- 授权失败
                    local resultCode = _result["resultCode"]
                    GameUtils.showMsg(LoginManager.LoginResultCode[resultCode])
                    if loginScene then
                        print("xiaxb", "showLoginBtns")
                        loginScene:showLoginBtns()
                    end
                end
            else
                -- 数据返回异常
                if type(result) == "string" then
                    GameUtils.showMsg(result)
                else
                    GameUtils.showMsg(LoginManager.LoginResultErr)
                end
                if loginScene then
                    print("xiaxb", "showLoginBtns")
                    loginScene:showLoginBtns()
                end
            end
        else
            -- 数据返回异常
            GameUtils.showMsg(LoginManager.LoginResultErr)
            if loginScene then
                print("xiaxb", "showLoginBtns")
                loginScene:showLoginBtns()
            end
        end
    end
    if loginScene then
        print("xiaxb", "playLoginAnimation")
        loginScene:playLoginAnimation()
    end
    MultiPlatform:getInstance():thirdPartyLogin(plat, loginCallBack)
end

function LoginManager:login(loginURL, loginScene)
    -- if loginScene then
    --     print("xiaxb", "playLoginAnimation")
    --     -- loginScene:playLoginAnimation()
    -- end

    --测试代码
    -- local layer = require("game/zjh/src/scene/GameScene"):create()
    -- local scene = cc.Scene:create()
    -- scene:addChild(layer)
    -- if cc.Director:getInstance():getRunningScene() then
    --     cc.Director:getInstance():replaceScene(scene)
    -- else
    --     cc.Director:getInstance():runWithScene(scene)
    -- end
    --把下面取消注释

    
    local function onGet (__error, __response)
        dump(__response)
        if loginScene then
            print("xiaxb", "showLoginBtns")
            loginScene:showLoginBtns()
        end
        local msg = nil
        if __error then
            -- local msg = __error
            if type(__error) == "table" then
                msg = __error.msg
            end     
            GameUtils.showMsg("登录连接失败！" .. msg)
            msg = "登录连接失败！"
            self:enterLogin(msg)
        else
            if 200 == __response.status then
                -- 登录成功
                self:onLogin(__response)
            elseif 404 == __response.status then
                -- token失效	需要重新登录
                cc.UserDefault:getInstance():setStringForKey("token", "")
                -- msg = "登录信息错误！"
                -- self:enterLogin()
            elseif 403 == __response.status then
                local function callback(event)
                    if "ok" == event then
                        -- print("xiaxb", "callback")
                        -- self:enterLogin()
                    end
                end
                local parm = {type = ConstantsData.ShowMgsBoxType.BIG_TYPE , msg = __response.msg, callback = callback}
                GameUtils.showMsgBox(parm)
                return
            elseif 500 == __response.status then
                -- 出现错误
                -- GameUtils.showMsg("登录失败！")
                msg = "登录失败！"
                -- self:enterLogin(msg)
            elseif 503 == __response.status then
                -- GameUtils.showMsg("登录失败！")
                msg = "登录失败！"
                -- self:enterLogin(msg)
            elseif 504 == __response.status then
                -- GameUtils.showMsg("账号已在其他设备登录！！！")
                msg = "账号已在其他设备登录！"
                -- print("xiaxb======msg:" .. msg)
                -- self:enterLogin(msg)
            else
                GameUtils.showMsg("登录失败！")
                msg = "登录失败！"
                -- self:enterLogin(msg)
            end
        end
        if msg then
            GameUtils.showMsg(msg)
        end
    end
    print("xiaxb", "loging-------start")
    -- GameUtils.startLoading("正在登陆服务器...", 10)
	-- HttpClient:getInstance():get(loginURL, onGet)
    print("xiaxb", "loging-------end")

    local param = {}
    param.clientOS = config.channle.clientOS
    param.clientMachineCode = VIRTUAL_MACHINECODE
    param.clientDevice = MultiPlatform:getInstance():getDeviceName()
    param.clientVersion = config.channle.VERSION

    HttpClient:getInstance():post(loginURL,param,onGet)
end

function LoginManager:onLogin(__response)
    -- print("LoginManager:onLogin")
    -- GameUtils.stopLoading()
    print("fly","LoginManager:onLogin __response.data.token",__response.data.token)
    UserData.token = __response.data.token

    if "table" ~= type(__response.data) then
        -- local msg = "登录异常！"
        -- self:enterLogin()
        return
    end

    UserData.userId = __response.data.userId or 0
    UserData.nickName = __response.data.nickName or ""
    UserData.gender = __response.data.gender or 1
    UserData.avatarUrl = __response.data.avatar  or ""
    UserData.loginType = __response.data.loginType or 0
    UserData.LastTableID = __response.data.roomId or 0
    UserData.LastGameID = __response.data.gameId or 0
    UserData.LastGameIP = __response.data.serverIp 
    UserData.LastGamePort = __response.data.serverPort
    UserData.coins = __response.data.score or 0
    UserData.roomCards = 0
    if  __response.data.roomCard then 
        UserData.roomCards = tonumber(__response.data.roomCard)
    end
    UserData.diamond = __response.data.diamond or 0
    UserData.HasNewbiePack = __response.data.hasNewbiePack -- 是否有新手大礼包
    UserData.LastGameRoomType = __response.data.gameType or 1
    UserData.MobilePhone =  __response.data.mobile or ""

    self:enterLobby()

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then
		 -- report lua userId
        buglySetUserId(UserData.userId)
        -- report lua channel
        buglyAddUserValue("channel", config.channle.CHANNLE_ID)
        buglyAddUserValue("version", config.channle.CHANNLE_ID)
	end

    -- 保存登录成功的token(用于自动登录)
    cc.UserDefault:getInstance():setStringForKey("token", UserData.token)

    -- 用于测试，保存多账号(发包必须关闭)
    -- local userList = cc.UserDefault:getInstance():getStringForKey("userList", "")
    -- if "" == userList then
    --     cc.UserDefault:getInstance():setStringForKey("userList", "user" .. UserData.userId)
    --     cc.UserDefault:getInstance():setStringForKey("user" .. UserData.userId, UserData.token)     
    -- else
    --     print("xiaxb------------userList:" .. userList)
    --     local userListTable = GameUtils.split(userList, ",")
    --     for k, v in pairs(userListTable) do
    --         if v ==  "user" .. UserData.userId then
    --             return
    --         end
    --     end
    --     cc.UserDefault:getInstance():setStringForKey("userList", userList .. ",user" .. UserData.userId)
    --     cc.UserDefault:getInstance():setStringForKey("user" .. UserData.userId, UserData.token)
    -- end
end

-- 更新完成跳转至登录场景
function LoginManager:enterLogin(isAutoLogin)
        
    if Boot and Boot.clear then Boot:clear() end
    local url = config.ServerConfig:findModelDomain() .. config.ApiConfig.REQUEST_STORESWITCH
    HttpClient:getInstance():get(url,function ( __error,__response )
        if __response and __response.data and __response.data.HideStore then 
            manager.UserManager:getInstance():setCloseRoomCardFlag(__response.data.HideStore ~= 0)  --  data.HideStore ~= 0   0正常  1 关闭私人房以及房卡
        end
        local loginScene = LoginScene:create()
        loginScene:runWithScene(isAutoLogin)
        -- dump(self.loginScene, "SERFDSADFA")
        
    end)
    

end

-- 登录完成则跳转到大厅场景
function LoginManager:enterLobby()
    if UserData.HasNewbiePack == 1 then
        local scene = cc.Director:getInstance():getRunningScene()
        local _novicesRewardLayer = NovicesRewardLayer.new()
        scene:addChild(_novicesRewardLayer,ConstantsData.LocalZOrder.DIY_DIALOAG_LAYER)
    else
        -- local orderList = cc.UserDefault:getInstance():setStringForKey("orderList", "")
        require("lobby/scene/LobbyScene"):create():runWithScene()
    end
end

-- lib.singleInstance:bind(LoginManager)
cc.exports.LoginManager = LoginManager
-- return LoginManager