//%attributes = {"publishedWeb":true}
//uCancelTran: Cancel Transaction.

C_BOOLEAN:C305(fCnclTrn)

If (Not:C34(<>fContinue))
	fCnclTrn:=True:C214
End if 