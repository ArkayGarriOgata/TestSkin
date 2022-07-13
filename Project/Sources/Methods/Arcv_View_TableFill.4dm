//%attributes = {}
//Method:  Arcv_View_TableFill(nTableNumber;esRecords)
//Description:  This method fills the arrays to display in the listbox

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nTableNumber)
	C_OBJECT:C1216($2; $esRecords)
	
	C_COLLECTION:C1488($cTableNumber)
	C_COLLECTION:C1488($cColumn)
	
	C_LONGINT:C283($nColumn)
	
	C_TEXT:C284($tColumn; $tColumnName; $tFieldName)
	C_TEXT:C284($tHeaderName; $tObject)
	C_TEXT:C284($tValue)
	
	C_OBJECT:C1216($enTableSetting)
	C_OBJECT:C1216($oRecordRow)
	
	C_OBJECT:C1216($oProgress)
	
	C_LONGINT:C283($nRow; $nNumberOfRows)
	
	ARRAY TEXT:C222($atColumn; 0)
	
	$esRecords:=New object:C1471()
	
	$nTableNumber:=$1
	$esRecords:=$2
	
	$nColumn:=0
	
	$enTableSetting:=New object:C1471()
	
	$oRecordRow:=New object:C1471()
	
	$nRow:=0
	
End if   //Done initialize

If (Is table number valid:C999($nTableNumber))  // Invalid table
	
	Core_ListBox_Clear(->Arcv_abView_Table)
	
	Compiler_Arcv_Array(Current method name:C684; 0)
	
	$enTableSetting:=ds:C1482.Arcv_Table.query("TableProperty.nTableNumber==:1"; $nTableNumber).first()  //Get columns
	
	For each ($tFieldName; $enTableSetting.TableProperty.cFieldName)  //Column
		
		$nColumn:=$nColumn+1
		$tColumn:=String:C10($nColumn; "00")
		
		$patColumn:=Get pointer:C304("Arcv_atView_Column"+$tColumn)
		
		$tColumnName:="Arcv_nView_Column"+$tColumn
		$pnColumnVariable:=Get pointer:C304($tColumnName)
		
		$tHeaderName:="Arcv_nView_Header"+$tColumn
		$pnHeaderVariable:=Get pointer:C304($tHeaderName)
		
		APPEND TO ARRAY:C911($atColumn; $tFieldName)
		
		LISTBOX INSERT COLUMN:C829(*; "Arcv_abView_Table"; $nColumn; $tColumnName; $patColumn->; $tHeaderName; $pnHeaderVariable->)
		
		OBJECT SET TITLE:C194($pnHeaderVariable->; $tFieldName)  //Must follow LISTBOX INSERT COLUMN
		
	End for each   //Done column
	
	$nNumberOfColumns:=Size of array:C274($atColumn)
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	
	$oProgress.tTitle:="Loading Row"
	$nNumberOfRows:=$esRecords.length
	$oProgress.nNumberOfLoops:=$nNumberOfRows
	
	For each ($oRecordRow; $esRecords.RecordRow) While ($nRow<$nNumberOfRows)  //Row
		
		If (Prgr_ContinueB($oProgress))  //Progress
			
			$nRow:=$nRow+1
			$oProgress.nLoop:=$nRow
			$oProgress.tMessage:="Loading Rows"
			
			Prgr_Message($oProgress)
			
			For ($nColumn; 1; $nNumberOfColumns)  //Column
				
				$tColumn:=String:C10($nColumn; "00")
				
				$patColumn:=Get pointer:C304("Arcv_atView_Column"+$tColumn)
				
				APPEND TO ARRAY:C911($patColumn->; OB Get:C1224($oRecordRow; $atColumn{$nColumn}; Is text:K8:3))
				
			End for   //Done column
			
		Else   //Progress cancelled
			
			$nRow:=$nNumberOfRows+1
			
		End if   //Done progress
		
	End for each   //Done row
	
	Prgr_Quit($oProgress)
	
End if   //Done valid table
