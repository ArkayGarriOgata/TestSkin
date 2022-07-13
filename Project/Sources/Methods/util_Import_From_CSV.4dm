//%attributes = {}
// _______
// Method: util_Import_From_CSV   ( ) ->
// By: Mel Bohince @ 05/04/21, 11:45:57
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (5/5/21) offer to remove 1st row with column titles

C_POINTER:C301($tablePtr; $1; $fieldPtr)
C_TEXT:C284($skipFields_t; $2)
C_LONGINT:C283($0; $numImported; $i; $tableNumber)
C_TEXT:C284($csvToImport; $recordDelimitor; $fieldDelimitor; $path)
C_COLLECTION:C1488($rows_c; $columns_c; $skipFields_c)
ARRAY TEXT:C222($paths; 0)
C_TEXT:C284($document)
C_BOOLEAN:C305($continueInteration)

If (Count parameters:C259=2)
	$tablePtr:=$1
	$skipFields_t:=$2
	
Else   //test
	$tablePtr:=->[Finished_Goods_Transactions:33]
	$skipFields_t:="21,23,25,35,36"
	//$skipFields_t:=String(Field(->[Finished_Goods_Transactions]LocationToRecNo))  //
	//$skipFields_t:=$skipFields_t+", "+String(Field(->[Finished_Goods_Transactions]LocationFromRecNo))
	//$skipFields_t:=$skipFields_t+", "+String(Field(->[Finished_Goods_Transactions]TransactionFailed))
	//$skipFields_t:=$skipFields_t+", "+String(Field(->[Finished_Goods_Transactions]z_SYNC_ID))
End if 

$numImported:=0

$path:=util_DocumentPath
$document:=Select document:C905($path; "CSV"; "Select the CSV file to import:"; 0; $paths)
If ((ok=1) & (Size of array:C274($paths)=1))
	
	$tableNumber:=Table:C252($tablePtr)
	
	$csvToImport:=""
	$fieldDelimitor:=","  //\t
	$recordDelimitor:="\r"
	
	$skipFields_c:=Split string:C1554($skipFields_t; $fieldDelimitor; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	$csvToImport:=Document to text:C1236($paths{1})
	
	$rows_c:=Split string:C1554($csvToImport; $recordDelimitor)
	zwStatusMsg("IMPORT CSV"; String:C10($rows_c.length)+" rows in file "+$document)
	
	CONFIRM:C162("Does first row have column titles?"; "Yes"; "No")  // Modified by: Mel Bohince (5/5/21) offer to remove 1st row with column titles
	If (ok=1)
		$rows_c:=$rows_c.remove(0; 1)
		zwStatusMsg("IMPORT CSV"; String:C10($rows_c.length)+" data rows in file "+$document)
	End if 
	
	C_LONGINT:C283($outerBar; $outerLoop; $out)
	$outerBar:=Progress New  //new progress bar
	$outerLoop:=$rows_c.length
	$out:=0
	Progress SET TITLE($outerBar; "Importing "+String:C10($outerLoop)+" to CSV file")
	Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration
	$continueInteration:=True:C214  //option to break out of ForEach
	
	CREATE EMPTY SET:C140($tablePtr->; "importedRecords")
	
	For each ($row; $rows_c) While ($continueInteration)
		$out:=$out+1
		Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
		
		$columns_c:=New collection:C1472
		$columns_c:=Split string:C1554($row; $fieldDelimitor)
		If ($columns_c.length>0)  //something read in the row
			
			$column:=0  //need to track incase fields are skipped
			$columnLimit:=$columns_c.length
			$fieldNumber:=1
			$fieldLimit:=Get last field number:C255($tablePtr)+1
			
			CREATE RECORD:C68($tablePtr->)
			
			//move thru the fields and if not skipped move across a column
			While ($column<$columnLimit) & ($fieldNumber<$fieldLimit)  //each column of the imported file
				$fieldPtr:=Field:C253($tableNumber; $fieldNumber)
				
				If (Type:C295($fieldPtr->)<38) & (Type:C295($fieldPtr->)#5)  //supported type //is object = 38, is undefined = 5
					
					If ($skipFields_c.indexOf(String:C10($fieldNumber))=-1)  //not specifically told to skip
						
						//$value_t:=$columns_c[$i-$columnOffset]  //collection starting at zero, fieldnums at 1
						$value_t:=$columns_c[$column]  //collection starting at zero, fieldnums at 1
						
						Case of 
							: (Type:C295($fieldPtr->)=Is text:K8:3) | (Type:C295($fieldPtr->)=Is alpha field:K8:1)
								$fieldPtr->:=Replace string:C233($value_t; Char:C90(Double quote:K15:41); "")
								
							: (Type:C295($fieldPtr->)=Is date:K8:7)
								$fieldPtr->:=Date:C102($value_t)
								
							: (Type:C295($fieldPtr->)=Is integer:K8:5) | (Type:C295($fieldPtr->)=Is longint:K8:6) | (Type:C295($fieldPtr->)=Is real:K8:4)
								$fieldPtr->:=Num:C11($value_t)
								
							: (Type:C295($fieldPtr->)=Is boolean:K8:9)
								$fieldPtr->:=($value_t="TRUE")
								
							: (Type:C295($fieldPtr->)=Is time:K8:8)
								$fieldPtr->:=Time:C179(Time string:C180(Num:C11($value_t)))
								
							Else 
								$fieldPtr->:=$value_t
						End case 
						
						$column:=$column+1  //while TEST
						
					End if   //skip field
					
				End if   //supported type
				
				$fieldNumber:=$fieldNumber+1  //while TEST
				
			End while 
			
			SAVE RECORD:C53($tablePtr->)
			ADD TO SET:C119($tablePtr->; "importedRecords")
			$numImported:=$numImported+1
			
		Else 
			ALERT:C41("Row "+String:C10($out)+" appears to be empty.")
		End if 
		
		$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
		
	End for each 
	
	USE SET:C118("importedRecords")
	CLEAR SET:C117("importedRecords")
	
	BEEP:C151
	Progress QUIT($outerBar)  //remove the thermometer
	
	If (Not:C34($continueInteration))
		ALERT:C41("Aborted import after row "+String:C10($out))
	End if 
	
	
End if   //file selected

$0:=$numImported
