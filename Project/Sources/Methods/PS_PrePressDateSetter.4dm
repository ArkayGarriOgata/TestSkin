//%attributes = {}
// _______
// Method: PS_PrePressDateSetter   ( Form.clickedTopLeft_o;"PlatesReady" ) ->
// By: MelvinBohince @ 03/07/22, 11:05:44
// Description
// set the date requested in the parameter
// ----------------------------------------------------
C_OBJECT:C1216($quad_o; $1; $status_o)
C_TEXT:C284($property; $2)
C_DATE:C307($dateToUse)

//If (Form event code#On Display Detail)

If (Count parameters:C259=2)
	$quad_o:=$1
	$property:=$2
	
	If ($quad_o#Null:C1517)
		
		If ($quad_o#Null:C1517)  //listbox row selectedD
			//toggle the date
			If ($quad_o[$property]#!00-00-00!)
				$dateToUse:=!00-00-00!
			Else 
				$dateToUse:=Current date:C33
			End if 
			
			$quad_o[$property]:=$dateToUse
			
			$status_o:=$quad_o.save(dk auto merge:K85:24)
			If ($status_o.success)
				zwStatusMsg("Prepress"; $property+" has been set  to "+String:C10($dateToUse; Internal date short special:K1:4)+" for "+$quad_o.JobSequence)
				
			Else 
				uConfirm($quad_o.JobSequence+" was not saved."; "Dang"; "Try Again")
			End if 
			
			PS_PrePressRefreshLBs
			
		End if 
	End if 
	
End if   //count params

//End if 


