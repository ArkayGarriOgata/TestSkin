//(S) [CONTROL]ReqEvent'ibCopy
uSpawnProcess("mCopyReq"; 32000; ":Copy:REQUISITION"; True:C214; True:C214)
If (False:C215)  //list called procedures for 4D Insider
	mCopyReq
End if 
//EOS