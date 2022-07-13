//%attributes = {}
//Method:  Core_HList_Clear(tHListNumber{;bClearAlSublLists})
//Description:  This will clear a Hlist and all the sublists if specified

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tHListNumber)
	C_BOOLEAN:C305($2; $bClearAllSubLists)
	C_POINTER:C301($pnHListNumber)
	
	$tHListNumber:=$1
	$bClearAllSubLists:=True:C214
	
	If (Count parameters:C259=2)
		$bClearAllSubLists:=$2
	End if 
	
	$pnHListNumber:=OBJECT Get pointer:C1124(Object named:K67:5; "CorenHList"+$tHListNumber)
	
End if   //Done Initialize

If ($bClearAllSubLists)
	CLEAR LIST:C377($pnHListNumber->; *)
Else 
	CLEAR LIST:C377($pnHListNumber->)
End if 