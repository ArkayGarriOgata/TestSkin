//(s)bRename ([process_spec]input)
C_TEXT:C284($New)

$New:=Request:C163("Please Enter a New PSpec ID"; "Max 20 Characters")

If (OK=1) & ($New#"") & ($New#"Max 20 Characters")
	MESSAGES OFF:C175
	$winRef:=NewWindow(170; 120; 6; 1; "")
	MESSAGE:C88("Updating Operation Seq…")
	QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1:=$New)
	
	MESSAGE:C88(<>sCr+"Updating Material PSpec…")
	QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1:=$New)
	
	MESSAGE:C88(<>sCr+"Updating Job…")
	QUERY:C277([Jobs:15]; [Jobs:15]ProcessSpec:14=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Jobs:15]; [Jobs:15]ProcessSpec:14:=$New)
	
	MESSAGE:C88(<>sCr+"Updating JobForm…")
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProcessSpec:46=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]ProcessSpec:46:=$New)
	
	MESSAGE:C88(<>sCr+"Updating Est_PSpec…")
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2:=$New)
	
	MESSAGE:C88(<>sCr+"Updating CaseScenario…")
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]ProcessSpec:5=[Process_Specs:18]ID:1)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		APPLY TO SELECTION:C70([Estimates_Differentials:38]; [Estimates_Differentials:38]ProcessSpec:5:=$New)
		FIRST RECORD:C50([Estimates_Differentials:38])
		
		
	Else 
		
		APPLY TO SELECTION:C70([Estimates_Differentials:38]; [Estimates_Differentials:38]ProcessSpec:5:=$New)
		
	End if   // END 4D Professional Services : January 2019 First record
	APPLY TO SELECTION:C70([Estimates_Differentials:38]; [Estimates_Differentials:38]PSpec_Qty_TAG:25:=Replace string:C233([Estimates_Differentials:38]PSpec_Qty_TAG:25; [Process_Specs:18]ID:1; $New))
	
	MESSAGE:C88(<>sCr+"Updating CaseForm…")
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23:=$New)
	
	MESSAGE:C88(<>sCr+"Updating Carton Spec…")
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProcessSpec:3=[Process_Specs:18]ID:1)
	APPLY TO SELECTION:C70([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProcessSpec:3:=$New)
	
	[Process_Specs:18]ID:1:=$New
	CLOSE WINDOW:C154($winRef)
End if 