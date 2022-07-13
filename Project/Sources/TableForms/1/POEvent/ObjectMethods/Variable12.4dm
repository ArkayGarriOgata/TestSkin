//(s) bViewOpen
uYesNoCancel("View Open PO Items"+Char:C90(13)+"or"+Char:C90(13)+"View Open POs"+Char:C90(13)+"or"+Char:C90(13)+"Cancel"; "PO Items"; "POs")

Case of 
	: (OK=1)
		uSpawnProcess("doShowOpenItems"; 96000; "Open:"+Table name:C256(->[Purchase_Orders_Items:12]))
		If (False:C215)
			doShowOpenItems
		End if 
		
	: (bNo=1)
		ViewOpenPOs  //spawns its own process
End case 
//
