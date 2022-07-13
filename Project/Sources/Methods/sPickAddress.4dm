//%attributes = {"publishedWeb":true}
//Procedure: sPickAddress(»array;»field)  011896  MLB
//allow pick of billto shipto for list instead of arrows
// Modified by: Mel Bohince (5/18/20) change [zz_control];"ChooseLocation" to List Box

C_POINTER:C301($1; $theArray)  //$1= "»aBilltos" | "»aShiptos"
$theArray:=$1
C_POINTER:C301($2; $theField)  //$2=field pointer
$theField:=$2
COPY ARRAY:C226($theArray->; asState)
ARRAY TEXT:C222(asCity; Size of array:C274(asState))
For ($i; 1; Size of array:C274(asState))
	//asCity{$i}:=Replace string(fGetAddressText (asState{$i});Char(13);"•")
	asCity{$i}:=fGetAddressText(asState{$i})
End for 
sDlogTitle:="Pick an address"
OpenSheetWindow(->[zz_control:1]; "ChooseLocation")
DIALOG:C40([zz_control:1]; "ChooseLocation")
If (ok=1)
	$hit:=Find in array:C230(addressListBox; True:C214)
	$theField->:=asState{$hit}
End if 
CLOSE WINDOW:C154