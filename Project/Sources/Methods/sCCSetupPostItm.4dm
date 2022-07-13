//%attributes = {"publishedWeb":true}
//sCCSetupPostItem  mod 1/20/94
//used in the [process_spec];"OperSeqSetup" dialog
//attached to righthand array set, posts item to left hand array set
//when user click upon an item.

C_LONGINT:C283($i; $j)

If (asCC2#0)
	If (asCC#0)  //insert
		$i:=asCC
	Else   //append
		$i:=Size of array:C274(asCC)+1
	End if 
	INSERT IN ARRAY:C227(aiSeq; $i; 1)
	INSERT IN ARRAY:C227(asCC; $i; 1)
	INSERT IN ARRAY:C227(asCCname; $i; 1)
	INSERT IN ARRAY:C227(alRelTemp; $i; 1)
	If (Position:C15("Material"; vSetupWhat)#0)  //arrays are loaded differently to adj for typical lengths
		asCC{$i}:=asCC2{asCC2}
		asCCname{$i}:=asCCName2{asCC2}
	Else 
		asCC{$i}:=asCCName2{asCC2}
		asCCname{$i}:=asCC2{asCC2}
	End if 
	
	alRelTemp{$i}:=-3  //this '-3' indicates that this CC is new to list
	If (iResequence=1)
		For ($j; $i; Size of array:C274(aiSeq))  //only updates sequences of current item to remaining elements of list
			aiSeq{$j}:=10*$j
		End for 
	End if 
	asCC2:=0
End if 