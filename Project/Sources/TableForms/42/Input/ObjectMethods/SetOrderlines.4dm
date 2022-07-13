// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/04/13, 15:51:15
// ----------------------------------------------------
// Method: [Job_Forms].Input.Button1
// Description:
// Rewritten
// ----------------------------------------------------

C_LONGINT:C283($i)
C_TEXT:C284($tSetTo)

wWindowTitle("push"; "Set JobItems' Orderline to a common value")
OpenSheetWindow(->[Finished_Goods:26]; "SetOrderLines")
DIALOG:C40([Finished_Goods:26]; "SetOrderLines")
CLOSE WINDOW:C154

If (OK=1)
	Case of 
			//: (rbExcess=1)
			//$tSetTo:="Excess"
		: (rbFillIn=1)
			$tSetTo:="Fill-In"
		: (rbRerun=1)
			$tSetTo:="Rerun"
		: (rbForecast=1)
			$tSetTo:="FORECAST"
		: (rbDFmmddyy=1)
			$tSetTo:="DF"+tText
		: (rbComponent=1)
			<>USE_SUBCOMPONENT:=True:C214
			$tSetTo:="JC"+tText
	End case 
	
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; asJOrderID)
	For ($i; 1; Size of array:C274(asJOrderID))
		asJOrderID{$i}:=$tSetTo
	End for 
	ARRAY TO SELECTION:C261(asJOrderID; [Job_Forms_Items:44]OrderItem:2)
	ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >)
End if 

wWindowTitle("pop")