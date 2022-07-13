//%attributes = {}
// Method: Job_getDieIdentifier () -> 
// ----------------------------------------------------
// by: mel: 12/06/04, 10:01:56
// ----------------------------------------------------
// Description:
// return a# if single, the work "combo" otherwise

C_TEXT:C284($1; $0; $jf)

MESSAGES OFF:C175

$0:=""

If (Count parameters:C259=1)
	$jf:=$1
Else 
	$jf:=[Job_Forms:42]JobFormID:5
End if 

If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
	
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jf)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
	QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $aCPN)
	
Else 
	
	QUERY:C277([Finished_Goods:26]; [Job_Forms_Items:44]JobForm:1=$jf)
	
End if   // END 4D Professional Services : January 2019 


If (Records in selection:C76([Finished_Goods:26])>0)
	DISTINCT VALUES:C339([Finished_Goods:26]OutLine_Num:4; $aOutline)
	If (Size of array:C274($aOutline)=1)
		$0:=$aOutline{1}
	Else 
		$0:="combo"
	End if 
	
Else 
	$0:="not found"
End if 