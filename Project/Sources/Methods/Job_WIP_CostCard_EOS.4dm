//%attributes = {"executedOnServer":true}

// Method: Job_WIP_CostCard_EOS ( jobform )  -> csv file
// By: MelvinBohince @ 04/06/22, 13:22:04
// Description
// rewrite server-side prep
//  chg to CSV
// ----------------------------------------------------

C_TEXT:C284($jobForm; $1; tText; $0)
$jobForm:=$1

C_TEXT:C284($t; $r)
$t:=","  //Char(9)
$r:=Char:C90(13)

C_TEXT:C284(tText; $text)
tText:=""
$text:=""

C_BOOLEAN:C305(prnCostCard)  //tramp variable to called methods
prnCostCard:=True:C214

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Finished_Goods_Transactions:33])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobForm)
If (Records in selection:C76([Job_Forms:42])=1)
	
	CostCtrCurrent("init"; "00/00/0000")
	$totMatl:=0
	$totLabor:=0
	$totBurden:=0
	$totCost:=0
	$totBB:=0
	$totEB:=0
	
	jobStartDateStr:=String:C10([Job_Forms:42]StartDate:10; <>MIDDATE)
	firstMach:=!00-00-00!
	firstMatl:=!00-00-00!
	beginDate:=!00-00-00!
	endDate:=Current date:C33
	$completed:=String:C10([Job_Forms:42]Completed:18; <>MIDDATE)
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=Num:C11(Substring:C12($jobForm; 1; 5)))
	$cust:=[Jobs:15]CustomerName:5
	
	tText:="W O R K  I N  P R O C E S S  -  J O B  C O S T  C A R D    printed:"+TS2String(TSTimeStamp)+$r+$r
	tText:=tText+"JOB No:  "+$jobForm+"  CUSTOMER:  "+$cust+"  EST No:  "+[Jobs:15]EstimateNo:6+"  Sheet Dim: "
	tText:=tText+String:C10([Job_Forms:42]Width:23)+" x "+String:C10([Job_Forms:42]Lenth:24)+"  "+String:C10([Job_Forms:42]NumberUp:26)+"  No UP    NET SHEETS:  "+String:C10([Job_Forms:42]EstNetSheets:28)+$r+$r
	tText:=tText+rCostCardHdrs(2)
	
	$beginBal:=0
	$matl:=0  //doesn't included BB
	$ccMatl:=0  //all material, for cost card
	$labor:=0
	$cclabor:=0
	$burden:=0
	$ccburden:=0
	$toFG:=0
	$inWIP:=0
	$endBal:=0
	$variance:=0
	$HPV:=0
	$prodValue:=0
	$lastSeq:=""
	$priorFG:=0
	$HPV:=0
	$flag:=""
	
	//*Get the Job Items
	rptWIPjmi($jobForm; ->arResult)
	$HPV:=arResult{1}
	tText:=tText+$text
	$text:=""
	//*Get the MachTicks
	rptWIPmachHrs($jobForm; ->arResult; endDate)
	$beginBal:=$beginBal+arResult{1}
	$labor:=arResult{2}
	$burden:=arResult{3}
	$lastSeq:=String:C10(arResult{4}; "000")
	$cclabor:=arResult{5}
	$ccburden:=arResult{6}
	tText:=tText+$text
	rCostCardAppend("")
	//*Get the Issues
	rptWIPmatl($jobForm; ->arResult; endDate)
	$ccMatl:=arResult{1}
	$beginBal:=$beginBal+arResult{2}
	$matl:=arResult{3}
	tText:=tText+$text
	rCostCardAppend("")
	//*Get the FG transactions to relieve WIP
	rptWIPfgXfer($jobForm; ->arResult; endDate)
	$prodValue:=arResult{1}
	$priorFG:=arResult{2}
	$toFG:=arResult{3}
	
	$HPV:=$HPV-$prodValue  //what more can be xfer'ed out
	If ($HPV<0)
		$HPV:=0
	End if 
	
	$beginBal:=$beginBal-$priorFG
	$inWIP:=$matl+$labor+$burden
	$endBal:=($beginBal+$inWIP)-$toFG
	
	If ($endBal<0)
		$variance:=$endBal
		$endBal:=0
		$flag:="EB<0"
	End if 
	
	If ($endBal>0)  //what value is left in the job
		If ($HPV<$endBal)
			$variance:=$endBal-$HPV
			$endBal:=$HPV
			$flag:="HPV<EB"
		End if 
	End if 
	
	$beginBal:=Round:C94($beginBal; 0)
	$matl:=Round:C94($matl; 0)
	$labor:=Round:C94($labor; 0)
	$burden:=Round:C94($burden; 0)
	$ccmatl:=Round:C94($ccmatl; 0)
	$cclabor:=Round:C94($cclabor; 0)
	$ccburden:=Round:C94($ccburden; 0)
	$inWIP:=Round:C94($inWIP; 0)
	$toFG:=Round:C94($toFG; 0)
	$endBal:=Round:C94($endBal; 0)
	$variance:=Round:C94($variance; 0)
	$prodValue:=Round:C94($prodValue; 0)
	$priorFG:=Round:C94($priorFG; 0)
	$HPV:=Round:C94($HPV; 0)
	
	If (jobStartDateStr="00/00/00")  // • mel (5/12/05, 11:02:32) try to set start date if required
		If (firstMach=!00-00-00!) & (firstMatl=!00-00-00!)
			//didn't start
		Else 
			Case of 
				: (firstMach=!00-00-00!)
					jobStartDateStr:=String:C10(firstMatl; <>MIDDATE)
				: (firstMatl=!00-00-00!)
					jobStartDateStr:=String:C10(firstMach; <>MIDDATE)
				: (firstMatl<firstMach)
					jobStartDateStr:=String:C10(firstMatl; <>MIDDATE)
				Else 
					jobStartDateStr:=String:C10(firstMach; <>MIDDATE)
			End case 
		End if 
	End if 
	
	If (jobStartDateStr#"00/00/00")
		
		tText:=tText+rCostCardHdrs(6)
		tText:=tText+String:C10($ccMatl)+$t+String:C10($cclabor)+$t+String:C10($ccburden)+$t+String:C10($ccMatl+$cclabor+$ccburden)+$t+String:C10($toFG)+$t+String:C10($endBal)+$t+String:C10($variance)+$t+$flag+$t+String:C10($prodValue)+$t+String:C10($priorFG)+$t+String:C10($HPV)+$r
		tText:=tText+$r+$r+$r
		tText:=tText+"ITEM"+$t+"[Job_Forms_Items]ItemNumber"+$r
		tText:=tText+"CPN"+$t+"[Job_Forms_Items]ProductCode"+$r
		tText:=tText+"WANT QTY"+$t+"[Job_Forms_Items]Qty_Want"+$r
		tText:=tText+"ACT QTY"+$t+"[Job_Forms_Items]Qty_Actual"+$r
		tText:=tText+"GLUED"+$t+"[Job_Forms_Items]Glued"+$r
		tText:=tText+"COST/M"+$t+"[Job_Forms_Items]PldCostTotal"+$r
		tText:=tText+"HPV"+$t+"[Job_Forms_Items]PldCostTotal x [Job_Forms_Items]Qty_Want"+$r
		tText:=tText+"ORD LINE"+$t+"[Job_Forms_Items]OrderItem"+$r
		tText:=tText+"PRICE/M"+$t+"[Customers_Order_Lines]Price_Per_M, if linked; otherwise, either the [Finished_Goods]RKContr"+"actPrice or latest [OrderLines]Price_Per_M for that CPN"+$r
		tText:=tText+"BOOK COST"+$t+"[Customers_Order_Lines]Cost_Per_M, if linked; otherwise, 0"+$r
		tText:=tText+"ORDER QTY"+$t+"[Customers_Order_Lines]Quantity, if linked; otherwise, 0"+$r
		tText:=tText+"SALES VALUE"+$t+"PRICE/M x [Job_Forms_Items]Qty_Want/1000, if linked; otherwise, 0"+$r
		tText:=tText+"CONTRIBUTION"+$t+"SALES VALUE - HPV"+$r
		tText:=tText+"JOB PV"+$t+"[(PRICE/M x WANT QTY)-(COST/M*WANT QTY)]/(PRICE/M*WANT QTY)"+$r
		tText:=tText+"BOOK PV"+$t+"[(PRICE/M x ORDER QTY)-(BOOK COST*ORDER QTY)]/(PRICE/M*ORDER QTY)"+$r
		tText:=tText+"REALIZABLE PV"+$t+"[(PRICE/M x WANT QTY)-(COST/M*WANT QTY)]/(PRICE/M*WANT QTY) if ORDER QTY > WANT Q"+"TY; otherwise,"+$r
		tText:=tText+""+$t+"[(PRICE/M x ORDER QTY)-(COST/M*WANT QTY)]/(PRICE/M*ORDER QTY)"+$r
		tText:=tText+"REALZ CONTR"+$t+"[(PRICE/M x WANT QTY)-(COST/M*WANT QTY)] if ORDER QTY > WANT QTY; otherwise,"+$r
		tText:=tText+""+$t+"[(PRICE/M x ORDER QTY)-(COST/M*WANT QTY)]"+$r
		
	Else   //start date
		tText:=tText+$jobform+" has not started yet"+$r
	End if   //start date
	
	//*Accumulate totals
	$totMatl:=$totMatl+$matl
	$totLabor:=$totLabor+$labor
	$totBurden:=$totBurden+$burden
	$totBB:=$totBB+$beginBal
	$totEB:=$totEB+$endBal
	$HPV:=arResult{1}
	
Else   //job not found
	tText:=tText+"form was not found"+$r
End if   //job found

tText:=tText+$r+$r+"------ END OF FILE ------"

$0:=tText

REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

//end server-side