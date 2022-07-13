//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/22/08, 15:24:43
// ----------------------------------------------------
// Method: wms_api_load_transaction_variab
// Description
// memics the variables used by the fg_transfer dialog so similar posting methods can be used
//
// Parameters
// Modified by: Mel Bohince (2/4/19) validate jobit

C_TEXT:C284($0; <>Last_skid_referenced; wms_case_id; wms_from_skid_id)  //return jobit with periods
C_LONGINT:C283(wms_number_cases)
// ----------------------------------------------------
//FG_TransactionVariablesExchange("clear")
sCriterion1:=""  //        cpn
sCriterion2:=""  //custid
rReal1:=0  //             qty
sCriterion3:=""  //from
sCriterion4:=""  //to
sCriterion5:=""  //jobform
i1:=0  //                job item
sCriterion6:=""  //orderline
sCriterion7:=""  //reason comment
sCriterion8:=""  //action taken
sCriterion9:=""  //reason
sCriter10:=""  //   skid ticket
sCriter11:=""  //user
sCriter12:=""  //release
bLastSkid2:=0  //still need to do this with the Receive dialog
wms_number_cases:=0
wms_case_id:=""  // Modified by: Mel Bohince (11/26/18) 
sJobit:=JMI_makeJobIt([WMS_aMs_Exports:153]Jobit:9)  //put the periods back in

sCriterion5:=Substring:C12(sJobit; 1; 8)
i1:=Num:C11(Substring:C12(sJobit; 10; 2))
//READ ONLY([Job_Forms_Items]) //bad news causes locked jmi
$numJMI:=qryJMI(sJobit)
If ($numJMI>0)  // Modified by: Mel Bohince (2/4/19) validate jobit
	wms_number_cases:=[WMS_aMs_Exports:153]number_of_cases:16
	sCriterion1:=[Job_Forms_Items:44]ProductCode:3
	sCriterion2:=[Job_Forms_Items:44]CustId:15
	If (Length:C16([WMS_aMs_Exports:153]from_Bin_id:17)>4)
		sCriterion3:=wms_convert_bin_id("ams"; [WMS_aMs_Exports:153]from_Bin_id:17)
	Else 
		sCriterion3:=[WMS_aMs_Exports:153]from_Bin_id:17  //blank
	End if 
	sCriterion4:=wms_convert_bin_id("ams"; [WMS_aMs_Exports:153]BinId:10)
	sCriterion6:=[Job_Forms_Items:44]OrderItem:2
	
	wms_case_id:=[WMS_aMs_Exports:153]case_id:15
	wms_from_skid_id:=[WMS_aMs_Exports:153]from_skid_id:21
	
	sCriterion8:="SCAN-"+String:C10([WMS_aMs_Exports:153]TypeCode:2)+" "+String:C10(wms_number_cases)+" cases to "+[WMS_aMs_Exports:153]BinId:10+" c:"+wms_case_id  //actiontaken
	sCriterion9:=""  //reason
	sCriterion7:=""  //reasonNotes
	If (Position:C15(Substring:C12(sCriterion4; 1; 2); " XC EX SC ")>0)
		sCriterion9:="Reject"  //reason
		sCriterion7:=Substring:C12([WMS_aMs_Exports:153]BinId:10; 7)  //reasonNotes
	End if 
	
	rReal1:=[WMS_aMs_Exports:153]ActualQty:11
	Case of 
		: ([WMS_aMs_Exports:153]Skid_number:14#"") & ([WMS_aMs_Exports:153]Skid_number:14#"NULL")  //perfer skid
			sCriter10:=[WMS_aMs_Exports:153]Skid_number:14
			
		: ([WMS_aMs_Exports:153]case_id:15#"") & ([WMS_aMs_Exports:153]case_id:15#"NULL")
			sCriter10:="CASE"  //[WMS_aMs_Exports]case_id
			
		Else   //
			sCriter10:="wms-"+String:C10([WMS_aMs_Exports:153]id:1)
	End case 
	// Modified by: Mel Bohince (11/26/18) next line doesnt' help, leave if for compatibility, and to pivot off the 4th arg in FGL_qryBin
	<>Last_skid_referenced:=wms_from_skid_id  //save this in case a case was removed from a skid
	
	sCriter11:=[WMS_aMs_Exports:153]ModWho:6
	dDate:=[WMS_aMs_Exports:153]TransDate:4
	tTime:=Time:C179([WMS_aMs_Exports:153]TransTime:5)
	//test
	//FG_TransactionVariablesExchange ("save")
	//FG_TransactionVariablesExchange ("clear")
	//FG_TransactionVariablesExchange ("restore")
	//FG_TransactionVariablesExchange ("remove")
	$0:=sJobit
	
Else   //couldn't find jobit
	$0:="ERROR"  // Modified by: Mel Bohince (2/4/19) validate jobit
End if 