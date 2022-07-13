//• 10/20/97 cs moved code to procedure - effiecency

//If (Not(<>NEW_FEATURE))  //•080895  MLB 1490 they need to see the closed to clean data up
If (oldway=1)  // Modified by: Mel Bohince (4/20/16) revert to old method with long transaction
	sPostReceipts
Else 
	RM_PostReceipts
End if 


<>RMBarCodePO:=""
<>RMPOICount:=0

sPONum:=""
gClrRMFields
POI_ItemsToReceive(0)
POI_ItemsToPost(0)
GOTO OBJECT:C206(sPONum)