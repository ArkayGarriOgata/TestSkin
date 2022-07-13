//OM: bShow() -> 
//@author mlb - 9/18/02  15:04
//◊jobform:="80669.01"
<>jobform:=util_getKeyFromListing(->[Job_Forms_Master_Schedule:67]JobForm:4)
C_TEXT:C284($jobform; <>jobform)
$jobform:=Replace string:C233(<>jobform; "."; "")
$target:=$jobform+"@"  // because subforms will be appended, including 00
ARRAY TEXT:C222($aVolumes; 0)
ARRAY TEXT:C222($aDocuments; 0)
VOLUME LIST:C471($aVolumes)
$hit:=Find in array:C230($aVolumes; "Layout Pdf")
If ($hit>-1)
	
	DOCUMENT LIST:C474("Layout Pdf"; $aDocuments)
	$hit:=Find in array:C230($aDocuments; $target)
	If ($hit>-1)
		
		For ($i; 1; Size of array:C274($aDocuments))
			IDLE:C311
			If ($aDocuments{$i}=$target)
				$errCode:=util_Launch_External_App("Layout Pdf:"+$aDocuments{$i})
				IDLE:C311
			End if 
		End for 
		
	Else 
		BEEP:C151
		ALERT:C41("No layout PDF's were found for this, "+$target+", jobform."; "Shucks")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("You must use Finder to mount the 'Layout Pdf' volume on 'HYBINETTE' first."; "I knew that")
End if 