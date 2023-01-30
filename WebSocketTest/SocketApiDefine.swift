//
//  SocketApiDefine.swift
//  MessengerSwiftUI
//
//  Created by KBSYS on 2022/11/03.
//

import Foundation

// web socket api name
let CHANNEL_PREFIX = "hynix.client"

let API_REQUEST = "websocket.apirequest"

let API_SELECT_CHANNEL_LIST = IS_CHANNEL_TREE ? "bizrunner.selectChannelTree" : "bizrunner.selectChannelList"
//let API_SELECT_CHANNEL_TREE_LIST = "bizrunner.selectChannelTree"
let API_SELECT_DM_LIST = "websocket.selectDMChannel"
let API_SELECT_MESSAGE_LIST = "websocket.selectMessageList"
let API_SELECT_MESSAGE = "websocket.selectMessage"

let API_SELECT_HYTUBE_LIST = "bizrunner.selectHyTUBEChannelList"
let API_SELECT_HIFB_LIST = "bizrunner.selectHyFeedBackChannelList"
let API_SELECT_CHATBOT_LIST = "websocket.selectBotTypeList"

let API_SELECT_CHANNEL_INFO_SUMMARY = "websocket.selectChannelInfoSummary"
let API_UNREAD_CHANNEL_MESSAGE_COUNT = "websocket.unreadChannelMessageCount"
let API_UNREAD_DM_MESSAGE_COUNT = "websocket.unreadDMChannelMessageCount"
let API_UPDATE_DM_FAVORITE = "websocket.updateFavoriteChannel"
let API_SELECT_PROFILE = "websocket.selectProfile"

let API_ADD_MESSAGE = "websocket.addMessage"
let API_WRITING_MESSAGE_START = "websocket.selectWritingMessageProfileNoticeStart"
let API_WRITING_MESSAGE_STOP = "websocket.selectWritingMessageProfileNoticeStop"
let API_FCM_TOKEN_SEND = "websocket.apiNotificationKey"

let API_SELECT_SEARCH_USER_LIST = "bizrunner.SearchUserList"
let API_SELECT_SEARCH_DEPT_LIST = "bizrunner.SearchDeptList"
let API_SELECT_SEARCH_CHANNEL_LIST = "websocket.apiSearchChannelList"


let API_SELECT_WS_SEARCH_USER_LIST = "websocket.apiSearchUserList"
let API_SELECT_SERVICE_CENTER_LIST = "websocket.selectEmpServicesList"
let API_SELECT_FAVORITE_MEMBER_LIST = "websocket.selectDMFavoriteMembers"
let API_SELECT_TRANS_LANGUAGE_LIST = "websocket.selectTranslatSupportTypeList"
let API_UPDATE_USER_LANGUAGE_TYPE = "websocket.updateUserLanguageType"

let API_SELECT_EMOTICON_GROUP_LIST = "websocket.selectEmoticonGroup"
let API_SELECT_EMOTICON_BY_GROUP_ID = "websocket.selectEmoticonByGropID"

let API_SELECT_ALARM_SETTING = "websocket.selectPrivateAlarmSetting"
let API_UPDATE_ALARM_SETTING = "websocket.updatePrivateAlarmSetting"

let API_INSERT_DM_CHANNEL = "websocket.insertDMChannel"
let API_INSERT_CHANNEL = "websocket.createChannel"
let API_JOIN_CHANNEL = "websocket.apiChannelJoinInvite"
let API_JOIN_HYFEEDBACK = "websocket.apiMobileHyFeedBack"

let API_BOT_COMMAND_LIST = "websocket.selectBotCommandList"
let API_MOBILE_LOG = "websocket.apiMobileLog"

let API_WRITING_MESSAGE_PROFILE_NOTICE_START = "websocket.selectWritingMessageProfileNoticeStart"
let API_WRITING_MESSAGE_PROFILE_NOTICE_STOP = "websocket.selectWritingMessageProfileNoticeStop"

let API_ADD_LIKE_EMOTICON = "websocket.addLikeEmoticon"
let API_DEL_LIKE_EMOTICON = "websocket.delLikeEmoticon"
let API_SELECT_FAVORITE_EMOTICON = "websocket.selectAddLikeEmoticon"

let API_REQUEST_AUTH_KEY = "websocket.apiRequestAuthKey"
let API_REQUEST_IMAGE_BYTE = "websocket.apiImageByte"


let API_ADD_VOTE_MESSAGE = "websocket.addVoteMessage"
let API_SELECT_ON_VOTING_LIST = "websocket.selectOnVotingList"
let API_SELECT_VOTE_BY_MESSAGEID = "websocket.selectVoteByMessageID"
let API_SEARCH_VOTE = "websocket.searchVote"
let API_ATTEND_VOTE = "websocket.attendVote"
let API_ADD_VOTE_ANSWER = "websocket.addVoteAnswer"
let API_UPDATE_VOTE_MESSAGE = "websocket.updateVoteMessage"

let API_SELECT_MEMBER_PROFILE = "websocket.selectMemberProfile"

let API_ADD_POST = "websocket.apiaddpost"
let API_UPDATE_POST = "websocket.apiupdatepost"

let API_TRANSLATION = "websocket.translation"
let API_UPDATE_FREEZING_ANONYMOUS = "websocket.updateFreezingAnonymous" //익명 채팅금지
let API_CHANNEL_ALARM_SETTING = "websocket.channelAlarmSetting"

let API_CHANNEL_DELETE = "websocket.requestChannelDelete"
let API_CHANNEL_REJECT_DELETE = "websocket.rejectChannelDelete"

let API_SELECT_PINNED_MESSAGE_LIST = "websocket.selectPinnedMessageList"
let API_SELECT_CHANNEL_IN_MEMBER = "websocket.selectChannelInMember"
let API_SELECT_CHANNEL_TODO_LIST = "websocket.selectChannelTodoList"
let API_SEARCH_MESSAGE_LIST = "websocket.searchMessageListAsc"

let API_UPDATE_CHANNEL_ALIAS = "websocket.updateChannelAlias"
let API_UPDATE_DMCHANNEL_ALIAS = "websocket.updateDMChannelAlias"

let API_SELECT_MESSAGE_ACTION = "websocket.selectMessageAction"
let API_ADD_REACTION = "websocket.addReaction"

let LOCAL_COMMAND = "local.command"

// TP CODE
let TP_DM_CHANNEL_OPEN           = "CHL1008"
let TP_CHANNEL_CREATE            = "CHL1004"     // 신규 채널 생성
let TP_CHANNEL_MESSAGE_SYNC      = "CNF1009"     // 채널별 UNREAD MESSAGE SYNC
let TP_DM_UNREAD_MESSAGE_SYNC    = "CNF2009"     // DM 채널 Unread 갱신

let TP_REQUEST_IMAGE_FILE        = "APL1006"     // edms 이미지 요청
let TP_RESPONSE_IMAGE_FILE       = "APL2006"     // edms 이미지 응답
let TP_REQUEST_POST_DETAIL       = "APL1007"     // post 상세 요청
let TP_RESPONSE_POST_DETAIL      = "APL2007"     // post 상세 응답
let TP_REQUEST_TEXT_FILE         = "APL1008"     // edms Text 요청
let TP_RESPONSE_TEXT_FILE        = "APL2008"     // edms Text 응답

let TP_SEARCH_MESSAGE_MENTION    = "ASC1001"      // 채널 내 멘션 메시지 검색 Response

let TP_CHANNEL_DELETE_YN         = "CHL1031"      // 채널 삭제 여부 선택
let TP_CHANNEL_DELETE_CANCEL     = "CHL1032"      // 채널 삭제 취소
let TP_CHANNEL_DELETE_COMPLETE   = "CHL1033"      // 채널 삭제 완료

let TP_REQUEST_TRANSLATION       = "TD1001"       // 번역 처리 요청 알림
let TP_RESPONSE_TRANSLATION      = "TD1002"       // 번역 처리 알림 (응답)


let TP_USER_LANGUAGE_CHANGE      = "CNF1006"      // 사용자 언어 설정 변경 - 개인별 사용자 정보 초기화

let TP_CHANNEL_ALIAS_MODIFY      = "CNF1014"      // 채널명 Alias 수정
let TP_DM_CHANNEL_ALIAS_MODIFY   = "CNF1015"      // DM 채널명 Alias 수정
