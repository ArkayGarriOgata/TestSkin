//bView
//• 3/25/98 cs created

If (Records in set:C195("clickedIncludeRecord")>0)
	COPY SET:C600("clickedIncludeRecord"; "◊PassThroughSet")
	<>PassThrough:=True:C214
	ViewSetter(3; ->[Purchase_Orders_Items:12])
Else 
	BEEP:C151
End if 

//