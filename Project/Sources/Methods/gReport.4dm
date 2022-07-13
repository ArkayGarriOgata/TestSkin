//%attributes = {"publishedWeb":true}
//(P) gReport

If (Records in selection:C76(Current form table:C627->)=0)
	BEEP:C151
	uNoneFound
	
Else   //QR REPORT(Current form table->;Char(1))
	SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
	QR REPORT:C197(Current form table:C627->; "TestingTestingTesting"; True:C214; True:C214; True:C214)  //• mlb 8/5/03 new parameters
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
End if 