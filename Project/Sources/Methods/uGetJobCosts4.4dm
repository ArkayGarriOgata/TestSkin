//%attributes = {"publishedWeb":true}
//uGetJobCosts4(»real;»real;»real;»real;»real)
//10/11/94
//12/8/94
//•070795 KS said to include CC
//•111396  mBohince  ignor closed orders and pick up XC
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_LONGINT:C283($openDemand)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	$numRecs:=qryOpenOrdLines(""; "*")  //`•111396  mBohince  elem closed orders
	$openDemand:=0
	FIRST RECORD:C50([Customers_Order_Lines:41])
	While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
		$openDemand:=$openDemand+([Customers_Order_Lines:41]Qty_Open:11+([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100)))
		NEXT RECORD:C51([Customers_Order_Lines:41])
	End while 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //`•111396  mBohince 
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >)
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
		If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]CustId:15#[Finished_Goods_Locations:35]CustID:16))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Finished_Goods_Locations:35]JobForm:19; *)
			//SEARCH([JobMakesItem]; & [JobMakesItem]CustId=[FG_Locations]CustID;*)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods_Locations:35]ProductCode:1)
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
		End if 
		
		C_REAL:C285($thousand)
		
		//  If (([JobMakesItem]ItemNumber>=50) & (Count parameters>5))  `old excess item 
		Case of 
			: ($openDemand<=0)  //none of this bin is valued
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000
				$6->:=$6->+[Finished_Goods_Locations:35]QtyOH:9
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			: ($openDemand>=[Finished_Goods_Locations:35]QtyOH:9)  //all of this bin is valued
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000
				$1->:=$1->+[Finished_Goods_Locations:35]QtyOH:9
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			: ($openDemand<[Finished_Goods_Locations:35]QtyOH:9)  //some of this bin is valued
				
				$thousand:=$openDemand/1000
				$1->:=$1->+$openDemand
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$thousand:=([Finished_Goods_Locations:35]QtyOH:9-$openDemand)/1000
				$6->:=$6->+([Finished_Goods_Locations:35]QtyOH:9-$openDemand)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$openDemand:=$openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts, $openDemand test failed.")
		End case 
		//end if
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End while 
	
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="Ex:@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >)
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	While (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
		If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]CustId:15#[Finished_Goods_Locations:35]CustID:16))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Finished_Goods_Locations:35]JobForm:19; *)
			//SEARCH([JobMakesItem]; & [JobMakesItem]CustId=[FG_Locations]CustID;*)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods_Locations:35]ProductCode:1)
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
		End if 
		
		C_REAL:C285($yield)
		$yield:=[Finished_Goods_Locations:35]PercentYield:17/100
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
				ALERT:C41("Error called by uGetJobCosts4, $openDemand test failed.")
		End case 
		//end new
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End while 
	
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	
Else 
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_LONGINT:C283($openDemand)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)
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
	
	
	For ($i; 1; $numRecs; 1)
		
		$openDemand:=$openDemand+($_Qty_Open{$i}+($_Quantity{$i}*($_OverRun{$i}/100)))
		
	End for 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //`•111396  mBohince 
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
	
	ARRAY TEXT:C222($_JobForm; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	ARRAY REAL:C219($_PercentYield; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $_JobForm; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; [Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
	
	SORT ARRAY:C229($_JobForm; $_ProductCode; $_CustID; $_QtyOH; >)
	
	$numRecs:=Size of array:C274($_CustID)
	
	For ($i; 1; $numRecs; 1)
		If (([Job_Forms_Items:44]JobForm:1#$_JobForm{$i}) | ([Job_Forms_Items:44]ProductCode:3#$_ProductCode{$i}) | ([Job_Forms_Items:44]CustId:15#$_CustID{$i}))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$_JobForm{$i}; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=$_ProductCode{$i})
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
		End if 
		
		C_REAL:C285($thousand)
		
		Case of 
			: ($openDemand<=0)  //none of this bin is valued
				$thousand:=$_QtyOH{$i}/1000
				$6->:=$6->+$_QtyOH{$i}
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-$_QtyOH{$i}
				
			: ($openDemand>=$_QtyOH{$i})  //all of this bin is valued
				$thousand:=$_QtyOH{$i}/1000
				$1->:=$1->+$_QtyOH{$i}
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				$openDemand:=$openDemand-$_QtyOH{$i}
				
			: ($openDemand<$_QtyOH{$i})  //some of this bin is valued
				
				$thousand:=$openDemand/1000
				$1->:=$1->+$openDemand
				$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$thousand:=($_QtyOH{$i}-$openDemand)/1000
				$6->:=$6->+($_QtyOH{$i}-$openDemand)
				$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
				$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
				$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				
				$openDemand:=$openDemand-$_QtyOH{$i}
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts, $openDemand test failed.")
		End case 
		
	End for 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="Ex:@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $_JobForm; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; [Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; [Finished_Goods_Locations:35]PercentYield:17; $_PercentYield)
	
	SORT ARRAY:C229($_JobForm; $_ProductCode; $_CustID; $_QtyOH; $_PercentYield; >)
	
	$numRecs:=Size of array:C274($_CustID)
	
	For ($i; 1; $numRecs; 1)
		If (([Job_Forms_Items:44]JobForm:1#$_JobForm{$i}) | ([Job_Forms_Items:44]ProductCode:3#$_ProductCode{$i}) | ([Job_Forms_Items:44]CustId:15#$_CustID{$i}))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$_JobForm{$i}; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=$_ProductCode{$i})
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
		End if 
		
		C_REAL:C285($yield)
		$yield:=$_PercentYield{$i}/100
		//new here
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
				ALERT:C41("Error called by uGetJobCosts4, $openDemand test failed.")
		End case 
		//end new
		
	End for 
	
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	
End if   // END 4D Professional Services : January 2019 First record
