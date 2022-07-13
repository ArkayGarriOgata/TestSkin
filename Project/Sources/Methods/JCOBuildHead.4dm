//%attributes = {"publishedWeb":true}
//(p) JCOBuildHead
//assign values for header portion
//many rH values are not explicitly zeroed since they will be 
//zeroed during the init routine
//• 12/16/97 cs created

C_BOOLEAN:C305($1; $0)

$0:=True:C214

If ($1)  //printing a single form
	rH8:=[Job_Forms:42]QtyActProduced:35
	rH9:=[Job_Forms:42]ActualGluedQty:53
	rH10:=[Job_Forms:42]1stPressCount:44
	dH1:=[Job_Forms:42]StartDate:10
	dH2:=[Job_Forms:42]Completed:18
	rh11:=[Job_Forms:42]EstCost_M:29
	rh12:=[Job_Forms:42]ActCost_M:41
	rH13:=[Job_Forms:42]AvgSellPrice:42
	rH14:=[Job_Forms:42]NumberUp:26
	rH15:=[Job_Forms:42]OverrunPct:45
	
	If (Records in selection:C76([Job_Forms_Items:44])>0)  //make sure that there are records (sum fails)      
		$Want:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
		If ($Want>0)
			rH2:=Round:C94((rH8/$Want); 3)
			//If (rH2>1)  ` this needs to never be large than 1
			//ALERT("The Over run % is Greater than 1 (100%) this is a
			//« problem. Please investigate.")
			//End if 
		Else 
			rH2:=0
		End if 
	Else 
		rH2:=0
	End if 
	
Else   //printing entire Job
	If (Records in selection:C76([Job_Forms:42])>0)  //there were forms for the job (should always be true)
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]StartDate:10; >)
		dH1:=[Job_Forms:42]StartDate:10
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]Completed:18; <)
		dH2:=[Job_Forms:42]Completed:18
		$ActCost:=0
		$BudCost:=0
		$SellValue:=0
		$Want:=0
		$ItemWant:=0
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116([Job_Forms_Items:44]; "Hold")
			uClearSelection(->[Job_Forms_Items:44])
			
		Else 
			
			ARRAY LONGINT:C221($_Hold; 0)
			LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_Hold)
			REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; Records in selection:C76([Job_Forms:42]))  //need to use a loop instead of sum because of calculation      
				rH8:=rH8+[Job_Forms:42]QtyActProduced:35  //sum actual production
				rH9:=rH9+[Job_Forms:42]ActualGluedQty:53  //sum actual glued
				rH10:=rH10+[Job_Forms:42]1stPressCount:44  //sum # sheet at first press
				RELATE MANY:C262([Job_Forms:42]JobFormID:5)  //get jmis for this form      
				
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					$ItemWant:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)  //determine want qtys for this item
				Else 
					$ItemWant:=0
				End if 
				$Want:=$Want+$ItemWant  //sum all want qtys
				$ActCost:=$ActCost+([Job_Forms:42]ActCost_M:41*[Job_Forms:42]QtyActProduced:35)  //Total actual cost
				$BudCost:=$BudCost+([Job_Forms:42]EstCost_M:29*$Want)  //Total planned (budgeted) cost
				$SellValue:=$SellValue+([Job_Forms:42]AvgSellPrice:42*$Want)  //this is what can be sold
				NEXT RECORD:C51([Job_Forms:42])
			End for 
		Else 
			
			ARRAY LONGINT:C221($_QtyActProduced; 0)
			ARRAY LONGINT:C221($_ActualGluedQty; 0)
			ARRAY LONGINT:C221($_1stPressCount; 0)
			ARRAY TEXT:C222($_JobFormID; 0)
			ARRAY REAL:C219($_ActCost_M; 0)
			ARRAY REAL:C219($_EstCost_M; 0)
			ARRAY REAL:C219($_AvgSellPrice; 0)
			
			
			SELECTION TO ARRAY:C260([Job_Forms:42]QtyActProduced:35; $_QtyActProduced; [Job_Forms:42]ActualGluedQty:53; $_ActualGluedQty; [Job_Forms:42]1stPressCount:44; $_1stPressCount; [Job_Forms:42]JobFormID:5; $_JobFormID; [Job_Forms:42]ActCost_M:41; $_ActCost_M; [Job_Forms:42]EstCost_M:29; $_EstCost_M; [Job_Forms:42]AvgSellPrice:42; $_AvgSellPrice)
			
			
			For ($i; 1; Size of array:C274($_QtyActProduced); 1)  //need to use a loop instead of sum because of calculation      
				rH8:=rH8+$_QtyActProduced{$i}  //sum actual production
				rH9:=rH9+$_ActualGluedQty{$i}  //sum actual glued
				rH10:=rH10+$_1stPressCount{$i}  //sum # sheet at first press
				
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$_JobFormID{$i})
				
				
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					
					ARRAY LONGINT:C221($_Qty_Want; 0)
					SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Want:24; $_Qty_Want)
					$ItemWant:=0
					For ($Iter; 1; Size of array:C274($_Qty_Want); 1)
						$ItemWant:=$ItemWant+$_Qty_Want{$Iter}
					End for 
					
				Else 
					$ItemWant:=0
				End if 
				$Want:=$Want+$ItemWant  //sum all want qtys
				$ActCost:=$ActCost+($_ActCost_M{$i}*$_QtyActProduced{$i})  //Total actual cost
				$BudCost:=$BudCost+($_EstCost_M{$i}*$Want)  //Total planned (budgeted) cost
				$SellValue:=$SellValue+($_AvgSellPrice{$i}*$Want)  //this is what can be sold
				
			End for 
		End if   // END 4D Professional Services : January 2019 query selection
		
		
		FIRST RECORD:C50([Job_Forms:42])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("Hold")
			CLEAR SET:C117("Hold")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_Hold)
			
		End if   // END 4D Professional Services : January 2019 
		
		rH12:=Round:C94($ActCost/rH8; 2)  //Actual cost/M
		
		If ($Want>0)
			rH2:=Round:C94((rH8/$Want); 3)
			rH11:=Round:C94($BudCost/$Want; 2)  //bugetd cost/M
			rH13:=Round:C94($SellValue/$Want; 2)  //salling value/m
		End if 
		
	Else 
		$0:=False:C215
	End if 
End if 