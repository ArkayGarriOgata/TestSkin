//%attributes = {"publishedWeb":true}
//PM: sAskMeSaveState() -> 
//@author mlb - 2/12/03  16:43

If ($1="save")
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "beforeJMIopen")
	COPY NAMED SELECTION:C331([Customers_ReleaseSchedules:46]; "beforeRelOpen")
	COPY NAMED SELECTION:C331([Customers_Order_Lines:41]; "beforeOrdOpen")
	CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "beforeFGLopen")
Else 
	USE NAMED SELECTION:C332("beforeRelOpen")
	USE NAMED SELECTION:C332("beforeJMIopen")
	USE NAMED SELECTION:C332("beforeOrdOpen")
	USE NAMED SELECTION:C332("beforeFGLopen")
	CLEAR NAMED SELECTION:C333("beforeRelOpen")
	CLEAR NAMED SELECTION:C333("beforeOrdOpen")
	GOTO OBJECT:C206(sCPN)
	HIGHLIGHT TEXT:C210(sCPN; 1; 20)
End if 