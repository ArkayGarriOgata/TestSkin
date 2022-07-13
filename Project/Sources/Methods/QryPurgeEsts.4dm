//%attributes = {"publishedWeb":true}
//Procedure: QryPurgeEsts($chkBoxPtr;$daysPtr;$countPtr;$status)  062795  MLB
//•062795  MLB  UPR 1507
//• 11/6/97 cs show actual date this relates to
//• 12/19/97 cs insure that if a checkbox is tuurned on then off that the set is c

C_POINTER:C301($1; $chkBoxPtr; $2; $daysPtr; $3; $countPtr)
C_TEXT:C284($4; $status)
C_LONGINT:C283($priorCnt)

$chkBoxPtr:=$1
$daysPtr:=$2
$countPtr:=$3
$priorCnt:=$countPtr->
$status:=$4

NewWindow(300; 25; 0; -720)
MESSAGE:C88(" Locating Estimates with status - "+$Status)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CREATE EMPTY SET:C140([Estimates:17]; $status)
	
Else 
	//you create it after
	
End if   // END 4D Professional Services : January 2019 query selection

If ($chkBoxPtr->=1)
	If ($status#"blank")
		QUERY:C277([Estimates:17]; [Estimates:17]Status:30=$status+"@"; *)
	Else 
		QUERY:C277([Estimates:17]; [Estimates:17]Status:30=""; *)
	End if 
	QUERY:C277([Estimates:17];  & ; [Estimates:17]DateOriginated:19<(4D_Current_date-$daysPtr->))
	CREATE SET:C116([Estimates:17]; $status)
	//Else `•050296  MLB  always create the set
	//CREATE EMPTY SET([ESTIMATE];$status)
	
	If (Records in set:C195($status)=0)
		MESSAGE:C88(Char:C90(13)+$status+" set is empty•••••")
	End if 
Else 
	CREATE EMPTY SET:C140([Estimates:17]; $Status)  //• 12/19/97 cs insure that if the check box is turned off the set is cleared
End if 
$countPtr->:=Records in set:C195($status)
r56:=r56+($countPtr->-$priorCnt)

If ($DaysPtr->>0)  //• 11/6/97 cs display calendar date
	dAsOf:=4D_Current_date-$DaysPtr->
Else 
	dAsOf:=!00-00-00!
End if 

CLOSE WINDOW:C154