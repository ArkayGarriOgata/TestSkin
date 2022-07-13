
// Method: [Purchase_Orders_Releases].Input.POitemKey ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/16/15, 11:41:33
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Purchase_Orders_Releases:79]POitemKey:1)

If (Form event code:C388=On Data Change:K2:15)
	
	If (Records in selection:C76([Purchase_Orders_Items:12])#1)
		uConfirm([Purchase_Orders_Releases:79]POitemKey:1+" was not found. Please try again."; "Ok"; "Help")
		GOTO OBJECT:C206([Purchase_Orders_Releases:79]POitemKey:1)
		
	Else 
		[Purchase_Orders_Releases:79]RM_Code:7:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
		C_LONGINT:C283($numRels)
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numRels)
		QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]POitemKey:1=[Purchase_Orders_Releases:79]POitemKey:1)
		[Purchase_Orders_Releases:79]RelNumber:4:=String:C10(($numRels+1); "000")
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
	End if 
	
End if 