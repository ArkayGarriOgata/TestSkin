//%attributes = {}
//Method:  Core_Table_DocFindField(oField)
//Attributes of oField:
//           cName                   [Table]FieldName
//           cNameValue              Count of FieldName
//.          cKey                    [Table]FieldKey
//.          cKeyValue               Count of FieldKey
//.          pNewName                Replace Value with New Value
//.          pNewKey                 Replace Key with New Key

//Description: This method will create a document with tables that
//  have a field that contains field name and field key name
//Note: When modifying this method the Key and Name sections are mirrors of each other
//.   This is done to allow changing their values independently

//.  Example: Find all tables with a "customer type" fieldname

//C_COLLECTION($cName)
//C_COLLECTION($cNameValue)

//$cName:=New collection(\
     "CustomerName";\
     "Customer";\
     "Company";\
     "CustName";\
     "Cust")

//$cNameValue:=New collection(\
     "Procter & Gamble";\
     "Procter & Gamble Co";\
     "Procter & Gamble, Co";\
     "P&G";\
     "P&G Co"\
     "P&G, Co")

//C_OBJECT($oFieldValue)

//$oNameKey:=New object()

//$oNameKey.cName:=$cName
//$oNameKey.cNameValue:=$cNameValue

//Core_Table_DocFindField ($oNameKey) 

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oNameKey)
	
	C_LONGINT:C283($nTable; $nNumberOfTables)
	C_LONGINT:C283($nField; $nNumberOfFields)
	C_LONGINT:C283($nFieldType)
	
	C_BOOLEAN:C305($bNameCount; $bNewName)
	C_BOOLEAN:C305($bKey; $bKeyCount; $bNewKey)
	C_BOOLEAN:C305($bOmitZero)
	C_BOOLEAN:C305($bDelete)
	
	C_POINTER:C301($pTable; $pField)
	
	C_TEXT:C284($tFieldName; $tNameValue; $tKeyValue)
	C_TEXT:C284($tTableName; $tQuery)
	
	C_OBJECT:C1216($esName)
	C_OBJECT:C1216($esKey)
	
	C_OBJECT:C1216($oProgress)
	C_OBJECT:C1216($oDrop)
	
	ARRAY TEXT:C222($atFoundField; 0)
	ARRAY TEXT:C222($atValueCount; 0)
	ARRAY POINTER:C280($apColumn; 0)
	
	$oNameKey:=New object:C1471()
	
	$oNameKey:=$1
	
	$bNameCount:=(OB Is defined:C1231($oNameKey; "cNameValue"))
	
	$bKey:=(OB Is defined:C1231($oNameKey; "cKey"))
	
	$bKeyCount:=(OB Is defined:C1231($oNameKey; "cKeyValue"))
	
	$bNewName:=(OB Is defined:C1231($oNameKey; "pNewName"))
	
	$bNewKey:=(OB Is defined:C1231($oNameKey; "pNewKey"))
	
	$bOmitZero:=False:C215
	If (OB Is defined:C1231($oNameKey; "nOmitZero"))
		$bOmitZero:=($oNameKey.nOmitZero=1)
	End if 
	
	$bDelete:=False:C215
	If (OB Is defined:C1231($oNameKey; "nDelete"))
		$bDelete:=($oNameKey.nDelete=1)
	End if 
	
	$esName:=New object:C1471()
	$esKey:=New object:C1471()
	
	$nNumberOfTables:=Get last table number:C254
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfTables
	$oProgress.tTitle:="Searching Table"
	
End if   //Done initialize

For ($nTable; 1; $nNumberOfTables)  //Tables
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		If (Is table number valid:C999($nTable))  //Valid table number
			
			$oProgress.nLoop:=$nTable
			$oProgress.tMessage:=Table name:C256($nTable)
			
			Prgr_Message($oProgress)
			
			$pTable:=Table:C252($nTable)
			
			$nNumberOfFields:=Get last field number:C255($nTable)
			
			For ($nField; 1; $nNumberOfFields)  //Fields
				
				If (Is field number valid:C1000($nTable; $nField))  //Valid field
					
					$pField:=Field:C253($nTable; $nField)
					
					$tFieldName:=Field name:C257($nTable; $nField)
					
					$nFieldType:=Type:C295($pField->)
					
					Case of   //Name
							
						: ($oNameKey.cName.countValues($tFieldName)=0)  //Not a field name
						: (Not:C34(\
							($nFieldType=Is text:K8:3) | \
							($nFieldType=Is alpha field:K8:1) | \
							($nFieldType=Is date:K8:7) | \
							($nFieldType=Is longint:K8:6)))  //Not Text or Alpha or Date or Longint
							
							APPEND TO ARRAY:C911($atFoundField; Core_FieldNameT($pField))
							APPEND TO ARRAY:C911($atValueCount; "Field type"+CorektSpace+String:C10(Type:C295($pField->)))
							
						Else   //Good
							
							If ($bNameCount)  //Count
								
								For each ($tNameValue; $oNameKey.cNameValue)  //cValue
									
									Case of   //Verify
											
										: (Position:C15(CorektSpace; $tFieldName)>0)
										: ($tNameValue=CorektBlank)
											
										Else   //Verified
											
											$tTableName:=Table name:C256($pTable)
											
											If ((Type:C295($pField->)=Is alpha field:K8:1) | (Type:C295($pField->)=Is text:K8:3))  //Single quote
												
												$tNameValue:=CorektSingleQuote+$tNameValue+CorektSingleQuote
												
											End if   //Done single quote
											
											$tQuery:=$tFieldName+CorektSpace+"="+CorektSpace+$tNameValue
											
											$esName:=ds:C1482[$tTableName].query($tQuery)
											
											If (Not:C34($bOmitZero & ($esName.length=0)))  //Omit zero
												
												APPEND TO ARRAY:C911($atFoundField; Core_FieldNameT($pField)+"="+CorektDoubleQuote+$tNameValue+CorektDoubleQuote)
												APPEND TO ARRAY:C911($atValueCount; String:C10($esName.length))
												
											End if   //Done omit zero
											
											Case of   //Option
													
												: ($bDelete)
													
													$oDrop:=$esName.drop()
													
												: ($bNewName)
													
													USE ENTITY SELECTION:C1513($esName)
													APPLY TO SELECTION:C70($pTable->; $pField->:=($oNameKey.pNewName)->)
													
											End case   //Done option
											
									End case   //Done verify
									
								End for each   //Done cValue
								
							Else   //No count
								
								APPEND TO ARRAY:C911($atFoundField; Core_FieldNameT($pField))  //[Table]Field
								
							End if   //Done count
							
					End case   //Done name
					
					Case of   //Key
							
						: (Not:C34($bKey))  //Don't do key
						: ($oNameKey.cKey.countValues($tFieldName)=0)  //Not a key field
						: ((Type:C295($pField->)#Is text:K8:3) & (Type:C295($pField->)#Is alpha field:K8:1))  //Not text or alpha
							
							APPEND TO ARRAY:C911($atFoundField; Core_FieldNameT($pField))
							APPEND TO ARRAY:C911($atValueCount; "Field type"+CorektSpace+String:C10(Type:C295($pField->)))
							
						Else   //Valid key field
							
							If ($bKeyCount)  //Count
								
								For each ($tKeyValue; $oNameKey.cKeyValue)  //Key value
									
									Case of   //Verify
											
										: (Position:C15(CorektSpace; $tFieldName)>0)
										: ($tKeyValue=CorektBlank)
											
										Else   //Verified
											
											If ((Type:C295($pField->)=Is alpha field:K8:1) | (Type:C295($pField->)=Is text:K8:3))  //Single quote
												
												$tKeyValue:=CorektSingleQuote+$tKeyValue+CorektSingleQuote
												
											End if   //Done single quote
											
											$tQuery:=$tFieldName+CorektSpace+"="+CorektSpace+$tKeyValue
											$tTableName:=Table name:C256($pTable)
											
											$esKey:=ds:C1482[$tTableName].query($tQuery)
											
											If (Not:C34(($bOmitZero & ($esKey.length=0))))  //Omit zero
												
												APPEND TO ARRAY:C911($atFoundField; Core_FieldNameT($pField)+"="+CorektDoubleQuote+$tKeyValue+CorektDoubleQuote)  //Append Key
												APPEND TO ARRAY:C911($atValueCount; String:C10($esKey.length))
												
											End if 
											
											Case of   //Option
													
												: ($bDelete)
													
													$oDrop:=$esKey.drop()
													
												: ($bNewKey)
													
													USE ENTITY SELECTION:C1513($esName)
													APPLY TO SELECTION:C70($pTable->; $pField->:=($oNameKey.pNewName)->)
													
											End case   //Done option
											
									End case   //Done verify
									
								End for each   //Done key value
								
							Else   //No count
								
								APPEND TO ARRAY:C911($atFoundField; Core_FieldNameT($pField))  //[Table]Field
								
							End if   //Done count
							
					End case   //Done key
					
				End if   //Done valid field
				
			End for   //Done fields
			
		End if   //Done valid table number
		
	Else   //Stop progress
		
		$nLoop:=$nNumberOfTables+1  //Cancel loop
		
	End if   //Done progress
	
End for   //Done tables

If ($bNameCount | $bKeyCount)  //Header
	
	SORT ARRAY:C229($atFoundField; $atValueCount; >)
	
	INSERT IN ARRAY:C227($atFoundField; 1)
	$atFoundField{1}:="[Table]Field"
	
	INSERT IN ARRAY:C227($atValueCount; 1)
	$atValueCount{1}:="Count"
	
	APPEND TO ARRAY:C911($apColumn; ->$atFoundField)
	APPEND TO ARRAY:C911($apColumn; ->$atValueCount)
	
Else   //Don't count
	
	SORT ARRAY:C229($atFoundField; >)
	
	INSERT IN ARRAY:C227($atFoundField; 1)
	$atFoundField{1}:="[Table]Field"
	
	APPEND TO ARRAY:C911($apColumn; ->$atFoundField)
	
End if   //Done header

$nNumberOfFound:=Size of array:C274($atFoundField)

If ($nNumberOfFound>2)  //Blank line
	
	$tBreakTable:=Core_Table_ParseNameT($atFoundField{$nNumberOfFound})
	
	For ($nFound; $nNumberOfFound; 2; -1)  //Found
		
		$tCurrentTable:=Core_Table_ParseNameT($atFoundField{$nFound})
		
		If ($tCurrentTable#$tBreakTable)  //Add blank line
			
			$tBreakTable:=$tCurrentTable
			
			INSERT IN ARRAY:C227($atFoundField; $nFound+1)
			
			If ($bNameCount | $bKeyCount)  //Add count
				
				INSERT IN ARRAY:C227($atValueCount; $nFound+1)
				
			End if   //Done add count
			
		End if   //Done add blank line
		
	End for   //Done found
	
End if   //Done blank line

Core_Array_ToDocument(->$apColumn)

Prgr_Quit($oProgress)