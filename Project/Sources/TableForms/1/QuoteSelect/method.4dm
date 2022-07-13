// ----------------------------------------------------
// Form Method: [zz_control].QuoteSelect
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	C_LONGINT:C283($T)
	
	rbCopy:=1
	sProfile:=""
	sQtrYrIntro:=""
	SetObjectProperties(""; ->sProfile; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sQtrYrIntro; True:C214; ""; False:C215)
	
	ARRAY TEXT:C222(asBull; 0)
	ARRAY TEXT:C222(asDiff; 0)
	ARRAY TEXT:C222(asCaseID; 0)
	
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)  //get case scenarios, carton specs
	SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; asCaseID; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
	$T:=Size of array:C274(asDiff)
	SORT ARRAY:C229(asCaseID; asDiff; >)
	ARRAY TEXT:C222(asBull; $T)
	asDiff:=0
	asCaseID:=0
	asBull:=0
	If ($t>=1)
		asBull{1}:="•"
	End if 
	LISTBOX SELECT ROW:C912(abDiffsLB; 0; 2)
End if 