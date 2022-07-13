//%attributes = {}
// _______
// Method: JMI_getCustWIP   ( endDate:date ; custID:text {exportOption:boolean}) -> productCodesInWIP:collection
// By: MelvinBohince @ 06/17/22, 14:51:55
// Description
// find the job items in WIP and return their distinct product codes
// for a given customer
// ----------------------------------------------------

C_DATE:C307($endDate; $1)
C_TEXT:C284($custID; $2)
C_BOOLEAN:C305($export; $3)

If (Count parameters:C259=2)
	$endDate:=$1
	$custID:=$2
	If (Count parameters:C259>2)
		$export:=$3
	End if 
	
Else   //test
	$endDate:=Current date:C33
	$custID:="00074"
	$export:=True:C214
End if 

// Build a query for items in WIP:
// to be in WIP, a job has to have started before the end of the specified period
// and either not completed or completed after the end of the specifed period
// these will be restricted to the desired customer 
// and to not having any production so far
C_COLLECTION:C1488($parametersAnd_c; $parametersOr_c)
C_TEXT:C284($queryString)  //there will be an AND section and an OR section
$parametersAnd_c:=New collection:C1472
$parametersAnd_c.push("CustId = :1")
$parametersAnd_c.push("Qty_Actual = :2")
$parametersAnd_c.push("JOB_FORM.StartDate # :3")
$parametersAnd_c.push("JOB_FORM.StartDate <= :4")

$parametersOr_c:=New collection:C1472
$parametersOr_c.push("JOB_FORM.Completed = :5")
$parametersOr_c.push("JOB_FORM.Completed > :6")
// wrap the ANDs and ORs with parens, then AND them together
$queryString:="("+$parametersAnd_c.join(" AND ")+")"
$queryString:=$queryString+" AND "
$queryString:=$queryString+"("+$parametersOr_c.join(" OR ")+")"

C_OBJECT:C1216($jobits_es)
$jobits_es:=ds:C1482.Job_Forms_Items.query($queryString; \
$custID; 0; !00-00-00!; $endDate; \
!00-00-00!; $endDate)\
.orderBy("ProductCode")

//now build an address lookup table that can be used with these wip items
C_COLLECTION:C1488($productsCodeInWIP_c; $0)
$productsCodeInWIP_c:=$jobits_es.toCollection("ProductCode").distinct("ProductCode")

$0:=$productsCodeInWIP_c

If ($export)
	util_EntitySelectionToCSV($jobits_es; New collection:C1472("JobForm"; "Jobit"; "ProductCode"); "JobitsInWIP_")
End if 



// first attempt queried the jobforms, then projected those to the items:
// Description
// start with the jobforms in WIP, then explode that to
// their product codes and export to csv,
// also export a shipto address lookup table for those items

//C_OBJECT($jf_es;$jobits_es)
//C_COLLECTION($jf_c;$address_c)
//first the AND criterian
//$parameters_c:=New collection
//$parameters_c.push("StartDate # :1")  //has been started
//$parameters_c.push("StartDate <= :2")  //started before the end date, maybe reporting a prior period
//$parameters_c.push("cust_id = :3")  //narrow down to a customer or all
//$queryString:=$parameters_c.join(" and ")
//$jf_es:=ds.Job_Forms.query($queryString;!00-00-00!;$endDate;$custID)

//  //now the OR criterian
//$parameters_c:=New collection
//$parameters_c.push("Completed > :1")  //could be completed after the end date
//$parameters_c.push("Completed = :2")  //or not yet completed
//$queryString:=$parameters_c.join(" or ")
//$jf_es:=$jf_es.query($queryString;$endDate;!00-00-00!)

//  //get the jobform's to be used in the item query
//$jf_c:=$jf_es.distinct("JobFormID")

//  //get the items of the jobs in wip
//$jobits_es:=ds.Job_Forms_Items.query("JobForm in :1 and Qty_Actual = :2";$jf_c;0).orderBy("ProductCode")

//util_EntitySelectionToCSV($jobits_es;New collection("JobForm";"Jobit";"ProductCode");"JobitsInWIP2_")


//now build an address lookup table that can be used with these wip items
//$productsInWIP_c:=$jobits_es.toCollection("ProductCode").distinct("ProductCode")
//ADDR_BuildAddressLookup ($productsInWIP_c)
