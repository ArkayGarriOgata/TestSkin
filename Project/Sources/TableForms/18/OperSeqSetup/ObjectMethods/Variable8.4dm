C_LONGINT:C283($hit; $last; $i)
$hit:=aiSeq
$last:=Size of array:C274(aiSeq)
If ($hit#0)
	BEEP:C151
	If (Position:C15("Material"; vSetupWhat)=0)
		CONFIRM:C162("Remove Seq#: "+String:C10(aiSeq{$hit}; "000")+" : "+asCC{$hit}+" and it's materials?"; "Remove"; "Cancel")
	Else 
		CONFIRM:C162("Remove Seq#: "+String:C10(aiSeq{$hit}; "000")+" : "+asCC{$hit}+"?"; "Remove"; "Cancel")
	End if 
	
	//CONFIRM("Remove Seq#: "+String(aiSeq{$hit};"000")+" : "+asCC{$hit}+" and its mat
	If (ok=1)
		DELETE FROM ARRAY:C228(aiSeq; $hit; 1)
		DELETE FROM ARRAY:C228(asCC; $hit; 1)
		DELETE FROM ARRAY:C228(asCCname; $hit; 1)
		DELETE FROM ARRAY:C228(alRelTemp; $hit; 1)
		If (iResequence=1)
			If ($hit#$last)
				For ($i; 1; $last-1)
					aiSeq{$i}:=$i*10
				End for 
			End if 
		End if 
		aiSeq:=0
		asCC:=0
		asCCname:=0
		alRelTemp:=0
		//REDRAW
	End if 
Else 
	BEEP:C151
End if 
