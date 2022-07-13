//%attributes = {"publishedWeb":true}
//(p) RmReNameLoc
//this does most/all of the work in locating RMs to rename
//or in some other way change all RM related record in the database
//pulled from code in sRenameRawMtl
//$1 String - RmCode to Locate
//returns number of TOTAL records found
//• 8/22/97 cs created 
// • mel (6/6/05, 09:01:59) add pakspec

C_TEXT:C284($1)
C_LONGINT:C283($0)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$1)
	CREATE SET:C116([Raw_Materials_Locations:25]; "Bins")
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$1)
	CREATE SET:C116([Raw_Materials_Transactions:23]; "Xfer")
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=$1)
	CREATE SET:C116([Purchase_Orders_Items:12]; "Items")
	QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Raw_Matl_Code:4=$1)
	CREATE SET:C116([Estimates_Materials:29]; "Est")
	QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=$1)
	CREATE SET:C116([Raw_Materials_Components:60]; "Parent")
	QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Compnt_Raw_Matl:2=$1)
	CREATE SET:C116([Raw_Materials_Components:60]; "Component")
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=$1)
	CREATE SET:C116([Raw_Materials_Allocations:58]; "Alloc")
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=$1)
	CREATE SET:C116([Job_Forms_Materials:55]; "Job")
	QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Raw_Matl_Code:13=$1)
	CREATE SET:C116([Process_Specs_Materials:56]; "PSpec")
	QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]RM_Code:36=$1)
	CREATE SET:C116([Finished_Goods_PackingSpecs:91]; "PakSpec")
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "Bins")
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Xfer")
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Items")
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Est")
	QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Raw_Matl_Code:4=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Parent")
	QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Component")
	QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Compnt_Raw_Matl:2=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Alloc")
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Job")
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "PSpec")
	QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Raw_Matl_Code:13=$1)
	SET QUERY DESTINATION:C396(Into set:K19:2; "PakSpec")
	QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]RM_Code:36=$1)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
End if   // END 4D Professional Services : January 2019 query selection

$0:=Records in set:C195("Est")+Records in set:C195("Req")+Records in set:C195("Alloc")+Records in set:C195("Job")+Records in set:C195("PSpec")+Records in set:C195("Parent")+Records in set:C195("Component")+Records in set:C195("Items")+Records in set:C195("PakSpec")