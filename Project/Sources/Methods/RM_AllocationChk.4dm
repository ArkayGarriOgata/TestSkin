//%attributes = {"publishedWeb":true}
//RM_AllocationChk
//check for allocation upr 1325 11/23/94
//12/6/94 test for records before calc.
//12/9/94 stdize the iopen calc
//•082402  mlb convert units if necessary, change warnigns, 
//• mlb - 6/26/01 add UOM, dont dup allocate recs for a form
//                always allocate if RM provided
// Modified by: Mel Bohince (10/30/13) include coldfoils budgeted as commodity 05 as well as the correct 09
// Modified by: Mel Bohince (5/25/16) include 20-plastic substrate

C_TEXT:C284($custID; $1; $uom)  //custid
C_DATE:C307($dateNeeded)
C_LONGINT:C283($qty)
C_TEXT:C284($commodity)
C_BOOLEAN:C305($allocate)

READ WRITE:C146([Raw_Materials_Allocations:58])
READ ONLY:C145([Raw_Materials:21])

$custID:=$1
$uom:=[Job_Forms_Materials:55]UOM:5
$qty:=0
$commodity:=Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2)  //01
$dateNeeded:=<>MAGIC_DATE  //• mlb - 7/19/01  16:09
$allocate:=False:C215  //pass thru

Case of 
	: ($commodity="01")  //board
		If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //then wait for plnnr to specify rm code
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			If (Records in selection:C76([Raw_Materials:21])=1)  //can allocate
				$allocate:=True:C214
			End if 
		End if 
		
	: ($commodity="20")  //sensor labels
		If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //then wait for plnnr to specify rm code
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			If (Records in selection:C76([Raw_Materials:21])=1)  //can allocate
				$allocate:=True:C214
			End if 
		End if 
		
	: ($commodity="12")  //sensor labels
		If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //then wait for plnnr to specify rm code
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			If (Records in selection:C76([Raw_Materials:21])=1)  //can allocate
				$allocate:=True:C214
			End if 
		End if 
		
		
	: ($commodity="09")  //cold foil
		If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //then wait for plnnr to specify rm code
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			If (Records in selection:C76([Raw_Materials:21])=1)  //can allocate
				$allocate:=True:C214
			End if 
		End if 
		
	: ($commodity="05")  //maybe cold foil
		If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //then wait for plnnr to specify rm code
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7; *)
			QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]CommodityCode:26=9)
			If (Records in selection:C76([Raw_Materials:21])=1)  //can allocate
				$allocate:=True:C214
			End if 
		End if 
		
	: ($commodity="06")  //corrugate
		$allocate:=False:C215  //stopped doing corrugate 6/25/09
		
	Else   //not an allocated mat'l
		$allocate:=False:C215
End case 

If ($allocate)
	If (False:C215)  //* calc the current balances for that rm, put it in iOpen    
		RM_AllocationCalc([Job_Forms_Materials:55]Raw_Matl_Code:7)  //12/9/94  sets iOpen
		Case of 
			: ($qty>iOpen)
				BEEP:C151
				ALERT:C41("WARNING: This job will exceed the available quantity of "+[Job_Forms_Materials:55]Raw_Matl_Code:7+Char:C90(13)+"Remember to make a requisition.")
			: ((iOpen-$qty)<[Raw_Materials:21]ReorderPoint:12)
				BEEP:C151
				ALERT:C41("Reorder point reached. Please make a requisition for "+[Job_Forms_Materials:55]Raw_Matl_Code:7)
		End case 
	End if   //false
	
	If ([Job_Forms:42]JobFormID:5#[Job_Forms_Materials:55]JobForm:1)  //was [RM_Allocations]JobForm on left side`•031897  MLB  
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Materials:55]JobForm:1)
	End if 
	
	If ([Job_Forms_Master_Schedule:67]JobForm:4#[Job_Forms_Materials:55]JobForm:1)  //was [RM_Allocations]JobForm on left side`•031897  MLB  
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Materials:55]JobForm:1)
	End if 
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
			$dateNeeded:=[Job_Forms_Master_Schedule:67]PressDate:25
		Else 
			$dateNeeded:=<>MAGIC_DATE
		End if 
	End if 
	
	//*Get the rm record, predicate to continue
	Case of 
		: ($commodity="01")
			QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=[Job_Forms_Materials:55]JobForm:1; *)  //$commodity
			QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13=($commodity+"@"))
			If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
				CREATE RECORD:C68([Raw_Materials_Allocations:58])
				[Raw_Materials_Allocations:58]JobForm:3:=[Job_Forms_Materials:55]JobForm:1
				[Raw_Materials_Allocations:58]zCount:10:=1
				[Raw_Materials_Allocations:58]commdityKey:13:=[Job_Forms_Materials:55]Commodity_Key:12
			End if 
			[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=[Job_Forms_Materials:55]Raw_Matl_Code:7
			[Raw_Materials_Allocations:58]CustID:2:=$custID
			If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
				[Raw_Materials_Allocations:58]Date_Allocated:5:=$dateNeeded
			End if 
			[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
			[Raw_Materials_Allocations:58]ModWho:9:=<>zResp
			
			If ([Job_Forms:42]ShortGrain:48)
				$length:=[Job_Forms:42]Width:23
			Else 
				$length:=[Job_Forms:42]Lenth:24
			End if 
			Case of 
				: ($uom="MSF")
					//$qty:=1000*[Material_Job]Planned_Qty/([JobForm]Width/12)
					$qty:=[Job_Forms:42]EstGrossSheets:27*($length/12)
					$uom:="LF"
					
				: ($uom="LF")
					$qty:=[Job_Forms_Materials:55]Planned_Qty:6
					
				: ($uom="SHT")
					$qty:=[Job_Forms_Materials:55]Planned_Qty:6
					$uom:="LF"
					
				Else 
					$qty:=[Job_Forms:42]EstGrossSheets:27*($length/12)
					$uom:="LF"
			End case 
			
			[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty
			[Raw_Materials_Allocations:58]UOM:11:=$uom
			SAVE RECORD:C53([Raw_Materials_Allocations:58])  //comm 1
			
		: ($commodity="20")  // Modified by: Mel Bohince (5/25/16) 
			RM_AllocateRM([Job_Forms_Materials:55]JobForm:1; $dateNeeded; $custID; [Job_Forms_Materials:55]Raw_Matl_Code:7; [Job_Forms_Materials:55]Commodity_Key:12; [Job_Forms_Materials:55]Planned_Qty:6; [Job_Forms_Materials:55]UOM:5)
			
		: ($commodity="06")  //currently inactive
			//clear any existing allocation qty's
			QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=[Job_Forms_Materials:55]JobForm:1; *)  //$commodity
			QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13=($commodity+"@"))
			APPLY TO SELECTION:C70([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Qty_Allocated:4:=0)
			//for each outline number
			RM_AllocateCorrugate([Job_Forms_Materials:55]JobForm:1; $dateNeeded)
			
		: ($commodity="12")
			RM_AllocateRM([Job_Forms_Materials:55]JobForm:1; $dateNeeded; $custID; [Job_Forms_Materials:55]Raw_Matl_Code:7; [Job_Forms_Materials:55]Commodity_Key:12; [Job_Forms_Materials:55]Planned_Qty:6; [Job_Forms_Materials:55]UOM:5)
			
		: ($commodity="09") | ($commodity="05")
			RM_AllocateRM([Job_Forms_Materials:55]JobForm:1; $dateNeeded; $custID; [Job_Forms_Materials:55]Raw_Matl_Code:7; [Job_Forms_Materials:55]Commodity_Key:12; [Job_Forms_Materials:55]Planned_Qty:6; [Job_Forms_Materials:55]UOM:5)
			
	End case 
	
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=[Job_Forms_Materials:55]JobForm:1; *)
	QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13=($commodity+"@"))
	Case of   //  //RM_AllocationChk
		: (Records in selection:C76([Raw_Materials_Allocations:58])=0)  //should never happen
			BEEP:C151
			ALERT:C41("Warning: This form has not allocated "+[Job_Forms_Materials:55]Commodity_Key:12+"."; "Risk Shortage")
			distribution:=Batch_GetDistributionList(""; "ACCTG")
			EMAIL_Sender("Missing Allocation "+[Job_Forms_Materials:55]JobForm:1; ""; [Job_Forms_Materials:55]JobForm:1+" appears to be missing an allocation for '"+[Job_Forms_Materials:55]Raw_Matl_Code:7+"'"; distribution)
			
		: ((Records in selection:C76([Raw_Materials_Allocations:58])>1) & ($commodity="01"))  //skip the 12-labels because could require 2 types
			BEEP:C151
			zwStatusMsg("Warning"; "This form has allocated "+[Job_Forms_Materials:55]Commodity_Key:12+" "+String:C10(Records in selection:C76([Raw_Materials_Allocations:58]))+" times.")
			distribution:=Batch_GetDistributionList(""; "ACCTG")
			EMAIL_Sender("Duplicate Allocation "+[Job_Forms_Materials:55]JobForm:1; ""; [Job_Forms_Materials:55]JobForm:1+" appears to be duplicate allocation for '"+[Job_Forms_Materials:55]Raw_Matl_Code:7+"'"; distribution)
	End case 
	
	UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
	
End if 