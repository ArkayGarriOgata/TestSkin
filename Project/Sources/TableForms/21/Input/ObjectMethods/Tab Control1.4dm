// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Inventory")
		
		
	: ($targetPage="Purchasing")
		
		
	: ($targetPage="Allocations")
		
		
	: ($targetPage="Make Batch")
		
		
	: ($targetPage="oldWhere Used")
		// Modified by: Mel Bohince (3/13/15) extend where-used to product codes
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=[Raw_Materials:21]Raw_Matl_Code:1)
		ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1; <)
		
		ARRAY BOOLEAN:C223(aCPNuses; 0)
		ARRAY TEXT:C222(aCPN; 0)
		$rm_code:=Uppercase:C13([Raw_Materials:21]Raw_Matl_Code:1)
		//
		Case of 
			: ([Raw_Materials:21]CommodityCode:26=2) | ([Raw_Materials:21]CommodityCode:26=3)
				
				Begin SQL
					SELECT ProductCode from Finished_Goods where ControlNumber in 
					(SELECT ControlNumber from Finished_Goods_Specs_Inks where upper(InkNumber) = :$rm_code)
					order by ProductCode
					into <<aCPNuses>>
				End SQL
				
			Else 
				
				Begin SQL
					SELECT ProductCode from Job_Forms_Items where JobForm in 
					(select distinct(JobForm) FROM Job_Forms_Materials WHERE upper(Raw_Matl_Code) = :$rm_code)
					order by ProductCode
					into <<aCPNuses>>
				End SQL
				
		End case 
		
		REDRAW:C174(aCPNuses)
		
	: ($targetPage="Where Used")
		//call server function:
		C_TEXT:C284($result_json)
		$result_json:=RM_whereUsed([Raw_Materials:21]Raw_Matl_Code:1)  // Modified by: Mel Bohince (11/7/20) 
		C_OBJECT:C1216($result_o)
		$result_o:=JSON Parse:C1218($result_json)
		//populate the 2 collection listboxes
		C_COLLECTION:C1488(jobforms_c; items_c)
		jobforms_c:=$result_o.jobforms
		items_c:=$result_o.items
		
End case 

