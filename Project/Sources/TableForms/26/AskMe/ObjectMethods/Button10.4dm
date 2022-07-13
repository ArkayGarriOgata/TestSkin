$selectionSetName:="Job_Forms_Items"

UNLOAD RECORD:C212([Job_Forms_Items:44])
CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdNamedSelectionBefore")
USE SET:C118($selectionSetName)


If ([Job_Forms_Items:44]ProductCode:3=sCPN)
	If (<>pid_CAR#0)
		zwStatusMsg("Calling CAR"; "Sending selected jobit.")
		<>jobit:=[Job_Forms_Items:44]Jobit:4
		<>PO:=""
		POST OUTSIDE CALL:C329(<>pid_CAR)
		//cancel
		HIDE PROCESS:C324(Current process:C322)
		
	Else 
		uConfirm("A Corrective Action window was not detected."; "OK"; "Help")
	End if 
	
Else 
	BEEP:C151
End if 

USE NAMED SELECTION:C332("holdNamedSelectionBefore")