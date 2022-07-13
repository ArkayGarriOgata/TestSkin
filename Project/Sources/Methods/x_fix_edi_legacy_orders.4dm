//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 04/06/10, 09:37:07
// ----------------------------------------------------
// Method: x_fix_edi_legacy_orders
// Description
// add the NA prefix, 01 suffix to existing orders where ELC changed the ref for SAP
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($cr)
$r:=Char:C90(13)
C_TIME:C306($docRef)
C_TEXT:C284($row)
C_BOOLEAN:C305($continue)

READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_ReleaseSchedules:46])
$docRef:=Open document:C264("")
If ($docRef#?00:00:00?)
	
	RECEIVE PACKET:C104($docRef; $row; $r)
	While (ok=1)
		$continue:=False:C215
		util_TextParser(14; $row)
		$new_po:=util_TextParser(3)
		$old_po:=Substring:C12($new_po; 3; 6)
		$cpn:=ELC_CPN_Format(util_TextParser(5))
		
		utl_Logfile("SAP_CONVERSION.log"; "--- ")
		
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]PONumber:11=$old_po)
		If (Records in selection:C76([Customers_Orders:40])>0)
			utl_Logfile("SAP_CONVERSION.log"; "ORDER "+String:C10([Customers_Orders:40]OrderNumber:1)+" "+$new_po+" "+String:C10(Records in selection:C76([Customers_Orders:40])))
			[Customers_Orders:40]PONumber:11:=$new_po
			SAVE RECORD:C53([Customers_Orders:40])
		Else 
			utl_Logfile("SAP_CONVERSION.log"; "NOGO: "+$new_po+" no order")
		End if 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21=($old_po+"@"))
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			utl_Logfile("SAP_CONVERSION.log"; "LINE "+$new_po+" "+String:C10(Records in selection:C76([Customers_Order_Lines:41])))
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21:=$new_po+".00010")
		Else 
			utl_Logfile("SAP_CONVERSION.log"; "NOGO: "+$new_po+" no lines")
		End if 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=($old_po+"@"))
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			utl_Logfile("SAP_CONVERSION.log"; "REL "+$new_po+" "+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46])))
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3:=$new_po+".00010.001")
		Else 
			utl_Logfile("SAP_CONVERSION.log"; "NOGO: "+$new_po+" no releases")
		End if 
		
		utl_Logfile("SAP_CONVERSION.log"; "--- ")
		
		RECEIVE PACKET:C104($docRef; $row; $r)
	End while 
	
	CLOSE DOCUMENT:C267($docRef)
	util_TextParser
	
	
End if 