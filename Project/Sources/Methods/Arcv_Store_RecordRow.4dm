//%attributes = {}
//Method:  Arcv_Store_RecordRow({nTable})
//Description:  This method will store a selection of records to [Archive]
// and store the information into the object field [Archive]RecordRow

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bStoppeByProgress)
	
	C_LONGINT:C283($nTable)
	C_LONGINT:C283($nArchived)
	C_LONGINT:C283($nNumberOfRecords)
	
	C_TEXT:C284($tNumberOfRecords; $tRecord)
	C_TEXT:C284($tTableName; $tWasWere)
	
	C_POINTER:C301($pTable)
	
	C_OBJECT:C1216($esStoreTable)
	C_OBJECT:C1216($eStoreRow)
	C_OBJECT:C1216($eArchive)
	
	C_OBJECT:C1216($oConfirm)
	C_OBJECT:C1216($oStatus)
	C_OBJECT:C1216($oAlert)
	C_OBJECT:C1216($oProgress)
	
	If (Count parameters:C259>=1)
		
		$nTable:=$1
		
	Else 
		
		$nTable:=Core_Application_GetTableN
		
	End if 
	
	If (Is table number valid:C999($nTable))  //Valid table
		
		$esStoreTable:=New object:C1471()
		$eStoreRow:=New object:C1471()
		
		$oConfirm:=New object:C1471()
		$oAlert:=New object:C1471()
		
		$oProgress:=New object:C1471()
		
		$pTable:=Table:C252($nTable)
		
		$tTableName:=Table name:C256($pTable)
		
		$nNumberOfRecords:=Records in selection:C76($pTable->)
		
		$tNumberOfRecords:=String:C10($nNumberOfRecords)
		
		$tRecord:=Choose:C955(($nNumberOfRecords=1); "record"; "records")
		
		$oConfirm.tMessage:=\
			"Would you like to archive the"+CorektSpace+\
			$tNumberOfRecords+CorektSpace+\
			$tTableName+CorektSpace+$tRecord+"?"
		
		$oConfirm.tDefault:="Archive"
		
		$oProgress.nLoop:=0
		$oProgress.nProgressID:=Prgr_NewN
		$oProgress.nNumberOfLoops:=$nNumberOfRecords
		$oProgress.tTitle:="Archiving"+CorektSpace+$tTableName
		
	End if   //Done valid table
	
End if   //Done initialize

Case of   //Archive
		
	: (Not:C34(Is table number valid:C999($nTable)))  //Invalid table
		
		$oAlert.tMessage:="There is no table to archive."
		
		Core_Dialog_Alert($oAlert)
		
	: ($nNumberOfRecords=0)  //No records
		
		$oAlert.tMessage:="There are no records to archive for table"+CorektSpace+\
			Table name:C256($nTable)+CorektPeriod
		
		Core_Dialog_Alert($oAlert)
		
	: (Core_Dialog_ConfirmN($oConfirm)=CoreknDefault)  //Archive
		
		$esStoreTable:=Create entity selection:C1512($pTable->)
		
		For each ($eStoreRow; $esStoreTable) While (Prgr_ContinueB($oProgress))  //Store record
			
			$oProgress.nLoop:=$oProgress.nLoop+1
			$oProgress.tMessage:="Archiving records..."
			
			Prgr_Message($oProgress)
			
			$eArchive:=ds:C1482.Archive.new()
			
			$eArchive.RecordRow:=$eStoreRow.toObject()
			$eArchive.Archive_Key:=$eStoreRow.pk_id
			$eArchive.TableNumber:=$nTable
			
			$oStatus:=$eArchive.save()
			
			If ($oStatus.success)  //Success
				$nArchived:=$nArchived+1
			End if   //Done success
			
		End for each   //Done store record
		
		Prgr_Quit($oProgress)
		
		$tRecord:=Choose:C955($nArchived=1; "record"; "records")
		$tWasWere:=Choose:C955($nArchived=1; "was"; "were")
		
		$oAlert.tMessage:=\
			String:C10($nArchived)+CorektSpace+"of"+CorektSpace+$tNumberOfRecords+CorektSpace+\
			$tRecord+CorektSpace+"for table"+CorektSpace+\
			$tTableName+CorektSpace+\
			$tWasWere+CorektSpace+"archived."
		
		Core_Dialog_Alert($oAlert)
		
End case   //Done archive
