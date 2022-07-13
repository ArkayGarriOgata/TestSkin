//%attributes = {"publishedWeb":true}
//fGetLeafText
C_TEXT:C284($0)
C_LONGINT:C283($i; $numRecs)
If (Length:C16([Estimates_Carton_Specs:19]Leaf_Information:77)>0)
	$0:=" "+[Estimates_Carton_Specs:19]Leaf_Information:77+"; "
Else 
	$0:=" No Leaf; "
End if 

//ALL SUBRECORDS([Estimates_Carton_Specs]notused_LeafInformation)
//$numRecs:=Records in subselection([Estimates_Carton_Specs]notused_LeafInformation)
//If ($numRecs=0)
//$0:=" No Leaf; "
//Else 
//$0:=" Leaf: "
//ORDER SUBRECORDS BY([Estimates_Carton_Specs]notused_LeafInformation;;>)
//FIRST SUBRECORD([Estimates_Carton_Specs]notused_LeafInformation)
//For ($i;1;$numRecs)
//$0:=$0++" panel has "
//$0:=$0+String()+" by "+String()+" inches of "
//$0:=$0++"; "
//NEXT SUBRECORD([Estimates_Carton_Specs]notused_LeafInformation)
//End for 
//End if 
//