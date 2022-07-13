//%attributes = {}
//Method:  Core_Peek_Report({$oOption})
//Description:  This method will create a report for who peeked 

//Example:
//.    Core_Peek_Report //Prints all records

//.    C_OBJECT($oOption)

//.    $oOption:=New object()

//.    $oOption.tQuery:="FormName" //All form names named Input
//.    $oOption.tValue:="Input"

//.    Core_Peek_Report ($oOption)

//.    $oOption.tQuery:="TableName" //All forms from table zz_Control
//.    $oOption.tValue:="zz_Control"

//.    Core_Peek_Report ($oOption)

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bUseCollection)
	C_BOOLEAN:C305($bUseEntitySelection)
	
	C_COLLECTION:C1488($cTableNames)
	C_COLLECTION:C1488($cFormNames)
	C_COLLECTION:C1488($cReport)
	
	C_LONGINT:C283($nRow)
	C_LONGINT:C283($nCount)
	
	C_OBJECT:C1216($oOption)
	C_OBJECT:C1216($esPeekers)
	C_OBJECT:C1216($enPeeker)
	
	C_TEXT:C284($tTab)
	C_TEXT:C284($tHeader; $tRow)
	C_TEXT:C284($tWhoAtrb)
	C_TEXT:C284($tFormName)
	C_TEXT:C284($tTableName)
	C_TEXT:C284($tTerminator)
	C_TEXT:C284($tValue)
	
	C_TIME:C306($hWhoPeeked)
	
	$cReport:=New collection:C1472()
	
	$oOption:=New object:C1471()
	$esPeekers:=New object:C1471()
	$enPeeker:=New object:C1471()
	
	If (Count parameters:C259>=1)
		$oOption:=$1  //All, FormName, UserName
	Else 
		$oOption.tQuery:="All"
	End if 
	
	$tTab:=Char:C90(Tab:K15:37)
	$nCount:=0
	
	$bUseCollection:=False:C215
	$bUseEntitySelection:=True:C214
	
	$tHeader:="Row"+$tTab+"On"+$tTab+"Start"+$tTab+"End"+$tTab+\
		"User Name"+$tTab+"Table Name"+$tTab+"Form Name"+CorektCR
	
End if   //Done initialize

$hWhoPeeked:=Create document:C266(CorektBlank)

If (OK=1)  //Document
	
	Case of   //Query
			
		: ($oOption.tQuery="All")
			
			$esPeekers:=ds:C1482.Core_Peek.all()
			
		: ($oOption.tQuery="Distinct")
			
			$cTableNames:=ds:C1482.Core_Peek.all().distinct("WhoPeeked.TableName").orderBy("WhoPeeked.TableName")
			
			For each ($tTableName; $cTableNames)  //Tables
				
				$cFormNames:=ds:C1482.Core_Peek.query("WhoPeeked.TableName = :1"; $tTableName).distinct("WhoPeeked.FormName").orderBy("WhoPeeked.FormName")
				
				For each ($tFormName; $cFormNames)  //Forms
					
					$cReport.push($tTableName; $tFormName)
					
				End for each   //Done forms
				
			End for each   //Done tables
			
			$tHeader:="Table Name"+$tTab+"Form Name"+CorektCR
			
			$bUseCollection:=True:C214
			$bUseEntitySelection:=False:C215
			
		Else 
			
			$tWhoAtrb:="WhoPeeked."+$oOption.tQuery+" = :1"
			$esPeekers:=ds:C1482.Core_Peek.query($tWhoAtrb; $oOption.tValue)
			
	End case   //Done query
	
	SEND PACKET:C103($hWhoPeeked; $tHeader)
	
	Case of   //Export
			
		: ($bUseCollection)
			
			For each ($tValue; $cReport)
				
				$nCount:=$nCount+1
				
				$tTerminator:=Choose:C955((Mod:C98($nCount; 2)=0); \
					CorektCR; \
					$tTab)
				
				SEND PACKET:C103($hWhoPeeked; $tValue+$tTerminator)
				
			End for each 
			
		: ($bUseEntitySelection)
			
			For each ($enPeeker; $esPeekers)
				
				$tRow:=CorektBlank
				$nRow:=$nRow+1
				
				$tRow:=\
					String:C10($nRow)+$tTab+\
					String:C10($enPeeker.WhoPeeked.On)+$tTab+\
					$enPeeker.WhoPeeked.Start+$tTab+\
					$enPeeker.WhoPeeked.End+$tTab+\
					$enPeeker.WhoPeeked.UserName+$tTab+\
					$enPeeker.WhoPeeked.TableName+$tTab+\
					$enPeeker.WhoPeeked.FormName+CorektCR
				
				SEND PACKET:C103($hWhoPeeked; $tRow)
				
			End for each 
			
	End case   //Done export
	
	CLOSE DOCUMENT:C267($hWhoPeeked)
	
End if   //Done document

