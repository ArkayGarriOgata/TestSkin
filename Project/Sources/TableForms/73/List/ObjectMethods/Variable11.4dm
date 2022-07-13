If (<>HasLabelPrinter=0)
	<>HasLabelPrinter:=uPrintLabelSetPort
End if 
If (<>HasLabelPrinter#0)
	C_LONGINT:C283($i; $numLocations)
	$numLocations:=Records in set:C195("UserSet")
	If ($numLocations#0)  //bSelect button from selectionList layout   
		ON EVENT CALL:C190("eCancelPrint")
		CUT NAMED SELECTION:C334([WMS_AllowedLocations:73]; "CurrentSel")  //• 5/7/97 cs `•020499  MLB  chg to cut
		uPrintBinLabel
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
			For ($i; 1; $numLocations)
				USE SET:C118("UserSet")
				GOTO SELECTED RECORD:C245([WMS_AllowedLocations:73]; $i)
				
				uPrintBinLabel([WMS_AllowedLocations:73]ValidLocation:1; [WMS_AllowedLocations:73]BarcodedID:2)
				
				If (Not:C34(<>fContinue))  //if the printing is stopped by user
					$i:=$numLocations+1
					<>fContinue:=True:C214
				End if 
			End for 
			
		Else 
			
			
			ARRAY TEXT:C222($_ValidLocation; 0)
			ARRAY TEXT:C222($_BarcodedID; 0)
			USE SET:C118("UserSet")
			SELECTION TO ARRAY:C260([WMS_AllowedLocations:73]ValidLocation:1; $_ValidLocation; \
				[WMS_AllowedLocations:73]BarcodedID:2; $_BarcodedID)
			
			
			For ($i; 1; $numLocations)
				
				uPrintBinLabel($_ValidLocation{$i}; $_BarcodedID{$i})
				
				If (Not:C34(<>fContinue))  //if the printing is stopped by user
					$i:=$numLocations+1
					<>fContinue:=True:C214
				End if 
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		uPrintBinLabel("close")
		USE NAMED SELECTION:C332("CurrentSel")  //• 5/7/97 cs   
		ON EVENT CALL:C190("")
		
	Else 
		BEEP:C151
		ALERT:C41("Select the Locations that you wish to print.")
	End if 
End if 
//EOS
