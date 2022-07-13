//(LP)MthEndSuite.dio -- JML  7/15/93
//This is ued by doFGRptRecords().
//•1/14/97 -cs- removed VenSum from normal print routine at month end, made to
//  print quarterly (request from Fred Golden.)
//• 3/12/9 7problems getting vensum report to NOT print
//  made it manually enabled ONLY
//• 2/3/98 cs re-enable auto printing of vensum
//•2/14/00  jb  turn off some of the defaults
//•090102  mlb "
// Modified by: Mel Bohince (6/30/15) darlene wants them off in initial state

C_LONGINT:C283($i)
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$i:=Find in array:C230(aSelected; "X")
		If ($i>-1)
			OBJECT SET ENABLED:C1123(bPick; True:C214)
			Core_ObjectSetColor(->bPick; -(Black:K11:16+(256*Light grey:K11:13)))
		Else 
			OBJECT SET ENABLED:C1123(bPick; False:C215)
			Core_ObjectSetColor(->bPick; -(Black:K11:16+(256*Light grey:K11:13)))
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(aSelected; Size of array:C274(<>MthEndSuite))
		If (True:C214)  // Modified by: Mel Bohince (6/30/15) darlene wants them off
			C_LONGINT:C283($i)
			For ($i; 1; Size of array:C274(aSelected))
				aSelected{$i}:=""
			End for 
			
		Else 
			
			If (Size of array:C274(aSelected)>27)
				For ($i; 1; Size of array:C274(aSelected))
					aSelected{$i}:="X"
				End for 
				aSelected{1}:=""  //"Sales & Production Backlog"
				//aSelected{2}:=""  `"Cost of Sales by Job"
				aSelected{3}:=""  //"Analysis of Shipped Sales by Customer" 
				//4 used `"Analysis of Shipped Sales by Sales Person" 
				
				aSelected{5}:=""  //"Shipment Quantities by Customer & Brand"
				aSelected{8}:=""  //"Costed Finished Goods Inventory" see FIFO
				aSelected{9}:=""  //"Costed Bill & Hold Inventory"
				aSelected{10}:=""  //"Costed Examining Inventory"
				aSelected{11}:=""  //"Costed Examining Expected Yield Inventory"
				aSelected{12}:=""  //"EX Expected Yield Inventory"
				aSelected{13}:=""  //"F/G Trans Log - WIP to CC"
				aSelected{14}:=""  //"F/G Trans Log - CC to FG"
				//15 used"F/G Trans Log - FG to SC"
				//16 used"F/G Trans Log - CC to SC"
				aSelected{17}:=""  //"F/G Trans Log - CC to EX"
				//18 used"F/G Trans Log - EX to SC"
				aSelected{19}:=""  //"F/G Trans Log - EX to XC" 
				//20 used"F/G Trans Log - XC to SC"
				aSelected{21}:=""  //"F/G Trans Log - XC to FG"
				aSelected{22}:=""  //"F/G Trans Log - XC to EX"
				//aSelected{23}:=""  `"F/G Trans Log - XC to EX"
				aSelected{24}:=""  //"F/G Trans Log - Customer to EX"
				aSelected{25}:=""  //"F/G Trans Log - Customer to FG"
				aSelected{26}:=""  //"Aged F/G Inventory - F/G Only"`"
				aSelected{27}:=""  //"Aged F/G Inventory - Exam Only"
				aSelected{28}:=""  //"Items Scrapped Between Dates - At Cost"
				aSelected{29}:=""  //"Items Scrapped Between Dates - At Price"
				aSelected{30}:=""  //"Inventory - 9 Months and Up"
				aSelected{31}:=""  //"Inventory - 12 Months and Up"
				aSelected{32}:=""  //"Inventory - 15 Months and Up"
				aSelected{33}:=""  //"Inventory Monthly (No Search)"
				aSelected{35}:=""  //"Total Purchases by Department"
				//36 used"FG/CC/XC/EX Summary" 
				aSelected{37}:=""  //"Simple Inventory, Aged"
				aSelected{38}:=""  //"Plant Contributions"
				aSelected{39}:=""  //"Simple Inventory, Forecast
				aSelected{40}:=""  //cpi
				//42 used"RM On Hand w/Cost"
				aSelected{43}:=""  //cogs h
				aSelected{44}:=""  //cogs h
				
				aSelected{45}:=""  //cogs h
				aSelected{46}:=""  //cogs r
				aSelected{47}:=""  //cogs payu
				
				aSelected{48}:=""  //costing
				aSelected{49}:=""  //costing r
				aSelected{50}:=""  //costing payu
				aSelected{51}:=""  //"Job Variance"
				aSelected{52}:=""  //"Machine Variances"
				
				aSelected{53}:=""  //"FIFO Regeneration"
				//54 used"FG Inventory at FIFO"
				aSelected{55}:=""  //"FG Inventory at FIFO Detail"
				//aSelected{56}:=""  `"R/M Aging"
				aSelected{57}:=""  //"FG Bin Summary"
				aSelected{58}:=""  //"3-6-9-12 Aged Inv Detail"
				//59 used"3-6-9-12 Aged Inv FIFO"
			End if 
		End if 
		
		$i:=Find in array:C230(aSelected; "X")
		If ($i>-1)
			OBJECT SET ENABLED:C1123(bPick; True:C214)
			Core_ObjectSetColor(->bPick; -(Black:K11:16+(256*Light grey:K11:13)))
		Else 
			OBJECT SET ENABLED:C1123(bPick; False:C215)
			Core_ObjectSetColor(->bPick; -(Black:K11:16+(256*Light grey:K11:13)))
		End if 
		
		document:=""
		$month:=String:C10(Month of:C24(4D_Current_date))
		$year:=String:C10(Year of:C25(4D_Current_date))
		dDateBegin:=Date:C102($month+"/1/"+$year)
		dDateEnd:=Date:C102($month+"/"+String:C10(<>aDaysInMth{Num:C11($month)})+"/"+$year)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
//