//%attributes = {"publishedWeb":true}
//Procedure: arrFGreports()  090195  MLB
//upr 1439 2/22/95 add 2 and reorder see doFGRptRecords
//•030796  MLB  add report
//• 2/28/97 cs upr 1848 added new report
//cs 10/14/97 added new report for Mary Kay
//•121197  MLB  UPR 1906
//• 5/18/98 cs rewrite of Mary Kay report
//•090398  MLB  one more

ARRAY TEXT:C222(<>aFGRptPop; 39)  //•121197  MLB  UPR 1906 resize stringlengtyh

<>aFGRptPop{1}:="Stock Status Report"
<>aFGRptPop{2}:="Bin Status Report"
<>aFGRptPop{3}:="Obsoleted CPN's to Scrap"
<>aFGRptPop{4}:="-----------------------"
<>aFGRptPop{5}:="Month End Suite"
<>aFGRptPop{6}:="3-6-9-12 Aged Inv FiFo"
<>aFGRptPop{7}:="FG Inv, Ords, and Forecasts"  //•111798  MLB  UPR
<>aFGRptPop{8}:="-----------------------"
//<>aFGRptPop{9}:="Reject-Listing"
//<>aFGRptPop{10}:="Reject-Customer Summary"
//<>aFGRptPop{11}:="Reject-Reason Summary"
<>aFGRptPop{9}:="FG_Location_Export"
<>aFGRptPop{10}:="-na"  // Modified by: Mel Bohince (4/1/20) remove 3 obsolete reports
<>aFGRptPop{11}:="-na"

<>aFGRptPop{12}:="Scrap-Listing"
<>aFGRptPop{13}:="Transfer Report"
<>aFGRptPop{14}:="-----------------------"
<>aFGRptPop{15}:="THC Report"
<>aFGRptPop{16}:="-Open Releases"
<>aFGRptPop{17}:="-Need to Manufacture"
<>aFGRptPop{18}:="-Need to Mfg without Rel"
<>aFGRptPop{19}:="-Need to Mfg by M.A.D."  //1/12/95 upr 1330
<>aFGRptPop{20}:="-Need to Mfg by Job Nº"  //•072695  MLB
<>aFGRptPop{21}:="-Need to Produce"
<>aFGRptPop{22}:="-----------------------"
<>aFGRptPop{23}:="Cust & Brand Shipments"  //upr 1472 4/25/95
<>aFGRptPop{24}:="Cost of Goods Sold"
<>aFGRptPop{25}:="Yet another Customer Liability"  //•090398  MLB  
<>aFGRptPop{26}:="On-Time Report"
<>aFGRptPop{27}:="Prep Report"
<>aFGRptPop{28}:="-----------------------"
<>aFGRptPop{29}:="Kill Report"
<>aFGRptPop{30}:="Kill Tickets"
<>aFGRptPop{31}:="-----------------------"
<>aFGRptPop{32}:="Arden Report"
<>aFGRptPop{33}:="William Lea Extract"
<>aFGRptPop{34}:="Cayey & BrownSummit Inventory"
<>aFGRptPop{35}:="-----------------------"
<>aFGRptPop{36}:="Bill & Hold Report"
<>aFGRptPop{37}:="Shipto's Inventory"
<>aFGRptPop{38}:="A# Analysis"
<>aFGRptPop{39}:="YTD Shipments"


<>aFGRptPopMenu:=<>aFGRptPop{1}
For ($i; 2; Size of array:C274(<>aFGRptPop))
	If (Substring:C12(<>aFGRptPop{$i}; 1; 1)="-")
		<>aFGRptPopMenu:=<>aFGRptPopMenu+";("+<>aFGRptPop{$i}
	Else 
		<>aFGRptPopMenu:=<>aFGRptPopMenu+";"+<>aFGRptPop{$i}
	End if 
End for 

ARRAY TEXT:C222(<>aELCRptPop; 13)
<>aELCRptPop{1}:="Excess Inventory"
<>aELCRptPop{2}:="MAD Warning"
<>aELCRptPop{3}:="Tooling Needed"
<>aELCRptPop{4}:="Order Patterns"
<>aELCRptPop{5}:="Commodity Overview Data"
<>aELCRptPop{6}:="Missed-Open Lookup Table"
<>aELCRptPop{7}:="Weeks Covered"
<>aELCRptPop{8}:="ELC Liabilities"
<>aELCRptPop{9}:="Supply v Demand"
<>aELCRptPop{10}:="EMEA Non-N America Extract"
<>aELCRptPop{11}:="Move Candidates"
<>aELCRptPop{12}:="Waiting Request For Mode"
<>aELCRptPop{13}:="Send Request For Mode"

<>aELCRptPopMenu:=<>aELCRptPop{1}
For ($i; 2; Size of array:C274(<>aELCRptPop))
	If (Substring:C12(<>aELCRptPop{$i}; 1; 1)="-")
		<>aELCRptPopMenu:=<>aELCRptPopMenu+";("+<>aELCRptPop{$i}
	Else 
		<>aELCRptPopMenu:=<>aELCRptPopMenu+";"+<>aELCRptPop{$i}
	End if 
End for 