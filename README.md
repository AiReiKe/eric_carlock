# eric_carlock
Eric Car Lock

自寫車門鎖 尚在測試階段 預計能有效解決 上鎖/解鎖 延遲問題

指令功能:
/carkey 查看自己所擁有的鑰匙 並且可將鑰匙給別人
/refreshcarkey 刷新自己身上的鑰匙 解決進行任何車輛交易後車主無法鎖車的窘境

預留Event(懂得可以自行運用):

client端:
TriggerEvent("eric_carlock:addcarkey", 車牌) --> 給予玩家車牌鑰匙

Server端:
TriggerClientEvent("eric_carlock:addcarkey", 玩家, 車牌) --> 給予玩家車牌鑰匙

----------------------------------------------------------------------------------------
⚠ 此插件為免費提供 嚴禁拿來進行任何商業或交易行為 ⚠
