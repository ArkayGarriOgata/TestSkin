//%attributes = {"publishedWeb":true}
//PM: Email_Opt_Subscribe() -> 
//@author mlb - 4/17/01  12:59

$from:=$1

emailBody:=Substring:C12(emailBody; 1; Position:C15(Char:C90(13); emailBody)-1)
emailResponse:="Subscribe to "+emailBody
READ WRITE:C146([y_batches:10])
QUERY:C277([y_batches:10]; [y_batches:10]BatchName:1=emailBody)
If (Records in selection:C76([y_batches:10])=1)
	CREATE RECORD:C68([y_batch_distributions:164])
	[y_batch_distributions:164]future:6:=[y_batches:10]_future2:8
	[y_batch_distributions:164]EmailAddress:2:=$from
	SAVE RECORD:C53([y_batch_distributions:164])
	emailResponse:=emailResponse+" succeeded."
Else 
	emailResponse:=emailResponse+" failed."
End if 
REDUCE SELECTION:C351([y_batches:10]; 0)
REDUCE SELECTION:C351([y_batch_distributions:164]; 0)