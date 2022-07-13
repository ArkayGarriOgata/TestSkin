//%attributes = {"publishedWeb":true}
//(p) gREFreshCCList
//update the Cost Center choice list after addingone or more Cost centers
//Also update the cost center lookup arrays  see also gReFreshRMlist
//1/10/95

ARRAY TEXT:C222(<>ayCC; 0)
ARRAY TEXT:C222($ayCC_DESC; 0)
ARRAY REAL:C219(<>ayOOP; 0)

MESSAGES OFF:C175

$winRef:=NewWindow(170; 30; 6; 1; "")
MESSAGE:C88("Updating Cost Center Lists…")
ALL RECORDS:C47([Cost_Centers:27])
SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; <>ayCC; [Cost_Centers:27]Description:3; $ayCC_DESC; [Cost_Centers:27]MHRoopSales:7; <>ayOOP)
ARRAY TEXT:C222($ayCC_DESC; Size of array:C274(<>ayCC))  //1/10/95
For ($i; 1; Size of array:C274(<>ayCC))
	$ayCC_DESC{$i}:=<>ayCC{$i}+" - "+$ayCC_DESC{$i}
End for 
ARRAY TO LIST:C287($ayCC_DESC; "CC_DESC")
ARRAY TEXT:C222($ayCC_DESC; 0)
CLOSE WINDOW:C154($winRef)
MESSAGES ON:C181