//If (Length([SerializedShippingLabels]LotNumber)=13)
//$lot:=Substring([SerializedShippingLabels]LotNumber;1;4)+Substring([SerializedShippingLabels]LotNumber;7;3)+Substring([SerializedShippingLabels]LotNumber;13;1)
//Else 
$lot:=[WMS_SerializedShippingLabels:96]LotNumber:6
//End if 
//t2:=fBarCode128mix ("10"+$lot;"90NONE")
//46474637 = NONE
//$lot:="3348"  `AP
//If (Substring([SerializedShippingLabels]LotNumber;3;2)="RV")
//$lot:=$lot+"5054"  `RV
//Else 
//$lot:=$lot+"4046"  `HN
//End if 
//$lot:=$lot+Substring([SerializedShippingLabels]LotNumber;5;9)+"0"
//t2:=BarCode_128B ("10"+$lot;"90NONE")
// Modified by: Mel Bohince (1/7/20) add a space between 90 and NONE so length doesn't memic a case_id length on scanner
// Modified by: Mel Bohince (1/29/20) undo the above, scanner should be ignoring non-numeric anyway
$human:="10"+$lot+Char:C90(util_ConvertAscii(202))+"90NONE"
$chkMod10:=fBarCodeMod10Digit($human)
t2:=fBarCodeSym(129; $human)  //+$chkMod10)