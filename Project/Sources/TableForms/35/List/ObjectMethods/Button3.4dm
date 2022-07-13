BEEP:C151
$numFound:=0
$targetStagingArea:=Request:C163("Which staging area do you wish to Find?"; "fg:vStage-?"; "OK"; "Cancel")
If (ok=1) & (Substring:C12($targetStagingArea; 1; 10)="fg:vStage-")
	CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "beforeDelete")
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]AdjTo:13=$targetStagingArea)
	$numFound:=Records in selection:C76([Finished_Goods_Locations:35])
	If ($numFound>0)
		CLEAR NAMED SELECTION:C333("beforeDelete")
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; >; [Finished_Goods_Locations:35]Bin:38; >; [Finished_Goods_Locations:35]Tier:39; >)
	Else 
		uConfirm("No bins found with [Finished_Goods_Locations]AdjTo set to "+$targetStagingArea; "OK"; "_")
		USE NAMED SELECTION:C332("beforeDelete")
	End if 
	
End if 
SET WINDOW TITLE:C213(String:C10($numFound)+" Staging Bins")