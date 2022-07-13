//%attributes = {"publishedWeb":true}
//qryReqtoReview
//Returns number of records found (might be useful)
//• 8/8/97 cs created
//• 10/28/97 cs changed search to allow all departs from Hauppauge

If (User in group:C338(Current user:C182; "Roanoke"))
	$Division:="2"
Else 
	$Division:="@"
End if 
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Req Approved"; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]CompanyID:43=$Division)  //• 8/8/97 cs have search filter for division