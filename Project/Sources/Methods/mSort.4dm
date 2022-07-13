//%attributes = {"publishedWeb":true}
//(P) mSort: Accesses 4D Adhoc Sorting

If (Records in selection:C76(zDefFilePtr->)=0)
	BEEP:C151
	ALERT:C41("There is no selection to sort!")
Else 
	//uSortRelated 
	SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
	ORDER BY:C49(zDefFilePtr->)
	zSort:=""
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
End if 
<>iLayout:=0