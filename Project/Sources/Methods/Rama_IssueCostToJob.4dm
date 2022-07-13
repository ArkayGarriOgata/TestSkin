//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/04/12, 14:39:20
// ----------------------------------------------------
// Method: Rama_IssueCostToJob(type_tranaction;cpn;qty;bin;pallet;$job)
// ----------------------------------------------------
// Modified by: Mel Bohince (9/11/14) option for old freight charge
// Modified by: Mel Bohince (1/12/15) do the charge when first sent to rama, for the entire qty

C_REAL:C285($cost_per_m)  // Modified by: Mel Bohince (9/17/12)
C_TEXT:C284($type; $1; $po_blanket_num; $po_item_gluing; $po_item_freight; $po_item_sleeve; $po_item_old_freight; $8; $type; $job)
C_LONGINT:C283($wasIssued; $bol)
C_DATE:C307($date)
C_BOOLEAN:C305($0; RAMA_PROJECT)

READ ONLY:C145([Purchase_Orders_Items:12])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([zz_control:1])  // Modified by: Mark Zinke (10/22/12)
RAMA_PROJECT:=CUST_isRamaProject(""; "")
$type:=$1

Case of 
	: (Count parameters:C259=2)
		$job:=$2
		$bol:=9999  // Modified by: Mel Bohince (1/12/15) this is just a flag used to determine if charge has been applied
		
	Else   //original
		$cpn:=$2
		$qty:=$3*-1
		$bin:=$4
		$pallet:=$5
		$job:=$6
		$date:=$7
		$bol:=Num:C11($8)
		
		ALL RECORDS:C47([zz_control:1])  // Modified by: Mark Zinke (10/22/12)
		$po_blanket_num:=[zz_control:1]RamaPONum:60  // Modified by: Mark Zinke (10/22/12) Was "0204183"
		$po_item_gluing:="01"
		$po_item_freight:="02"
		$po_item_sleeve:="03"
		$po_item_old_freight:="04"  // Modified by: Mel Bohince (9/11/14) 
		
		$po_blanket_num:=$po_blanket_num+$po_item_freight
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$po_blanket_num)
		If (Records in selection:C76([Purchase_Orders_Items:12])=1)
			$cost_per_m:=[Purchase_Orders_Items:12]UnitPrice:10
		Else 
			$cost_per_m:=0.024  //0.018 as of 9/14/12  0.024 as of 9/11/14
		End if 
		
End case 

Case of 
	: ($type="test")  //run this whenever payuse load is being sent to rama
		SET QUERY DESTINATION:C396(Into variable:K19:4; $wasIssued)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$job; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]ReceivingNum:23=$bol)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		$0:=($wasIssued=0)  // therefore needs issue
		
	: ($type="anticipate")
		$bol:=9999  // Modified by: Mel Bohince (1/12/15) this is just a flag used to determine if charge has been applied
		
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]JobForm:12:=$job
		[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
		[Raw_Materials_Transactions:23]XferDate:3:=$date
		[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
		[Raw_Materials_Transactions:23]Qty:6:=$qty
		[Raw_Materials_Transactions:23]POItemKey:4:=$po_blanket_num
		
		[Raw_Materials_Transactions:23]ActCost:9:=$cost_per_m
		[Raw_Materials_Transactions:23]ActExtCost:10:=$cost_per_m*[Raw_Materials_Transactions:23]Qty:6  ///1000
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:="RAMA Freight"
		[Raw_Materials_Transactions:23]CommodityCode:24:=13
		[Raw_Materials_Transactions:23]Commodity_Key:22:="13-O/S Freight"
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		[Raw_Materials_Transactions:23]CompanyID:20:="2"
		[Raw_Materials_Transactions:23]DepartmentID:21:="9999"
		[Raw_Materials_Transactions:23]ExpenseCode:26:="5150"
		[Raw_Materials_Transactions:23]viaLocation:11:=$bin
		[Raw_Materials_Transactions:23]ReferenceNo:14:=$pallet
		[Raw_Materials_Transactions:23]Reason:5:=$cpn  //"Contract Transportation"
		[Raw_Materials_Transactions:23]ReceivingNum:23:=$bol  //just a flag y'all
		[Raw_Materials_Transactions:23]Invoiced:30:=!00-00-00!
		[Raw_Materials_Transactions:23]Paid:31:=!00-00-00!
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]CostCenter:19:="rama"  // Modified by: Mel Bohince (9/15/14) 
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		$0:=(ok=1)
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		
	: ($type="freight")
		//$po_blanket_num:=$po_blanket_num+$po_item_freight
		//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$po_blanket_num)
		//If (Records in selection([Purchase_Orders_Items])=1)
		//$cost_per_m:=[Purchase_Orders_Items]UnitPrice
		//Else 
		//$cost_per_m:=0.024  //0.018 as of 9/14/12  0.024 as of 9/11/14
		//End if 
		//CREATE RECORD([Raw_Materials_Transactions])
		//[Raw_Materials_Transactions]JobForm:=$job
		//[Raw_Materials_Transactions]Xfer_Type:="Issue"
		//[Raw_Materials_Transactions]XferDate:=$date
		//[Raw_Materials_Transactions]XferTime:=4d_Current_time
		//[Raw_Materials_Transactions]Qty:=$qty
		//[Raw_Materials_Transactions]POItemKey:=$po_blanket_num
		//
		//[Raw_Materials_Transactions]ActCost:=$cost_per_m
		//[Raw_Materials_Transactions]ActExtCost:=$cost_per_m*[Raw_Materials_Transactions]Qty  ///1000
		//[Raw_Materials_Transactions]Raw_Matl_Code:="RAMA Freight"
		//[Raw_Materials_Transactions]CommodityCode:=13
		//[Raw_Materials_Transactions]Commodity_Key:="13-O/S Freight"
		//[Raw_Materials_Transactions]Location:="WIP"
		//[Raw_Materials_Transactions]CompanyID:="2"
		//[Raw_Materials_Transactions]DepartmentID:="9999"
		//[Raw_Materials_Transactions]ExpenseCode:="5150"
		//[Raw_Materials_Transactions]viaLocation:=$bin
		//[Raw_Materials_Transactions]ReferenceNo:=$pallet
		//[Raw_Materials_Transactions]Reason:=$cpn  //"Contract Transportation"
		//[Raw_Materials_Transactions]ReceivingNum:=$bol  //will be given timestamp when payed
		//[Raw_Materials_Transactions]Invoiced:=!00/00/0000!
		//[Raw_Materials_Transactions]Paid:=!00/00/0000!
		//[Raw_Materials_Transactions]Count:=1
		//[Raw_Materials_Transactions]ModDate:=4D_Current_date
		//[Raw_Materials_Transactions]ModWho:=<>zResp
		//[Raw_Materials_Transactions]CostCenter:="rama"  // Modified by: Mel Bohince (9/15/14) 
		//SAVE RECORD([Raw_Materials_Transactions])
		//UNLOAD RECORD([Raw_Materials_Transactions])
		
	: ($type="old-freight")  // Modified by: Mel Bohince (9/11/14) 
		//$po_blanket_num:=$po_blanket_num+$po_item_old_freight
		//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$po_blanket_num)
		//If (Records in selection([Purchase_Orders_Items])=1)
		//$cost_per_m:=[Purchase_Orders_Items]UnitPrice
		//Else 
		//$cost_per_m:=0.018  //0.018 as of 9/14/12 
		//End if 
		//CREATE RECORD([Raw_Materials_Transactions])
		//[Raw_Materials_Transactions]JobForm:=$job
		//[Raw_Materials_Transactions]Xfer_Type:="Issue"
		//[Raw_Materials_Transactions]XferDate:=$date
		//[Raw_Materials_Transactions]XferTime:=4d_Current_time
		//[Raw_Materials_Transactions]Qty:=$qty
		//[Raw_Materials_Transactions]POItemKey:=$po_blanket_num
		//
		//[Raw_Materials_Transactions]ActCost:=$cost_per_m
		//[Raw_Materials_Transactions]ActExtCost:=$cost_per_m*[Raw_Materials_Transactions]Qty  ///1000
		//[Raw_Materials_Transactions]Raw_Matl_Code:="RAMA Freight"
		//[Raw_Materials_Transactions]CommodityCode:=13
		//[Raw_Materials_Transactions]Commodity_Key:="13-O/S Freight"
		//[Raw_Materials_Transactions]Location:="WIP"
		//[Raw_Materials_Transactions]CompanyID:="2"
		//[Raw_Materials_Transactions]DepartmentID:="9999"
		//[Raw_Materials_Transactions]ExpenseCode:="5150"
		//[Raw_Materials_Transactions]viaLocation:=$bin
		//[Raw_Materials_Transactions]ReferenceNo:=$pallet
		//[Raw_Materials_Transactions]Reason:=$cpn  //"Contract Transportation"
		//[Raw_Materials_Transactions]ReceivingNum:=$bol  //will be given timestamp when payed
		//[Raw_Materials_Transactions]Invoiced:=!00/00/0000!
		//[Raw_Materials_Transactions]Paid:=!00/00/0000!
		//[Raw_Materials_Transactions]Count:=1
		//[Raw_Materials_Transactions]ModDate:=4D_Current_date
		//[Raw_Materials_Transactions]ModWho:=<>zResp
		//[Raw_Materials_Transactions]CostCenter:="rama"  // Modified by: Mel Bohince (9/15/14) 
		//SAVE RECORD([Raw_Materials_Transactions])
		//UNLOAD RECORD([Raw_Materials_Transactions])
		
	: ($type="gluing")
		//QUERY([Finished_Goods];[Finished_Goods]ProductCode=$2)
		//If (Records in selection([Finished_Goods])=1)
		//If (Position("sleeve";[Finished_Goods]Style)>0)
		//$po_blanket_num:=$po_blanket_num+$po_item_sleeve
		//Else 
		//$po_blanket_num:=$po_blanket_num+$po_item_gluing
		//End if 
		//Else 
		//$po_blanket_num:=$po_blanket_num+$po_item_gluing
		//End if 
		//
		//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$po_blanket_num)
		//If (Records in selection([Purchase_Orders_Items])=1)
		//$cost_per_m:=[Purchase_Orders_Items]UnitPrice
		//Else 
		//If (Substring($po_blanket_num;8;2)=$po_item_gluing)
		//$cost_per_m:=0.019  //set as of 9/14/12
		//Else 
		//$cost_per_m:=0.021
		//End if 
		//End if 
		//
		//CREATE RECORD([Raw_Materials_Transactions])
		//[Raw_Materials_Transactions]JobForm:=$job
		//[Raw_Materials_Transactions]Xfer_Type:="Issue"
		//[Raw_Materials_Transactions]XferDate:=$date
		//[Raw_Materials_Transactions]XferTime:=4d_Current_time
		//[Raw_Materials_Transactions]Qty:=$qty
		//[Raw_Materials_Transactions]POItemKey:=$po_blanket_num
		//
		//[Raw_Materials_Transactions]ActCost:=$cost_per_m
		//[Raw_Materials_Transactions]ActExtCost:=$cost_per_m*[Raw_Materials_Transactions]Qty  ///1000
		//If (Substring($po_blanket_num;8;2)=$po_item_gluing)
		//[Raw_Materials_Transactions]Raw_Matl_Code:="RAMA Gluing"
		//Else 
		//[Raw_Materials_Transactions]Raw_Matl_Code:="RAMA Sleeve"
		//End if 
		//[Raw_Materials_Transactions]CommodityCode:=13
		//[Raw_Materials_Transactions]Commodity_Key:="13-O/S Gluing"
		//[Raw_Materials_Transactions]Location:="WIP"
		//[Raw_Materials_Transactions]CompanyID:="2"
		//[Raw_Materials_Transactions]DepartmentID:="9999"
		//[Raw_Materials_Transactions]ExpenseCode:="5130"
		//[Raw_Materials_Transactions]viaLocation:=$bin
		//[Raw_Materials_Transactions]ReferenceNo:=$pallet
		//[Raw_Materials_Transactions]Reason:=$cpn  //"Contract Gluing"
		//[Raw_Materials_Transactions]ReceivingNum:=$bol  //will be given timestamp when payed
		//[Raw_Materials_Transactions]Invoiced:=!00/00/0000!
		//[Raw_Materials_Transactions]Paid:=!00/00/0000!
		//[Raw_Materials_Transactions]Count:=1
		//[Raw_Materials_Transactions]ModDate:=4D_Current_date
		//[Raw_Materials_Transactions]ModWho:=<>zResp
		//[Raw_Materials_Transactions]CostCenter:="rama"  // Modified by: Mel Bohince (9/15/14) 
		//SAVE RECORD([Raw_Materials_Transactions])
		//UNLOAD RECORD([Raw_Materials_Transactions])
		
End case 

