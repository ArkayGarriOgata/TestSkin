//%attributes = {}
//Method:  Core_Table_DocumentInfo
//Description:  This method will run thru tables and document information

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bInvisible; $bNew; $bModify; $bDelete; $bLoad)
	
	C_LONGINT:C283($nTable; $nNumberOfTables)
	C_POINTER:C301($pTable)
	
	C_TEXT:C284($tTableInformation; $tTableHeader)
	C_TEXT:C284($tTab)
	
	C_TIME:C306($hDocumentTable)
	
	C_OBJECT:C1216($oAsk)
	$oAsk:=New object:C1471()
	$oAsk.tMessage:="The table information document is created."
	
	$nNumberOfTables:=Get last table number:C254
	$tTableInformation:=CorektBlank
	$tTab:=Char:C90(Tab:K15:37)
	
End if   //Done Initialize

$hDocumentTable:=Create document:C266(CorektBlank)

If (OK=1)  //Document
	
	$tTableHeader:=\
		"Table Number"+$tTab+\
		"Table Name"+$tTab+\
		"Records"+$tTab+\
		"Invisible"+$tTab+\
		"New"+$tTab+\
		"Modify"+$tTab+\
		"Delete"+$tTab+\
		"Load"+CorektCR
	
	SEND PACKET:C103($hDocumentTable; $tTableHeader)
	
	For ($nTable; 1; $nNumberOfTables)  //Table numbers
		
		If (Is table number valid:C999($nTable))  //Valid table number
			
			$pTable:=Table:C252($nTable)
			
			GET TABLE PROPERTIES:C687($pTable; $bInvisible; $bNew; $bModify; $bDelete; $bLoad)
			
			ALL RECORDS:C47($pTable->)
			
			$tTableInformation:=\
				String:C10($nTable)+$tTab+\
				Table name:C256($pTable)+$tTab+\
				String:C10(Records in selection:C76($pTable->))+$tTab+\
				Core_Convert_BooleanT($bInvisible)+$tTab+\
				Core_Convert_BooleanT($bNew)+$tTab+\
				Core_Convert_BooleanT($bModify)+$tTab+\
				Core_Convert_BooleanT($bDelete)+$tTab+\
				Core_Convert_BooleanT($bLoad)+CorektCR
			
			SEND PACKET:C103($hDocumentTable; $tTableInformation)
			
		End if   //Done valid table number
		
	End for   //Done table numbers
	
	CLOSE DOCUMENT:C267($hDocumentTable)
	
	Core_Dialog_Alert($oAsk)
	
End if   //Done Document
