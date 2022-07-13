//OM: bShow() -> 
//@author mlb - 9/18/02  15:04
//◊jobform:="80669.01"
If (app_LoadIncludedSelection("init"; ->[Finished_Goods:26]ProductCode:1)>0)
	$target:=[Finished_Goods:26]ProductCode:1+".pdf"  // because subforms will be appended, including 00
	ARRAY TEXT:C222($aVolumes; 0)
	ARRAY TEXT:C222($aDocuments; 0)
	VOLUME LIST:C471($aVolumes)
	$hit:=Find in array:C230($aVolumes; "PDF")
	If ($hit>-1)
		
		DOCUMENT LIST:C474("PDF"; $aDocuments)
		$hit:=Find in array:C230($aDocuments; $target)
		If ($hit>-1)
			
			For ($i; 1; Size of array:C274($aDocuments))
				IDLE:C311
				If ($aDocuments{$i}=$target)
					$errCode:=util_Launch_External_App("PDF:"+$aDocuments{$i})
					IDLE:C311
				End if 
			End for 
			
		Else 
			BEEP:C151
			ALERT:C41("No Item PDF's were found for this, "+$target+", product code."; "Shucks")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("You must use Connect To Server in the Finder's Go menu to mount the PDF volume on"+" 'HYBINETTE' first."; "I knew that")
	End if 
	
	app_LoadIncludedSelection("clear"; ->[Finished_Goods:26]ProductCode:1)
End if 