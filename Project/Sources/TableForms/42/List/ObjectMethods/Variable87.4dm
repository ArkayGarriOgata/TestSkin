
C_LONGINT:C283($i; $numJobBags)
$numJobBags:=Records in set:C195("UserSet")
If ($numJobBags#0)  //bSelect button from selectionList layout   
	ON EVENT CALL:C190("eCancelPrint")
	CONFIRM:C162("Hide the subform counts?"; "Hide"; "Show")
	If (ok=1)
		$new:=True:C214
	Else 
		$new:=False:C215
	End if 
	
	CUT NAMED SELECTION:C334([Job_Forms:42]; "CurrentSel")  //• 5/7/97 cs `•020499  MLB  chg to cut
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		For ($i; 1; $numJobBags)
			USE SET:C118("UserSet")
			GOTO SELECTED RECORD:C245([Job_Forms:42]; $i)
			If ($new)
				JOB_QuantityControlSheet([Job_Forms:42]JobFormID:5)
			Else 
				JOB_QuantityControlSheetOrig([Job_Forms:42]JobFormID:5)
			End if 
			
			If (Not:C34(<>fContinue))  //if the printing is stopped by user
				$i:=$numJobBags+1
				<>fContinue:=True:C214
			End if 
		End for 
		
	Else 
		ARRAY LONGINT:C221($_record_number; 0)
		USE SET:C118("UserSet")
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms:42]; $_record_number)
		
		For ($i; 1; $numJobBags)
			
			GOTO RECORD:C242([Job_Forms:42]; $_record_number{$i})
			
			If ($new)
				JOB_QuantityControlSheet([Job_Forms:42]JobFormID:5)
			Else 
				JOB_QuantityControlSheetOrig([Job_Forms:42]JobFormID:5)
			End if 
			
			If (Not:C34(<>fContinue))  //if the printing is stopped by user
				$i:=$numJobBags+1
				<>fContinue:=True:C214
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	USE NAMED SELECTION:C332("CurrentSel")  //• 5/7/97 cs   
	ON EVENT CALL:C190("")
	
Else 
	BEEP:C151
	ALERT:C41("Select the forms that you wish to print.")
End if 
//EOS