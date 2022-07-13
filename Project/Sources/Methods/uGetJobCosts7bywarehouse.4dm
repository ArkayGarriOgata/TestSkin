//%attributes = {"publishedWeb":true}
//PM:  uGetJobCosts7bywarehouse  081899  mlb
//•081899  mlb  UPR 2053
//based on uGetJobCosts(»real;»real;»real;»real;»real)  
//10/11/94
//12/8/94 use var openDemand set by calling proc to determine value
//•072998  MLB  test flag for closed JMI record, then use Actual Costs
//here begins the new stuff
//   find the current demand for this item to pass this into the uGetJobCost to 
//    decide if valued or excess
//•111398  MLB  UPR test for ◊UseNRV flag, lower of market or cost
//If ([Finished_Goods]ProductCode="P0266") | ([Finished_Goods]ProductCode=
//«"P0270")
//TRACE
//End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_LONGINT:C283($openDemand; $numRecs; $i)
	C_REAL:C285($thousand; $matl; $labor; $burden)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	$openDemand:=ORD_GetOpenDemand
	
	
	If (Substring:C12(t2; 1; 1)="R")  //for Roanoke, reduce open demand by the amount in the Hauppauge warehouse
		$hit:=Find in array:C230(<>aFGKey; ([Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1))
		If ($hit>-1)
			$openDemand:=$openDemand-<>aQty_OH{$hit}
			If ($openDemand<0)
				$openDemand:=0
			End if 
		End if 
	End if 
	
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Finished_Goods_Locations:35])
		
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	
	For ($i; 1; $numRecs)
		If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]CustId:15#[Finished_Goods_Locations:35]CustID:16))
			qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
			If ([Job_Forms_Items:44]FormClosed:5) & (<>UseActCost)  //•072998  MLB  
				t3a:=t3a+"$Act"
				$matl:=[Job_Forms_Items:44]Cost_Mat:12
				$labor:=[Job_Forms_Items:44]Cost_LAB:13
				$burden:=[Job_Forms_Items:44]Cost_Burd:14
			Else 
				$matl:=[Job_Forms_Items:44]PldCostMatl:17
				$labor:=[Job_Forms_Items:44]PldCostLab:18
				$burden:=[Job_Forms_Items:44]PldCostOvhd:19
			End if 
			
			If (<>UseNRV)  //•111398  MLB  htk request
				$jobCost:=$matl+$labor+$burden  //current valuation 
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
				If (Records in selection:C76([Customers_Order_Lines:41])>0)
					$ordValue:=[Customers_Order_Lines:41]Price_Per_M:8
				Else 
					$ordValue:=0
				End if 
				
				If ($ordValue<$jobCost)  //report lower cost        
					t3a:=t3a+"$NRV"
					If ($ordValue>0) & ($jobCost#0)
						$reduction:=$ordValue/$jobCost
						$matl:=$matl*$reduction
						$labor:=$labor*$reduction
						$burden:=$burden*$reduction
					Else 
						$matl:=0
						$labor:=0
						$burden:=0
					End if 
				End if   //adj required
				
			End if   //•111398  MLB  end htk request
			
		End if 
		
		Case of 
			: ($openDemand<=0)  //none of this bin is valued
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000
				$6->:=$6->+[Finished_Goods_Locations:35]QtyOH:9
				$7->:=$7->+Round:C94($matl*$thousand; 0)
				$8->:=$8->+Round:C94($labor*$thousand; 0)
				$9->:=$9->+Round:C94($burden*$thousand; 0)
				$openDemand:=$openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			: ($openDemand>=[Finished_Goods_Locations:35]QtyOH:9)  //all of this bin is valued
				$thousand:=[Finished_Goods_Locations:35]QtyOH:9/1000
				$1->:=$1->+[Finished_Goods_Locations:35]QtyOH:9
				$2->:=$2->+Round:C94($matl*$thousand; 0)
				$3->:=$3->+Round:C94($labor*$thousand; 0)
				$4->:=$4->+Round:C94($burden*$thousand; 0)
				$openDemand:=$openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			: ($openDemand<[Finished_Goods_Locations:35]QtyOH:9)  //some of this bin is valued
				
				$thousand:=$openDemand/1000
				$1->:=$1->+$openDemand
				$2->:=$2->+Round:C94($matl*$thousand; 0)
				$3->:=$3->+Round:C94($labor*$thousand; 0)
				$4->:=$4->+Round:C94($burden*$thousand; 0)
				
				$thousand:=([Finished_Goods_Locations:35]QtyOH:9-$openDemand)/1000
				$6->:=$6->+([Finished_Goods_Locations:35]QtyOH:9-$openDemand)
				$7->:=$7->+Round:C94($matl*$thousand; 0)
				$8->:=$8->+Round:C94($labor*$thousand; 0)
				$9->:=$9->+Round:C94($burden*$thousand; 0)
				
				$openDemand:=$openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts, $openDemand test failed.")
		End case 
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	
Else 
	
	C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
	C_LONGINT:C283($openDemand; $numRecs; $i)
	C_REAL:C285($thousand; $matl; $labor; $burden)
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $aOpen; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]OverRun:25; $aOR)
	$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
	For ($i; 1; $numRecs)
		$openDemand:=$openDemand+($aOpen{$i}+($aQty{$i}*($aOR{$i}/100)))
	End for 
	
	
	
	If (Substring:C12(t2; 1; 1)="R")  //for Roanoke, reduce open demand by the amount in the Hauppauge warehouse
		$hit:=Find in array:C230(<>aFGKey; ([Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1))
		If ($hit>-1)
			$openDemand:=$openDemand-<>aQty_OH{$hit}
			If ($openDemand<0)
				$openDemand:=0
			End if 
		End if 
	End if 
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $_JobForm; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; [Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
	SORT ARRAY:C229($_JobForm; $_ProductCode; $_CustID; $_QtyOH; >)
	
	$numRecs:=Size of array:C274($_ProductCode)
	
	For ($i; 1; $numRecs; 1)
		If (([Job_Forms_Items:44]JobForm:1#$_JobForm{$i}) | ([Job_Forms_Items:44]ProductCode:3#$_ProductCode{$i}) | ([Job_Forms_Items:44]CustId:15#$_CustID{$i}))
			qryJMI($_JobForm{$i}; 0; $_ProductCode{$i})
			t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
			If ([Job_Forms_Items:44]FormClosed:5) & (<>UseActCost)  //•072998  MLB  
				t3a:=t3a+"$Act"
				$matl:=[Job_Forms_Items:44]Cost_Mat:12
				$labor:=[Job_Forms_Items:44]Cost_LAB:13
				$burden:=[Job_Forms_Items:44]Cost_Burd:14
			Else 
				$matl:=[Job_Forms_Items:44]PldCostMatl:17
				$labor:=[Job_Forms_Items:44]PldCostLab:18
				$burden:=[Job_Forms_Items:44]PldCostOvhd:19
			End if 
			
			If (<>UseNRV)  //•111398  MLB  htk request
				$jobCost:=$matl+$labor+$burden  //current valuation 
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
				If (Records in selection:C76([Customers_Order_Lines:41])>0)
					$ordValue:=[Customers_Order_Lines:41]Price_Per_M:8
				Else 
					$ordValue:=0
				End if 
				
				If ($ordValue<$jobCost)  //report lower cost        
					t3a:=t3a+"$NRV"
					If ($ordValue>0) & ($jobCost#0)
						$reduction:=$ordValue/$jobCost
						$matl:=$matl*$reduction
						$labor:=$labor*$reduction
						$burden:=$burden*$reduction
					Else 
						$matl:=0
						$labor:=0
						$burden:=0
					End if 
				End if   //adj required
				
			End if   //•111398  MLB  end htk request
			
		End if 
		
		Case of 
			: ($openDemand<=0)  //none of this bin is valued
				$thousand:=$_QtyOH{$i}/1000
				$6->:=$6->+$_QtyOH{$i}
				$7->:=$7->+Round:C94($matl*$thousand; 0)
				$8->:=$8->+Round:C94($labor*$thousand; 0)
				$9->:=$9->+Round:C94($burden*$thousand; 0)
				$openDemand:=$openDemand-$_QtyOH{$i}
				
			: ($openDemand>=$_QtyOH{$i})  //all of this bin is valued
				$thousand:=$_QtyOH{$i}/1000
				$1->:=$1->+$_QtyOH{$i}
				$2->:=$2->+Round:C94($matl*$thousand; 0)
				$3->:=$3->+Round:C94($labor*$thousand; 0)
				$4->:=$4->+Round:C94($burden*$thousand; 0)
				$openDemand:=$openDemand-$_QtyOH{$i}
				
			: ($openDemand<$_QtyOH{$i})  //some of this bin is valued
				
				$thousand:=$openDemand/1000
				$1->:=$1->+$openDemand
				$2->:=$2->+Round:C94($matl*$thousand; 0)
				$3->:=$3->+Round:C94($labor*$thousand; 0)
				$4->:=$4->+Round:C94($burden*$thousand; 0)
				
				$thousand:=($_QtyOH{$i}-$openDemand)/1000
				$6->:=$6->+($_QtyOH{$i}-$openDemand)
				$7->:=$7->+Round:C94($matl*$thousand; 0)
				$8->:=$8->+Round:C94($labor*$thousand; 0)
				$9->:=$9->+Round:C94($burden*$thousand; 0)
				
				$openDemand:=$openDemand-$_QtyOH{$i}
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts, $openDemand test failed.")
		End case 
		
	End for 
	$5->:=$5->+Round:C94($2->+$3->+$4->; 0)
	
	If (Count parameters:C259>5)
		$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
	End if 
	
End if   // END 4D Professional Services : January 2019 First record
