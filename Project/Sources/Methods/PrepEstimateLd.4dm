//%attributes = {"publishedWeb":true}
//PrepEstimateLd()    `-JML    9/1/93
//Loads in any combination of the three files of a Prep estimate:
//[machine_est], [materials_est], [Prep_spec]
// $1 = "" or "Mach"
// $2 = "" or "Mat"

C_TEXT:C284($1; $2; $3; $4)
C_LONGINT:C283($Parameters)

$Parameters:=Count parameters:C259

If ($Parameters>=1)
	If (Substring:C12($1; 1; 4)="Mach")
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]EstimateNo:14=[Estimates:17]EstimateNo:1; *)
		QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]EstimateType:16="Prep")
	End if 
End if 

If ($Parameters>=2)
	If (Substring:C12($2; 1; 3)="Mat")
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]EstimateNo:5=[Estimates:17]EstimateNo:1; *)
		QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]EstimateType:7="Prep")
	End if 
End if 