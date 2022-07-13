//%attributes = {"publishedWeb":true}
//gFindPOItem: Find Item Number for selected Purchase Order
//rtn record number to use
//• 6/12/97 cs  remove if(false) and commented out code
//• 6/11/98 cs removed unused code
//•082499  mlb  make sure theres not a skip in sequence

C_TEXT:C284($0)
C_LONGINT:C283($count; $highitem)

SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]ItemNo:3; $aItemNum)
$count:=Size of array:C274($aItemNum)
If ($count>0)
	SORT ARRAY:C229($aItemNum; <)
	$highitem:=Num:C11($aItemNum{1})
End if 

If ($highitem<=$count)
	$0:=String:C10($count; "00")
Else 
	$0:=String:C10($highitem; "00")
End if 