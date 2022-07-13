//%attributes = {"publishedWeb":true}
//(p) uVerifyJobStart
//$1 - string - Jobform ID
//insure that jobform startdate has been set
//• 8/4/98 cs created
//• 8/24/98 cs fixed field reference for date assignment
//•121498  Systems G3  don't use current date, misses back dated trns
C_TEXT:C284($1; $JobForm)
C_BOOLEAN:C305($ReadOnly; $success; $0)
$success:=False:C215

C_DATE:C307($2; $xdate)
If (Count parameters:C259=2)  //•121498  Systems G3  don't use current date, misses back dated trns
	$xdate:=$2
Else 
	$xdate:=4D_Current_date
End if 
$JobForm:=$1

If ([Job_Forms:42]JobFormID:5#$JobForm)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$JobForm)
End if 

If ([Job_Forms:42]StartDate:10=!00-00-00!)  //date not set
	If (Read only state:C362([Job_Forms:42]))
		UNLOAD RECORD:C212([Job_Forms:42])
		READ WRITE:C146([Job_Forms:42])
		LOAD RECORD:C52([Job_Forms:42])
		$ReadOnly:=True:C214
	End if 
	//fLockNLoad (->[JobForm])
	If (Not:C34(Locked:C147([Job_Forms:42])))
		// Modified by: Mel Bohince (2/23/16) don't set jobform to Wip or start date and set stock rec'd if appropriate
		//If ([Job_Forms]Status="Released")
		//[Job_Forms]Status:="WIP"
		[Job_Forms:42]StartDate:10:=$xdate
		SAVE RECORD:C53([Job_Forms:42])
		
		$success:=True:C214
		//End if 
	End if 
	
	If ($ReadOnly)
		UNLOAD RECORD:C212([Job_Forms:42])
		READ ONLY:C145([Job_Forms:42])
	End if 
	
Else   //already set
	$success:=True:C214
End if 

$0:=$success  //