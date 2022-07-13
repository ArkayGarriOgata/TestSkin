//%attributes = {}
// Method: Job_getRepeatOf () -> 
// ----------------------------------------------------
// by: mel: 12/08/04, 16:16:14
// ----------------------------------------------------
// Description:
// find the privious job using a one outline die
//----------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=1)
	$jf:=$1
Else 
	$jf:=[Job_Forms_Master_Schedule:67]JobForm:4
End if 

READ ONLY:C145([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jf)

Case of 
	: (Records in selection:C76([Job_Forms:42])=0)
		//do nothing
		
	: ([Job_Forms:42]OutlineNumber:65="combo")  //do nothing
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		
	: ([Job_Forms:42]OutlineNumber:65="not found")  //do nothing
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		
	Else   //possible repeat
		$die:=[Job_Forms:42]OutlineNumber:65
		$pspec:=[Job_Forms:42]ProcessSpec:46
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]OutlineNumber:65=$die; *)  //same single outline die
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ProcessSpec:46=$pspec; *)  //on a prior job number
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5<$jf)  //on a prior job number
		If (Records in selection:C76([Job_Forms:42])=0)  //try w/o pspec
			$pspec:="?"
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]OutlineNumber:65=$die; *)  //same single outline die
			QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5<$jf)  //on a prior job number
		Else 
			$pspec:=""
		End if 
End case 

If (Records in selection:C76([Job_Forms:42])>0)
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobForm)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	SORT ARRAY:C229($aJobForm; <)
	$0:=$aJobForm{1}+$pspec
Else 
	$0:=""
End if 