//%attributes = {"publishedWeb":true}
//PM: JML_get1stItemMAD($jobform) -> 
//@author mlb - 4/17/02  14:40

C_BOOLEAN:C305($stateChanged)
C_TEXT:C284($1)
C_DATE:C307($0)

If (Not:C34(Read only state:C362([Job_Forms_Items:44])))
	READ ONLY:C145([Job_Forms_Items:44])
	$stateChanged:=True:C214
Else 
	$stateChanged:=False:C215
End if 

$0:=!00-00-00!
//zwStatusMsg ("1stMAD";$1)
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37#!00-00-00!)

If (Records in selection:C76([Job_Forms_Items:44])>0)
	ARRAY DATE:C224($aDate; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]MAD:37; $aDate)
	SORT ARRAY:C229($aDate; >)
	$0:=$aDate{1}
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
End if   //jmi  

If ($stateChanged)
	READ WRITE:C146([Job_Forms_Items:44])
End if 