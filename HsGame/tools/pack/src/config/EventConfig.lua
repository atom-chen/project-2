--[[--
@author fly
]]

local EventConfig = {
	EVENT_ROOM_PROGRESS_TO_VIEW = "EVENT_ROOM_PROGRESS_TO_VIEW",
	EVENT_ROOM_ENDED_TO_VIEW = "EVENT_ROOM_ENDED_TO_VIEW",
	EVENT_ROOM_JOIN_CHESS_TO_VIEW = "EVENT_ROOM_JOIN_CHESS_TO_VIEW",
	EVENT_CREATE_ROOM_SHOW = "EVENT_CREATE_ROOM_SHOW",
	EVENT_CREATE_REQUEST = "EVENT_CREATE_REQUEST",
	EVENT_ENTER_GAME = "EVENT_ENTER_GAME",
	EVENT_LOGIN_TIP_SHOW = "EVENT_LOGIN_TIP_SHOW",
	EVENT_SOUND_PLAY = "EVENT_SOUND_PLAY",
	EVENT_AUDIO_EFFECT_PLAY = "EVENT_AUDIO_EFFECT_PLAY",
	EVENT_AUDIO_EFFECT_STOP = "EVENT_AUDIO_EFFECT_STOP",
	EVENT_MUISIC_PLAY = "EVENT_MUISIC_PLAY",
	EVENT_MUISIC_STOP = "EVENT_MUISIC_STOP",
	EVENT_REFRESH_GAME_PLAYS = "EVENT_REFRESH_GAME_PLAYS",
	EVENT_REFRESH_USER_INFO = "EVENT_REFRESH_USER_INFO",
	EVENT_REFRESH_USER_NICKNAME = "EVENT_REFRESH_USER_NICKNAME",
	EVENT_REFRESH_USER_AVATAR = "EVENT_REFRESH_USER_AVATAR",
	EVENT_NO_INTERACTION = "EVENT_NO_INTERACTION",
	EVENT_ALLOW_INTERACTION = "EVENT_ALLOW_INTERACTION",
	EVENT_SEND_CHAT = "EVENT_SEND_CHAT",
	EVENT_SEND_CHAT_FRIEND_VIEW = "EVENT_SEND_CHAT_FRIEND_VIEW",
	EVENT_SEND_CHAT_WORLD_VIEW = "EVENT_SEND_CHAT_WORLD_VIEW",
	EVENT_SEND_CHAT_GAME_VIEW = "EVENT_SEND_CHAT_GAME_VIEW",
	EVENT_SOCKET_DISPATCH_MSG = "EVENT_SOCKET_DISPATCH_MSG",
	EVENT_RECONNECT_SOCKET = "EVENT_RECONNECT_SOCKET", --重连socket
	EVENT_SEND_HEAD_JUMP = "EVENT_SEND_HEAD_JUMP", --发送心跳包
	EVENT_RECEIVE_HEAD_JUMP = "EVENT_RECEIVE_HEAD_JUMP", --接收心跳包
	EVENT_INIT_RECONNECT_STATE = "EVENT_INIT_RECONNECT_STATE", -- 重置重连状态
	EVENT_UPDATA_RECONNECT_FAIL_STATE = "EVENT_UPDATA_RECONNECT_FAIL_STATE", --更新重连失败状态

    EVENT_SYSTEN_BROADCAST_MSG = "EVENT_SYSTEN_BROADCAST_MSG",  --广播
    EVENT_TASK_GOTO_GAME_SCENE = "EVENT_TASK_GOTO_GAME_SCENE",  --任务前往游戏场景
    PIPLE_TO_ENTER_GAME = "PIPLE_TO_ENTER_GAME",
    EVENT_GAME_LIST_REFRESH = "EVENT_GAME_LIST_REFRESH",
    EVENT_GAME_RESULT_FINISH = "EVENT_GAME_RESULT_FINISH"
}

cc.exports.config.EventConfig = EventConfig