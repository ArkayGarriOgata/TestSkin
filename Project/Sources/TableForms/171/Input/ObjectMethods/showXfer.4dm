// _______
// Method: [Raw_Material_Labels].Input.showXfer   ( ) ->
// By: Mel Bohince @ 04/17/19, 08:16:22
// Description
// get the transactions that reference this labelid
// ----------------------------------------------------


QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]RM_Label_Id:34=[Raw_Material_Labels:171]Label_id:2)

If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; >; [Raw_Materials_Transactions:23]XferTime:25; >)
Else 
	uConfirm("No issue transactions found."; "Ok"; "Thought So")
End if 


//c_object($xfer_collection)
//$xfer_collection:=ds.Raw_Materials_Transactions.query("RM_Label_Id = :1";[Raw_Material_Labels]Label_id)

