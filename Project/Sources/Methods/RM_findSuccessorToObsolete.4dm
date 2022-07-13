//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 08/01/13, 14:51:30
// ----------------------------------------------------
// Method: RM_findSuccessorToObsolete -> true if failed to find a suitable replacement
// Description:
// Makes sure the replacement isn't obsolete.
// And that replacement isn't obsolete.
// And that replacement isn't obsolete.........
// $1 = Original obsolete part.
// $0 = Failed, T or F
// [Raw_Materials] is already Read Only.
// ----------------------------------------------------
// Modified by: Mel Bohince (12/10/14) fix circular repeat loop, add $2

C_TEXT:C284($tSuccessor; $1; $originalRM; $2)
C_BOOLEAN:C305($bDone; $0; $failed)

$tSuccessor:=$1
$originalRM:=$2  // Modified by: Mel Bohince (12/10/14) fix circular repeat loop, add $2, fixes alerts and don't double back
$bDone:=False:C215
$failed:=True:C214


Repeat   //chain fwd thru replacemnets
	
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$tSuccessor)  //check the state of the named successor
	If (Records in selection:C76([Raw_Materials:21])=1)
		If ([Raw_Materials:21]Status:25#"Obsolete")  //We're done!
			uConfirm([Job_Forms_Materials:55]Raw_Matl_Code:7+" is Obsolete, will be replaced with "+$tSuccessor+". FIX PSPEC and ESTIMATE!"; "Ok"; "Help")
			[Job_Forms_Materials:55]Raw_Matl_Code:7:=$tSuccessor
			$bDone:=True:C214
			$failed:=False:C215
			
		Else   //the successor to the original is also obsolete, keep digging
			If ([Raw_Materials:21]Successor:34#"") & ([Raw_Materials:21]Successor:34#$originalRM)
				$tSuccessor:=[Raw_Materials:21]Successor:34  //dig deeper
				
			Else 
				uConfirm($originalRM+" is Obsolete and no successor found. You must fix before printing jobbag "+[Job_Forms:42]JobFormID:5; "Ok"; "Help")
				$bDone:=True:C214
				$failed:=True:C214
			End if 
			
		End if 
		
	Else 
		uConfirm($originalRM+" is Obsolete and no successor found. You must fix before printing jobbag "+[Job_Forms:42]JobFormID:5; "Ok"; "Help")
		$bDone:=True:C214
		$failed:=True:C214
	End if 
	
Until ($bDone)



$0:=$failed
