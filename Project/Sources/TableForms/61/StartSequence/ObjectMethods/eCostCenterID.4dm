// Modified by: Mel Bohince (10/19/16) validate cc is in same group as budget
[Job_Forms_Machine_Tickets:61]CostCenterID:2:=Replace string:C233([Job_Forms_Machine_Tickets:61]CostCenterID:2; " "; "")
$gluingUser:=(Substring:C12(Current user:C182; 1; 4)="Glue")  // Modified by: Mel Bohince (10/12/17)
//If (Current user="Designer")  // Modified by: Mel Bohince (10/12/17)
//CONFIRM("Act like Glue line user?";"Regular";"Gluer")
//If (ok=1)
//$gluingUser:=False
//Else 
//$gluingUser:=True
//End if 
//End if 

If ($gluingUser)
	If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>GLUERS)>0)
		$continue:=True:C214
	Else 
		uConfirm("Don't you mean one of these "+<>GLUERS; "Ok"; "Help")
		$continue:=False:C215
		[Job_Forms_Machine_Tickets:61]CostCenterID:2:=""
	End if 
	
Else 
	$continue:=True:C214
End if 

If ($continue)
	$enteredMachineClass:=CostCtr_getClass([Job_Forms_Machine_Tickets:61]CostCenterID:2)  //validate cc
	If ($enteredMachineClass#"unknown")
		If ($enteredMachineClass#machineClass)
			uConfirm("Switch from "+machineClass+" to "+$enteredMachineClass+"?"; "Sure"; "Try Again")
			If (ok=1)
				machineClass:=CostCtr_getClass(sCC)
			Else 
				[Job_Forms_Machine_Tickets:61]CostCenterID:2:=Old:C35([Job_Forms_Machine_Tickets:61]CostCenterID:2)
				GOTO OBJECT:C206([Job_Forms_Machine_Tickets:61]CostCenterID:2)
			End if 
		End if 
		
		
		If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>GLUERS)>0)
			OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; True:C214)
		Else 
			OBJECT SET ENTERABLE:C238([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; False:C215)
		End if 
		
	Else 
		uConfirm([Job_Forms_Machine_Tickets:61]CostCenterID:2+" is unknown, please try again."; "Ok"; "Help")
		[Job_Forms_Machine_Tickets:61]CostCenterID:2:=""
		REJECT:C38([Job_Forms_Machine_Tickets:61]CostCenterID:2)
	End if 
End if   //continue

