//%attributes = {}
// -------
// Method: EDI_CheckForMissingICN   ( ) ->
// By: Mel Bohince @ 02/07/18, 15:33:50
// Description
// look for breaks in sequences, btn on inbox output layout
// ----------------------------------------------------
ARRAY TEXT:C222($missingICNs; 0)

$when:=Request:C163("Check what date_received?"; String:C10(Current date:C33))
dDateBegin:=Date:C102($when)  //!01/31/2018!
dDateEnd:=dDateBegin
QUERY:C277([edi_Inbox:154]; [edi_Inbox:154]Date_Received:9>=dDateBegin; *)
QUERY:C277([edi_Inbox:154];  & ; [edi_Inbox:154]Date_Received:9<=dDateEnd; *)
QUERY:C277([edi_Inbox:154];  & ; [edi_Inbox:154]ICN:4#""; *)
QUERY:C277([edi_Inbox:154];  & ; [edi_Inbox:154]ICN:4#"Log@"; *)
QUERY:C277([edi_Inbox:154];  & ; [edi_Inbox:154]ICN:4#"Rpt@"; *)
QUERY:C277([edi_Inbox:154];  & ; [edi_Inbox:154]ICN:4#"Sess@")
If (Records in selection:C76([edi_Inbox:154])>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([edi_Inbox:154]; [edi_Inbox:154]ICN:4; >)
		$currentICN:=Num:C11([edi_Inbox:154]ICN:4)-1
		While (Not:C34(End selection:C36([edi_Inbox:154])))
			$lastICN:=$currentICN
			$nextExpectedICN:=$currentICN+1
			$currentICN:=Num:C11([edi_Inbox:154]ICN:4)
			If ($currentICN#$nextExpectedICN) & ($currentICN#$lastICN)
				APPEND TO ARRAY:C911($missingICNs; String:C10($nextExpectedICN))
			End if 
			NEXT RECORD:C51([edi_Inbox:154])
			
		End while 
		
	Else 
		
		ARRAY TEXT:C222($_ICN; 0)
		
		SELECTION TO ARRAY:C260([edi_Inbox:154]ICN:4; $_ICN)
		SORT ARRAY:C229($_ICN; >)
		$currentICN:=Num:C11($_ICN{1})-1
		For ($Iter; 1; Size of array:C274($_ICN); 1)
			
			$lastICN:=$currentICN
			$nextExpectedICN:=$currentICN+1
			$currentICN:=Num:C11($_ICN{$Iter})
			If ($currentICN#$nextExpectedICN) & ($currentICN#$lastICN)
				APPEND TO ARRAY:C911($missingICNs; String:C10($nextExpectedICN))
			End if 
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	$numElements:=Size of array:C274($missingICNs)
	If ($numElements>0)
		utl_LogIt("init")
		For ($i; 1; $numElements)
			utl_LogIt($missingICNs{$i})
		End for 
		utl_LogIt("show")
		
	Else 
		uConfirm("ICN series appears to be contiguous."; "Great"; "Help")
	End if 
	
Else 
	uConfirm("No inbox records found for "+$when+"."; "Great"; "Help")
End if 