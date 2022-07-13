If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	USE SET:C118("clickedIncluded")
	
	<>JOBIT:=[Job_Forms_Items:44]Jobit:4
	Zebra_LabelSetup(<>JOBIT; "Arkay Barcode")  //[PackingSpecifications]LabelCase
	
	USE NAMED SELECTION:C332("hold")
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 