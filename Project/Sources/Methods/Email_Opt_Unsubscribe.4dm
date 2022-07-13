//%attributes = {"publishedWeb":true}
//PM: Email_Opt_Unsubscribe() -> 
//@author mlb - 4/17/01  13:00

$from:=$1

emailBody:=Substring:C12(emailBody; 1; Position:C15(Char:C90(13); emailBody)-1)
emailResponse:="Unsubscribe to "+emailBody
READ ONLY:C145([y_batches:10])
QUERY:C277([y_batches:10]; [y_batches:10]BatchName:1=emailBody; *)
READ WRITE:C146([y_batch_distributions:164])
QUERY:C277([y_batch_distributions:164]; [y_batch_distributions:164]future:6=[y_batches:10]_future2:8; *)
QUERY:C277([y_batch_distributions:164];  & ; [y_batch_distributions:164]EmailAddress:2=$from)
If (Records in selection:C76([y_batch_distributions:164])=1)
	DELETE RECORD:C58([y_batch_distributions:164])
	emailResponse:=emailResponse+" succeeded."
Else 
	emailResponse:=emailResponse+" failed because you are not subscribed as "+$from+". Contact Mel Bohince x3186."
End if 

REDUCE SELECTION:C351([y_batch_distributions:164]; 0)