//%attributes = {"publishedWeb":true}
//(p) rPrintReq
//prints the selected requistion number

C_TEXT:C284($ReqID)

$ReqID:=uSmRequest("Please Enter the Requisition ID to Print."; "R000000"; "Print")

If ($ReqId#"") & ($ReqId#"R000000") & (OK=1)  //user entered a reqid and accepted it
	READ ONLY:C145([Purchase_Orders:11])
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5=$ReqId)  //locate it (could contain '@')
	
	If (Records in selection:C76([Purchase_Orders:11])>0)  //if something was found - print them
		
		For ($i; 1; Records in selection:C76([Purchase_Orders:11]))
			ReqPrint([Purchase_Orders:11]PONo:1)
			NEXT RECORD:C51([Purchase_Orders:11])
		End for 
		
		
	Else 
		ALERT:C41("No Requistions with ID '"+$ReqId+"' were found.")
	End if 
	
Else 
	If (OK=1)
		ALERT:C41("Invalid Requisition ID.")
	End if 
End if 