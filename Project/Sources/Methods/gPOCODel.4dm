//%attributes = {"publishedWeb":true}
//gPOCODel:
//If ([PURCHASE_ORDER]Status # "Chg Order") | ([PO_Chg_Orders]ChgOrdStatus
//« # "Open")
//ALERT("Requsition must be open to delete change order.")
//Else 
//gConfirmDel 
//If (fDelete=True)

If (fLockNLoad(->[Purchase_Orders_Chg_Orders:13]))
	uCancelTran
	
	If (fCnclTrn=False:C215)
		$chgs:=Records in selection:C76([Purchase_Orders_ChgOrder_Items:166])  //v1.0.3-JJG (03/28/17) - deprecated //Records in subselection([Purchase_Orders_Chg_Orders]POCO_Items)
		If ($chgs=0)
			[Purchase_Orders:11]StatusTrack:51:="Empty Change Order deleted "+String:C10(4D_Current_date; Internal date short special:K1:4)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
		Else 
			[Purchase_Orders:11]StatusTrack:51:="Change Order with "+String:C10($chgs)+"items deleted "+String:C10(4D_Current_date; Internal date short special:K1:4)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
		End if 
		
		DELETE RECORD:C58([Purchase_Orders_Chg_Orders:13])
		RELATE MANY:C262([Purchase_Orders:11]PONo:1)
		BEEP:C151
		ALERT:C41("Be sure to return all changes to their original state!"; "Sure")
	End if 
End if 