//%attributes = {"executedOnServer":true}
// _______
// Method: RM_whereUsed   ( ) ->
// By: Mel Bohince @ 11/06/20, 10:40:14
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (12/15/20) //show more fields, per Jill/Kris

C_TEXT:C284($rm_code; $1)
If (Count parameters:C259>0)
	$rm_code:=$1
Else 
	$rm_code:="FSC 1/2 mil SBS18.56"
End if 

C_COLLECTION:C1488($budgets_c; $xations_c; $combined_c; $distinct_c; $jobforms_c)
// Modified by: Mel Bohince (12/15/20) //show more fields, per Jill/Kris
If (False:C215)  //find the JOB FORM that either budgeted this rm or was issued it
	$budgets_c:=ds:C1482.Job_Forms_Materials.query("Raw_Matl_Code=:1 and JobForm#:2"; $rm_code; "").toCollection("JobForm")  //orderBy("JobForm")  // ,Planned_Cost,Actual_Price,UOM,Planned_Qty,Actual_Qty
	$xations_c:=ds:C1482.Raw_Materials_Transactions.query("Raw_Matl_Code=:1 and JobForm#:2"; $rm_code; "").toCollection("JobForm")  //orderBy("JobForm")
	
	//merge the two collections into one distinct collection
	$combined_c:=$budgets_c.concat($xations_c)
	$distinct_c:=$combined_c.distinct("JobForm")
	
	//distinct removed the "JobForm" attribute name, put it back in
	ARRAY TEXT:C222($_jobforms; 0)
	COLLECTION TO ARRAY:C1562($distinct_c; $_jobforms)
	$jobforms_c:=New collection:C1472
	ARRAY TO COLLECTION:C1563($jobforms_c; $_jobforms; "JobForm")
	
Else   //ignore the RMX, they also want some additional fields
	C_OBJECT:C1216($jobforms_es)
	$jobforms_es:=ds:C1482.Job_Forms_Materials.query("Raw_Matl_Code=:1 and JobForm#:2"; $rm_code; "").orderBy("JobForm")
	$jobforms_c:=$jobforms_es.toCollection("JobForm,Planned_Cost,Actual_Price,UOM,Planned_Qty,Actual_Qty")  //the displayed data
	$combined_c:=$jobforms_es.toCollection("JobForm")  //used in the item query below
	$distinct_c:=$combined_c.distinct("JobForm")
End if 

//now get the PRODUCT CODES that were on those jobs, method depends on commodity
C_OBJECT:C1216($rm_e)
$rm_e:=ds:C1482.Raw_Materials.query("Raw_Matl_Code=:1"; $rm_code).first()  //assuming that we called this while sitting on an RM record

C_COLLECTION:C1488($items_c; $controlNumber_c)

//$items_c:=$items_c.distinct("ProductCode")

If ($rm_e.CommodityCode=2) | ($rm_e.CommodityCode=3)  //looks like an ink or coating so check the control records
	$controlNumber_c:=ds:C1482.Finished_Goods_Specs_Inks.query("InkNumber=:1"; $rm_code).toCollection("ControlNumber")
	$controlNumber_c:=$controlNumber_c.distinct("ControlNumber")
	
	C_OBJECT:C1216($fg_es)
	$fg_es:=ds:C1482.Finished_Goods.query("ControlNumber in :1"; $controlNumber_c)
	$items_c:=$fg_es.toCollection("ProductCode")
	
Else 
	$items_c:=ds:C1482.Job_Forms_Items.query("JobForm in :1"; $distinct_c).toCollection("ProductCode")
End if 

C_OBJECT:C1216($rtn_o)
$rtn_o:=New object:C1471("jobforms"; $jobforms_c; "items"; $items_c)
C_TEXT:C284($0; $rtn_t)
$rtn_t:=JSON Stringify:C1217($rtn_o)
$0:=$rtn_t





