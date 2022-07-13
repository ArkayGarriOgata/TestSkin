//%attributes = {"publishedWeb":true}
//Procedure: arrRMreports()  090195  MLB
//• 2/2/98  cs added new report
// Modified by: MelvinBohince (2/3/22) swap RM On Hand Export for On-Hand by Location"

ARRAY TEXT:C222(<>aRMRptPop; 22)

<>aRMRptPop{1}:="Raw Material Catalog"
<>aRMRptPop{2}:="-"
<>aRMRptPop{3}:="RM On Hand Export"  //"On-Hand by Location"
<>aRMRptPop{4}:="On-Hand by Commodity"
<>aRmRptPop{5}:="Wip Inventory"
<>aRMRptPop{6}:="Allocation Report"  //1
<>aRMRptPop{7}:="-"
<>aRMRptPop{8}:="Receiving Log"  //1
<>aRMRptPop{9}:="Issue Log"  //1
<>aRMRptPop{10}:="Return Log"  //1
<>aRMRptPop{11}:="Batch Log"  //1
<>aRMRptPop{12}:="Adjustment Log"  //1
<>aRMRptPop{13}:="-"
<>aRMRptPop{14}:="Auto Issue Log"  //• 2/2/98 cs 
<>aRmRptPop{15}:="Reprint Post Exceptions"  //• 3/3/98 cs
<>aRmRptPop{16}:="RM Aging"  //•082302  mlb  
<>aRmRptPop{17}:="PI RM Count Sheet"  // • mel (7/20/05, 11:32:34)
<>aRmRptPop{18}:="Inventory Equation"  // • mel (8/11/10)
<>aRmRptPop{19}:="PH77144 Usage"
<>aRmRptPop{20}:="LaserCam Statement"  // Modified by: Mel Bohince (8/2/16)
<>aRmRptPop{21}:="RM Transaction Export"  // Modified by: Mel Bohince (7/12/17) 
<>aRmRptPop{22}:="Roll Stock"  // Added by: Mel Bohince (4/18/19)  

<>aRmRptPopMenu:=<>aRmRptPop{1}
For ($i; 2; Size of array:C274(<>aRmRptPop))
	If (Substring:C12(<>aRmRptPop{$i}; 1; 1)="-")
		<>aRmRptPopMenu:=<>aRmRptPopMenu+";("+<>aRmRptPop{$i}
	Else 
		<>aRmRptPopMenu:=<>aRmRptPopMenu+";"+<>aRmRptPop{$i}
	End if 
End for 