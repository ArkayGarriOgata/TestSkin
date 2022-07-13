//%attributes = {}
// _______
// Method: _version210709   ( ) ->
// By: Mel Bohince @ 07/09/21, 11:11:58
// Description
// clear some old print flow records
// ----------------------------------------------------

READ WRITE:C146([PrintFlow_Msg_Queue:169])
//do them in chunks
QUERY:C277([PrintFlow_Msg_Queue:169]; [PrintFlow_Msg_Queue:169]Created:2="2021@")
util_DeleteSelection(->[PrintFlow_Msg_Queue:169])

QUERY:C277([PrintFlow_Msg_Queue:169]; [PrintFlow_Msg_Queue:169]Created:2="2020@")
util_DeleteSelection(->[PrintFlow_Msg_Queue:169])

QUERY:C277([PrintFlow_Msg_Queue:169]; [PrintFlow_Msg_Queue:169]Created:2="2019@")
util_DeleteSelection(->[PrintFlow_Msg_Queue:169])

QUERY:C277([PrintFlow_Msg_Queue:169]; [PrintFlow_Msg_Queue:169]Created:2="2018@")
util_DeleteSelection(->[PrintFlow_Msg_Queue:169])


REDUCE SELECTION:C351([PrintFlow_Msg_Queue:169]; 0)
