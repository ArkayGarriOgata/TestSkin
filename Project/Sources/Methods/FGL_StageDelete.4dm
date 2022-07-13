//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/06/08, 14:38:53
// ----------------------------------------------------
// Method: FGL_StageDelete
// ----------------------------------------------------

C_LONGINT:C283($numFound)
C_TEXT:C284($targetStagingArea)
C_BOOLEAN:C305($continue)

$continue:=True:C214

Case of 
	: (User in group:C338(Current user:C182; "Physical Inv"))
	: (Current user:C182="Designer")
		
	Else 
		$continue:=False:C215
End case 

If ($continue)
	BEEP:C151
	$targetStagingArea:=Request:C163("Which staging area do you wish to delete?"; "fg:vStage-?"; "OK"; "Cancel")
	If (OK=1) & (Substring:C12($targetStagingArea; 1; 10)="fg:vStage-")
		CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "beforeDelete")
		READ WRITE:C146([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]AdjTo:13=$targetStagingArea)
		$numFound:=Records in selection:C76([Finished_Goods_Locations:35])
		If ($numFound>0)
			SET WINDOW TITLE:C213(String:C10($numFound)+" Deleting Stage "+$targetStagingArea)
			uConfirm("Delete "+String:C10($numFound)+" records from [Finished_Goods_Locations] tagged as "+$targetStagingArea; "Delete"; "Cancel")
			If (OK=1)
				util_DeleteSelection(->[Finished_Goods_Locations:35]; "*")
			End if 
			
		Else 
			uConfirm("No bins found with [Finished_Goods_Locations]AdjTo set to "+$targetStagingArea; "OK"; "_")
		End if 
		USE NAMED SELECTION:C332("beforeDelete")
	End if 
	
End if 