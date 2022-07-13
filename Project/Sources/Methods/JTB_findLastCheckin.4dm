//%attributes = {}
// Method: JTB_findLastCheckin   (jobformid:text) -> whereWasLastCheckin : text
// By: Mel Bohince @ 04/12/21, 11:58:31
// Description
// return where the job bag (physical) has been checked-in
// ----------------------------------------------------
//Modified by: MelvinBohince(6/2/22)
//v19 rewrite, cache location in a process
//.  collection to minimize the server calls
//.  as this is called in an output list
//.  during on-display-detail on the JobMaster output form
//   to indicate last person to scan the jobbag
//.   return immediately if invalid usage
//    return"?"if not found



var $jobFormToFind; $1; $0 : Text
var jobBagLocationCache_c; $jtbFound_c : Collection

If (Count parameters:C259=1)  //guarding required argument
	$jobFormToFind:=$1
	
Else   //arg required
	return "jobform required"  //bail v19
	//if testing:
	//$jobFormToFind:="17564.05"  //also change 'return' to '$return:=' so you can trace
	//$jobFormToFind:="17564.15"  //will not find this job
	//$jobFormToFind:="00000000"  //invalid jobform
	//$jobFormToFind:="00000.0"  //invalid jobform
End if 

If (Length:C16($jobFormToFind)#8) | (Position:C15("."; $jobFormToFind)=0)  //guarding bad argument
	return "invalid jobform"  //bail v19
End if 

If (jobBagLocationCache_c=Null:C1517)  //load a local copy of the job bag locations in this process
	jobBagLocationCache_c:=ds:C1482.JTB_Job_Transfer_Bags.query("Location # :1"; "").toCollection("Jobform, Location")
End if 

$jtbFound_c:=jobBagLocationCache_c.query("Jobform=:1"; $jobFormToFind)  //search in the local cache

$0:=($jtbFound_c.length>0) ? $jtbFound_c[0].Location : " ¯\\_(ツ)_/¯"  //Ternary operator in v19

If (Count parameters:C259=0)  //in testing mode, otherwise bailed earlier
	ASSERT:C1129($return="Luis")
End if 
