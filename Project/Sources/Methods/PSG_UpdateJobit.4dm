//%attributes = {}
// _______
// Method: PSG_UpdateJobit   ( ) ->
// By: MelvinBohince @ 03/18/22, 10:01:38
// Description
// apply changes made on glue schedule to the jobform items table
// considering that there may be more than one subform
// which the old inline code did not handle
// ----------------------------------------------------

C_LONGINT:C283($currLBitem; $1)
$currLBitem:=$1

C_BOOLEAN:C305($restoreUI; $continue; $save)

READ WRITE:C146([Job_Forms_Items:44])
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=aJobit{$currLBitem})

START TRANSACTION:C239
$continue:=True:C214  //to break from while and cancel transaction
$restoreUI:=False:C215  //use if can't save the jmi record

While (Not:C34(End selection:C36([Job_Forms_Items:44]))) & ($continue)  //could be subforms
	If (fLockNLoad(->[Job_Forms_Items:44]))
		
		If (User in group:C338(Current user:C182; "Role_Glue_Scheduling"))
			
			[Job_Forms_Items:44]Gluer:47:=aGluer{$currLBitem}
			[Job_Forms_Items:44]Priority:48:=aPrior{$currLBitem}
			[Job_Forms_Items:44]Separate:49:=aSeparate{$currLBitem}
			[Job_Forms_Items:44]GluerComment:50:=aComment{$currLBitem}
			If ([Job_Forms_Items:44]GlueStyle:51#aStyle{$currLBitem})  // Modified by: Mel Bohince (9/30/14) 
				$fg_e:=ds:C1482.Finished_Goods.query("ProductCode = :1"; aCPN{$currLBitem}).first()
				If ($fg_e#Null:C1517)
					$fg_e.GlueType:=aStyle{$currLBitem}
					$status_o:=$fg_e.save(dk auto merge:K85:24)  //very optimistic about this
				End if 
			End if 
			[Job_Forms_Items:44]GlueStyle:51:=aStyle{$currLBitem}
			[Job_Forms_Items:44]MAD:37:=aHRD{$currLBitem}
			[Job_Forms_Items:44]GlueRate:52:=aDurationHrs{$currLBitem}
			[Job_Forms_Items:44]Cases:44:=aCasesOrdered{$currLBitem}
			[Job_Forms_Items:44]CasesMade:55:=aCasesMade{$currLBitem}
			$save:=True:C214
			
		Else   //not Role_Glue_Scheduling, allowed to change cases made
			If ([Job_Forms_Items:44]CasesMade:55#aCasesMade{$currLBitem})
				[Job_Forms_Items:44]CasesMade:55:=aCasesMade{$currLBitem}
				$save:=True:C214
			End if   //not role schd
			
		End if   //access allowed
		
		If ($save)
			SAVE RECORD:C53([Job_Forms_Items:44])
		End if 
		
	Else   //bail on locked record
		$continue:=False:C215
		$restoreUI:=True:C214  //restore the changes made on the ui
		uConfirm("Changes were not saved for item "+aJobit{$currLBitem}+", try again later."; "OK"; "Locked")
	End if   //locked
	
	NEXT RECORD:C51([Job_Forms_Items:44])
End while 

If ($continue)
	VALIDATE TRANSACTION:C240
Else 
	CANCEL TRANSACTION:C241
End if 

PSG_ServerArrays("die!")  //Kill the stored procedure so other users can get the changes


If ($restoreUI)  //undo changes to ui
	aGluer{$currLBitem}:=[Job_Forms_Items:44]Gluer:47
	aPrior{$currLBitem}:=[Job_Forms_Items:44]Priority:48
	aSeparate{$currLBitem}:=[Job_Forms_Items:44]Separate:49
	aComment{$currLBitem}:=[Job_Forms_Items:44]GluerComment:50
	aStyle{$currLBitem}:=[Job_Forms_Items:44]GlueStyle:51
	aHRD{$currLBitem}:=[Job_Forms_Items:44]MAD:37
	aDurationHrs{$currLBitem}:=[Job_Forms_Items:44]GlueRate:52
	aCasesOrdered{$currLBitem}:=[Job_Forms_Items:44]Cases:44
	aCasesMade{$currLBitem}:=[Job_Forms_Items:44]CasesMade:55
End if 

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
READ ONLY:C145([Job_Forms_Items:44])
/////////////////////////////////////////