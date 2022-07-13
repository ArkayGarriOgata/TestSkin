//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/17/07, 16:12:55
// ----------------------------------------------------
// Method: BOL_inputOnDataChange
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

iTotal:=0
For ($i; 1; Size of array:C274(aTotalPicked))
	iTotal:=iTotal+aTotalPicked{$i}
End for 

$alreadyPicked:=0
For ($i; 1; Size of array:C274(aLocation2))
	If (aReleases{$i}=release_number)  //deduct inventory
		$alreadyPicked:=$alreadyPicked+aTotalPicked2{$i}
	End if 
End for 

Case of 
	: (iTotal=0) | (Records in selection:C76([Customers_ReleaseSchedules:46])=0)
		SetObjectProperties(""; ->iTotal; True:C214; ""; True:C214; White:K11:1; Light grey:K11:13)
	: ((iTotal+$alreadyPicked)>max_ship_quantity)
		SetObjectProperties(""; ->iTotal; True:C214; ""; True:C214; Yellow:K11:2; Red:K11:4)
		uConfirm("WARNING: You should only ship "+String:C10(max_ship_quantity)+" against this release, remove something."; "Ignor"; "Help")
		
	: (iTotal=[Customers_ReleaseSchedules:46]Sched_Qty:6)
		SetObjectProperties(""; ->iTotal; True:C214; ""; True:C214; White:K11:1; Dark green:K11:10)
	Else 
		SetObjectProperties(""; ->iTotal; True:C214; ""; True:C214; Black:K11:16; Light grey:K11:13)
End case 

BOL_setControls