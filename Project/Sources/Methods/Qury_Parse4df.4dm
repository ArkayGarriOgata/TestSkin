//%attributes = {}
//Method: Qury_Parse4df(l4dfQuery;cQuery)
//Description: This method will take a 4df blob and
//.   parse it into a collection that can be used to fill in a query

//{"mainTable": 46,\
"queryDestination": 1,\
"Version": 3",\
"ja": false,\
“lines”:\
[{"tableNumber": "46","fieldNumber": "3","criterion": "2","oneBox": “<@“},\
{“lineOperator": "1","tableNumber": "46","fieldNumber": "12","criterion": "1","oneBox": "00199”},\
{“lineOperator": "1","tableNumber": "46","fieldNumber": "7","criterion": "4","oneBox": "2020-7-01T04:00:00.000Z"}]}"

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $plQuery)
	C_COLLECTION:C1488($2; $cQuery)
	
	C_LONGINT:C283($nLine; $nNumberOfLines)
	C_LONGINT:C283($nQuery; $nNumberOfQueries)
	C_LONGINT:C283($nOrder; $nParentTable; $nStart)
	C_LONGINT:C283($nVersion; $nCriterion)
	C_LONGINT:C283($nMainTable)
	
	C_TEXT:C284($tLine; $tCriteria)
	C_TEXT:C284($tQueryLine)
	
	C_BOOLEAN:C305($bJa; $bStartQuery)
	C_POINTER:C301($pTable)
	
	ARRAY TEXT:C222($atLine; 0)  //Lines of query from .4DF
	
	ARRAY LONGINT:C221($anOrder; 0)  //Parsed element arrays
	ARRAY LONGINT:C221($anTable; 0)
	ARRAY LONGINT:C221($anField; 0)
	ARRAY LONGINT:C221($anCriterion; 0)
	ARRAY TEXT:C222($atCriteria1; 0)
	ARRAY TEXT:C222($atCriteria2; 0)
	ARRAY LONGINT:C221($anConjunction; 0)
	
	ARRAY LONGINT:C221($anUnsupportedCriterion; 0)  //Verify criterias
	ARRAY TEXT:C222($atStripCharacter; 0)
	
	C_OBJECT:C1216($oAsk)
	
	$cQuery:=New collection:C1472()
	
	$plQuery:=$1
	$cQuery:=$2
	
	$nLine:=0
	$nNumberOfLines:=0
	$nQuery:=0
	$nNumberOfQueries:=0
	$nOrder:=0
	$nParentTable:=0
	$nStart:=0
	$nVersion:=0
	
	$tLine:=CorektBlank
	$tCriteria:=CorektBlank
	$tQueryLine:=CorektBlank
	
	$bJa:=False:C215
	$bStartQuery:=False:C215
	
	$oAsk:=New object:C1471()
	
	APPEND TO ARRAY:C911($atStripCharacter; CorektSpace)
	APPEND TO ARRAY:C911($atStripCharacter; CorektCR)
	APPEND TO ARRAY:C911($atStripCharacter; Char:C90(Line feed:K15:40))
	APPEND TO ARRAY:C911($atStripCharacter; CorektDoubleQuote)
	APPEND TO ARRAY:C911($atStripCharacter; Char:C90(Tab:K15:37))
	
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 12)  //!Text does not contain, !Date is within current
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 13)  //!Text contains word(s)
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 14)  //!Text does not contain word(s)
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 15)  //!Numeric is in list, Text is in list
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 22)  //!Date is within last
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 23)  //!Date is within the last
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 32)  //!Date is within next
	APPEND TO ARRAY:C911($anUnsupportedCriterion; 33)  //!Date is within the next
	
End if   //Done Initialize

$tQueryLine:=BLOB to text:C555($plQuery->; UTF8 text without length:K22:17)

TEXT TO ARRAY:C1149($tQueryLine; $atLine; 100000; "Helvetica"; 9)  //each line to element in array

$nNumberOfLines:=Find in array:C230($atLine; "@"+CorektRightBracket+"@")  //]

For ($nLine; 1; $nNumberOfLines)  //Clean
	
	$atLine{$nLine}:=Core_Text_RemoveT($atLine{$nLine}; ->$atStripCharacter)
	
End for   //Done clean

For ($nLine; 2; $nNumberOfLines)  //Lines
	
	$tLine:=$atLine{$nLine}
	
	Case of   //Parse
			
		: (Position:C15("mainTable"; $tLine)>0)
			
			$nMainTable:=Num:C11($tLine)
			
			If (Is table number valid:C999($nMainTable))
				
				$pMainTable:=Table:C252(Num:C11($tLine))
				
			Else 
				
				$oAsk.tMessage:="The main table number"+CorektSpace+String:C10($nMainTable)+CorektSpace+"is not valid."
				
				Core_Dialog_Alert($oAsk)
				
			End if 
			
		: (Position:C15("queryDestination"; $tLine)>0)
			
			$nQueryDestination:=Num:C11($tLine)
			
		: (Position:C15("version"; $tLine)>0)
			
			$nVersion:=Num:C11($tLine)
			
		: (Position:C15("ja"; $tLine)>0)
			
			$bJa:=(Position:C15("true"; $tLine)>0)
			
		: (Position:C15(CorektLeftBracket; $tLine)>0)  //[
			
			$bStartQuery:=True:C214
			
			//First line needs to be parsed and added
			
			
		: (Not:C34($bStartQuery))
			
		: (Position:C15("{"; $tLine)>0)  //Start query row
			
			$nOrder:=$nOrder+1
			
		: (Position:C15("}"; $tLine)>0)  //End query row
			
			APPEND TO ARRAY:C911($anOrder; $nOrder)
			
			If ($nOrder=1)
				APPEND TO ARRAY:C911($anConjunction; 1)
			End if 
			
			If (Size of array:C274($atCriteria1)<Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atCriteria1; CorektBlank)
			End if 
			
			If (Size of array:C274($atCriteria2)<Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atCriteria2; CorektBlank)
			End if 
			
		: (Position:C15("{"; $tLine)>0)  //Start query row
			
			$nOrder:=$nOrder+1
			
		: (Position:C15("}"; $tLine)>0)  //End query row
			
			APPEND TO ARRAY:C911($anOrder; $nOrder)
			
			If ($nOrder=1)
				APPEND TO ARRAY:C911($anConjunction; 1)
			End if 
			
			If (Size of array:C274($atCriteria1)<Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atCriteria1; CorektBlank)
			End if 
			
			If (Size of array:C274($atCriteria2)<Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atCriteria2; CorektBlank)
			End if 
			
		: (Position:C15("lineOperator"; $tLine)>0)
			
			APPEND TO ARRAY:C911($anConjunction; Num:C11($tLine))
			
		: (Position:C15("tableNumber"; $tLine)>0)
			
			$nTable:=Num:C11($tLine)
			APPEND TO ARRAY:C911($anTable; $nTable)
			
		: (Position:C15("fieldNumber"; $tLine)>0)
			
			$nField:=Num:C11($tLine)
			APPEND TO ARRAY:C911($anField; $nField)
			
		: (Position:C15("criterion"; $tLine)>0)
			
			$pShowQueryField:=Field:C253($nTable; $nField)
			$nShowQueryType:=Type:C295($pShowQueryField->)
			
			$nCriterion:=Num:C11($tLine)
			
			If (Find in array:C230($anUnsupportedCriterion; $nCriterion)=CoreknNoMatchFound)  //Good criterion
				
				Case of   //Exception
						
					: (($nShowQueryType=Is boolean:K8:9) & ($nCriterion=0))  //Boolean is false
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atCriteria1; "False")
						
					: (($nShowQueryType=Is boolean:K8:9) & ($nCriterion=1))  //Boolean is true
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atCriteria1; "True")
						
					: (($nShowQueryType=Is date:K8:7) & ($nCriterion=11))  //Date is today
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atCriteria1; String:C10(Current date:C33))
						
					: ($nCriterion=21)  //Date is yesterday
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atCriteria1; String:C10(Add to date:C393(Current date:C33; 0; 0; -1)))
						
					: ($nCriterion=31)  //Date is tomorrow
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atCriteria1; String:C10(Add to date:C393(Current date:C33; 0; 0; 1)))
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=3))  //!Blob contains at least
						
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=5))  //!Blob contains a maximum of
						
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is date:K8:7) & ($nCriterion=12))  //!Date is within current
						
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=41))  //!Blob is empty
						
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=42))  //!Blob is not empty
						
						$nLine:=$nNumberOfLines+1  //Terminate
						
					Else   //Good criterion
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						
				End case   //Done exception
				
			Else   //Can't parse
				
				$nLine:=$nNumberOfLines+1  //Terminate
				
			End if   //Done good criterion
			
		: (Position:C15("Box"; $tLine)>0) & ((Position:C15("one"; $tLine)>0) | (Position:C15("first"; $tLine)>0))
			
			$nStart:=Position:C15(CorektColon; $tLine)+1
			$tCriteria:=Substring:C12($tLine; $nStart)
			$tCriteria:=Core_Text_RemoveT($tCriteria; ->$atStripCharacter)
			
			APPEND TO ARRAY:C911($atCriteria1; $tCriteria)
			
		: (Position:C15("Box"; $tLine)>0) & ((Position:C15("two"; $tLine)>0) | (Position:C15("second"; $tLine)>0))
			
			$nStart:=Position:C15(CorektColon; $tLine)+1
			$tCriteria:=Substring:C12($tLine; $nStart)
			$tCriteria:=Core_Text_RemoveT($tCriteria; ->$atStripCharacter)
			
			APPEND TO ARRAY:C911($atCriteria2; $tCriteria)
			
	End case   //Done parse
	
End for   //Done lines

SORT ARRAY:C229($anOrder; $anTable; $anField; $anCriterion; \
$atCriteria1; $atCriteria2; $anConjunction; >)

ARRAY TO COLLECTION:C1563($cQuery; \
$anTable; "nTableNumber"; \
$anField; "nFieldNumber"; \
$anCriterion; "nCriterion"; \
$atOperator; "tOperator"; \
$atCriteria1; "tCriteria1"; \
$atCriteria2; "tCriteria2"; \
$anConjunction; "nConjunction")
