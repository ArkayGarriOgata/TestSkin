QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sRMCode)
If (Records in selection:C76([Raw_Materials:21])=1)
	// sPONumber:=""
	//sItemNumber:=""
	rPOPrice:=[Raw_Materials:21]LastPurCost:43
	rActPrice:=[Raw_Materials:21]ActCost:45
	rQty:=0
	rQty2:=0
	sUM1:=[Raw_Materials:21]IssueUOM:10
	sUM2:=[Raw_Materials:21]ReceiptUOM:9
	r1:=[Raw_Materials:21]ConvertRatio_N:16
	r2:=[Raw_Materials:21]ConvertRatio_D:17
	rPriceConv:=1
Else 
	BEEP:C151
	ALERT:C41("ERROR: Invalid R/M Code!  Entry needed in File [Raw_Materials]")
	sRMCode:=""
	//gClrRMFields 
End if 