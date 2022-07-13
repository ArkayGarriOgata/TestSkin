//%attributes = {"publishedWeb":true}
//PM: JMI_CertOfAnal() -> 
//@author mlb - 3/18/02  10:46

C_LONGINT:C283($numAttributes; $pid; $numJMI; $winRef)

If (Count parameters:C259=0)
	$pid:=New process:C317("JMI_CertOfAnal"; <>lMinMemPart; "COA Worksheet"; <>JOBIT)
	If (False:C215)
		JMI_CertOfAnal
	End if 
	
Else 
	SET MENU BAR:C67(<>defaultmenu)
	READ WRITE:C146([Job_Forms_Items:44])
	$numJMI:=qryJMI(Substring:C12($1; 1; 8); 0; "@")
	If ($numJMI>0)
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
		READ WRITE:C146([Job_Forms_Items_CertOfAnal:117])
		READ ONLY:C145([Customers:16])
		READ ONLY:C145([Customers_Order_Lines:41])
		READ ONLY:C145([Finished_Goods:26])
		READ ONLY:C145([Finished_Goods_Specifications:98])
		READ ONLY:C145([Job_Forms_Materials:55])
		//• mlb - 9/24/02  15:06
		//load in the specifications for the report's calc
		ARRAY INTEGER:C220(aInteger; 0)
		ARRAY TEXT:C222(aAttribute; 0)
		ARRAY REAL:C219(aNominal; 0)
		ARRAY REAL:C219(aLowerLimit; 0)
		ARRAY REAL:C219(aUpperLimit; 0)
		ARRAY REAL:C219(aMean; 0)
		ARRAY REAL:C219(aStdDev; 0)
		ARRAY REAL:C219(aCpk; 0)
		ARRAY REAL:C219(aPPM; 0)
		READ ONLY:C145([QA_CertOfAnalysisSpecs:120])
		ALL RECORDS:C47([QA_CertOfAnalysisSpecs:120])
		SELECTION TO ARRAY:C260([QA_CertOfAnalysisSpecs:120]SortOrder:5; aInteger; [QA_CertOfAnalysisSpecs:120]Attribute:1; aAttribute; [QA_CertOfAnalysisSpecs:120]Nominal:2; aNominal; [QA_CertOfAnalysisSpecs:120]LowerLimit:3; aLowerLimit; [QA_CertOfAnalysisSpecs:120]UpperLimit:4; aUpperLimit)
		REDUCE SELECTION:C351([QA_CertOfAnalysisSpecs:120]; 0)
		SORT ARRAY:C229(aInteger; aAttribute; aNominal; aLowerLimit; aUpperLimit; >)
		
		$numAttributes:=Size of array:C274(aAttribute)
		ARRAY REAL:C219(aMean; $numAttributes)
		ARRAY REAL:C219(aStdDev; $numAttributes)
		ARRAY REAL:C219(aCpk; $numAttributes)
		ARRAY REAL:C219(aPPM; $numAttributes)
		
		FORM SET INPUT:C55([Job_Forms_Items:44]; "COAinput")
		FORM SET OUTPUT:C54([Job_Forms_Items:44]; "List")
		$winRef:=Open form window:C675([Job_Forms_Items:44]; "COAinput"; 8)
		MODIFY SELECTION:C204([Job_Forms_Items:44]; *)
		CLOSE WINDOW:C154($winRef)
		FORM SET INPUT:C55([Job_Forms_Items:44]; "Input")
		
		ARRAY INTEGER:C220(aInteger; 0)
		ARRAY TEXT:C222(aAttribute; 0)
		ARRAY REAL:C219(aNominal; 0)
		ARRAY REAL:C219(aLowerLimit; 0)
		ARRAY REAL:C219(aUpperLimit; 0)
		ARRAY REAL:C219(aMean; 0)
		ARRAY REAL:C219(aStdDev; 0)
		ARRAY REAL:C219(aCpk; 0)
		ARRAY REAL:C219(aPPM; 0)
		
		REDUCE SELECTION:C351([Job_Forms_Items_CertOfAnal:117]; 0)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		REDUCE SELECTION:C351([Customers:16]; 0)
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
		
	Else 
		BEEP:C151
		ALERT:C41($1+" was not found")
	End if 
	
End if 