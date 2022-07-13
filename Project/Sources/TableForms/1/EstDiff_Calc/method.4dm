// Method: [zz_control].EstDiff_Calc ( )  -> 
// ----------------------------------------------------
//[control];"EstDiff_Calc   -JML   9/30/93
//used by gEstDiff_Calc() procedure
//3/31/95
//• 8/7/98 nlb

If (Form event code:C388=On Load:K2:1)
	If (<>NewAlloccat)
		t4:="Fixed/Variable Allocation"
	Else 
		t4:="Square Inch Allocation"
	End if 
	
	t4:=t4+", @ "+aMHRname{aMHRname}+" MHRs"
	OBJECT SET ENABLED:C1123(bPick; False:C215)
	
	asDiff:=0
	asBull:=0
	asDiffid:=0
	ListBox1:=0
	
	If (Size of array:C274(asDiff)=1)  //3/31/95
		asDiff:=1
		asDiffid:=1
		asBull:=1
		asBull{1}:="•"
		ListBox1{1}:=True:C214
		ACCEPT:C269
	End if 
	
End if 
//EOP