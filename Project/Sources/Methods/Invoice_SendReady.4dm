//%attributes = {"publishedWeb":true}
//Method: Invoice_SendReady()  051099  MLB
//test to see if last sent files have been integrated
C_LONGINT:C283($0)
$0:=0  //zero is ok


Case of 
	: (<>OpenAccountsActive)
		//nothing
		//#################################
		
		//: (<>AcctVantageActive)
		//  //nothing
		
		//: (<>FlexwareActive)
		//If (Test path name(<>DynamicsPath+<>DynamicsInvoiceDtlFilename)=Is a document)
		//$0:=$0+1
		//BEEP
		//ALERT("Previous file '"+<>DynamicsInvoiceDtlFilename+"' has not been integrated. "+Char(13)+"Integrate or delete this document from folder '"+<>DynamicsPath+"'")
		//End if 
		
		//Else 
		//If (Test path name(<>DynamicsPath+<>DynamicsCustFilename)=Is a document)  //must integrate custinfo one at time
		//$0:=$0+1
		//BEEP
		//ALERT("Previous file '"+<>DynamicsCustFilename+"' has not been integrated. "+Char(13)+"Integrate or delete this document from folder '"+<>DynamicsPath+"'")
		//End if 
End case 



//