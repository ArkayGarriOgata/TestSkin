//%attributes = {"publishedWeb":true}
//PM: JML_EmailMissedClosing() -> 
//@author mlb - 3/4/02  15:58
// • mel (1/12/05, 09:03:05) stop emailing to salesmen

C_TEXT:C284($1; $ccList)

If (Count parameters:C259=1)
	$ccList:=$1
Else 
	$ccList:="mel.bohince@arkay.com,"
End if 

READ ONLY:C145([Customers:16])
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Salesman:1="")
For ($i; 1; Records in selection:C76([Job_Forms_Master_Schedule:67]))
	QUERY:C277([Customers:16]; [Customers:16]Name:2=[Job_Forms_Master_Schedule:67]Customer:2)
	If (Records in selection:C76([Customers:16])>0)
		[Job_Forms_Master_Schedule:67]Salesman:1:=[Customers:16]SalesmanID:3
		REDUCE SELECTION:C351([Customers:16]; 0)
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
	End if 
	NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
End for 

$lead:=4D_Current_date
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42#!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42<=$lead; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!)
ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Salesman:1; >; [Job_Forms_Master_Schedule:67]Line:5; >; [Job_Forms_Master_Schedule:67]JobForm:4; >)
SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJF; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]Salesman:1; $aRep; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42; $aDeadLine)

If (Size of array:C274($aJF)>0)
	C_TEXT:C284($t; $cr)
	$cr:=Char:C90(13)
	$t:=Char:C90(9)
	READ ONLY:C145([Users:5])
	$subject:="Missed Closing Dates"
	$currentRep:=$aRep{1}
	$body:="The following jobs will lose their press "+"date unless Closing Date is met."
	$body:=$body+"  Please contact your customers today."+$cr
	For ($i; 1; Size of array:C274($aJF))
		If ($currentRep#$aRep{$i})
			//send
			$body:=$body
			distributionList:=""
			QUERY:C277([Users:5]; [Users:5]Initials:1=$currentRep)  //• mlb - 2/21/02  11:34
			If (Records in selection:C76([Users:5])>0)
				distributionList:=distributionList+Email_WhoAmI([Users:5]UserName:11)+$t
			End if 
			//•••••••distributionList:=distributionList+$ccList
			distributionList:=$ccList
			EMAIL_Sender($subject; ""; $body; distributionList; "")
			zwStatusMsg("EMail"; "Missed Closing Dates "+distributionList)
			
			//init
			$currentRep:=$aRep{$i}
			$body:="The following jobs will lose their press "+"date unless needed approvals/art/specs are submitted"
			$body:=$body+" at least a week before press.  Please contact your customers today."+$cr
			$body:=$body+"JOBFORM "+" "+"CLOSING ON"+" "+"LINE"+$cr
		End if 
		$body:=$body+$aJF{$i}+" "+String:C10($aDeadLine{$i}; Internal date short:K1:7)+" "+$aLine{$i}+$cr
	End for 
	//send
	$body:=$body
	distributionList:=""
	QUERY:C277([Users:5]; [Users:5]Initials:1=$currentRep)  //• mlb - 2/21/02  11:34
	If (Records in selection:C76([Users:5])>0)
		distributionList:=distributionList+Email_WhoAmI([Users:5]UserName:11)+$t
	End if 
	
	//•••••••distributionList:=distributionList+$ccList
	distributionList:=$ccList
	EMAIL_Sender($subject; ""; $body; distributionList; "")
	zwStatusMsg("EMail"; "Missed Closing Dates "+distributionList)
	
End if 