//%attributes = {}
// Method: Est_BatchCalulation () -> 
// ----------------------------------------------------
// by: mel: 06/06/05, 12:11:42
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements)
ARRAY TEXT:C222(aMHRname; 3)  //•090399  mlb  UPR 2052

READ WRITE:C146([Estimates:17])
READ WRITE:C146([Estimates_Carton_Specs:19])
READ WRITE:C146([Estimates_Machines:20])
READ WRITE:C146([Estimates_Materials:29])
READ WRITE:C146([Process_Specs:18])
READ WRITE:C146([Estimates_PSpecs:57])
READ WRITE:C146([Finished_Goods:26])
READ WRITE:C146([Estimates_FormCartons:48])
READ WRITE:C146([Estimates_DifferentialsForms:47])
READ WRITE:C146([Estimates_Differentials:38])
READ ONLY:C145([Customers:16])

aMHRname{1}:="Sales"
aMHRname{2}:="Haup"
aMHRname{3}:="Roan"
aMHRname:=1
$winRef:=OpenSheetWindow(->[Estimates:17]; "batchCalc_dio")
DIALOG:C40([Estimates:17]; "batchCalc_dio")
CLOSE WINDOW:C154($winRef)
If (OK=1)
	If (rb1=1)
		<>PrintToPDF:=True:C214
		C_LONGINT:C283($macPDF; $printer)
		$macPDF:=3
		$prefPath:=util_DocumentPath
		$pdfDocName:="aMsOutput"+String:C10(TSTimeStamp)+".pdf"
		SET PRINT OPTION:C733(Destination option:K47:7; $macPDF; ($prefPath+$pdfDocName))
	Else 
		<>PrintToPDF:=False:C215
		$printer:=1
		SET PRINT OPTION:C733(Destination option:K47:7; $printer; "")
	End if 
	
	Est_LogIt("init")
	
	//get a selection of estimates or use current selection
	ARRAY TEXT:C222($aEstimate; 0)
	SELECTION TO ARRAY:C260([Estimates:17]EstimateNo:1; $aEstimate)
	SORT ARRAY:C229($aEstimate; >)
	CUT NAMED SELECTION:C334([Estimates:17]; "WhileCalculating")
	
	$numElements:=Size of array:C274($aEstimate)
	If (bPrice=1)
		Est_comparePriceToCost
	End if 
	
	uThermoInit($numElements; "Batch Estimate Calculation...")
	For ($i; 1; $numElements)
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$aEstimate{$i})
		
		If (bCalc=1)
			Est_Calculate([Estimates:17]EstimateNo:1)
		End if 
		
		If (rb3=0)
			rRptEstimate([Estimates:17]EstimateNo:1)
		End if 
		
		If (bPrice=1)
			Est_comparePriceToCost([Estimates:17]EstimateNo:1)
		End if 
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	If (bPrice=1)
		Est_comparePriceToCost(""; "SAVE")
	End if 
	
	USE NAMED SELECTION:C332("WhileCalculating")
	
	Est_LogIt("show")
	Est_LogIt("init")
End if 