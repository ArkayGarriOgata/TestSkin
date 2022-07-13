//%attributes = {"publishedWeb":true}
//(p) ReqApprove
//does needed work to approve a Req from inside the Req
//• 6/16/97 cs  created

CREATE EMPTY SET:C140([Purchase_Orders:11]; "problemApproving")
If (PoOneApprove([Purchase_Orders:11]PONo:1; "*"))  //if overbudget pooneapprove=true
End if 
CLEAR SET:C117("problemApproving")
fApproved:=True:C214
MESSAGES OFF:C175
ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
MESSAGES ON:C181