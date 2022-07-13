//%attributes = {"publishedWeb":true}
//Procedure: uPurgeEstDel("*")  062995  MLB
//•062995  MLB  UPR 1507

//see also gEstDel

C_TEXT:C284($1)  //complete removal unless parameter 1 is sent
util_DeleteSelection(->[Estimates_Carton_Specs:19]; "*")
util_DeleteSelection(->[Estimates_Differentials:38]; "*")
util_DeleteSelection(->[Estimates_DifferentialsForms:47]; "*")
util_DeleteSelection(->[Estimates_Materials:29]; "*")
util_DeleteSelection(->[Estimates_Machines:20]; "*")
util_DeleteSelection(->[Estimates_FormCartons:48]; "*")


If (Count parameters:C259<1)  //complete remove
	util_DeleteSelection(->[Estimates_PSpecs:57]; "*")
	util_DeleteSelection(->[Estimates:17]; "*")
End if 
//