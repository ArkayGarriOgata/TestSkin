// _______
// Method: [Customer_Portal_Extracts].LoginList.DuplicateLogin   ( ) ->
// By: Mel Bohince @ 03/05/20, 10:03:29
// Description
// 
// ----------------------------------------------------

If (esSelLogins.length>0)
	If (enLogin#Null:C1517)
		uConfirm("Duplicate "+enLogin.Name+"?"; "Duplicate"; "Cancel")
		If (ok=1)
			//start like the new button does
			C_OBJECT:C1216($enRec)  //tried using enLogin.clone() w/o success
			
			$enRec:=ds:C1482.Customer_Portal_Extracts.new()
			$enRec.Name:="DUP_OF_"+enLogin.Name
			$enRec.Username:="dup@email.com"
			$enRec.Password:="changeThis"
			$enRec.Customers:=enLogin.Customers
			$enRec.Active:=True:C214
			$enRec.save()
			esLogins:=esLogins.add($enRec)
			
		End if 
		
	Else   //selected one 
		BEEP:C151
	End if 
	
Else   //empty list
	BEEP:C151
End if 



