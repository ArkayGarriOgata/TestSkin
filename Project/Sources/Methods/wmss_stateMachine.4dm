//%attributes = {}

// Method: wmss_stateMachine ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/11/15, 09:30:02
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

$priorPrompt:=rft_prompt
rft_error_log:=""
$success:=False:C215
zwStatusMsg("BUILD SKID"; "Last scan: "+rft_response)

Case of 
	: (rft_response="DONE")  //A way to bail
		CANCEL:C270
		
	: (rft_state="CASE")
		$success:=wmss_scannedCase
		
	: (rft_state="SKID")
		$success:=wmss_scannedSSCC
		If ($success)  // & (False)
			$success:=wms_SkidAlreadyUsed  //check if that skid is already in inventory
		End if 
		
	Else   //wtf
		wmss_init("That was weird...\rScan the next skid.")
End case 


// Set up for next scan,
// display errors if present and scroll list box if some items
If (Not:C34($success))
	rft_prompt:=$priorPrompt
End if 

SET WINDOW TITLE:C213(rft_state)
If (rft_state="CASE")
	$scans:=Size of array:C274(ListBox1)
	If (scan_number<=$scans) & ($scans>2)
		OBJECT SET SCROLL POSITION:C906(ListBox1; scan_number)
	End if 
End if 

If (Length:C16(rft_error_log)>0)
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215; Black:K11:16; Yellow:K11:2)
	BEEP:C151
	
Else 
	SetObjectProperties(""; ->rft_error_log; False:C215)
End if 

rft_response:=""
GOTO OBJECT:C206(rft_response)