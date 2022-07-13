//%attributes = {}
// _______
// Method: 4D_Current_date   ( ) ->
// By: 4D-PS @ 05/10/19
// Description
// use client's offset instead of contacting server
// ----------------------------------------------------


C_DATE:C307($0)
If (Not:C34(<>modification4D_10_05_19))  //| (<>disable_4DPS_mod)
	
	$0:=Current date:C33(*)
	
Else 
	C_TIME:C306($current_time; $resultat)
	$Current_date:=Current date:C33
	$current_time:=Current time:C178
	If (<>4d_Time.compare)
		If ($current_time>?24:00:00?)
			
			$resultat:=Time:C179($current_time-<>4d_Time.Difference)
			If ($resultat<?24:00:00?)
				
				$Current_date:=Current date:C33-1
				
			End if 
			
		End if 
	Else 
		If ($current_time<?24:00:00?)
			
			$resultat:=Time:C179($current_time+<>4d_Time.Difference)
			If ($resultat>?24:00:00?)
				
				$Current_date:=Current date:C33+1
				
			End if 
			
		End if 
	End if 
	$0:=$Current_date
End if 