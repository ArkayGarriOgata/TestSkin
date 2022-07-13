If (Records in set:C195("UserSet")>0)
	$tag:=Request:C163("Tag HILITED releases' expedite field with what?"; "RFM"; "Ok"; "Cancel")  // Modified by: Mel Bohince (2/11/16) chg asn to rfm
	If (ok=1) & (Length:C16($tag)>0)
		zwStatusMsg("Tagging Rels"; "Adding "+$tag+" to the Expedite field")
		CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "holdRel")
		USE SET:C118("UserSet")  //use Rels user selected to process
		APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Expedite:35:=$tag+" "+[Customers_ReleaseSchedules:46]Expedite:35)
		USE NAMED SELECTION:C332("holdRel")
	End if 
	
Else 
	uConfirm("Select the records to tag first."; "Ok"; "Help")
End if 