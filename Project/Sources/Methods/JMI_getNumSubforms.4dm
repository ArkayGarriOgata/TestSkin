//%attributes = {"publishedWeb":true}
//PM: JMI_getNumSubforms() -> 
//@author mlb - 3/25/02  12:13

C_LONGINT:C283($i; $numItems; $j; $numSubforms; $0)

$jobForm:=$1

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobForm)
$numItems:=Records in selection:C76([Job_Forms_Items:44])
$numSubforms:=0
SELECTION TO ARRAY:C260([Job_Forms_Items:44]SubFormNumber:32; $aSF)
For ($i; 1; $numItems)
	If ($aSF{$i}>$numSubforms)
		$numSubforms:=$aSF{$i}
	End if 
End for 

$0:=$numSubforms