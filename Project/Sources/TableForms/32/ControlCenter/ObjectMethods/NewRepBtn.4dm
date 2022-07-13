// _______
// Method: [Salesmen].ControlCenter.NewRepBtn   ( ) ->
// By: Mel Bohince @ 12/11/19, 10:28:30
// Description
// pick a user to make a salesmen from
// ----------------------------------------------------
// based on: [MaintRepairSupply_Bins].ControlCenter.AddBin   ( ) ->
// ----------------------------------------------------
C_OBJECT:C1216($users; $reps; $form_o; $rep; $result)
C_TEXT:C284(userInitials)
$users:=ds:C1482.Users.query("DOT = :1"; !00-00-00!).orderBy("FirstName asc")

$form_o:=New object:C1471
$form_o.users:=$users

$winRef:=OpenFormWindow(->[Users:5]; "Pick_UserFromList")
DIALOG:C40([Users:5]; "Pick_UserFromList"; $form_o)
If (ok=1)
	$users:=ds:C1482.Users.query("Initials = :1"; userInitials).first()
	
	$reps:=ds:C1482.Salesmen.query("( ID = :1 "; userInitials)
	If ($reps.length=0)
		$rep:=ds:C1482.Salesmen.new()
		$rep.ID:=$users.Initials
		$rep.FirstName:=$users.FirstName
		$rep.MI:=$users.MI
		$rep.LastName:=$users.LastName
		$rep.BusTitle:="Sales Rep"
		$rep.Phone:=$users.CellPhone
		$rep.Active:=True:C214
		$result:=$rep.save()  //save the entity
		
		If (Not:C34($result.success))
			uConfirm("Not saved. Error: "+$result.statusText; "Darn"; "Ok")
		End if 
		
		Form:C1466.reps:=ds:C1482.Salesmen.query("( Active = :1 "; True:C214).orderBy("FirstName asc")
		//
		//Select the created user in the list box
		// The indexOf() method will be detailed in another How do I
		LISTBOX SELECT ROW:C912(*; "ListBoxReps"; $rep.indexOf(Form:C1466.reps)+1)
		OBJECT SET SCROLL POSITION:C906(*; "ListBoxReps"; $rep.indexOf(Form:C1466.reps)+1)
		repSelection:="ACTIVE"
		
		
	Else   //exists
		uConfirm(userInitials+" already is set up as a Sales Rep, use Update to set Active."; "Ok"; "Help")
	End if 
	
End if 
