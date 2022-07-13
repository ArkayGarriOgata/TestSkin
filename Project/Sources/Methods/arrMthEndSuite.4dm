//%attributes = {"publishedWeb":true}
//Procedure: arrMthEndSuite()  090195  MLB for rrptMthEndSuite
//•091295 upr 1696
//121495
//•030796  MLB  new report
//•071296  MLB  remove Stock on hand report for M.Hochman
//•1/14/97 -cs- make VenSum report print automagically ONLY Quarterly
//•120397  MLB  UPR 239
//•121197  MLB  UPR 1906
//•012198  MLB  UPR 1915
//• 8/6/98 cs add Wip Inventory rept to MES
//•030299  MLB  UPR inventory test for marty
//•071599  mlb  UPR 2050
//•072099  mlb  UPR 2056
//•121499  mlb  UPR add fifo detail

If (True:C214)  //(User in group(Current user;"Administration"))
	ARRAY TEXT:C222(<>MthEndSuite; 62)
	<>MthEndSuite{1}:="Sales & Production Backlog"
	<>MthEndSuite{2}:="Cost of Sales by Job"
	<>MthEndSuite{3}:="Analysis of Shipped Sales by Customer"  //mod 1/25/95 chip
	<>MthEndSuite{4}:="Analysis of Shipped Sales by Sales Person"  //mod 1/25/ 95 chip
	<>MthEndSuite{5}:="Shipment Quantities by Customer & Brand"  //4/25/95 upr1472
	
	<>MthEndSuite{6}:="Cost of Sales by Class Summary"
	<>MthEndSuite{7}:="Arkay Packaging Inventory Cost Analysis"
	
	<>MthEndSuite{8}:="Costed Finished Goods Inventory"
	<>MthEndSuite{9}:="Costed Bill & Hold Inventory"  //•061295  MLB  UPR 1640
	<>MthEndSuite{10}:="Costed Examining Inventory"
	<>MthEndSuite{11}:="Costed Examining Expected Yield Inventory"
	<>MthEndSuite{12}:="EX Expected Yield Inventory"
	
	//see upr 1333 for legal moves  vvvvvvv
	<>MthEndSuite{13}:="F/G Trans Log - WIP to CC"
	
	<>MthEndSuite{14}:="F/G Trans Log - CC to FG"
	<>MthEndSuite{15}:="F/G Trans Log - FG to SC"
	
	<>MthEndSuite{16}:="F/G Trans Log - CC to SC"
	<>MthEndSuite{17}:="F/G Trans Log - CC to EX"
	
	<>MthEndSuite{18}:="F/G Trans Log - EX to SC"
	<>MthEndSuite{19}:="F/G Trans Log - EX to XC"  //2/28/95
	
	<>MthEndSuite{20}:="F/G Trans Log - XC to SC"
	<>MthEndSuite{21}:="F/G Trans Log - XC to FG"  //upr 1333 2/13/95 sub fg to xc for fg to ex which can't happen
	<>MthEndSuite{22}:="F/G Trans Log - XC to EX"  //121495
	
	<>MthEndSuite{23}:="F/G Trans Log CustOvership-SC"  //03/08/95 chip upr 999
	<>MthEndSuite{24}:="F/G Trans Log - Customer to EX"
	<>MthEndSuite{25}:="F/G Trans Log - Customer to FG"
	
	<>MthEndSuite{26}:="Aged F/G Inventory - F/G Only"  //upr 1461 chip 03/20/95
	<>MthEndSuite{27}:="Aged F/G Inventory - Exam Only"
	
	<>MthEndSuite{28}:="Items Scrapped Between Dates - At Cost"
	<>MthEndSuite{29}:="Items Scrapped Between Dates - At Price"
	<>MthEndSuite{30}:="Inventory - 9 Months and Up"  //1/11/95 upr 1329
	<>MthEndSuite{31}:="Inventory - 12 Months and Up"
	<>MthEndSuite{32}:="Inventory - 15 Months and Up"
	<>MthEndSuite{33}:="Inventory Monthly (No Search)"
	//◊MthEndSuite{32}:="Stock On Hand - Board & Paper"`•071296  MLB  for MH
	<>MthEndSuite{34}:="Total Purchases by Commodity (VenSum)"  //•1/14/97 -cs- this value (32)is referenced directly in Monthly Dialog
	//  if this value is changed PLEASE change it also in the layout procedure for
	//   [control]MthEndSuite.dio, and the scripts dDateEnd & dDateBegin
	<>MthEndSuite{35}:="Total Purchases by Department"  //•091295 upr 1696
	<>MthEndSuite{36}:="FG/CC/XC/EX Summary"  //•121495 KS
	<>MthEndSuite{37}:="Simple Inventory, Aged"  //•030796  MLB for KS/MK
	<>MthEndSuite{38}:="Plant Contributions"  //•120397  MLB  UPR 239
	<>MthEndSuite{39}:="Simple Inventory, Forecast"  //•121197  MLB  UPR 1906
	<>MthEndSuite{40}:="CPI - Shipping Performance"  //•012198  MLB  UPR 1915
	<>MthEndSuite{41}:="RM On Hand w/Cost"  //• 5/19/98 cs added 
	<>MthEndSuite{42}:="Wip Inventory"  //• 8/6/98 cs 
	<>MthEndSuite{43}:="Inventory Test by Quantity"  //•030299  MLB  UPR 
	<>MthEndSuite{44}:="Inventory Test by Job Cost"  //•030299  MLB  UPR 2056
	<>MthEndSuite{45}:="CoGS Hauppauge"  //•071599  mlb  UPR 2050
	<>MthEndSuite{46}:="CoGS Roanoke"  //•071599  mlb  UPR 2050
	<>MthEndSuite{47}:="CoGS PayUse"  //•071599  mlb  UPR 2050
	<>MthEndSuite{48}:="Hauppauge Costed F/G Inventory"  //•081899  mlb  UPR 2053"
	<>MthEndSuite{49}:="Roanoke Costed F/G Inventory"  //•081899  mlb  UPR 2053
	<>MthEndSuite{50}:="Pay-Use Costed F/G Inventory"  //•081899  mlb  UPR 2053
	<>MthEndSuite{51}:="Job Variance"  //•082799  mlb 
	<>MthEndSuite{52}:="Machine Variances"  //•090199  mlb  UPR 2054
	<>MthEndSuite{53}:="FIFO Regeneration"
	<>MthEndSuite{54}:="FG Inventory at FIFO"
	<>MthEndSuite{55}:="FG Inventory at FIFO Detail"
	<>MthEndSuite{56}:="R/M Aging"
	<>MthEndSuite{57}:="FG Bin Summary"
	<>MthEndSuite{58}:="3-6-9-12 Aged Inv Detail"
	<>MthEndSuite{59}:="3-6-9-12 Aged Inv FIFO"
	<>MthEndSuite{60}:="THC Report"
	<>MthEndSuite{61}:="Purchases"
	<>MthEndSuite{62}:="WB Inline Coating Usage"
	
Else 
	ARRAY TEXT:C222(<>MthEndSuite; 24)
	<>MthEndSuite{1}:="Shipment Quantities by Customer & Brand"  //4/25/95 upr1472
	
	<>MthEndSuite{2}:="F/G Trans Log - WIP to CC"
	<>MthEndSuite{3}:="F/G Trans Log - CC to EX"
	<>MthEndSuite{4}:="F/G Trans Log - CC to FG"
	<>MthEndSuite{5}:="F/G Trans Log - XC to FG"  //upr 1333 2/13/95 sub fg to xc for fg to ex which can't happen
	<>MthEndSuite{6}:="F/G Trans Log - XC to EX"  //121495
	<>MthEndSuite{7}:="F/G Trans Log - FG to SC"
	<>MthEndSuite{8}:="F/G Trans Log - EX to XC"  //2/28/95
	<>MthEndSuite{9}:="F/G Trans Log - EX to Scrap"
	<>MthEndSuite{10}:="F/G Trans Log - Customer to EX"
	<>MthEndSuite{11}:="F/G Trans Log - Customer to FG"
	<>MthEndSuite{12}:="F/G Trans Log - Overship to SC"  //03/08/95 chip upr 999
	
	<>MthEndSuite{13}:="Items Scrapped Between Dates - At Price"
	
	<>MthEndSuite{14}:="Aged F/G Inventory - F/G Only"  //upr 1461 chip 03/20/95
	<>MthEndSuite{15}:="Aged F/G Inventory - Exam Only"
	
	<>MthEndSuite{16}:="Inventory Monthly (No Search)"
	
	<>MthEndSuite{17}:="FG/CC/XC/EX Summary"  //•121495 KS
	<>MthEndSuite{18}:="Simple Inventory, Aged"  //•030796  MLB for KS/MK
	
	<>MthEndSuite{19}:="Simple Inventory, Forecast"  //•121197  MLB  UPR 1906
	<>MthEndSuite{20}:="CPI - Shipping Performance"  //•012198  MLB  UPR 1915    
	<>MthEndSuite{21}:="Cost of Sales by Job"
	<>MthEndSuite{22}:="Costed Finished Goods Inventory"
	<>MthEndSuite{23}:="FG Inventory at FIFO"
	<>MthEndSuite{24}:="FG Inventory at FIFO Detail"
End if 