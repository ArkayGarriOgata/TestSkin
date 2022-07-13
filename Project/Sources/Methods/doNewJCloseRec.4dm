//%attributes = {"publishedWeb":true}
//Procedure: doNewJCloseRec
//032696 TJF `TJF 041196 (melisa) `TJF 042496 `TJF 051396
//•100496  MLB  add some totals
//• 4/10/98 cs Nan Checking
//•120798  MLB  update closedate
//assumes the Jobform record is current
//assumes the procedures gBuildA, gBuildB_C, gBuildD_E have just  executed
//So I think the definition of Contribution is revenue received less the cost used-variable costs.And Booked, in this context means expected, not actual.
//Not sure, its been a while since I stayed at a HolidayInn Express and I’m not .But revenue and cost are open to a little interpretation, so lets see what Ken w.
//Using Find in Design:
//[Job_Forms_CloseoutSummaries]BookContrib:=ayD5{9}  //from doNewJCloseRec, that M-F’n Ken that started the job closeout code and his f’d up variables names and misuse of arrays, G-D assemble programmer. 
//Then:
//ayD5{9}:=ayD5{8}-((($Cost*$Want)/1000))  //from JCOBuildD_E called by JOB_Closeout
//Where:
//$Cost:=[Job_Forms]EstCost_M;lets rename that variable to$estimatedAvgCostPerThousand
//$Want:=Sum([Job_Forms_Items]Qty_Want);lets rename that variable to$costedJobQty
//[Job_Forms]AvgSellPrice;from JOB_SellingPrice which extends the order price or contract price by the les;lets rename the field to$expectedJobValuePerThousand
//ayD5{8}:=(([Job_Forms]AvgSellPrice*$Want)/1000);lets rename that variable to$optimisticJobsValuePerThousand,
//So I think it is saying that:
//BookedContribution=$optimisticJobsValuePerThousand-((estimatedAvgCostPerThousand*costedJobQty)/1000)
//In the end I don’t know that it does what is intended. I’m bothered by all the reduction to “per thousand” things. 
READ WRITE:C146([Job_Forms_CloseoutSummaries:87])

QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]JobForm:1=[Job_Forms:42]JobFormID:5)
If (Records in selection:C76([Job_Forms_CloseoutSummaries:87])=0)
	zwStatusMsg("Close Out"; " Creating Job Close Summary record"+Char:C90(13))
	CREATE RECORD:C68([Job_Forms_CloseoutSummaries:87])
	[Job_Forms_CloseoutSummaries:87]JobForm:1:=[Job_Forms:42]JobFormID:5
	[Job_Forms_CloseoutSummaries:87]Customer:2:=CUST_getName([Jobs:15]CustID:2; "elc")  // Modified by: Mel Bohince (10/18/16)  was job.customername
	[Job_Forms_CloseoutSummaries:87]Line:3:=[Jobs:15]Line:3
	
Else 
	If (Not:C34(fLockNLoad(->[Job_Forms_CloseoutSummaries:87])))
		TRACE:C157
	End if 
End if 

[Job_Forms_CloseoutSummaries:87]CloseDate:19:=[Job_Forms:42]ClosedDate:11  //•120798  MLB  keep in sync
[Job_Forms_CloseoutSummaries:87]BoardSpend:4:=ayE2{23}
[Job_Forms_CloseoutSummaries:87]BoardWaste:5:=ayE2{21}
//[JobCloseSum]OtherMaterial:=ayD5{1}-ayA5{1}``````TJF 041196 (melisa)
//[JobCloseSum]OtherMaterial:=ayD7{1}-ayA7{1}
[Job_Forms_CloseoutSummaries:87]OtherMaterial:6:=ayD7{1}-(ayE2{23}+ayE2{21})  //TJF 051396

[Job_Forms_CloseoutSummaries:87]MRSpend:7:=ayD7{2}-ayD3{2}+ayD2{2}
[Job_Forms_CloseoutSummaries:87]MROverrun:8:=ayD3{2}-ayD2{2}
[Job_Forms_CloseoutSummaries:87]Run:9:=ayD7{3}

[Job_Forms_CloseoutSummaries:87]TotActVar:10:=ayD7{5}
[Job_Forms_CloseoutSummaries:87]TotStdVar:11:=uNANCheck(ayD5{5})

[Job_Forms_CloseoutSummaries:87]BookContrib:12:=ayD5{9}
[Job_Forms_CloseoutSummaries:87]BookPV:13:=ayD5{10}

[Job_Forms_CloseoutSummaries:87]ActContrib:14:=ayD6{9}
[Job_Forms_CloseoutSummaries:87]ActPV:15:=ayD6{10}
[Job_Forms_CloseoutSummaries:87]ContribVar:16:=ayD6{9}-ayD5{9}

[Job_Forms_CloseoutSummaries:87]BookSP:17:=ayD5{8}
[Job_Forms_CloseoutSummaries:87]ActSP:18:=ayD6{8}

[Job_Forms_CloseoutSummaries:87]TotalMaterial:20:=ayD6{1}  //•100496  MLB 
[Job_Forms_CloseoutSummaries:87]TotalConversion:21:=ayD6{4}  //•100496  MLB 
[Job_Forms_CloseoutSummaries:87]TotalCost:22:=ayD6{1}+ayD6{4}  //•100496  MLB 

[Job_Forms_CloseoutSummaries:87]QtyProduced:23:=[Job_Forms:42]QtyActProduced:35
[Job_Forms_CloseoutSummaries:87]QtyBudgeted:24:=[Job_Forms:42]QtyWant:22
[Job_Forms_CloseoutSummaries:87]BudgetedMaterial:25:=ayD2{1}  //[JobForm]Pld_CostTtlMatl
[Job_Forms_CloseoutSummaries:87]BudgetedConversion:26:=ayD2{4}  //[JobForm]PldCostTtlLabo+[JobForm]Pld_CostTtlOH
[Job_Forms_CloseoutSummaries:87]BudgetedTotalCost:27:=ayD2{1}+ayD2{4}  //[JobCloseSum]BudgetedMaterial+[JobCloseSum]BudgetedConversion


SAVE RECORD:C53([Job_Forms_CloseoutSummaries:87])

If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Job_Forms_CloseoutSummaries:87])
	REDUCE SELECTION:C351([Job_Forms_CloseoutSummaries:87]; 0)
	
Else 
	
	REDUCE SELECTION:C351([Job_Forms_CloseoutSummaries:87]; 0)
	
End if   // END 4D Professional Services : January 2019 
