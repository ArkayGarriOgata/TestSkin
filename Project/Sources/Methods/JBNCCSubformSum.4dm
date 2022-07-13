//%attributes = {"publishedWeb":true}
//(p) JBNCCSubFromSum
//Cost center/Subform summary
//print a break down of sheets based on output of CC per Subform
//number used here collected in JBNSubformratio
//$1 - longint - pixels printed so far
//$2 - longint - max pixels that fit
//$3 - longint - number of sheets leaving operation
//retunrs total pixels printed on current page
//• 2/2/98 cs created
//• 2/5/98 cs SWGTA1 is a resued set of string vars

C_LONGINT:C283($i; $ToDo; $Size; $Count; $0; $1; $Pixels; $2; $MaxPixels; $Items; $height)

$Items:=6
$Size:=Size of array:C274(aSubform)
$ToDo:=Int:C8($Size/$Items)
$ToDo:=$ToDo+(Num:C11(($Size%$Items)>0))
$Count:=0
$Pixels:=$1
$MaxPixels:=$2

For ($i; 1; $ToDo)  //each line of subforms (9 at a time)
	For ($j; 1; $Items)  //for each subform element on layout
		$Ptr:=Get pointer:C304("real"+String:C10($j))  //sheet count fields
		$Ptr2:=Get pointer:C304("SWGTA"+String:C10($j))  //subform id fields
		$Count:=$Count+1
		
		If ($Count<=$Size)  //if my index into array is not larger than array
			$Ptr->:=aRatio{$Count}*$3  //get values
			$Ptr2->:=String:C10(aSubform{$Count}; "##0")
		Else   //else set to zero, fields formated to show '-' if zero
			$Ptr->:=0
			$Ptr2->:=""
		End if 
	End for 
	
	If ($Pixels+12+14>$MaxPixels)
		$Pixels:=JBN_PrintHeader("*")
	End if 
	$height:=Print form:C5([Jobs:15]; "JBN_SubForm.h")
	$Pixels:=$Pixels+14
	$height:=Print form:C5([Jobs:15]; "JBN_SubForm.d")
	$Pixels:=$Pixels+12
End for 

$0:=$Pixels