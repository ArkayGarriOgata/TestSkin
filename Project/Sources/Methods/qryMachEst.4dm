//%attributes = {"publishedWeb":true}
//(p) qryMachEst
//•072195  MLB  UPR 1684

C_REAL:C285($allHrs; $6)
C_LONGINT:C283($0)

Case of 
	: (Count parameters:C259=0)
		If ([Estimates_Machines:20]DiffFormID:1#[Estimates_Materials:29]DiffFormID:1) | ([Estimates_Machines:20]CostCtrID:4#[Estimates_Materials:29]CostCtrID:2) | ([Estimates_Machines:20]Sequence:5#[Estimates_Materials:29]Sequence:12)
			QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_Materials:29]DiffFormID:1; *)
			QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]CostCtrID:4=[Estimates_Materials:29]CostCtrID:2; *)
			QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]Sequence:5=[Estimates_Materials:29]Sequence:12)
		End if 
		
	: (Count parameters:C259>=5)  //called from fCalcPrepScreen
		If (([Estimates_Machines:20]EstimateNo:14#$1) | ([Estimates_Machines:20]CostCtrID:4#$2) | ([Estimates_Machines:20]Sequence:5#$3) | ([Estimates_Machines:20]EstimateType:16#$4))
			USE SET:C118("PrepMach")  //•072895  MLB  
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4=$2; *)
			QUERY SELECTION:C341([Estimates_Machines:20];  & ; [Estimates_Machines:20]Sequence:5=$3)
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			
			//SEARCH([Machine_Est];[Machine_Est]EstimateNo=$1;*)
			//SEARCH([Machine_Est]; & [Machine_Est]CostCtrID=$2;*)
			//SEARCH([Machine_Est]; & [Machine_Est]Sequence=$3;*)
			//SEARCH([Machine_Est]; & [Machine_Est]EstimateType=$4)
		End if 
		C_BOOLEAN:C305($new)
		If (Records in selection:C76([Estimates_Machines:20])=0)
			CREATE RECORD:C68([Estimates_Machines:20])
			[Estimates_Machines:20]DiffFormID:1:=$1
			[Estimates_Machines:20]CostCtrID:4:=$2
			[Estimates_Machines:20]Sequence:5:=$3
			[Estimates_Machines:20]CostCtrName:2:=[Cost_Centers:27]Description:3
			[Estimates_Machines:20]EstimateNo:14:=$1
			[Estimates_Machines:20]EstimateType:16:=$4
			$new:=True:C214
		Else 
			$new:=False:C215
		End if 
		[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MakeReadyHrs:30+$5  //$MRrate
		If (Count parameters:C259=6)
			[Estimates_Machines:20]RunningHrs:32:=[Estimates_Machines:20]RunningHrs:32+$6
			$allHrs:=$5+$6
		Else 
			[Estimates_Machines:20]RunningHrs:32:=[Estimates_Machines:20]RunningHrs:32+0
			$allHrs:=$5
		End if 
		[Estimates_Machines:20]RunningRate:31:=0
		//•072195  MLB  UPR 1684 add costs
		If ([Cost_Centers:27]AddScrapExcess:25)
			[Estimates_Machines:20]CostScrap:12:=[Estimates_Machines:20]CostScrap:12+($allHrs*[Cost_Centers:27]ScrapExcessCost:32)
		End if 
		[Estimates_Machines:20]CostLabor:13:=[Estimates_Machines:20]CostLabor:13+($allHrs*[Cost_Centers:27]MHRlaborSales:4)
		[Estimates_Machines:20]CostOverhead:15:=[Estimates_Machines:20]CostOverhead:15+($allHrs*[Cost_Centers:27]MHRburdenSales:5)
		[Estimates_Machines:20]CostOOP:28:=[Estimates_Machines:20]CostOOP:28+($allHrs*[Cost_Centers:27]MHRoopSales:7)
		[Estimates_Machines:20]OOPStd:17:=[Cost_Centers:27]MHRoopSales:7
		[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
		//end 1684
		SAVE RECORD:C53([Estimates_Machines:20])
		If ($new)
			ADD TO SET:C119([Estimates_Machines:20]; "PrepMach")
		End if 
		
	: (Count parameters:C259=4)  //called from fCalcPrepScreen
		If (([Estimates_Machines:20]EstimateNo:14#$1) | ([Estimates_Machines:20]CostCtrID:4#$2) | ([Estimates_Machines:20]Sequence:5#$3) | ([Estimates_Machines:20]EstimateType:16#$4))
			QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]EstimateNo:14=$1; *)
			QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]CostCtrID:4=$2; *)
			QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]Sequence:5=$3; *)
			QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]EstimateType:16=$4)
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Parameter error called be qryMachEst")
End case 
$0:=Records in selection:C76([Estimates_Machines:20])