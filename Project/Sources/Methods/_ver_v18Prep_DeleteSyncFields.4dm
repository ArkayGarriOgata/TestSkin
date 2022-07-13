//%attributes = {}
// Method: _ver_v18Prep_DeleteSyncFields ( )
//Description:  This method will delete all the z fields used for 

If (True:C214)  //Initialize
	
	C_TEXT:C284($tStatement; $tTableName)
	C_LONGINT:C283($nTable; $nNumberOfTables)
	
	C_TEXT:C284($tSyncData; $tSyncID)
	
	C_OBJECT:C1216($oProgress)
	
	$nNumberOfTables:=Get last table number:C254
	
	$tSyncData:="_SYNC_DATA"
	$tSyncID:="_SYNC_ID"
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfTables
	$oProgress.tTitle:="Delete Sync Fields"
	
End if   //Done initialize

utl_Logfile("DeleteSyncFields.log"; "Start")

For ($nTable; 1; $nNumberOfTables)  //Tables
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		If (Is table number valid:C999($nTable))  //Valid table
			
			$tTableName:=Table name:C256($nTable)
			
			$oProgress.nLoop:=$nTable
			$oProgress.tMessage:="Updating"+CorektSpace+$tTableName
			
			Prgr_Message($oProgress)
			
			$tStatement:=CorektBlank
			
			$tStatement:=$tStatement+"ALTER TABLE ["+$tTableName+"]"+CorektSpace
			$tStatement:=$tStatement+"DROP COLUMN"+CorektSpace+$tSyncData+CorektComma+CorektSpace+$tSyncID+CorektSemiColon
			
			Begin SQL
				EXECUTE IMMEDIATE :$tStatement;
			End SQL
			
		End if   //Done valid table
		
	Else   //Progress canceled
		
		$nTable:=$nNumberOfTables+1
		
	End if   //Done progress
	
End for   //Done tables

Prgr_Quit($oProgress)

utl_Logfile("DeleteSyncFields.log"; "End")

