//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/04/11, 16:32:26
// ----------------------------------------------------
// Method: Est_SubformBreakDown
// Description
// see also Est_NumberOfSheetsAssertion, JBNSubformRatio, Job_SubformBreakDown
// ----------------------------------------------------
// Modified by: Mel Bohince (10/12/15) check that subform has uniform net sheets
// Modified by: Mel Bohince (8/1/16) cross check override against subforms, makes a diff in calculation

C_LONGINT:C283($numItems; $numSubforms; $i; $j; $totalSheets)
C_BOOLEAN:C305($continue; $0)

$continue:=True:C214
//query done by Est_FormCostsCalculation
//QUERY([Estimates_FormCartons];[Estimates_FormCartons]DiffFormID=[Estimates_DifferentialsForms]DiffFormId)
//ORDER BY([Estimates_FormCartons];[Estimates_FormCartons]ItemNumber;>)
$numItems:=Records in selection:C76([Estimates_FormCartons:48])
$numSubforms:=0

ARRAY LONGINT:C221($aSF; 0)
ARRAY LONGINT:C221($ayld; 0)
ARRAY LONGINT:C221($aitemUp; 0)
ARRAY LONGINT:C221($aSFnetSheets; 0)
ARRAY LONGINT:C221($ajobitem; 0)
SELECTION TO ARRAY:C260([Estimates_FormCartons:48]SubFormNumber:10; $aSF; [Estimates_FormCartons:48]MakesQty:5; $ayld; [Estimates_FormCartons:48]NumberUp:4; $aitemUp; [Estimates_FormCartons:48]NetSheets:7; $aSFnetSheets; [Estimates_FormCartons:48]ItemNumber:3; $ajobitem)
MULTI SORT ARRAY:C718($aSF; >; $ajobitem; >; $aitemUp; $aSFnetSheets; $ayld)


For ($i; 1; $numItems)  //find the highest subform number
	If ($aSF{$i}>$numSubforms)
		$numSubforms:=$aSF{$i}
	End if 
End for 

If ($numSubforms>0)  //has subforms
	//calc subform totals
	ARRAY LONGINT:C221($aQtyT; $numSubforms)
	ARRAY LONGINT:C221($aUPT; $numSubforms)
	ARRAY LONGINT:C221($aNetT; $numSubforms)
	For ($i; 1; $numItems)
		$subform_number:=$aSF{$i}
		$aQtyT{$subform_number}:=$aQtyT{$subform_number}+$ayld{$i}
		$aUPT{$subform_number}:=$aUPT{$aSF{$i}}+$aitemUp{$i}
		If ($aNetT{$subform_number}=0)
			$aNetT{$subform_number}:=$aSFnetSheets{$i}
		Else 
			If ($aSFnetSheets{$i}#$aNetT{$subform_number})
				Est_LogIt("ERROR "+" ERROR "+" ERROR ")
				Est_LogIt("ERROR "+" ERROR "+" ERROR "+": Net Sheets confused for Subform "+String:C10($subform_number)+" Item: "+String:C10($ajobitem{$i}))
				Est_LogIt("ERROR "+" ERROR "+" ERROR : "+String:C10($aSFnetSheets{$subform_number})+" v "+String:C10($aSFnetSheets{$i}))
				Est_LogIt("ERROR "+" ERROR "+" ERROR ")
				$continue:=False:C215
			End if 
		End if 
	End for 
	//calc sheets
	$totalSheets:=0
	
	For ($j; 1; $numSubforms)
		$sheets:=$aQtyT{$j}/$aUPT{$j}
		$totalSheets:=$totalSheets+$sheets
		
		
		If ([Estimates_DifferentialsForms:47]NumberUpOverrid:30>0)  // Modified by: Mel Bohince (8/1/16) cross check override against subforms, makes a diff in calculation
			If ($aUPT{$j}#[Estimates_DifferentialsForms:47]NumberUpOverrid:30)
				$continue:=False:C215
				Est_LogIt("ERROR "+" ERROR "+" ERROR ")
				Est_LogIt("ERROR "+" ERROR "+" ERROR "+": Number Up Override failure on Subform "+String:C10($j))
				Est_LogIt("ERROR "+" ERROR "+" ERROR : "+String:C10([Estimates_DifferentialsForms:47]NumberUpOverrid:30)+" v "+String:C10($aUPT{$j}))
				Est_LogIt("ERROR "+" ERROR "+" ERROR ")
				BEEP:C151
			End if 
		End if 
		
	End for 
	
	
	If ($totalSheets#[Estimates_DifferentialsForms:47]NumberSheets:4)
		$continue:=False:C215
		Est_LogIt("ERROR "+" ERROR "+" ERROR ")
		Est_LogIt("ERROR "+" ERROR "+" ERROR "+": Net Sheets incorrect for Subform breakdown")
		Est_LogIt("ERROR "+" ERROR "+" ERROR : "+String:C10([Estimates_DifferentialsForms:47]NumberSheets:4)+" v "+String:C10($totalSheets))
		Est_LogIt("ERROR "+" ERROR "+" ERROR ")
		BEEP:C151
	End if 
	
End if   //subforms


$0:=$continue