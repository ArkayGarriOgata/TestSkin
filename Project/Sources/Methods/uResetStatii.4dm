//%attributes = {"publishedWeb":true}
//uResetStatii
//see also JOB_PutOnHold
//•053195  MLB  UPR 1619
//10-31-05 mlb make hold optional
If ([Customers_Orders:40]LastStatus:48="")
	BEEP:C151
	[Customers_Orders:40]LastStatus:48:=Request:C163("Hold released. Set 'Order' Status back to:"; "?")
End if 
[Customers_Orders:40]Status:10:=[Customers_Orders:40]LastStatus:48
[Customers_Orders:40]ModWho:8:=<>zResp
[Customers_Orders:40]ModDate:9:=4D_Current_date
SAVE RECORD:C53([Customers_Orders:40])

READ WRITE:C146([Jobs:15])  //3/1/95 upr 1242
QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Customers_Orders:40]JobNo:44)

If (Records in selection:C76([Jobs:15])>0)  //•053195  MLB  UPR 1619
	If ([Jobs:15]LastStatus:16="")
		//BEEP
		//[JOB]LastStatus:=Request("Hold released. Set 'Job' Status back to:";"?")
	Else 
		[Jobs:15]Status:4:=[Jobs:15]LastStatus:16
		[Jobs:15]ModDate:8:=4D_Current_date
		[Jobs:15]ModWho:9:=<>zResp
		SAVE RECORD:C53([Jobs:15])
	End if 
End if 
UNLOAD RECORD:C212([Jobs:15])
//