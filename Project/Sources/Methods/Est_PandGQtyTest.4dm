//%attributes = {}
// Method: Est_PandGQtyTest
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/13/13, 08:38:25
// ----------------------------------------------------
// Description:
// Tests all estimates to make sure of the following:
// 1. Customer ID is P&G (00199)
// 2. There is a Max and Min Qty in any of the [Finished_Goods] table records for the product codes.
// If either of these are false, do nothing.
// Parameters:
// $0 = Pass or Fail
// If fail, Set the to Hold
// ----------------------------------------------------

// Modified by: Mel Bohince (5/31/13) test if p&g earlier, assume that its going to pass test
// Modified by: Mel Bohince (10/3/13) assume pass until problem detected, also in calling method don't stop other tests

C_POINTER:C301($pFailed; $1)
C_LONGINT:C283($i; $xlMax; $xlMin; $xlSupply; $xlDemand)
C_BOOLEAN:C305($0; $pass)
C_TEXT:C284($tMsg; $tErr; $tSaveButton; $2)

$pFailed:=$1
$tSaveButton:=$2
$pFailed->:=False:C215  //be optimistic, elim the else
$pass:=True:C214  //be optimistic, elim the else

If ([Job_Forms:42]cust_id:82="00199")  //p&g, run test
	//$0:=False // Modified by: Mel Bohince (10/3/13) assume pass until problem detected, also in calling method don't stop other tests
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "JobFormItems")
		
	Else 
		
		ARRAY LONGINT:C221($_JobFormItems; 0)
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_JobFormItems)
		
	End if   // END 4D Professional Services : January 2019 
	
	ARRAY TEXT:C222($atProdCode; 0)
	ARRAY LONGINT:C221(axlAmount; 0)
	ARRAY LONGINT:C221(axlMax; 0)
	ARRAY LONGINT:C221(axlMin; 0)
	ARRAY LONGINT:C221(axlThisWant; 0)
	ARRAY LONGINT:C221(axlSupply; 0)
	ARRAY LONGINT:C221(axlDemand; 0)
	ARRAY TEXT:C222(atProdCodes; 0)
	
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	READ ONLY:C145([Finished_Goods_Locations:35])
	READ ONLY:C145([Job_Forms_Items:44])
	//Get [Finished_Goods] record to check Inventory Max
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $atProdCode; [Job_Forms_Items:44]Qty_Want:24; axlThisWant)
	For ($i; 1; Size of array:C274($atProdCode))
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$atProdCode{$i})  //Get the [Finished_Goods] records
		$xlMax:=[Finished_Goods:26]InventoryMax:63
		$xlMin:=[Finished_Goods:26]InventoryMin:62
		
		If (($xlMax>0) & ($xlMin>0))  //Only test if inventory limits have been set
			$xlSupply:=0
			$xlDemand:=0
			
			//Test forecast.
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$atProdCode{$i}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			$xlDemand:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
			
			//Test for existing inventory.
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$atProdCode{$i})
			$xlSupply:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			
			//Test for other planned jobs.
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$atProdCode{$i}; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]JobForm:1#[Job_Forms:42]JobFormID:5)
			$xlSupply:=$xlSupply+Sum:C1([Job_Forms_Items:44]Qty_Want:24)
			
			//If (($xlDemand>$xlMax) | (($xlSupply+axlThisWant{$i}-$xlDemand)>$xlMax) | ($xlDemand<$xlMin) | (($xlSupply+axlThisWant{$i}-$xlDemand)<$xlMin))  //Needs override email
			If (($xlDemand>$xlMax) | (($xlSupply+axlThisWant{$i}-$xlDemand)>$xlMax) | (($xlSupply+axlThisWant{$i}-$xlDemand)<$xlMin))  //Needs override email
				APPEND TO ARRAY:C911(atProdCodes; $atProdCode{$i})
				APPEND TO ARRAY:C911(axlAmount; $xlSupply+axlThisWant{$i}-$xlDemand)
				APPEND TO ARRAY:C911(axlMax; $xlMax)
				APPEND TO ARRAY:C911(axlMin; $xlMin)
				APPEND TO ARRAY:C911(axlSupply; $xlSupply)
				APPEND TO ARRAY:C911(axlDemand; $xlDemand)
			End if 
		End if 
	End for 
	
	If (Size of array:C274(atProdCodes)>0)  //problem detected
		Est_PandGBlob("Fill")
		If ($tSaveButton="Save")  //User clicked the Save button, don't send all the emails, just inform the user there is a problem. Added by: Mark Zinke (5/17/13)
			[Job_Forms:42]Status:6:="Hold"
			Est_PandGAlert
			
		Else 
			$tErr:=Est_PandGQtyEmail
			Case of 
				: (bCancel=1)
					
				: ($tErr="")
					[Job_Forms:42]Status:6:="Hold"
					$tMsg:="The status of this job has been set to "+util_Quote("Hold")+"."+<>CR+<>CR
					$tMsg:=$tMsg+"Please wait until your manager has reveiwed this estimate and emails you back with instructions."
					ALERT:C41($tMsg)
					
				Else 
					ALERT:C41($tErr)
			End case 
			$pFailed->:=True:C214
			$pass:=False:C215
		End if 
		
		//Else   //Everything is OK  //now this else is redundant
		//$pFailed->:=False
		//$0:=True
	End if 
	
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	READ WRITE:C146([Finished_Goods:26])
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	READ WRITE:C146([Finished_Goods_Locations:35])
	READ WRITE:C146([Job_Forms_Items:44])
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("JobFormItems")
		CLEAR NAMED SELECTION:C333("JobFormItems")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_JobFormItems)
		
	End if   // END 4D Professional Services : January 2019 
	
End if 

$0:=$pass