//%attributes = {"publishedWeb":true}
//gViewPSpec    -JML   10/5/93
//Creates a new process to aid Estimator-Shows
//cartons of current Estimate in a separate window.

<>iMode:=3
<>filePtr:=->[Estimates_Carton_Specs:19]

//sCartonTtle:=""  `◊sCartonTtle
Open window:C153(12; 50; 450; 250; 8; "Review Cartons:"+<>TheEstID)  //;"wCloseWinBox")  
READ ONLY:C145([Estimates:17])
READ ONLY:C145([Estimates_Differentials:38])
READ ONLY:C145([Estimates_Carton_Specs:19])

QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=<>TheEstID)
If ((<>sEstDiffID#"") & (<>sEstDiffID#<>sQtyWorksht))
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=<>TheEstID+<>sEstDiffID)
Else 
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=<>TheEstID+"@")
End if 
gEstimateLDWkSh("Diff")

uSetUp(1; 1)  //doNewRecord()
FORM SET OUTPUT:C54([Estimates_Carton_Specs:19]; "List2")
FORM SET INPUT:C55([Estimates_Carton_Specs:19]; "Input")
DISPLAY SELECTION:C59([Estimates_Carton_Specs:19]; *)

CLOSE WINDOW:C154
uSetUp(0; 0)