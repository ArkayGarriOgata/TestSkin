//%attributes = {"publishedWeb":true}
//PM: Email_Opt_Subscriptions() -> 
//@author mlb - 4/17/01  13:00

READ ONLY:C145([y_batches:10])

ALL RECORDS:C47([y_batches:10])

emailResponse:=Char:C90(13)+"Available Subscriptions:"+Char:C90(13)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($j; 1; Records in selection:C76([y_batches:10]))
		emailResponse:=emailResponse+[y_batches:10]BatchName:1+" - "
		emailResponse:=emailResponse+[y_batches:10]Description:2+Char:C90(13)
		emailResponse:=emailResponse+"<mailto:Virtual.Factory@arkay.com?subject=Subscribe&body="+Replace string:C233([y_batches:10]BatchName:1; " "; "%20")+">"+Char:C90(13)+Char:C90(13)
		NEXT RECORD:C51([y_batches:10])
	End for 
	
	
Else 
	
	ARRAY TEXT:C222($_BatchName; 0)
	ARRAY TEXT:C222($_Description; 0)
	
	SELECTION TO ARRAY:C260([y_batches:10]BatchName:1; $_BatchName; [y_batches:10]Description:2; $_Description)
	
	For ($j; 1; Size of array:C274($_BatchName); 1)
		
		emailResponse:=emailResponse+$_BatchName{$j}+" - "
		emailResponse:=emailResponse+$_Description{$j}+Char:C90(13)
		emailResponse:=emailResponse+"<mailto:Virtual.Factory@arkay.com?subject=Subscribe&body="+Replace string:C233($_BatchName{$j}; " "; "%20")+">"+Char:C90(13)+Char:C90(13)
		
	End for 
	
	
End if   // END 4D Professional Services : January 2019 First record

emailResponse:=emailResponse+Char:C90(13)+"To subscribe to one of these reports, send an email to "+"Virtual.Factory@arkay.com"
emailResponse:=emailResponse+" with the Subscribe in the subject"
emailResponse:=emailResponse+" and enter the name of the report in the first line of your email's body."
REDUCE SELECTION:C351([y_batches:10]; 0)