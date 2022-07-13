//%attributes = {"publishedWeb":true}
//(p) WasteForm
//does the needed calcs for the Close out waste form
//moved this from gBuildD_E, in attempt to ease readability
//also added the local constant for precision
//• 12/12/97 cs 

C_LONGINT:C283($Precision)

$Precision:=100
//* Job Form info
ayE2{1}:=[Job_Forms:42]QtyWant:22  //* Budgeted quantity
ayE2{2}:=[Job_Forms:42]QtyActProduced:35  //* actual (net) production
ayE2{3}:=[Job_Forms:42]AvgSellPrice:42  //* Selling price
ayE2{4}:=[Job_Forms:42]OverrunPct:45  //* Allowed Over run %
ayE2{5}:=[Job_Forms:42]EstNetSheets:28  //* Budgeted Net sheets
ayE2{6}:=[Job_Forms:42]EstGrossSheets:27  //* Budgeted gross sheets
ayE2{7}:=[Job_Forms:42]1stPressCount:44*[Job_Forms:42]NumberUp:26  //* Gross Number items
ayE2{8}:=ayE2{7}-ayE2{2}  //* actual waste (Gross Number items {7} - act production {2})

//ayE2{5}:=[JOB]WantQty/[JOB]NumberUp
//ayE2{6}:=ayE2{5}+[JOB]EstWasteSheets

If (ayE2{7}#0)  //* actual waste % (actual waste/Gross Number items)
	ayE2{9}:=Round:C94((ayE2{8}/ayE2{7})*$Precision; 2)  //upr 1407 change precision
Else 
	ayE2{9}:=0
End if 
If (ayE2{6}#0)  //* budgeted waste percent (Budgeted gross -Budgeted Net )/Budgeted gross sheets)
	ayE2{10}:=Round:C94(((ayE2{6}-ayE2{5})/ayE2{6})*$Precision; 2)  //upr 1407 change precision
Else 
	ayE2{10}:=0
End if 
If (ayE2{7}#0)  //* budgeted waste [cartons] (budgeted waste percent * gross items)
	ayE2{11}:=Round:C94((ayE2{10}*ayE2{7})/$Precision; 0)
Else 
	ayE2{11}:=0
End if 
ayE2{12}:=ayE2{11}-ayE2{8}  //*waste carton difference (budgeted waste cartons - actual waste cartons)
ayE2{13}:=Round:C94((ayE2{12}/1000)*ayE2{3}; 0)  //* Waste (sale) Value (waste carton difference*Selling price/1000)
ayE2{14}:=Round:C94((ayE2{1}*ayE2{4})/$Precision; 0)  //* allowed overrun (budgetd qty * allowed overrun %)
ayE2{15}:=ayE2{2}-ayE2{1}  //* actual over/under run (Actual production - budgeted quantity)
ayE2{16}:=ayE2{15}-ayE2{14}  //* Overrun difference (Actual over run - budgeted over run)
ayE2{17}:=Round:C94((ayE2{16}/1000)*ayE2{3}; 0)  //* overrun (loss sale) value (Overrun differnce* selling price/1000)
//* actual board cost (from closeout)
//ayE2{18}:=ayA6{1}
//set in gBuildA_B
ayE2{19}:=Round:C94((ayE2{10}*ayE2{18})/$Precision; 0)  //* budgeted waste board cost (Budgeted waste % * Actual Board Cost)
ayE2{20}:=Round:C94((ayE2{9}*ayE2{18})/$Precision; 0)  //* actual wate board cost (Actual waste % * Actual Board cost)
ayE2{21}:=ayE2{19}-ayE2{20}  //* Waste board cost varience (Budgted waste bd cost -actual waste brd cost)
//* Total board varience 
//ayE2{22}:=ayA5{1}
//set in gBuildA_B
ayE2{23}:=ayE2{22}-ayE2{21}  //* Board sepending varience (Total varience - budgeted varience)
ayE2{24}:=Round:C94((ayE2{15}/1000)*ayE2{3}; 0)  //* overrun (sale) value (actual overrun * selling price/1000)

//waste report
r1D6:=ayE2{1}
r2D6:=ayE2{2}
r3D6:=ayE2{3}
r4D6:=ayE2{4}
r5D6:=ayE2{5}
r6D6:=ayE2{6}
r7D6:=ayE2{7}
r8D6:=ayE2{8}
r9D6:=ayE2{9}
r10D6:=ayE2{10}
r11D6:=ayE2{11}
r12D6:=ayE2{12}
r13D6:=ayE2{13}
r14D6:=ayE2{14}
r15D6:=ayE2{15}
r16D6:=ayE2{16}
r17D6:=ayE2{17}
r18D6:=ayE2{18}
r19D6:=ayE2{19}
r20D6:=ayE2{20}
r21D6:=ayE2{21}
r22D6:=ayE2{22}
r23D6:=ayE2{23}
r24D6:=ayE2{24}
aFtTitle1:="What the Board Variance would be if actual equalled estimated waste"
If (r24D6<0)
	aFtTitle2:="NOT VALID UNDER CURRENT BUDGET APPROACH !"
Else 
	aFtTitle2:=""
End if 

rH3:=ayE2{10}
rH4:=ayE2{9}