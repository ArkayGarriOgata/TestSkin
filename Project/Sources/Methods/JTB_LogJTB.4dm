//%attributes = {"publishedWeb":true}
//PM: JTB_LogJTB() -> 
//@author mlb - 2/7/02  14:52
//WARNING temporarily being used by trigger_Global for logging

CREATE RECORD:C68([JTB_Logs:114])
[JTB_Logs:114]JTBid:1:=$1
[JTB_Logs:114]tsTimeStamp:2:=TSTimeStamp
[JTB_Logs:114]Description:3:=$2+"  ["+User_GetInitials+"]"
SAVE RECORD:C53([JTB_Logs:114])
//QUERY([JTB_Log];[JTB_Log]JTBid=$1)
//ORDER BY([JTB_Log];[JTB_Log]TimeStamp;<)
//REDRAW([JTB_Log])