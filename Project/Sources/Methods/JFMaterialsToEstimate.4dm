//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/02/13, 14:59:06
// ----------------------------------------------------
// Method: JFMaterialsToEstimate
// Description
// Get the proper [Estimates_Materials] record and record 
// the Raw_Matl_Code to it.
// NOTE: This is not fool proof. Some fool will be able to mess it up.
// No back index exists so there may be some records not updated.
// ----------------------------------------------------

C_LONGINT:C283($i; $xlWinRef)
C_TEXT:C284($tWinTitle)

READ WRITE:C146([Estimates_Materials:29])

$tWinTitle:="Job Form -> Estimate"

$xlWinRef:=OpenFormWindow(->[Estimates_Materials:29]; "FillInFromJobForm"; ->$tWinTitle)
DIALOG:C40([Estimates_Materials:29]; "FillInFromJobForm")
CLOSE WINDOW:C154

If (bOK=1)
	For ($i; 1; Size of array:C274(atSeq))
		If (<>atRMCode{$i}#atRMCode{$i})
			QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=[Job_Forms:42]CaseFormID:9)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
				
				QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6=atCommKey{$i}; *)
				QUERY SELECTION:C341([Estimates_Materials:29];  & ; [Estimates_Materials:29]Qty:9=arQty{$i}; *)
				QUERY SELECTION:C341([Estimates_Materials:29];  & ; [Estimates_Materials:29]Cost:11=arCost{$i})
				
			Else 
				QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3; *)
				QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6=atCommKey{$i}; *)
				QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Qty:9=arQty{$i}; *)
				QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Cost:11=arCost{$i})
				
			End if   // END 4D Professional Services : January 2019 query selection
			If (Records in selection:C76([Estimates_Materials:29])=1)
				[Estimates_Materials:29]Raw_Matl_Code:4:=atRMCode{$i}
				SAVE RECORD:C53([Estimates_Materials:29])
			End if 
		End if 
	End for 
End if 