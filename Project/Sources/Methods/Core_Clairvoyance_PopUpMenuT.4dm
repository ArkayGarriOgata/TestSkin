//%attributes = {}
//Method:  Core_Clairvoyance_PopUpMenuT (oClairvoyance)=>tDisplayChoice
//Description:  This method will query while someone is typing in a field and when the selection is
//  small enough it will present a dropdown that the user can select the correct choice.
//  See Vndr_Clairvoyance_VendorId for an example
//   Minimum number of characters is 3 to type in
//   Maximum number in popup 19

//  $oClairvoyance.ptQueryValue         This is value being queried (On After Keystroke)
//  $oClairvoyance.tQueryMethodN        This is method that will execute query (add @ to query if needed)
//  $oClairvoyance.ptQueryField         This is field that will be queried
//  $oClairvoyance.ptKeyField           This is key field that can be used to find unique record
//  $oClairvoyance.ptKeyFieldValue      This is value for key field selected
//  $oClairvoyance.nLeft                This is left for location of popup menu
//  $oClairvoyance.nTop                 This is top for locatioin of popup menu
//  $oClairvoyance.ptConcatenateField   This is field to concatenate to query

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oClairvoyance)
	
	C_POINTER:C301($pTable)
	C_LONGINT:C283($nChoice; $nNumberOfRecords)
	
	C_TEXT:C284($tDisplayChoice; $tQueryText; $tFind; $tDisplayFieldChoice)
	C_TEXT:C284($tSeperator)
	
	C_BOOLEAN:C305($bConcatenate)
	C_LONGINT:C283($nNumberOfParameters)
	
	ARRAY TEXT:C222($atDisplay; 0)
	ARRAY TEXT:C222($atKey; 0)
	ARRAY TEXT:C222($atConcatenate; 0)
	ARRAY TEXT:C222($atCombined; 0)
	
	ARRAY POINTER:C280($apPart; 0)
	APPEND TO ARRAY:C911($apPart; ->$atDisplay)
	APPEND TO ARRAY:C911($apPart; ->$atConcatenate)
	
	$oClairvoyance:=$1
	
	$bConcatenate:=Choose:C955(OB Is defined:C1231($oClairvoyance; "ptConcatenateField"); True:C214; False:C215)
	
	$tSeperator:=CorektSpace+CorektPipe+CorektSpace
	
End if   //Done Initialize

If ($oClairvoyance.tQueryMethodN=CorektBlank)  //Query is done already
	
	$pTable:=Table:C252(Table:C252($oClairvoyance.ptKeyField))
	
	$nNumberOfRecords:=Records in selection:C76($pTable->)
	
Else   //Run Query
	
	$tDisplayChoice:=CorektBlank
	
	$tQueryText:=Get edited text:C655
	
	$tFind:=$tQueryText+"@"
	
	$tDisplayChoice:=$tQueryText
	
	EXECUTE METHOD:C1007($oClairvoyance.tQueryMethodN; $nNumberOfRecords; $tFind)
	
End if   //Done query is done already

Case of   //Use popup menu
		
	: (Length:C16($tFind)<4)
	: ($nNumberOfRecords=0)
	: ($nNumberOfRecords=1)  //Found one
		
		($oClairvoyance.ptKeyFieldValue)->:=($oClairvoyance.ptKeyField)->
		
		$tDisplayChoice:=($oClairvoyance.ptQueryField)->
		
	: ($nNumberOfRecords<20)  //Maximum allowed
		
		If ($bConcatenate)
			
			SELECTION TO ARRAY:C260(($oClairvoyance.ptQueryField)->; $atDisplay; ($oClairvoyance.ptKeyField)->; $atKey; ($oClairvoyance.ptConcatenateField)->; $atConcatenate)
			
			Core_Array_Combine(->$apPart; ->$atCombined; $tSeperator)
			
			COPY ARRAY:C226($atCombined; $atDisplay)
			
		Else 
			
			SELECTION TO ARRAY:C260(($oClairvoyance.ptQueryField)->; $atDisplay; ($oClairvoyance.ptKeyField)->; $atKey)
			
		End if 
		
		Core_Array_Replace(->$atDisplay; CorektLeftParen; CorektLeftBracket)  //")" make an item disabled
		Core_Array_Replace(->$atDisplay; CorektRightParen; CorektRightBracket)  //Replace right so it looks good
		
		SORT ARRAY:C229($atDisplay; $atKey; >)
		$tDisplayFieldChoice:=Core_Array_CreatePopupMenuT(->$atDisplay)
		
		$nChoice:=Pop up menu:C542($tDisplayFieldChoice; 1; $oClairvoyance.nLeft; $oClairvoyance.nTop)
		
		$oClairvoyance.ptKeyFieldValue->:=$atKey{$nChoice}
		$tDisplayChoice:=$atDisplay{$nChoice}
		
End case   //Done use popup menu

$0:=$tDisplayChoice
