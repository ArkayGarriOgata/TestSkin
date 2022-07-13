//zSetUsageStat ("AskMe";"Mod Rel";sCustID+":"+sCPN)
//• mlb - 2/12/03  16:19 use named selection
If (ListBox1#0)
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		GOTO RECORD:C242([Finished_Goods_DeliveryForcasts:145]; aRecNo{ListBox1})  //• mlb - 2/12/03  16:23
		CREATE SET:C116([Finished_Goods_DeliveryForcasts:145]; "◊PassThroughSet")
		
		
	Else 
		
		ARRAY LONGINT:C221($_record_number; 0)
		APPEND TO ARRAY:C911($_record_number; aRecNo{ListBox1})
		CREATE SET FROM ARRAY:C641([Finished_Goods_DeliveryForcasts:145]; $_record_number; "◊PassThroughSet")
		
	End if   // END 4D Professional Services : January 2019 
	<>PassThrough:=True:C214
	
	ViewSetter(2; ->[Finished_Goods_DeliveryForcasts:145])
End if 
//