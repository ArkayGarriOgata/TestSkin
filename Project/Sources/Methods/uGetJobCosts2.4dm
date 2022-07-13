//%attributes = {"publishedWeb":true}
//uGetJobCosts2 (»real;»real;»real;»real;»real)
//mod 9/13/94 upr120
//10/11/94
//•072998  MLB  test flag for closed JMI record, then use Actual Costs
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_LONGINT:C283($i; $numRecs)
	C_REAL:C285($thousand; $yield; $scrap)
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >)
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	For ($i; 1; $numRecs)
		//While (Not(End selection([FG_Locations])))
		If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]CustId:15#[Finished_Goods_Locations:35]CustID:16))
			qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)
			//SEARCH([JobMakesItem];[JobMakesItem]JobForm=[FG_Locations]JobForm;*)
			//SEARCH([JobMakesItem]; & [JobMakesItem]CustId=[FG_Locations]CustID;*)
			//SEARCH([JobMakesItem]; & [JobMakesItem]ProductCode=[FG_Locations]ProductCode)
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
			If ([Job_Forms_Items:44]FormClosed:5) & (<>UseActCost)  //•072998  MLB  
				t3a:=t3a+"Closed"
				$matl:=[Job_Forms_Items:44]Cost_Mat:12
				$labor:=[Job_Forms_Items:44]Cost_LAB:13
				$burden:=[Job_Forms_Items:44]Cost_Burd:14
			Else 
				$matl:=[Job_Forms_Items:44]PldCostMatl:17
				$labor:=[Job_Forms_Items:44]PldCostLab:18
				$burden:=[Job_Forms_Items:44]PldCostOvhd:19
			End if 
		End if 
		
		$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000
		$yield:=[Finished_Goods_Locations:35]PercentYield:17/100
		$scrap:=1-([Finished_Goods_Locations:35]PercentYield:17/100)
		
		$1->:=$1->+([Finished_Goods_Locations:35]QtyOH:9*$yield)
		$2->:=$2->+Round:C94($matl*$thousand*$yield; 0)
		$3->:=$3->+Round:C94($labor*$thousand*$yield; 0)
		$4->:=$4->+Round:C94($burden*$thousand*$yield; 0)
		
		$6->:=$6->+([Finished_Goods_Locations:35]QtyOH:9*$scrap)
		$7->:=$7->+Round:C94($matl*$thousand*$scrap; 0)
		$8->:=$8->+Round:C94($labor*$thousand*$scrap; 0)
		$9->:=$9->+Round:C94($burden*$thousand*$scrap; 0)
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	//
Else 
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_LONGINT:C283($i; $numRecs)
	C_REAL:C285($thousand; $yield; $scrap)
	
	ARRAY TEXT:C222($_JobForm; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	ARRAY REAL:C219($_PercentYield; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $_JobForm; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; [Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; [Finished_Goods_Locations:35]PercentYield:17; $_PercentYield)
	
	SORT ARRAY:C229($_JobForm; $_ProductCode; $_CustID; $_QtyOH; $_PercentYield; >)
	
	$numRecs:=Size of array:C274($_JobForm)
	
	For ($i; 1; $numRecs)
		If (([Job_Forms_Items:44]JobForm:1#$_JobForm{$i}) | ([Job_Forms_Items:44]ProductCode:3#$_ProductCode{$i}) | ([Job_Forms_Items:44]CustId:15#$_CustID{$i}))
			qryJMI($_JobForm{$i}; 0; $_ProductCode{$i})
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
			If ([Job_Forms_Items:44]FormClosed:5) & (<>UseActCost)  //•072998  MLB  
				t3a:=t3a+"Closed"
				$matl:=[Job_Forms_Items:44]Cost_Mat:12
				$labor:=[Job_Forms_Items:44]Cost_LAB:13
				$burden:=[Job_Forms_Items:44]Cost_Burd:14
			Else 
				$matl:=[Job_Forms_Items:44]PldCostMatl:17
				$labor:=[Job_Forms_Items:44]PldCostLab:18
				$burden:=[Job_Forms_Items:44]PldCostOvhd:19
			End if 
		End if 
		
		$thousand:=$_QtyOH{$i}/1000
		$yield:=$_PercentYield{$i}/100
		$scrap:=1-($_PercentYield{$i}/100)
		
		$1->:=$1->+($_QtyOH{$i}*$yield)
		$2->:=$2->+Round:C94($matl*$thousand*$yield; 0)
		$3->:=$3->+Round:C94($labor*$thousand*$yield; 0)
		$4->:=$4->+Round:C94($burden*$thousand*$yield; 0)
		
		$6->:=$6->+($_QtyOH{$i}*$scrap)
		$7->:=$7->+Round:C94($matl*$thousand*$scrap; 0)
		$8->:=$8->+Round:C94($labor*$thousand*$scrap; 0)
		$9->:=$9->+Round:C94($burden*$thousand*$scrap; 0)
		
	End for 
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	//
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
