//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/20/13, 12:33:39
// ----------------------------------------------------
// Method: JOB_CheckHRD
// Description:
// Makes sure that all [Job_Forms_Items] have a HRD.
// Uses the current selection of [Job_Forms_Items].
// ----------------------------------------------------



C_LONGINT:C283($i)
ARRAY DATE:C224($adMAD; 0)
C_DATE:C307($0)
$0:=!00-00-00!

DISTINCT VALUES:C339([Job_Forms_Items:44]MAD:37; $adMAD)
If (Size of array:C274($adMAD)>0)  // Modified by: Mel Bohince (9/8/14) add some protection
	
	SORT ARRAY:C229($adMAD; <)  //The valid date will always be at the beginning of the array.
	//If ($adMAD{1}=!00/00/0000!)  //None of the items have the HRD set. Ask for it. // Modified by: Mel Bohince (9/8/14) WTF!
	//$adMAD{1}:=Date(Request("Please enter the HRD for the Items."))
	//End if 
	
	If ($adMAD{1}>!00-00-00!)  // Modified by: Mel Bohince (9/8/14) only due if some date
		$0:=$adMAD{1}  // Modified by: Mel Bohince (9/8/14) rtn a date incase new items are added
		For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
			GOTO SELECTED RECORD:C245([Job_Forms_Items:44]; $i)
			If ([Job_Forms_Items:44]MAD:37=!00-00-00!)
				[Job_Forms_Items:44]MAD:37:=$adMAD{1}
				SAVE RECORD:C53([Job_Forms_Items:44])
			End if 
		End for 
		
	End if   //date found
End if   //array has size
