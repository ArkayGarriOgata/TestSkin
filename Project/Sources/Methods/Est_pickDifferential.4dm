//%attributes = {"publishedWeb":true}
//PM: Est_pickDifferential() -> 
//@author mlb - 5/20/02  10:46
//[control];"EnterJob'  sPONum script    -JML   9/18/93

C_LONGINT:C283($T)
ARRAY TEXT:C222(asBull; 0)
ARRAY TEXT:C222(asDiff; 0)
ARRAY TEXT:C222(asCaseID; 0)

asDiff:=0
asCaseID:=0
asBull:=0

OBJECT SET ENABLED:C1123(bPick; False:C215)

If (Length:C16(sPONum)=9)
	READ WRITE:C146([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=sPONum)
	If (Records in selection:C76([Estimates:17])=1)
		RELATE MANY:C262([Estimates:17]EstimateNo:1)  //get case scenarios, carton specs
		SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; asCaseID; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
		
		SORT ARRAY:C229(asDiff; >)
		$T:=Size of array:C274(asDiff)
		ARRAY TEXT:C222(asBull; $T)
		If ($T>0)
			asBull{1}:="•"
		End if 
		OBJECT SET ENABLED:C1123(bPick; True:C214)
		asCaseID:=0
		asDiff:=0
		asBull:=0
		If ([Estimates:17]z_Cost_TotalPrep:9#0)
			INSERT IN ARRAY:C227(asDiff; 1; 1)
			INSERT IN ARRAY:C227(asBull; 1; 1)
			INSERT IN ARRAY:C227(asCaseID; 1; 1)
			asDiff{1}:="Preparatory"
		End if 
		$T:=Size of array:C274(asDiff)
		If ($T=0)
			BEEP:C151
			ALERT:C41(sPONum+" does not have any estimate information within it.")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41(sPONum+" not found.")
	End if   //found estimate  
	
Else 
	BEEP:C151
	ALERT:C41(sPONum+" is not a valid estimate number.")
End if 