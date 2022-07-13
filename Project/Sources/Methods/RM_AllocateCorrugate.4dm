//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 12/14/05, 15:22:51
// ----------------------------------------------------
// Method: RM_AllocateCorrugate(jobform)
// ----------------------------------------------------

C_DATE:C307($dateNeeded; $2)

$uom:="EACH"
$dateNeeded:=$2

QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1="UnspecifiedCorrugate")
If (Records in selection:C76([Raw_Materials:21])=0)
	CREATE RECORD:C68([Raw_Materials:21])
	[Raw_Materials:21]Raw_Matl_Code:1:="unspecifiedcorrugate"
	[Raw_Materials:21]Commodity_Key:2:="06-Unknown"
	[Raw_Materials:21]ReceiptUOM:9:=$uom
	[Raw_Materials:21]IssueUOM:10:=[Raw_Materials:21]ReceiptUOM:9
	[Raw_Materials:21]ConvertRatio_N:16:=1
	[Raw_Materials:21]ConvertRatio_D:17:=1
	[Raw_Materials:21]Flex5:23:=""  //sCriterion4  `color entered in dialog
	[Raw_Materials:21]Description:4:="RM or pakspec missing"
	[Raw_Materials:21]CommodityCode:26:=6
	[Raw_Materials:21]CompanyID:27:="2"  //just a default
	[Raw_Materials:21]DepartmentID:28:="9999"  //default for inventory items
	[Raw_Materials:21]Obsolete_ExpCode:29:=""
	[Raw_Materials:21]SubGroup:31:="Unknown"
	[Raw_Materials:21]ModDate:47:=4D_Current_date
	[Raw_Materials:21]ModWho:48:=<>zResp
	[Raw_Materials:21]Flex4:22:="Created by Corrugate Allocation"
	SAVE RECORD:C53([Raw_Materials:21])
End if 

$hits:=JOB_getOutlineQuantities($1)  //sets  aOutlineNum and  aNumberCartons
For ($i; 1; $hits)
	QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=aOutlineNum{$i})
	If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
		If ([Finished_Goods_PackingSpecs:91]RM_Code:36#"")
			If ([Finished_Goods_PackingSpecs:91]CaseCount:2#0)
				$caseCount:=[Finished_Goods_PackingSpecs:91]CaseCount:2
			Else 
				$caseCount:=1  //someone should notice a problem on allocation report
			End if 
			//how many do we need?
			//find item using that outline
			$qty:=Round:C94((aNumberCartons{$i}/$caseCount); 0)
			
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Finished_Goods_PackingSpecs:91]RM_Code:36)
			If (Records in selection:C76([Raw_Materials:21])=1)  //valid rm, can allocate
				$comKey:=[Raw_Materials:21]Commodity_Key:2
			Else 
				$comKey:=[Job_Forms_Materials:55]Commodity_Key:12
				CREATE RECORD:C68([Raw_Materials:21])
				[Raw_Materials:21]Raw_Matl_Code:1:=[Finished_Goods_PackingSpecs:91]RM_Code:36
				[Raw_Materials:21]Commodity_Key:2:=$comKey
				[Raw_Materials:21]ReceiptUOM:9:=$uom
				[Raw_Materials:21]IssueUOM:10:=[Raw_Materials:21]ReceiptUOM:9
				[Raw_Materials:21]ConvertRatio_N:16:=1
				[Raw_Materials:21]ConvertRatio_D:17:=1
				[Raw_Materials:21]Flex5:23:=""  //sCriterion4  `color entered in dialog
				[Raw_Materials:21]Description:4:="RM specified by "+aOutlineNum{$i}
				[Raw_Materials:21]CommodityCode:26:=Num:C11(Substring:C12($comKey; 1; 2))
				[Raw_Materials:21]CompanyID:27:="2"  //just a default
				[Raw_Materials:21]DepartmentID:28:="9999"  //default for inventory items
				[Raw_Materials:21]Obsolete_ExpCode:29:=""
				[Raw_Materials:21]SubGroup:31:=Substring:C12($comKey; 4)
				[Raw_Materials:21]ModDate:47:=4D_Current_date
				[Raw_Materials:21]ModWho:48:=<>zResp
				[Raw_Materials:21]Flex4:22:="Created by Corrugate Allocation"
				SAVE RECORD:C53([Raw_Materials:21])
			End if   //rm
			
			QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=$1; *)  //$commodity
			QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=[Finished_Goods_PackingSpecs:91]RM_Code:36)
			If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
				CREATE RECORD:C68([Raw_Materials_Allocations:58])
				[Raw_Materials_Allocations:58]JobForm:3:=$1
				[Raw_Materials_Allocations:58]zCount:10:=1
				[Raw_Materials_Allocations:58]commdityKey:13:=$comKey
			End if 
			[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=[Finished_Goods_PackingSpecs:91]RM_Code:36
			[Raw_Materials_Allocations:58]CustID:2:=$custID
			If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
				[Raw_Materials_Allocations:58]Date_Allocated:5:=$dateNeeded
			End if 
			[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
			[Raw_Materials_Allocations:58]ModWho:9:=<>zResp
			[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty
			[Raw_Materials_Allocations:58]UOM:11:=$uom
			SAVE RECORD:C53([Raw_Materials_Allocations:58])  //comm 6
			UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
			
		Else   //rm not specified
			QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=$1; *)  //$commodity
			QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]Raw_Matl_Code:1="UnspecifiedCorrugate")
			If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
				CREATE RECORD:C68([Raw_Materials_Allocations:58])
				[Raw_Materials_Allocations:58]JobForm:3:=$1
				[Raw_Materials_Allocations:58]zCount:10:=1
				[Raw_Materials_Allocations:58]commdityKey:13:="06-Unknown"
			End if 
			[Raw_Materials_Allocations:58]Raw_Matl_Code:1:="UnspecifiedCorrugate"
			[Raw_Materials_Allocations:58]CustID:2:=$custID
			If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
				[Raw_Materials_Allocations:58]Date_Allocated:5:=$dateNeeded
			End if 
			[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
			[Raw_Materials_Allocations:58]ModWho:9:=<>zResp
			[Raw_Materials_Allocations:58]Qty_Allocated:4:=aNumberCartons{$i}
			[Raw_Materials_Allocations:58]UOM:11:=$uom
			SAVE RECORD:C53([Raw_Materials_Allocations:58])  //comm 6
			UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
		End if   //rmcode
		
	Else 
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=$1; *)  //$commodity
		QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]Raw_Matl_Code:1="UnspecifiedCorrugate")
		If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
			CREATE RECORD:C68([Raw_Materials_Allocations:58])
			[Raw_Materials_Allocations:58]JobForm:3:=$1
			[Raw_Materials_Allocations:58]zCount:10:=1
			[Raw_Materials_Allocations:58]commdityKey:13:="06-Unknown"
		End if 
		[Raw_Materials_Allocations:58]Raw_Matl_Code:1:="UnspecifiedCorrugate"
		[Raw_Materials_Allocations:58]CustID:2:=$custID
		If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
			[Raw_Materials_Allocations:58]Date_Allocated:5:=$dateNeeded
		End if 
		[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
		[Raw_Materials_Allocations:58]ModWho:9:=<>zResp
		
		[Raw_Materials_Allocations:58]Qty_Allocated:4:=aNumberCartons{$i}
		[Raw_Materials_Allocations:58]UOM:11:=$uom
		SAVE RECORD:C53([Raw_Materials_Allocations:58])  //comm 6
		UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
	End if   //pakspec
End for 
//get the r/m and quantity based on case count of packing spec