//%attributes = {}
// -------
// Method: CUST_NameLookupTable   ( ) ->
// By: Mel Bohince @ 09/28/17, 08:06:19
// Description
// export id and name for use in excel with a vlookup
// because big selections on slow networks stall doing this live
// ---------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	
	$pid_:=New process:C317("CUST_NameLookupTable"; <>lMidMemPart; "CUST_NameLookupTable"; "init")
	If (False:C215)
		CUST_NameLookupTable
	End if 
	
Else 
	Case of 
		: ($1="init")
			READ ONLY:C145([Customers:16])
			ALL RECORDS:C47([Customers:16])
			SELECTION TO ARRAY:C260([Customers:16]ID:1; $aId; [Customers:16]Name:2; $aFullName; [Customers:16]ParentCorp:19; $aParent; [Customers:16]ShortName:57; $aShortname; [Customers:16]SalesmanID:3; $aSalerep)
			SORT ARRAY:C229($aId; $aFullName; $aParent; $aShortname; $aSalerep; >)
			C_LONGINT:C283($i; $numElements)
			$numElements:=Size of array:C274($aId)
			ARRAY TEXT:C222($aName; $numElements)
			
			C_TEXT:C284($text; $docName)
			C_TIME:C306($docRef)
			
			$text:="CUST_ID\tNAME\tFULL_NAME\tPARENT\tSHORT_NAME\tSALES_REP\r"
			$docName:="CustomerLookupTable_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			$docRef:=util_putFileName(->$docName)
			
			If ($docRef#?00:00:00?)
				
				For ($i; 1; $numElements)
					$aName{$i}:=CUST_getName($aId{$i}; "el")
					If (Position:C15("Lauder"; $aParent{$i})>0)
						$aParent{$i}:="Estee Lauder Companies Inc"
					End if 
					If (Position:C15("L'O"; $aParent{$i})>0)
						$aParent{$i}:="L'Oreal/Lancome"
					End if 
					$text:=$text+$aId{$i}+"\t"+$aName{$i}+"\t"+$aFullName{$i}+"\t"+$aParent{$i}+"\t"+$aShortname{$i}+"\t"+$aSalerep{$i}+"\r"
				End for 
				
				SEND PACKET:C103($docRef; $text)
				SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
				CLOSE DOCUMENT:C267($docRef)
				
				//// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
				$err:=util_Launch_External_App($docName)
			End if 
			
	End case 
End if 

