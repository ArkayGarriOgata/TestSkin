//(s) bOK - [control]cate and options 3
//• 2/25/98 cs added check against writing to disk & file opened
Case of 
	: (dDateEnd<dDateBegin)
		ALERT:C41("That date range is invalid.  Try again.")
	Else 
		ACCEPT:C269
End case 
//