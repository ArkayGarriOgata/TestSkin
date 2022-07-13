//%attributes = {"publishedWeb":true}
//(P) gCancelPO: called from (S) [PURCHASE_ORDER]Input'hcPO
//•052599  mlb sPOAction=New is not reliable!!!

C_BOOLEAN:C305($delete)

If (Is new record:C668([Purchase_Orders:11]))  //•052599  mlb sPOAction=New is not reliable!!!
	RELATE MANY:C262([Purchase_Orders:11]PONo:1)
	$po_clause_key:=[Purchase_Orders:11]PO_Clauses:33
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)
		uConfirm("You have created line items for this PO, proceeding will delete them. "+Char:C90(13)+"Continue anyway?"; "Yes"; "Go Back")
		If (OK=1)
			$delete:=True:C214
		Else 
			$delete:=False:C215
		End if 
	Else 
		$delete:=True:C214
	End if 
	
	If ($delete)
		DELETE SELECTION:C66([Purchase_Orders_Items:12])
		DELETE SELECTION:C66([Purchase_Orders_Chg_Orders:13])
		uResetID(Table:C252(->[Purchase_Orders:11]); Num:C11([Purchase_Orders:11]PONo:1))
		
		QUERY:C277([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]id_added_by_converter:7=$po_clause_key)
		If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])>0)
			DELETE SELECTION:C66([Purchase_Orders_PO_Clauses:165])
		End if 
		
		CANCEL:C270
	Else 
		REJECT:C38  //go back    
	End if 
	
	fCancel:=True:C214
	fPOMaint:=False:C215
	
Else   //existing po header
	CANCEL:C270
End if 