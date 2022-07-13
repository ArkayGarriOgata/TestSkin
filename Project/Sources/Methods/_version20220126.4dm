//%attributes = {}
// _______
// Method: _version20220126   ( ) ->
// By: MelvinBohince @ 01/26/22, 08:46:33
// Description
// set up StrongSync option in edi
// ----------------------------------------------------

C_OBJECT:C1216($e; $new_e; $status_o; $clone_o)

$e:=ds:C1482.edi_COM_Account.query("useDefault=True").first()  //should be expandrive-liason

If ($e#Null:C1517)
	
	$clone_o:=$e.toObject()  //couldn't get .clone() to behave
	
	//make changes
	$clone_o.Name:="StrongSync-Liaison"
	$clone_o.useDefault:=False:C215
	$clone_o.pk_id:=Generate UUID:C1066
	
	//save the pref
	$new_e:=ds:C1482.edi_COM_Account.new()
	$new_e.fromObject($clone_o)
	
	$status_o:=$new_e.save()
	If (Not:C34($status_o.success))
		BEEP:C151
	End if 
	
	
Else 
	ALERT:C41("Expandrive option not found.")
End if 

EDI_clearBlobs
BEEP:C151
