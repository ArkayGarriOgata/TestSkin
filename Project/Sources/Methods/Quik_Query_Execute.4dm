//%attributes = {}
//Method:  Quik_Query_Execute(plQuery{;pbShowQuery})
//Description:  This method will execute the query
//    ! Means not implemented yet so it forces show query see $anUnsupportedCriterion
// Modified by: Garri Ogata (10/28/20) -   //Added READ ONLY

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $plQuery)
	C_POINTER:C301($2; $pbShowQuery)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nLine; $nNumberOfLines)
	C_LONGINT:C283($nQuery; $nNumberOfQueries)
	C_LONGINT:C283($nOrder; $nParentTable; $nStart)
	C_LONGINT:C283($nVersion; $nCriterion)
	C_LONGINT:C283($nMainTable)
	
	C_TEXT:C284($tLine; $tValue)
	C_TEXT:C284($tQueryLine)
	
	C_BOOLEAN:C305($bJa; $bStartQuery)
	C_BOOLEAN:C305($bShowQuery)
	C_POINTER:C301($pTable)
	
	ARRAY TEXT:C222($atLine; 0)
	ARRAY LONGINT:C221($anOrder; 0)
	ARRAY LONGINT:C221($anTable; 0)
	ARRAY LONGINT:C221($anField; 0)
	ARRAY LONGINT:C221($anCriterion; 0)
	ARRAY TEXT:C222($atValue1; 0)
	ARRAY TEXT:C222($atValue2; 0)
	ARRAY LONGINT:C221($anConjunction; 0)
	ARRAY LONGINT:C221($anUnsupportedCriterion; 0)
	
	ARRAY TEXT:C222($atStripCharacter; 0)
	
	C_OBJECT:C1216($oAsk)
	
	$plQuery:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	
	$bJustEvaluate:=False:C215
	
	If ($nNumberOfParameters>=2)
		$bJustEvaluate:=True:C214
		$pbShowQuery:=$2
	End if 
	
	$nLine:=0
	$nNumberOfLines:=0
	$nQuery:=0
	$nNumberOfQueries:=0
	$nOrder:=0
	$nParentTable:=0
	$nStart:=0
	$nVersion:=0
	
	$tLine:=CorektBlank
	$tValue:=CorektBlank
	$tQueryLine:=CorektBlank
	
	$bJa:=False:C215
	$bStartQuery:=False:C215
	$bShowQuery:=False:C215
	
	$oAsk:=New object:C1471()
	
	APPEND TO ARRAY:C911($atStripCharacter; CorektSpace)
	APPEND TO ARRAY:C911($atStripCharacter; CorektCR)
	APPEND TO ARRAY:C911($atStripCharacter; Char:C90(Line feed:K15:40))
	APPEND TO ARRAY:C911($atStripCharacter; CorektDoubleQuote)
	
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
			
		: (Not:C34($bStartQuery))
			
		: (Position:C15("{"; $tLine)>0)  //Start query row
			
			$nOrder:=$nOrder+1
			
		: (Position:C15("}"; $tLine)>0)  //End query row
			
			APPEND TO ARRAY:C911($anOrder; $nOrder)
			
			//Append possible missing
			
			If ($nOrder=1)
				APPEND TO ARRAY:C911($anConjunction; 1)
			End if 
			
			If (Size of array:C274($atValue1)#Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atValue1; CorektBlank)
			End if 
			
			If (Size of array:C274($atValue2)#Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atValue2; CorektBlank)
			End if 
			
		: (Position:C15("{"; $tLine)>0)  //Start query row
			
			$nOrder:=$nOrder+1
			
		: (Position:C15("}"; $tLine)>0)  //End query row
			
			APPEND TO ARRAY:C911($anOrder; $nOrder)
			
			//Append possible missing
			
			If ($nOrder=1)
				APPEND TO ARRAY:C911($anConjunction; 1)
			End if 
			
			If (Size of array:C274($atValue1)#Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atValue1; CorektBlank)
			End if 
			
			If (Size of array:C274($atValue2)#Size of array:C274($anOrder))
				APPEND TO ARRAY:C911($atValue2; CorektBlank)
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
						APPEND TO ARRAY:C911($atValue1; "False")
						
					: (($nShowQueryType=Is boolean:K8:9) & ($nCriterion=1))  //Boolean is true
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atValue1; "True")
						
					: (($nShowQueryType=Is date:K8:7) & ($nCriterion=11))  //Date is today
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atValue1; String:C10(Current date:C33))
						
					: ($nCriterion=21)  //Date is yesterday
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atValue1; String:C10(Add to date:C393(Current date:C33; 0; 0; -1)))
						
					: ($nCriterion=31)  //Date is tomorrow
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						APPEND TO ARRAY:C911($atValue1; String:C10(Add to date:C393(Current date:C33; 0; 0; 1)))
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=3))  //!Blob contains at least
						
						$bShowQuery:=True:C214
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=5))  //!Blob contains a maximum of
						
						$bShowQuery:=True:C214
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is date:K8:7) & ($nCriterion=12))  //!Date is within current
						
						$bShowQuery:=True:C214
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=41))  //!Blob is empty
						
						$bShowQuery:=True:C214
						$nLine:=$nNumberOfLines+1  //Terminate
						
					: (($nShowQueryType=Is BLOB:K8:12) & ($nCriterion=42))  //!Blob is not empty
						
						$bShowQuery:=True:C214
						$nLine:=$nNumberOfLines+1  //Terminate
						
					Else   //Good criterion
						
						APPEND TO ARRAY:C911($anCriterion; $nCriterion)
						
				End case   //Done exception
				
			Else   //Show query
				
				$bShowQuery:=True:C214
				$nLine:=$nNumberOfLines+1  //Terminate
				
			End if   //Done good criterion
			
		: (Position:C15("Box"; $tLine)>0) & ((Position:C15("one"; $tLine)>0) | (Position:C15("first"; $tLine)>0))
			
			$nStart:=Position:C15(CorektColon; $tLine)+1
			$tValue:=Substring:C12($tLine; $nStart)
			$tValue:=Core_Text_RemoveT($tValue; ->$atStripCharacter)
			
			APPEND TO ARRAY:C911($atValue1; $tValue)
			
		: (Position:C15("Box"; $tLine)>0) & ((Position:C15("two"; $tLine)>0) | (Position:C15("second"; $tLine)>0))
			
			$nStart:=Position:C15(CorektColon; $tLine)+1
			$tValue:=Substring:C12($tLine; $nStart)
			$tValue:=Core_Text_RemoveT($tValue; ->$atStripCharacter)
			
			APPEND TO ARRAY:C911($atValue2; $tValue)
			
	End case   //Done parse
	
End for   //Done lines

If ((Not:C34($bShowQuery)) & (Not:C34($bJustEvaluate)))  //Execute
	
	Core_Table_ReadOnly($pMainTable)
	Core_Table_ReadOnly(->$anTable)
	
	$nNumberOfQueries:=Size of array:C274($anOrder)
	
	For ($nQuery; 1; $nNumberOfQueries)  //Query
		
		$nOrder:=$anOrder{$nQuery}
		
		$nConjunction:=$anConjunction{$nQuery}
		
		$nTable:=$anTable{$nQuery}
		$nField:=$anField{$nQuery}
		
		$nCriterion:=$anCriterion{$nQuery}
		
		$tValue1:=$atValue1{$nQuery}
		$tValue2:=$atValue2{$nQuery}
		
		$pTable:=Table:C252($nTable)
		$pField:=Field:C253($nTable; $nField)
		
		Case of   //Criterion (!=must use show query)
				
			: ($nCriterion=0)  //Boolean is false
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->=False:C215; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->=False:C215; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->=False:C215; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->=False:C215; *)
						
				End case 
				
			: ($nCriterion=1)  //Numeric equals, Text is, Date is, Boolean is true
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->=$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->=$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->=$tValue1; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->=$tValue1; *)
				End case 
				
			: ($nCriterion=2)  //Numeric is different from, Text is not, Date is not
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->#$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->#$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->#$tValue1; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->#$tValue1; *)
				End case 
				
			: ($nCriterion=3)  //Numeric is greater than or equal to, Text is or is after, Date starts from, !Blob contains at least
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->>=$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->>=$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->>=$tValue1; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->>=$tValue1; *)
				End case 
				
			: ($nCriterion=4)  //Numeric is strictly greater than, Text is after, Date is after
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->>$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->>$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->>$tValue1; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->>$tValue1; *)
				End case 
				
			: ($nCriterion=5)  //Numeric is lower than or equal to, Text is or is before, Date is up to, !Blob contains a maximum of
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField-><=$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField-><=$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField-><=$tValue1; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField-><=$tValue1; *)
				End case 
				
			: ($nCriterion=6)  //Numeric is strictly lower than, Text is before, Date is before
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField-><$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField-><$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField-><$tValue1; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField-><$tValue1; *)
				End case 
				
			: ($nCriterion=7)  //Numeric is between, Text is between, Date is between
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->>=$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField-><=$tValue2; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->>=$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField-><=$tValue2; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->>=$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField-><=$tValue2; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->>=$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField-><=$tValue2; *)
				End case 
				
			: ($nCriterion=8)  //Numeric is between (excluded), Text is between (excluded),Date is after and before
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField-><$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField->>$tValue2; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField-><$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField->>$tValue2; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField-><$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField->>$tValue2; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField-><$tValue1; *)
						QUERY:C277($pTable->;  & ; $pField->>$tValue2; *)
				End case 
				
			: ($nCriterion=9)  //Text starts with
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->=$tValue1+"@"; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->=$tValue1+"@"; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->=$tValue1+"@"; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->=$tValue1+"@"; *)
				End case 
				
			: ($nCriterion=10)  //Text ends with
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->="@"+$tValue1; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->="@"+$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->="@"+$tValue1; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->; #; $pField->="@"+$tValue1; *)
				End case 
				
			: ($nCriterion=11)  //Text contains, !Date is today
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->="@"+$tValue1+"@"; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->="@"+$tValue1+"@"; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->="@"+$tValue1+"@"; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->="@"+$tValue1+"@"; *)
				End case 
				
			: ($nCriterion=12)  //!Text does not contain, !Date is within current
			: ($nCriterion=13)  //!Text contains word(s)
			: ($nCriterion=14)  //!Text does not contain word(s)
			: ($nCriterion=15)  //!Numeric is in list, Text is in list
			: ($nCriterion=21)  //!Date is yesterday
			: ($nCriterion=22)  //!Date is within last
			: ($nCriterion=23)  //!Date is within the last
			: ($nCriterion=31)  //!Date is tomorrow
			: ($nCriterion=32)  //!Date is within next
			: ($nCriterion=33)  //!Date is within the next
			: ($nCriterion=41)  //Text is empty, !Blob is empty
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->=CorektBlank; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->=CorektBlank; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->=CorektBlank; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->=CorektBlank; *)
				End case 
				
			: ($nCriterion=42)  //Text is not empty, !Blob is not empty
				
				Case of 
					: ($nOrder=1)
						QUERY:C277($pTable->; $pField->#CorektBlank; *)
					: ($nConjunction=1)
						QUERY:C277($pTable->;  & ; $pField->#CorektBlank; *)
					: ($nConjunction=2)
						QUERY:C277($pTable->;  | ; $pField->#CorektBlank; *)
					: ($nConjunction=3)
						QUERY:C277($pTable->; #; $pField->#CorektBlank; *)
				End case 
				
		End case   //Done criterion (!=must use show query)
		
	End for   //Done query
	
	QUERY:C277($pMainTable->)
	
End if   //Done execute

If ($bJustEvaluate)  //ShowQuery
	$pbShowQuery->:=$bShowQuery
End if   //Done ShowQuery
