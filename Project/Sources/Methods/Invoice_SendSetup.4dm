//%attributes = {"publishedWeb":true}
//Method: Invoice_SendSetup()  051099  MLB
//diskfile setup info
If (<>OpenAccountsActive)
	<>DynamicsPath:=util_DocumentPath("get")  //ams_documents
	<>DynamicsCustFilename:="cust_from_ams_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	<>DynamicsInvoiceHdrFilename:="ar_from_ams_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	<>DynamicsInvoiceDtlFilename:=""
	
Else 
	//If (<>DynamicsPath="") | (<>DynamicsCustFilename="") | (<>DynamicsInvoiceHdrFilename="") | (<>DynamicsInvoiceDtlFilename="") | (<>DynamicsPath=":")
	
	//READ ONLY([zz_control])
	//ALL RECORDS([zz_control])
	//<>DynamicsPath:=[zz_control]DynamicsPath
	//<>DynamicsCustFilename:=[zz_control]DynamicsCustFname
	//<>DynamicsInvoiceHdrFilename:=[zz_control]DynamicsInvoHdrFname
	//<>DynamicsInvoiceDtlFilename:=[zz_control]DynamicsInvoDtlFname
	//REDUCE SELECTION([zz_control];0)
	//If (<>DynamicsCustFilename="")
	//<>DynamicsCustFilename:="CustMstr.txt"  //default
	//End if 
	
	//If (<>DynamicsInvoiceHdrFilename="")
	//<>DynamicsInvoiceHdrFilename:="InvoHDR.txt"  //default
	//End if 
	
	//If (<>DynamicsInvoiceDtlFilename="")
	//<>DynamicsInvoiceDtlFilename:="InvoDTL.txt"  //default
	//End if 
	
	//If (Test path name(<>DynamicsPath)#Is a folder)
	//<>DynamicsPath:=Select folder("Select Dynamics Inbox")
	//End if 
	
	//If (Substring(<>DynamicsPath;Length(<>DynamicsPath);1)#":")
	//<>DynamicsPath:=<>DynamicsPath+":"
	//End if 
	
	//End if 
End if 
//