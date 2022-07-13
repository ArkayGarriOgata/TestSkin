//%attributes = {"publishedWeb":true}
//(p) JCOWasteForm
//based on WasteForm
//does the needed calcs for the Close out waste form
//moved this from gBuildD_E, in attempt to ease readability
//also added the local constant for precision
//$1 - boolean - printing form (true) printing Job (false)
//• 12/12/97 cs 
//• 12/15/97 cs Fred Requesteed that all formulas here be 'translated'
// so that all percentages are relative to Yield quantities
//• 5/29/98 cs change in production waste - Fred

C_LONGINT:C283($Precision)
C_REAL:C285($Budget; $GrossCount; $GrossBudget; $ActualCount; $EstNetCount)
C_REAL:C285(rReal1t; rReal2t)

$GrossCount:=[Job_Forms:42]1stPressCount:44*[Job_Forms:42]NumberUp:26
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5; *)
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="01@")  //get board budget
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; Records in selection:C76([Job_Forms_Materials:55]))
		
		If ([Job_Forms_Materials:55]UOM:5="SHT")
			$Budget:=$Budget+[Job_Forms_Materials:55]Planned_Qty:6
		Else 
			$Budget:=$Budget+ConvertUnits([Job_Forms_Materials:55]Planned_Qty:6; [Job_Forms_Materials:55]UOM:5; "SHT"; ->rReal1t; ->rReal2t; "*"; [Job_Forms_Materials:55]Raw_Matl_Code:7; [Job_Forms:42]Width:23; [Job_Forms:42]Lenth:24)
		End if 
		NEXT RECORD:C51([Job_Forms_Materials:55])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_UOM; 0)
	ARRAY REAL:C219($_Planned_Qty; 0)
	ARRAY TEXT:C222($_Raw_Matl_Code; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]UOM:5; $_UOM; [Job_Forms_Materials:55]Planned_Qty:6; $_Planned_Qty; [Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code)
	
	For ($i; 1; Size of array:C274($_UOM); 1)
		
		If ($_UOM{$i}="SHT")
			$Budget:=$Budget+$_Planned_Qty{$i}
		Else 
			$Budget:=$Budget+ConvertUnits($_Planned_Qty{$i}; $_UOM{$i}; "SHT"; ->rReal1t; ->rReal2t; "*"; $_Raw_Matl_Code{$i}; [Job_Forms:42]Width:23; [Job_Forms:42]Lenth:24)
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection

$GrossBudget:=[Job_Forms:42]NumberUp:26*$Budget
$ActualCount:=[Job_Forms:42]QtyActProduced:35
$EstNetCount:=[Job_Forms:42]EstGrossSheets:27*[Job_Forms:42]NumberUp:26
ayE2{2}:=[Job_Forms:42]QtyActProduced:35  //* actual (net) production
ayE2{3}:=[Job_Forms:42]AvgSellPrice:42  //* Selling price
ayE2{4}:=[Job_Forms:42]OverrunPct:45  //* Allowed Over run %
ayE2{5}:=[Job_Forms:42]EstNetSheets:28  //* Budgeted Net sheets
ayE2{6}:=[Job_Forms:42]EstGrossSheets:27  //* Budgeted gross sheets

If (Records in selection:C76([Job_Forms_Items:44])>0)
	$YieldCount:=Sum:C1([Job_Forms_Items:44]Qty_Yield:9)
	$WantCount:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
Else 
	$YieldCount:=0
	$WantCount:=0
End if 
$Precision:=100

ayE2{1}:=$WantCount  //* Budgeted (customer need) quantity
ayE2{7}:=$GrossCount  //* Gross Number items
ayE2{8}:=ayE2{7}-ayE2{2}  //* actual waste (Gross Number items {7} - act production {2})

//these formulas requested by Fred Golden 12/15/97
If ($YieldCount>0)
	rH3:=Round:C94((($YieldCount-$WantCount)/$YieldCount)*$Precision; 2)  //Pln'd Waste := [(∑y - ∑w) / ∑y]
	//• 5/29/98 cs changed formula - requested by Fred
	//old =
	//rH4:=Round((($GrossCount-$YieldCount)/$GrossCount)*$Precision;2)  `Prod
	//« Waste:= [(∑g-∑y)/∑g] 
	//new below  
	rH4:=Round:C94((($GrossBudget-$YieldCount)/$GrossBudget)*$Precision; 2)  //Prod Waste:= [(∑gb-∑y)/∑gb] gb=gross budget
	rH5:=rH3+rH4  //Total Budgeted waste =Pln'd Waste+Prod Waste
	rH6:=Round:C94((($ActualCount-$YieldCount)/$YieldCount)*$Precision; 2)  //unplanned Excess [(∑a-∑y)/∑y]
	rH7:=Round:C94((($GrossCount-$ActualCount)/$YieldCount)*$Precision; 2)  //Net Manufacture waste [(∑g - ∑a)/∑y]
Else 
	rh3:=0
	rh4:=0
	rh5:=0
	rh6:=0
	rh7:=0
End if 

If ($YieldCount#0)  //* actual waste % (actual waste/Gross Number items)
	ayE2{9}:=Round:C94((ayE2{8}/$YieldCount)*$Precision; 2)  //• 12/15/97 cs changed to Yield
Else 
	ayE2{9}:=0
End if 
ayE2{10}:=rh3

If (ayE2{7}#0)  //* budgeted waste [cartons] (budgeted waste percent * gross items)
	ayE2{11}:=Round:C94((rH3*$YieldCount)/$Precision; 0)  //• 12/15/97 cs changed to yield
Else 
	ayE2{11}:=0
End if 
ayE2{12}:=ayE2{11}-ayE2{8}  //*waste carton difference (budgeted waste cartons - actual waste cartons)
ayE2{13}:=Round:C94((ayE2{12}/1000)*ayE2{3}; 0)  //* Waste (sale) Value (waste carton difference*Selling price/1000)
ayE2{14}:=Round:C94((ayE2{1}*ayE2{4})/$Precision; 0)  //* allowed overrun (budgetd qty * allowed overrun %)
ayE2{15}:=ayE2{2}-ayE2{1}  //* actual overrun (Actual production - budgeted quantity)
ayE2{16}:=ayE2{15}-ayE2{14}  //* Overrun difference (Actual over run - budgeted over run)
ayE2{17}:=Round:C94((ayE2{16}/1000)*ayE2{3}; 0)  //* overrun (loss sale) value (Overrun differnce* selling price/1000)
If (Size of array:C274(ayA6)>0)
	ayE2{18}:=ayA6{1}  //* actual board cost (from closeout)
Else 
	ayE2{18}:=0
End if 
ayE2{19}:=Round:C94((ayE2{10}*ayE2{18})/$Precision; 0)  //* budgeted waste board cost (Budgeted waste % * Actual Board Cost)
ayE2{20}:=Round:C94((ayE2{9}*ayE2{18})/$Precision; 0)  //* actual wate board cost (Actual waste % * Actual Board cost)
ayE2{21}:=ayE2{19}-ayE2{20}  //* Waste board cost varience (Budgted waste bd cost -actual waste brd cost)
If (Size of array:C274(ayA5)>0)
	ayE2{22}:=ayA5{1}  //* Total board varience 
Else 
	ayE2{22}:=0
End if 
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