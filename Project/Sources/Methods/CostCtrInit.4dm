//%attributes = {}
// _______
// Method: CostCtrInit   ( ) ->
// By: Mel Bohince @ 06/03/21, 07:16:14
// Description
// load the costcenter table into Storage for global use
// and give the server a rest
//  !!!!!!!!!!!
//  NOTE that if more than one Effective date for a cc, both/all are loaded into storage
// ----------------------------------------------------
//   see also methods CostCtrCurrent, CostCtrInit, CostCtrGroup
// Modified by: Mel Bohince (6/9/21) added last year down budget for gPrintItem's use

If (Storage:C1525.CostCenters=Null:C1517)  //setup once
	
	C_OBJECT:C1216($cc_es; $cc_e; $cc_o)
	$cc_es:=ds:C1482.Cost_Centers.query("ProdCC = :1 or (cc_Group = :2 and Description # :3)"; True:C214; "@Outside@"; "GONE@").orderBy("ID")  //
	
	
	
	C_COLLECTION:C1488($costCenter_c)
	$costCenter_c:=New shared collection:C1527
	Use ($costCenter_c)
		
		For each ($cc_e; $cc_es)
			$cc_o:=New shared object:C1526
			//Use ($cc_o)// THIS DIDN'T WORK, IDKy
			//$temp_o:=$cc_e.toObject("ID,Description,cc_Group,MHRburdenSales,MHRlaborSales")
			//End use 
			
			Use ($cc_o)
				$cc_o.cc:=$cc_e.ID
				$cc_o.dated:=$cc_e.EffectivityDate
				$cc_o.desc:=$cc_e.Description
				$cc_o.group:=$cc_e.cc_Group
				$cc_o.dept:=Substring:C12($cc_o.group; 1; 3)
				$cc_o.burden:=$cc_e.MHRburdenSales
				$cc_o.labor:=$cc_e.MHRlaborSales
				$cc_o.oop:=$cc_o.burden+$cc_o.labor
				$cc_o.scrap:=$cc_e.ScrapExcessCost
				$cc_o.down:=$cc_e.DownBudget
				$cc_o.last_yr_down:=$cc_e.LY_DownBudget  // Modified by: Mel Bohince (6/9/21) 
				
			End use 
			
			//$costCenter_c:=$es.toCollection("ID,Description,cc_Group,MHRburdenSales,MHRlaborSales")//DIDN'T WORK, GUESS SOMETHING ABOUT USE( )
			$costCenter_c.push($cc_o)
		End for each 
		
	End use 
	
	Use (Storage:C1525)
		Storage:C1525.CostCenters:=New shared collection:C1527
		
		Use (Storage:C1525.CostCenters)
			Storage:C1525.CostCenters:=$costCenter_c  //.copy(), deep copy not necessary 
		End use   //collection
		
	End use   //storage
	
	
	uInit_CostCenterGroups  //TODO, eliminate the IP variables
	
End if   //setup once
