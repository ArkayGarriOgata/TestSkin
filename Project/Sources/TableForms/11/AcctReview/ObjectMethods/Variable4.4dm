If (Po1<Size of array:C274(aText))
	Po1:=Po1+1
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=aText{Po1})
End if 
BeforePOReview