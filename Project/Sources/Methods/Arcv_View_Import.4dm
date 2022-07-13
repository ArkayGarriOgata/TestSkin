//%attributes = {}
//Method:  Arcv_View_Import(nTable)
//Desrciption: This method will create records in table

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nTable)
	C_LONGINT:C283($nReStored)
	C_LONGINT:C283($nNumberOfRecords)
	C_LONGINT:C283($nColumn; $nRow)
	
	C_TEXT:C284($tNumberOfRecords; $tRecord)
	C_TEXT:C284($tTableName; $tWasWere)
	
	C_POINTER:C301($pTable)
	
	C_OBJECT:C1216($esRestoreTable)
	C_OBJECT:C1216($eRestore)
	
	C_OBJECT:C1216($oConfirm)
	C_OBJECT:C1216($oStatus)
	C_OBJECT:C1216($oAlert)
	
	$oConfirm:=New object:C1471()
	$oStatus:=New object:C1471()
	$oAlert:=New object:C1471()
	
	$nTable:=Core_Table_GetTableNumberN(Form:C1466.tTableName)
	
	If (Is table number valid:C999($nTable))  //Valid table
		
		$esRestoreTable:=New object:C1471()
		
		$pTable:=Table:C252($nTable)
		$tTableName:=Table name:C256($pTable)
		
		LISTBOX GET CELL POSITION:C971(*; "Arcv_abView_Table"; $nColumn; $nRow)
		
		$esRestoreTable:=ds:C1482.Archive.query("pk_id = :1"; Arcv_atView_Column01{$nRow})
		
		$nNumberOfRecords:=$esRestoreTable.length  //Currently hard coded to just do one record at a time till we get search to work
		
		$tNumberOfRecords:=String:C10($nNumberOfRecords)
		
		$tRecord:=Choose:C955(($nNumberOfRecords=1); "record"; "records")
		
		$oConfirm.tMessage:=\
			"Would you like to restore the"+CorektSpace+\
			$tNumberOfRecords+CorektSpace+\
			$tTableName+CorektSpace+$tRecord+"?"
		
		$oConfirm.tDefault:="Restore"
		
	End if   //Done valid table
	
End if   //Done initialize

Case of   //Restore
		
	: (Not:C34(Is table number valid:C999($nTable)))  //Invalid table
		
		$oAlert.tMessage:="There is no table to restore."
		
		Core_Dialog_Alert($oAlert)
		
	: ($nNumberOfRecords=0)  //No records
		
		$oAlert.tMessage:="There are no records to restore for table"+CorektSpace+\
			Table name:C256($nTable)+CorektPeriod
		
		Core_Dialog_Alert($oAlert)
		
	: (Core_Dialog_ConfirmN($oConfirm)=CoreknNonDefault)  //Cancelled
		
	Else   //Valid
		
		$eRestore:=ds:C1482[$tTableName].new()
		
		$nNumberOfFields:=Size of array:C274(Arcv_atView_Field)
		
		For ($nField; 1; $nNumberOfFields)  //Field
			
			If (Arcv_Field_ValidB($nTable; Arcv_atView_Field{$nField}))  //Valid
				
				OB SET:C1220($eRestore; Arcv_atView_Field{$nField}; Arcv_atView_Value{$nField})
				
			End if   //Done valid
			
		End for   //Done field
		
		$oStatus:=$eRestore.save()
		
		If ($oStatus.success)  //Success
			$nReStored:=$nReStored+1
		End if   //Done success
		
		$tRecord:=Choose:C955($nReStored=1; "record"; "records")
		$tWasWere:=Choose:C955($nReStored=1; "was"; "were")
		
		$oAlert.tMessage:=\
			String:C10($nReStored)+CorektSpace+"of"+CorektSpace+$tNumberOfRecords+CorektSpace+\
			$tRecord+CorektSpace+"for table"+CorektSpace+\
			$tTableName+CorektSpace+\
			$tWasWere+CorektSpace+"restored."
		
		Core_Dialog_Alert($oAlert)
		
End case   //Done restore
