//%attributes = {"publishedWeb":true}
//PM: util_DeleteSelection(->table{;"*"}{;"no-msg"}) -> number locked or -1 if no deletions
//@author mlb - 7/1/02  11:56
// Modified by: Mel Bohince (5/12/16) allow msg suppression with 3 params

//if 1 param, you're gonna get a msg, , locked records are ignored
//util_DeleteSelection (->[Finished_Goods_Locations])

//if 2 params, if param 2 is not blank, msg is suppressed, will keep trying to clear lockset
//util_DeleteSelection (->[Finished_Goods_Locations];"no-msg")

//if 3 params, if param 2 is not blank, msg is suppressed, locked records are ignored
//util_DeleteSelection (->[Finished_Goods_Locations];"no-msg";"ignore-locked")

C_POINTER:C301($tablePtr; $1)
$tablePtr:=$1
C_LONGINT:C283($0; $locked; $numSelected)
C_TEXT:C284($2; $3)  //"*" to clear locked set
C_BOOLEAN:C305($giveMsg)
//$giveMsg:=(Count parameters<3)
Case of 
	: (Count parameters:C259=1)
		$giveMsg:=True:C214
	: (Count parameters:C259>1)
		If (Length:C16($2)>0)  // Modified by: Mel Bohince (5/12/16) allow msg suppression with 3 params
			$giveMsg:=False:C215
		End if 
End case 

$numSelected:=Records in selection:C76($tablePtr->)

If ($giveMsg)
	zwStatusMsg("DELETING"; String:C10($numSelected)+" in the "+Table name:C256($tablePtr)+" table")
End if 

If (Records in selection:C76($tablePtr->)>0)
	DELETE SELECTION:C66($tablePtr->)
	FLUSH CACHE:C297
	$locked:=Records in set:C195("LockedSet")
	If ($locked=0)
		If ($giveMsg)
			utl_Logfile("delete.log"; String:C10($numSelected)+" records deleted from "+Table name:C256($tablePtr))
			zwStatusMsg("DELETED"; String:C10($numSelected)+" in the "+Table name:C256($tablePtr)+" table")
		End if 
	Else 
		BEEP:C151
		If ($giveMsg)
			utl_Logfile("delete.log"; String:C10($numSelected)+" records deleted from "+Table name:C256($tablePtr)+"; "+String:C10($locked)+" locked records in "+Table name:C256($tablePtr))
		End if 
		If (Count parameters:C259=2)
			$keepTrying:=True:C214
			Repeat 
				$locked:=Records in set:C195("LockedSet")
				USE SET:C118("LockedSet")
				LOAD RECORD:C52($tablePtr->)
				$keepTrying:=fLockNLoad($tablePtr)
				DELETE SELECTION:C66($tablePtr->)
			Until ($locked=0) | (Not:C34($keepTrying))
			
		Else 
			If ($giveMsg)
				zwStatusMsg("DELETED"; String:C10($numSelected)+" in the "+Table name:C256($tablePtr)+" table, "+String:C10($locked)+" were locked")
			End if 
		End if 
	End if 
	//
	$0:=$locked
	
Else 
	$0:=-1
End if 