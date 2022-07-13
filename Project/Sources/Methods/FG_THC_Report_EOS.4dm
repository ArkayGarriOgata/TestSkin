//%attributes = {"executedOnServer":true}
// _______
// Method: FG_THC_Report_EOS   ( $params_o ) -> text in csv format
// By: Mel Bohince @ 10/25/21, 14:13:57
// Description
// gather the data for the thc report on the server
// ----------------------------------------------------
//$params_o:=New object("customerId";sCustId;"line";"";"thc_states";$thcStates_c)

ON ERR CALL:C155("e_ExeOnServerError")

C_OBJECT:C1216($params_o; $1)
C_TEXT:C284($text; $t; $r)
$t:=","
$r:="\r"

C_DATE:C307($planningFence)
$planningFence:=Add to date:C393(Current date:C33; 0; 6; 0)

If (Count parameters:C259=1)
	$params_o:=$1
Else 
	C_COLLECTION:C1488($thcStates_c)
	$thcStates_c:=New collection:C1472
	$thcStates_c.push("4")
	$thcStates_c.push("5")
	$thcStates_c.push("7")
	$thcStates_c.push("8")
	C_BOOLEAN:C305($includeForecasts; $includeAskMeTotals)
	$includeForecasts:=True:C214  //19 false, 461 true
	$includeAskMeTotals:=False:C215
	$params_o:=New object:C1471("customerId"; "00121"; "line"; ""; "forecasts"; $includeForecasts; "totals"; $includeAskMeTotals; "thc_states"; $thcStates_c)
End if 

If ($params_o.forecasts)
	
	$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("CustID = :1 and Actual_Date = :2 and PayU = :3 and Sched_Date <= :4 and THC_State in :5"; \
		$params_o.customerId; !00-00-00!; 0; $planningFence; $params_o.thc_states).orderBy("THC_State, Sched_Date")  //("Sched_Date, ProductCode")
	
Else 
	$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("CustID = :1 and Actual_Date = :2 and PayU = :3 and CustomerRefer # :4 and Sched_Date <= :5 and THC_State in :6"; \
		$params_o.customerId; !00-00-00!; 0; "<@"; $planningFence; $params_o.thc_states).orderBy("THC_State, Sched_Date")  //("Sched_Date, ProductCode")
	
End if 

//setup column titles
$text:="CustId,Customer,Line,Outline,ProductCode,THC,Comment,Week@"+String:C10(util_weekNumber(Current date:C33))+",Schd_Date,Schd_Qty,Need_Qty,Art Received Date,Cust_Refer,Open Jobs,Destination,FG_Status,Control#,PlateID,PackingSpec,Stock,ProcessSpec,SqIn"\


If ($params_o.totals)
	$text:=$text+",Price,Qty_OrderLines,Qty_OrderLines_OverRun,Qty_Releases,Qty_Inventory,Qty_Production"
	C_OBJECT:C1216($CustomerTotal_o)
	$CustomerTotal_o:=New object:C1471
End if 
$text:=$text+"\r"

//get the data
For each ($rel_e; $rel_es)
	If ($rel_e.FINISHED_GOOD#Null:C1517)
		$outline:=$rel_e.FINISHED_GOOD.OutLine_Num
		$fgStatus:=$rel_e.FINISHED_GOOD.Status
		$fgControlID:=$rel_e.FINISHED_GOOD.ControlNumber
		$fgPlateID:=$rel_e.FINISHED_GOOD.PlateID
		
		If ($rel_e.FINISHED_GOOD.PACKING_SPEC#Null:C1517)
			$cases:=$rel_e.FINISHED_GOOD.PACKING_SPEC.CasesPerSkid
			$packed_at:=$rel_e.FINISHED_GOOD.PACKING_SPEC.CaseCount
		Else 
			$cases:=0
			$packed_at:=0
		End if 
		$artRecdDate:=String:C10($rel_e.FINISHED_GOOD.ArtReceivedDate)
		$lastPrice:=String:C10($rel_e.FINISHED_GOOD.LastPrice)
		If ($lastPrice="")
			$lastPrice:=String:C10($rel_e.FINISHED_GOOD.RKContractPrice)
		End if 
		$processSpec:=$rel_e.FINISHED_GOOD.ProcessSpec
		$sqIn:=$rel_e.FINISHED_GOOD.SquareInch
		
		If ($rel_e.FINISHED_GOOD.PREP_SPEC#Null:C1517)
			$stock:=String:C10($rel_e.FINISHED_GOOD.PREP_SPEC.StockCaliper)+"-"+$rel_e.FINISHED_GOOD.PREP_SPEC.StockType
		Else 
			$stock:="n/f'"
		End if 
		
	Else 
		$outline:="n/f"
		$fgStatus:="n/f"
		$fgControlID:="n/f"
		$fgPlateID:="n/f"
		$cases:=0
		$packed_at:=0
		$artRecdDate:="n/f"
		$lastPrice:="n/f"
		$processSpec:="n/f"
		$sqIn:=0
	End if 
	
	$text:=$text+$rel_e.CustID+$t+CUST_getName($rel_e.CustID; "elc")+$t+$rel_e.CustomerLine+$t+$outline+$t+$rel_e.ProductCode+$t+String:C10($rel_e.THC_State)+$t
	$text:=$text+txt_quote(THC_decode($rel_e.THC_State))+$t+String:C10(util_weekNumber($rel_e.Sched_Date))+$t+String:C10($rel_e.Sched_Date; System date short:K1:1)+$t+String:C10($rel_e.Sched_Qty)+$t
	If ($rel_e.THC_Qty>0)
		$text:=$text+String:C10($rel_e.THC_Qty)+$t
	Else 
		$text:=$text+"0"+$t
	End if 
	$text:=$text+$artRecdDate+$t
	
	$text:=$text+$rel_e.CustomerRefer+$t+txt_quote(JMI_plannedProduction($rel_e.ProductCode; $rel_e.OrderLine))+$t+$rel_e.Shipto+"-"+Replace string:C233(ADDR_getCity($rel_e.Shipto); ","; "-")+$t
	$text:=$text+$fgStatus+$t+$fgControlID+$t+$fgPlateID+$t
	$cases:=$cases
	$packed_at:=$packed_at
	$packing_spec:=String:C10($cases)+"x"+String:C10($packed_at)+"="+String:C10($cases*$packed_at)
	
	$text:=$text+$packing_spec+$t+$stock+$t+$processSpec+$t+String:C10($sqIn)
	
	If ($params_o.totals)
		
		CmOL_THC_GetTotal($rel_e.CustID; $rel_e.ProductCode; ->$CustomerTotal_o)  //Garri
		
		$text:=$text+$t+\
			$lastPrice+$t+\
			String:C10($CustomerTotal_o.rTotalOrderLine)+$t+\
			String:C10($CustomerTotal_o.rTotalOrderLineOverRun)+$t+\
			String:C10($CustomerTotal_o.rTotalRelease)+$t+\
			String:C10($CustomerTotal_o.rTotalInventory)+$t+\
			String:C10($CustomerTotal_o.rTotalProduction)+$r
		
	Else   //askme totals not requested
		$text:=$text+"\r"
	End if 
	
End for each 

$0:=$text

ON ERR CALL:C155("")