//%attributes = {"publishedWeb":true}
sDlogTitle:="Enter the Id:"

SET MENU BAR:C67(<>DefaultMenu)
NewWindow(250; 125; 6; 0; "Export")
DIALOG:C40([zz_control:1]; "ChooseExport")
CLOSE WINDOW:C154
If (OK=1)
	If (sJobid#"")
		Exp_ExportJob(sJobid)
		sJobId:=""
	End if 
	
	If (sCustId#"")
		//export routine here!     
		sCustId:=""
	End if 
	
	If (sEstimateId#"")
		Exp_ExportEst(sEstimateId)
		sEstimateId:=""
	End if 
	
	If (sOrderId#"")
		Exp_ExportOrder(sOrderId)  //5/2/95
		sOrderId:=""
	End if 
End if 
sDlogTitle:=""