$lastPrice:=FG_getLastPrice([Finished_Goods:26]FG_KEY:47)
If ($lastPrice#0)
	[Finished_Goods:26]LastPrice:27:=$lastPrice
Else 
	BEEP:C151
	ALERT:C41("Couldn't find a last price to use, fix manually.")
End if 