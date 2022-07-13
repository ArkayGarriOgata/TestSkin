//(S)PrtOrdAckn:
//• 7/23/98 cs new way to revise jobs to stop revising closed forms
//see sCreateBudget on Cust Order layout
If (Length:C16([Estimates:17]Comments:34)>0)
	$msg:=Replace string:C233([Estimates:17]Comments:34; "Based on Estimate Number "; "via:")
	util_FloatingAlert("Comments:"+Char:C90(13)+$msg)
End if 

$windowTitle:=Get window title:C450
$winRef:=OpenSheetWindow(->[zz_control:1]; "text_dio"; "Get Info for Estimate "+[Estimates:17]EstimateNo:1)
t1:=Estimate_getInfo
DIALOG:C40([zz_control:1]; "text_dio")
CLOSE WINDOW:C154
SET WINDOW TITLE:C213($windowTitle)