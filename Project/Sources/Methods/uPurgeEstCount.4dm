//%attributes = {"publishedWeb":true}
//Procedure: uPurgeEstCount()  062995  MLB
//•062995  MLB  UPR 1507
C_TEXT:C284($1)  //complete removal unless parameter 1 is sent

r63:=r63+Records in selection:C76([Estimates_Carton_Specs:19])
r64:=r64+Records in selection:C76([Estimates_Differentials:38])
r65:=r65+Records in selection:C76([Estimates_DifferentialsForms:47])
r66:=r66+Records in selection:C76([Estimates_Materials:29])
r67:=r67+Records in selection:C76([Estimates_Machines:20])
r68:=r68+Records in selection:C76([Estimates_FormCartons:48])

If (Count parameters:C259<1)  //complete remove
	r61:=r61+Records in selection:C76([Estimates_PSpecs:57])
	
	
End if 
//