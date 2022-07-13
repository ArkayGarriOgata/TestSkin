// -------
// Method: [Job_PlatingMaterialUsage].Input   ( ) ->
// By: Mel Bohince @ 06/01/17, 12:00:38
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (12/10/19) remove cd74 fields

Case of 
	: (Form event code:C388=On Load:K2:1)
		// Added by: Mel Bohince (9/6/19) make reversing entries if changed
		//beforeM1:=[Job_PlatingMaterialUsage]M1O+[Job_PlatingMaterialUsage]M1R  //cd74
		beforeM2:=[Job_PlatingMaterialUsage:175]M2O:8+[Job_PlatingMaterialUsage:175]M2R:9  ///xl
		beforeM3:=[Job_PlatingMaterialUsage:175]M3O:10+[Job_PlatingMaterialUsage:175]M3R:11  //large
		//beforeM4:=[Job_PlatingMaterialUsage]M4O+[Job_PlatingMaterialUsage]M4R  //small
		beforeM5:=[Job_PlatingMaterialUsage:175]M5O:14+[Job_PlatingMaterialUsage:175]M5R:15  //cyrel
		
		If (Is new record:C668([Job_PlatingMaterialUsage:175]))
			OBJECT SET ENABLED:C1123(bValidate; False:C215)
			[Job_PlatingMaterialUsage:175]JobSequence:2:=[ProductionSchedules:110]JobSequence:8
			[Job_PlatingMaterialUsage:175]Operator:3:=<>zResp
			[Job_PlatingMaterialUsage:175]DateEntered:4:=4D_Current_date
			[Job_PlatingMaterialUsage:175]Shift:5:=SF_GetShift(TSTimeStamp)
			[Job_PlatingMaterialUsage:175]CostCenter:17:=[ProductionSchedules:110]CostCenter:1
			
			Lvalue2:=Num:C11([ProductionSchedules:110]PlatesReady:18#!00-00-00!)
			Lvalue7:=Num:C11([ProductionSchedules:110]CyrelsReady:19#!00-00-00!)
			
			GOTO OBJECT:C206([Job_PlatingMaterialUsage:175]M1O:6)
			
		Else 
			OBJECT SET ENABLED:C1123(bValidate; True:C214)
			GOTO OBJECT:C206([Job_PlatingMaterialUsage:175]Comment:16)
		End if 
		
		If ([Job_PlatingMaterialUsage:175]JobSequence:2#[ProductionSchedules:110]JobSequence:8)  //incase set a date fields updated
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=[Job_PlatingMaterialUsage:175]JobSequence:2)
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)  //enable save btn if any entry
		
		C_LONGINT:C283($i; $hasEntry; $tableNum; $fieldNumFirst; $fieldNumLast)
		$hasEntry:=0
		C_POINTER:C301($ptr_formVar)
		$tableNum:=Table:C252(->[Job_PlatingMaterialUsage:175])
		$fieldNumFirst:=Field:C253(->[Job_PlatingMaterialUsage:175]M1O:6)
		$fieldNumLast:=Field:C253(->[Job_PlatingMaterialUsage:175]M5R:15)
		For ($i; $fieldNumFirst; $fieldNumLast)
			$ptr_formVar:=Field:C253($tableNum; $i)
			$hasEntry:=$hasEntry+$ptr_formVar->
		End for 
		If (($hasEntry)>0)
			OBJECT SET ENABLED:C1123(bValidate; True:C214)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		
		If (iMode=2)
			
			//$chgCD74:=[Job_PlatingMaterialUsage]M1O+[Job_PlatingMaterialUsage]M1R-beforeM1
			//If ($chgCD74#0)
			//RMX_PlatesPostCorrection ($chgCD74;"CD74")
			//End if 
			$chgXL:=[Job_PlatingMaterialUsage:175]M2O:8+[Job_PlatingMaterialUsage:175]M2R:9-beforeM2
			If ($chgXL#0)
				RMX_PlatesPostCorrection($chgXL; "XL")
			End if 
			$chgLarge:=[Job_PlatingMaterialUsage:175]M3O:10+[Job_PlatingMaterialUsage:175]M3R:11-beforeM3
			If ($chgLarge#0)
				RMX_PlatesPostCorrection($chgLarge; "Large")
			End if 
			//$chgSmall:=[Job_PlatingMaterialUsage]M4O+[Job_PlatingMaterialUsage]M4R-beforeM4
			//If ($chgSmall#0)
			//RMX_PlatesPostCorrection ($chgSmall;"Small")
			//End if 
			$chgCyrel:=[Job_PlatingMaterialUsage:175]M5O:14+[Job_PlatingMaterialUsage:175]M5R:15-beforeM5
			If ($chgCyrel#0)
				RMX_PlatesPostCorrection($chgCyrel; "Cyrel")
			End if 
		End if 
End case 
