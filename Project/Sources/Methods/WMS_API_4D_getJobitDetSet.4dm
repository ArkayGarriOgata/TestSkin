//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getJobitDetSet - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fProceed)
C_TEXT:C284($1; $ttCommando; $ttHoldCutSel; $ttSelectionSetName)
$ttCommando:=$1
$fProceed:=False:C215

$ttSelectionSetName:="Job_Forms_Items"
$ttHoldCutSel:="holdNamedSelectionBefore"

Case of 
	: ($ttCommando="check")
		$fProceed:=(Records in set:C195($ttSelectionSetName)>0)
		$0:=$fProceed
		
	: ($ttCommando="get")
		
		UNLOAD RECORD:C212([Job_Forms_Items:44])
		CUT NAMED SELECTION:C334([Job_Forms_Items:44]; $ttHoldCutSel)
		USE SET:C118($ttSelectionSetName)
		
		
	: ($ttCommando="clear")
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			READ ONLY:C145([Job_Forms_Items:44])
			USE NAMED SELECTION:C332($ttHoldCutSel)
			
		Else 
			
			READ ONLY:C145([Job_Forms_Items:44])
			USE NAMED SELECTION:C332($ttHoldCutSel)
			
		End if   // END 4D Professional Services : January 2019 
		
End case 