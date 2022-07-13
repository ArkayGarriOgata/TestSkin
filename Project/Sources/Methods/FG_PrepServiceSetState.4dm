//%attributes = {}
// Method: FG_PrepServiceSetState () -> 
// ----------------------------------------------------
// by: mel: 12/29/04, 12:35:18
// ----------------------------------------------------
// Description:
// Set checkboxes to initiated state and make sure the dates are within flow rules
// ----------------------------------------------------

If ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)
	bSubmit:=1
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateArtReceived:63; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!)  //restrict some changes to specs
	bPrepDone:=1
	FG_PrepSetPrepDone
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateSubmitted:5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateArtReceived:63; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bSubmit; False:C215)
End if 

If ([Finished_Goods_Specifications:98]DateReturned:9#!00-00-00!)
	bReturned:=1
	If (Not:C34([Finished_Goods_Specifications:98]Approved:10))
		bRejected:=1
	Else 
		bRejected:=0
	End if 
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateSubmitted:5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateArtReceived:63; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateReturned:9; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DatePrepDone:6; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bSubmit; False:C215)
	OBJECT SET ENABLED:C1123(bPrepDone; False:C215)
End if 

If ([Finished_Goods_Specifications:98]Approved:10)
	bRejected:=0
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateReturned:9; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]DateArtApproved:46; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateReturned:9; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]DateArtApproved:46; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If ([Finished_Goods_Specifications:98]DateProofRead:7#!00-00-00!)
	bQADone:=1
End if 

If ([Finished_Goods_Specifications:98]DateDirectFiled:66#!00-00-00!)
	bQAfiled:=1
End if 

If ([Finished_Goods_Specifications:98]DateSentToCustomer:8#!00-00-00!)
	bSent:=1
End if 

If ([Finished_Goods_Specifications:98]Hold:62)
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateSubmitted:5; True:C214; ""; True:C214; Yellow:K11:2; Black:K11:16)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateSubmitted:5; True:C214; ""; True:C214; Black:K11:16; White:K11:1)  // Modified by: Mark Zinke (5/6/13)
End if 