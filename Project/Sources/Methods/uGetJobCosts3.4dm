//%attributes = {"publishedWeb":true}
//uGetJobCosts3(»real;»real;»real;»real;»real) uGetJobCosts2
//10/11/94
//12/8/94
//•070795 KS said to include CC
//•021696  mBohince  exclude closed orderliens
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_REAL:C285($thousand; $yield)
	C_LONGINT:C283($openDemand; $onHandFG; $i; $numRecs)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	$numRecs:=qryOpenOrdLines(""; "*")
	$openDemand:=0
	FIRST RECORD:C50([Customers_Order_Lines:41])
	For ($i; 1; $numRecs)
		//If ([OrderLines]Qty_Open>0)  `don't include negatives
		$openDemand:=$openDemand+([Customers_Order_Lines:41]Qty_Open:11+([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100)))
		// End if 
		NEXT RECORD:C51([Customers_Order_Lines:41])
	End for 
	
	CREATE SET:C116([Finished_Goods_Locations:35]; "Examining")
	//make sure FG: is valued first
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	$onHandFG:=0
	For ($i; 1; $numRecs)
		$onHandFG:=$onHandFG+[Finished_Goods_Locations:35]QtyOH:9
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	$openDemand:=$openDemand-$onHandFG
	USE SET:C118("Examining")
	CLEAR SET:C117("Examining")
	//end the new stuff
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >)
		FIRST RECORD:C50([Finished_Goods_Locations:35])
		
		
	Else 
		
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >)
		
		
	End if   // END 4D Professional Services : January 2019 First record
	
	For ($i; 1; $numRecs)
		If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]CustId:15#[Finished_Goods_Locations:35]CustID:16))
			qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)
			//SEARCH([JobMakesItem];[JobMakesItem]JobForm=[FG_Locations]JobForm;*)
			//SEARCH([JobMakesItem]; & [JobMakesItem]CustId=[FG_Locations]CustID;*)
			//SEARCH([JobMakesItem]; & [JobMakesItem]ProductCode=[FG_Locations]ProductCode)
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
		End if 
		
		$yield:=[Finished_Goods_Locations:35]PercentYield:17/100
		If (False:C215)
			If (([Job_Forms_Items:44]ItemNumber:7>=50) & (Count parameters:C259>5))  //old excess item
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000*$yield
				$6->:=$6->+([Finished_Goods_Locations:35]QtyOH:9*$yield)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
			Else 
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000*$yield
				$1->:=$1->+([Finished_Goods_Locations:35]QtyOH:9*$yield)
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
			End if 
		End if   //false
		//new here
		Case of 
			: ($openDemand<=0)  //none of this bin is valued
				$thousand:=([Finished_Goods_Locations:35]QtyOH:9/1000)*$yield
				$6->:=$6->+([Finished_Goods_Locations:35]QtyOH:9*$yield)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-([Finished_Goods_Locations:35]QtyOH:9*$yield)
				
			: ($openDemand>=([Finished_Goods_Locations:35]QtyOH:9*$yield))  //all of this bin is valued
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000*$yield
				$1->:=$1->+([Finished_Goods_Locations:35]QtyOH:9*$yield)
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-([Finished_Goods_Locations:35]QtyOH:9*$yield)
				
			: ($openDemand<([Finished_Goods_Locations:35]QtyOH:9*$yield))  //some of this bin is valued
				
				$thousand:=$openDemand/1000
				$1->:=$1->+$openDemand
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$thousand:=(([Finished_Goods_Locations:35]QtyOH:9*$yield)-$openDemand)/1000
				$6->:=$6->+(([Finished_Goods_Locations:35]QtyOH:9*$yield)-$openDemand)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$openDemand:=$openDemand-([Finished_Goods_Locations:35]QtyOH:9*$yield)
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts3, $openDemand test failed.")
		End case 
		//end new
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	//
Else 
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_REAL:C285($thousand; $yield)
	C_LONGINT:C283($openDemand; $onHandFG; $i; $numRecs)
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
	
	ARRAY LONGINT:C221($_Qty_Open; 0)
	ARRAY LONGINT:C221($_Quantity; 0)
	ARRAY REAL:C219($_OverRun; 0)
	
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]OverRun:25; $_OverRun)
	
	$numRecs:=Size of array:C274($_OverRun)
	
	$openDemand:=0
	For ($i; 1; $numRecs)
		$openDemand:=$openDemand+($_Qty_Open{$i}+($_Quantity{$i}*($_OverRun{$i}/100)))
	End for 
	
	//4D PS :we gona don't use set
	
	ARRAY TEXT:C222($_JobForm; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	ARRAY REAL:C219($_PercentYield; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $_JobForm; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; [Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; [Finished_Goods_Locations:35]PercentYield:17; $_PercentYield)
	
	SORT ARRAY:C229($_JobForm; $_ProductCode; $_CustID; $_QtyOH; $_PercentYield; >)
	
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
	
	
	ARRAY LONGINT:C221($_QtyOH1; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $_QtyOH1)
	$numRecs:=Size of array:C274($_QtyOH1)
	
	$onHandFG:=0
	For ($i; 1; $numRecs)
		$onHandFG:=$onHandFG+$_QtyOH1{$i}
	End for 
	$openDemand:=$openDemand-$onHandFG
	
	
	$numRecs:=Size of array:C274($_CustID)
	
	For ($i; 1; $numRecs)
		If (([Job_Forms_Items:44]JobForm:1#$_JobForm{$i}) | ([Job_Forms_Items:44]ProductCode:3#$_ProductCode{$i}) | ([Job_Forms_Items:44]CustId:15#$_CustID{$i}))
			qryJMI($_JobForm{$i}; 0; $_ProductCode{$i})
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
		End if 
		
		$yield:=$_PercentYield{$i}/100
		
		Case of 
			: ($openDemand<=0)  //none of this bin is valued
				$thousand:=($_QtyOH{$i}/1000)*$yield
				$6->:=$6->+($_QtyOH{$i}*$yield)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-($_QtyOH{$i}*$yield)
				
			: ($openDemand>=($_QtyOH{$i}*$yield))  //all of this bin is valued
				$thousand:=$_QtyOH{$i}/1000*$yield
				$1->:=$1->+($_QtyOH{$i}*$yield)
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-($_QtyOH{$i}*$yield)
				
			: ($openDemand<($_QtyOH{$i}*$yield))  //some of this bin is valued
				
				$thousand:=$openDemand/1000
				$1->:=$1->+$openDemand
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$thousand:=(($_QtyOH{$i}*$yield)-$openDemand)/1000
				$6->:=$6->+(($_QtyOH{$i}*$yield)-$openDemand)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$openDemand:=$openDemand-($_QtyOH{$i}*$yield)
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts3, $openDemand test failed.")
		End case 
		//end new
		
	End for 
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	//
End if   // END 4D Professional Services : January 2019 First record
