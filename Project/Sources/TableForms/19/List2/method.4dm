// _______
// Method: [Estimates_Carton_Specs].List2   ( ) ->
// Description
// 
// ----------------------------------------------------


If (Form event code:C388=On Outside Call:K2:11)
	If ((<>sEstDiffID#"") & (<>sEstDiffID#<>sQtyWorksht))
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=<>TheEstID+<>sEstDiffID)
	Else 
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=<>TheEstID+"@")
	End if 
	gEstimateLDWkSh("Diff")
End if 