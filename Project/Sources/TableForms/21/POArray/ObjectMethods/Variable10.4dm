//(S) [RAW_MATERIALS]POArray'bAdd
//•2/13/97 cs on site allow change of location without change to comapny
// Modified by: Mel Bohince (3/4/16) unloaded RM rec, loaded when the item was selected
C_LONGINT:C283($hit)

If (rQty#0) & (sItemNumber#"") & (sPONumber#"")
	If (sRMCode#"")
		POI_ItemsToPost(0; "Load")
		sReceiveNum:=POI_ReceivingNumberManager("setNext"; 1)  //increment and clear sReceiveNum
		gClrRMFields
		UNLOAD RECORD:C212([Raw_Materials:21])  // Modified by: Mel Bohince (3/4/16) this was loaded when the item was selected
		GOTO OBJECT:C206(sPONum)
		
	Else 
		uConfirm("RM Code is required."; "OK"; "Help")
	End if   //rm code pass
	
Else 
	Case of 
		: ((sItemNumber="") | (sPONumber=""))
			uConfirm("A Purchase Order must be entered and an Item selected."; "OK"; "Help")
		: (rQty<=0)
			uConfirm("A positive Quantity received must be entered."; "OK"; "Help")
	End case 
End if 