//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 11/10/09, 09:35:24
// ----------------------------------------------------
// Method: ELC_Obsoletes
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305($limitSearch)  //things that were obsolete changed over time to non obsolete, use this to limit to past month

If (Count parameters:C259=0)
	$pid:=New process:C317("ELC_Obsoletes"; <>lMinMemPart; "ELC Obsoletes"; "init")
	If (False:C215)
		ELC_Obsoletes
	End if 
	
Else 
	uConfirm("Which DELFOR records should be considered?"; "Past Month"; "All")
	If (OK=1)
		$limitSearch:=True:C214
	Else 
		$limitSearch:=False:C215
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numLinks:=ELC_query(->[Finished_Goods_DeliveryForcasts:145]Custid:12)
		QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Is_Obsolete:13=True:C214)
		If ($limitSearch)
			$earliest_delfor_date:=fYYMMDD(Add to date:C393(4D_Current_date; 0; -1; 0); 4)
			QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9>=$earliest_delfor_date)
		End if 
		
		
	Else 
		
		$critiria:=ELC_getName
		READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
		If ($limitSearch)
			$earliest_delfor_date:=fYYMMDD(Add to date:C393(4D_Current_date; 0; -1; 0); 4)
			QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9>=$earliest_delfor_date; *)
		End if 
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Customers:16]ParentCorp:19=$critiria; *)
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Is_Obsolete:13=True:C214)
		
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	
	If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
		DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; $aCPN)
		QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $aCPN)
		
		pattern_PassThru(->[Finished_Goods:26])
		ViewSetter(2; ->[Finished_Goods:26])
	Else 
		uConfirm("No obsoletes found."; "OK"; "Help")
	End if 
End if 