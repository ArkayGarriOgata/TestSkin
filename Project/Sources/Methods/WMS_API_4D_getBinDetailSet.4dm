//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getBinDetailSet - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fProceed)
C_TEXT:C284($1; $ttCommando; $ttHoldCutSel; $ttSelectionSetName)
$ttCommando:=$1
$fProceed:=False:C215

$ttSelectionSetName:="clickedIncludeRecordFinished_Goods_Locations"
$ttHoldCutSel:="holdNamedSelectionBefore"

Case of 
	: ($ttCommando="check")
		$fProceed:=(Records in set:C195($ttSelectionSetName)>0)
		$0:=$fProceed
		
	: ($ttCommando="get")
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; $ttHoldCutSel)
		USE SET:C118($ttSelectionSetName)
		
		
	: ($ttCommando="clear")
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Finished_Goods_Locations:35])
			READ ONLY:C145([Finished_Goods_Locations:35])
			USE NAMED SELECTION:C332($ttHoldCutSel)
		Else 
			
			READ ONLY:C145([Finished_Goods_Locations:35])
			USE NAMED SELECTION:C332($ttHoldCutSel)
		End if   // END 4D Professional Services : January 2019 
		
		
End case 