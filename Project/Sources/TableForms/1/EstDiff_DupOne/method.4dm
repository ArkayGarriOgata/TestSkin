//[control];"EstDiff_DupOne   -JML   9/29/93
//used by gEstDiff_DupOne() procedure
If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(bOk; False:C215)
	ARRAY TEXT:C222(asDiff; 0)
	ARRAY BOOLEAN:C223(ListBox1; 0)
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)  //get existing differentials
	SELECTION TO ARRAY:C260([Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
	asDiff:=0
End if 
//EOP