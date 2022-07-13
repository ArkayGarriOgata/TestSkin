//%attributes = {"publishedWeb":true}
//pSpecEstimateLd()    `-JML    9/27/93
//Loads in any combination of the2 files of a Process Spec estimating files:
//[machine_PSpec], [materials_pSpec]
// $1 = "" or "Mach"
// $2 = "" or "Mat"

C_TEXT:C284($1; $2)
C_LONGINT:C283($Parameters)

$Parameters:=Count parameters:C259

If ($Parameters>=1)
	If (Substring:C12($1; 1; 4)="Mach")
		QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1=[Process_Specs:18]ID:1; *)
		QUERY:C277([Process_Specs_Machines:28];  & ; [Process_Specs_Machines:28]CustID:2=[Process_Specs:18]Cust_ID:4)
	End if 
End if 

If ($Parameters>=2)
	If (Substring:C12($2; 1; 3)="Mat")
		QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CustID:2=[Process_Specs:18]Cust_ID:4)
	End if 
End if 