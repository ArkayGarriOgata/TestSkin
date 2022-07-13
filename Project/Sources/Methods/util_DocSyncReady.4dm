//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/31/07, 20:57:47
// ----------------------------------------------------
// Method: util_DocSyncReady()  --> 
// Description
// 
//
// ----------------------------------------------------

// ----------------------------------------------------

C_LONGINT:C283($numFiles; $i; $j; $fieldAttrTy; $fieldLength)  //wDocStructure(void)      
C_LONGINT:C283($relatedFile; $relField; $atts)
C_BOOLEAN:C305($isIndexed)
ARRAY TEXT:C222($aTypeList; 30)
ARRAY INTEGER:C220($aTypeLength; 30)
$aTypeList{0}:="Alpha"
$aTypeLength{0}:=0
$aTypeList{1}:="Real"
$aTypeLength{1}:=10
$aTypeList{2}:="Text"
$aTypeLength{2}:=128
$aTypeList{3}:="Picture"
$aTypeLength{3}:=128
$aTypeList{4}:="Date"
$aTypeLength{4}:=6
$aTypeList{6}:="Boolean"
$aTypeLength{6}:=2
$aTypeList{7}:="Subtable"
$aTypeLength{7}:=128
$aTypeList{8}:="Integer"
$aTypeLength{8}:=2
$aTypeList{9}:="Longint"
$aTypeLength{9}:=4
$aTypeList{11}:="Time"
$aTypeLength{11}:=4
$aTypeList{30}:="BLOB"
$aTypeLength{30}:=512

C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284($choices)


utl_LogIt("init")
utl_Logfile("sync-test.log"; "START")
$numFiles:=Get last table number:C254
For ($i; 1; $numFiles)
	If (Is table number valid:C999($i))
		$tablename:=String:C10($i; "000")+") "+Table name:C256($i)+" "
		GET TABLE PROPERTIES:C687($i; $invisible; $trigSaveNew; $trigSaveRec; $trigDelRec; $trigLoadRec)
		$ready:=True:C214
		If (Not:C34($trigSaveNew))
			$ready:=False:C215  //$tablename:=$tablename+" New "
		End if 
		If (Not:C34($trigSaveRec))
			$ready:=False:C215  //$tablename:=$tablename+" Save "
		End if 
		If (Not:C34($trigDelRec))
			$ready:=False:C215  //$tablename:=$tablename+" Delete "
		End if 
		If ($ready)
			$tablename:=" OK "+$tablename
		Else 
			$tablename:=" XX "+$tablename
		End if 
		utl_LogIt($tablename)
		utl_Logfile("sync-test.log"; "#################################")
		utl_Logfile("sync-test.log"; $tablename)
		$numFields:=Get last field number:C255($i)
		
		$gotfields:=0
		For ($j; 1; $numFields)
			$field:="-"*40+"> "
			If (Field name:C257($i; $j)="_SYNC_ID") | (Field name:C257($i; $j)="_SYNC_DATA")
				$field:=$field+" "+Field name:C257($i; $j)
				GET FIELD PROPERTIES:C258($i; $j; $fieldAttrTy; $fieldLength; $isIndexed)  //;$isUnique;$isInvisible)
				$field:=$field+" "+$aTypeList{$fieldAttrTy}+" "
				If ($isIndexed)
					$field:=$field+" Indexed"
				End if 
				utl_LogIt($field)
				utl_Logfile("sync-test.log"; $field)
			End if 
		End for 
	End if 
End for 

utl_LogIt("LOG SAVED IN sync-test.log")
utl_LogIt("show")
utl_Logfile("sync-test.log"; "END")
