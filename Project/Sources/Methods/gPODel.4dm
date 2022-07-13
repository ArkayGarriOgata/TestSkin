//%attributes = {"publishedWeb":true}
//gPODel:
//10/21/94 made right
//10/25/94 upr 1299    made more right
//12/6/49 made really really right

C_TEXT:C284($poNum)

uConfirm("You may change the Status to Canceled. Contact Systems Dept to have this PO deleted."; "OK"; "Help")
If (False:C215)
	RELATE MANY:C262([Purchase_Orders:11]PONo:1)  //upr 1396
	QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Received:14>0)
	If (Records in selection:C76([Purchase_Orders_Items:12])=0)
		$poNum:=[Purchase_Orders:11]PONo:1
		$po_clause_key:=[Purchase_Orders:11]PO_Clauses:33
		gDeleteRecord(->[Purchase_Orders:11])
		
		If ((fDelete) & (Not:C34(fCnclTrn)))
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=$poNum)
			If (Records in selection:C76([Purchase_Orders_Items:12])>0)
				DELETE SELECTION:C66([Purchase_Orders_Items:12])
			End if 
			
			QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=$poNum+"@")
			If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
				DELETE SELECTION:C66([Purchase_Orders_Job_forms:59])
			End if 
			
			QUERY:C277([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]PONo:3=$poNum)
			If (Records in selection:C76([Purchase_Orders_Chg_Orders:13])>0)
				DELETE SELECTION:C66([Purchase_Orders_Chg_Orders:13])
			End if 
			
			QUERY:C277([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]id_added_by_converter:7=$po_clause_key)
			If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])>0)
				DELETE SELECTION:C66([Purchase_Orders_PO_Clauses:165])
			End if 
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("One or More Line Items on this PO has a Received Quantity Greater than 0 (zero) Deletion Can Not Occur.")
	End if 
End if 