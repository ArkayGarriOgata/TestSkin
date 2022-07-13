//%attributes = {"publishedWeb":true}
//PM: User_NotifyAll() -> 
//see also User_NotifyCheck, User_NotifyAll, User_NotifySet
READ WRITE:C146([Users:5])
C_LONGINT:C283($i; $numUsers; $timestamp)
$timestamp:=TSTimeStamp

QUERY:C277([Users:5]; [Users:5]NotifyMe:23=True:C214)  //only set the flag on those registered to receive
APPLY TO SELECTION:C70([Users:5]; [Users:5]NotifyPressSchdChg:22:=$timestamp)

REDUCE SELECTION:C351([Users:5]; 0)
