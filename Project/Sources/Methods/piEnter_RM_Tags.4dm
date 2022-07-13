//%attributes = {"publishedWeb":true}
//piEnter_RM_Tags
//• mlb - 4/20/01   sCriterion3:=""`set to users location, not the inventory
// Modified by: MelvinBohince (1/11/22) validate the po entered is for an inventoried item

If (Count parameters:C259=1)
	If (User in group:C338(Current user:C182; "Physical Inv"))
		uSpawnProcess("piEnter_RM_Tags"; 32000; "Enter R/M Tags"; True:C214; True:C214)
		If (False:C215)  //list called procedures for 4D Insider 
			piEnter_RM_Tags
		End if 
	Else 
		uNotAuthorized
	End if 
	
Else 
	NewWindow(350; 210; 1; 0; "Enter R/M Tags"; "wCloseCancel")
	//OPEN WINDOW(2;40;342;200;0;nGetPrcsName ;"wCloseCancel")
	SET MENU BAR:C67(4)
	READ WRITE:C146([Raw_Materials_Locations:25])
	READ WRITE:C146([Raw_Materials_Transactions:23])
	READ ONLY:C145([Purchase_Orders_Items:12])
	READ ONLY:C145([Purchase_Orders:11])
	READ ONLY:C145([Vendors:7])
	READ ONLY:C145([Raw_Materials:21])
	sCriterion1:=""
	sCriterion2:=""
	sCriterion3:=""  //set to users location, not the inventory
	sCriterion4:=""
	sCriterion5:=""
	rReal1:=0
	tText:=""
	tTitle:=""
	dDate:=Current date:C33
	
	C_OBJECT:C1216($form_o)  // Modified by: MelvinBohince (1/11/22) validate the po entered is for an inventoried item
	$form_o:=New object:C1471
	
	C_COLLECTION:C1488($inventoriedGroups_c)  // Added by: MelvinBohince (1/11/22) 
	$inventoriedGroups_c:=ds:C1482.Raw_Materials_Groups.query("ReceiptType = :1"; 1).orderBy("Commodity_Key").toCollection().extract("Commodity_Key")
	$form_o.validCommodityKeys_c:=$inventoriedGroups_c
	
	DIALOG:C40([zz_control:1]; "RM_pi_Tag"; $form_o)
	
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
	REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
	REDUCE SELECTION:C351([Vendors:7]; 0)
	CLOSE WINDOW:C154
	uWinListCleanup
End if 