//%attributes = {"publishedWeb":true}
//sOSsetup      modified-JML   8/20/93, mlb 1/20/94
//•053095  MLB  UPR 1501 allow setup via opsequences
//This procedure allows the user to define the operation sequence used
//for a form or a process.  This interface can be used at any time
//to modify & update an existing operational sequnce or to create
//a brand new sequence.
//The procedure also is used to manipulate materials of an Estimate.
//$1 = "Process" , "Prep", "Form", "Material-Prep", "Material-Prod", "Material-Pro
C_TEXT:C284($1; vSetupWhat)
C_TEXT:C284($2; sCC)  //•053095  MLB  UPR 1501, optional cc id
C_LONGINT:C283($3; iCCseq; $winRef)  //•053095  MLB  UPR 1501, optional sequence
If (Count parameters:C259=3)  //•053095  MLB  UPR 1501
	sCC:=$2
	iCCseq:=$3
Else 
	sCC:=""
	iCCseq:=0
End if 

If (Count parameters:C259>0)
	vSetupWhat:=$1
Else 
	vSetUpWhat:="Process"
End if 

C_TEXT:C284($Title)
If (Substring:C12($1; 1; 8)="Material")
	$Title:="Materials Setup"
Else 
	$Title:="Operations Setup"
End if 


$winRef:=OpenFormWindow(->[Process_Specs:18]; "OperSeqSetup")
DIALOG:C40([Process_Specs:18]; "OperSeqSetup")
CLOSE WINDOW:C154($winRef)
If ((ok=1))
	Est_Transit
	If (($1="Form") | ($1="Material-Prod"))
		[Estimates_DifferentialsForms:47]CostTTL:18:=0  //init the calc fields
		[Estimates_DifferentialsForms:47]CostTtlOH:16:=0
		[Estimates_DifferentialsForms:47]CostTtlMatl:17:=0
		[Estimates_DifferentialsForms:47]CostTtlLabor:15:=0
		[Estimates_DifferentialsForms:47]Cost_Overtime:25:=0
		[Estimates_DifferentialsForms:47]SheetsQtyGross:19:=0
		[Estimates_DifferentialsForms:47]Cost_Scrap:24:=0
		[Estimates_DifferentialsForms:47]Cost_Dups:20:=0
		[Estimates_DifferentialsForms:47]Cost_Plates:21:=0
		[Estimates_DifferentialsForms:47]Cost_Dies:22:=0
		SAVE RECORD:C53([Estimates_DifferentialsForms:47])
		
		If ([Estimates_DifferentialsForms:47]DiffId:1=[Estimates_Differentials:38]Id:1)
			[Estimates_Differentials:38]CostTtlLabor:11:=0
			[Estimates_Differentials:38]CostTtlOH:12:=0
			[Estimates_Differentials:38]CostTtlMatl:13:=0
			[Estimates_Differentials:38]Cost_Overtime:17:=0
			[Estimates_Differentials:38]Cost_Scrap:15:=0
			[Estimates_Differentials:38]CostTTL:14:=0
			[Estimates_Differentials:38]Cost_Dups:19:=0
			[Estimates_Differentials:38]Cost_Plates:20:=0
			[Estimates_Differentials:38]Cost_Dies:21:=0
			Estimate_ReCalcNeeded
		End if 
		
	End if   //ok
	
End if 

//