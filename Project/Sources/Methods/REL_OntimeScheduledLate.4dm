//%attributes = {}
// Method: REL_OntimeScheduledLate () -> 
// ----------------------------------------------------
// by: mel: 01/20/04, 13:23:53
// ----------------------------------------------------

C_DATE:C307($1; $2; dDateBegin; dDateEnd; $allowedEarly; $allowedLate)
C_TEXT:C284($3; sCust)
C_TEXT:C284(xTitle; xText; distributionList)
C_TEXT:C284($cr)
C_BOOLEAN:C305($continue)
C_LONGINT:C283($4; $outputStyle; $i; $numCust; $relCursor; $totalNumReleases; $totalNumOnTime; $hit; $percent; $dayOfWeek; $lateCursor)
ARRAY LONGINT:C221($aReleaseNumber; 0)
ARRAY LONGINT:C221($aLateRelease; 0)

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_ReleaseSchedules:46])

$cr:=Char:C90(13)
$continue:=False:C215
$outputStyle:=0  //report, 1=dialog, 2=email
$lateCursor:=0
$continue:=False:C215

CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "beforeSearch")
If (Count parameters:C259=0)
	$continue:=False:C215
	
Else 
	dDateBegin:=$1
	dDateEnd:=$2
	sCust:=$3
	zwStatusMsg("BAD SCHD"; "Promised From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" for Customer Id= "+sCust)
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Promise_Date:32>=dDateBegin; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Promise_Date:32<=dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=sCust)
	
	QUERY SELECTION BY FORMULA:C207([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Promise_Date:32<[Customers_ReleaseSchedules:46]Sched_Date:5)
	
	$continue:=Records in selection:C76([Customers_ReleaseSchedules:46])>0
	
End if 

If ($continue)
	CREATE SET:C116([Customers_ReleaseSchedules:46]; "CurrentSet")
	SET WINDOW TITLE:C213(String:C10(Records in set:C195("CurrentSet"))+" Promised before Schedule Release ")
	CLEAR NAMED SELECTION:C333("beforeSearch")
Else 
	BEEP:C151
	ALERT:C41("No release promised from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" have Schedule dates after their Promise date.")
	USE NAMED SELECTION:C332("beforeSearch")
End if 