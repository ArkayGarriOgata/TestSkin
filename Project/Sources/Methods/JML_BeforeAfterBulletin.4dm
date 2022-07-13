//%attributes = {"publishedWeb":true}
//PM: JML_BeforeAfterBulletin("before" | "after") -> 
//@author mlb - 3/4/02  14:48

If ($1="before")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; aJobform; [Job_Forms_Master_Schedule:67]PressDate:25; aDate; [Job_Forms_Master_Schedule:67]Line:5; aLine)
	SORT ARRAY:C229(aDate; aJobform; aLine; >)
	
Else 
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $jobform; [Job_Forms_Master_Schedule:67]PressDate:25; $aNewDate; [Job_Forms_Master_Schedule:67]Line:5; $aLine)
	SORT ARRAY:C229($aNewDate; $jobform; >)
	
	C_TEXT:C284($cr)
	$cr:=Char:C90(13)
	
	$subject:="Press date changes as of "+TS2String(TSTimeStamp)
	$body:=""
	For ($i; 1; Size of array:C274(aJobform))
		$hit:=Find in array:C230($jobform; aJobform{$i})
		If ($hit>-1)
			If (aDate{$i}#$aNewDate{$hit})
				$body:=$body+aJobform{$i}+" changed from "+String:C10(aDate{$i}; Internal date short:K1:7)+" to "+String:C10($aNewDate{$hit}; Internal date short:K1:7)+" "+aLine{$i}+$cr
			End if 
		Else 
			$body:=$body+aJobform{$i}+" was not found in after set"+$cr
		End if 
	End for 
	
	$body:=$body+$cr
	
	For ($i; 1; Size of array:C274($jobform))
		$hit:=Find in array:C230(aJobform; $jobform{$i})
		If ($hit=-1)
			$body:=$body+$jobform{$i}+" set to "+String:C10($aNewDate{$i}; Internal date short:K1:7)+" "+$aLine{$i}+$cr
		End if 
	End for 
	
	If (Length:C16($body)>5)  //send email    
		$body:=$body
		$from:=Email_WhoAmI
		distributionList:=$from+Char:C90(9)+"mel.bohince@arkay.com"+Char:C90(9)
		EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
		zwStatusMsg("EMail"; "Press Date changes has been sent to "+distributionList)
	End if 
	
	ARRAY TEXT:C222(aJobform; 0)
	ARRAY TEXT:C222(aLine; 0)
	ARRAY DATE:C224(aDate; 0)
	
End if 