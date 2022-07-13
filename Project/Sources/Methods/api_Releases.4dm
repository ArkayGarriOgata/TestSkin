//%attributes = {}
// -------
// Method: api_Releases   ( ) ->
// By: Mel Bohince @ 06/07/17, 15:47:12
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements; $rel)
C_TEXT:C284($1; $0; $res)
C_OBJECT:C1216($obj_by_value)
C_BOOLEAN:C305($debug)
$debug:=False:C215

READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Addresses:30])

If (Count parameters:C259=0) & (Not:C34($debug))  //rtn a collection
	//$0:=Selection to JSON([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]ProductCode;[Customers_ReleaseSchedules]CustomerLine;[Customers_ReleaseSchedules]CustomerRefer;[Customers_ReleaseSchedules]Sched_Date;[Customers_ReleaseSchedules]Sched_Qty;[Customers_ReleaseSchedules]Shipto)
	
Else   //got me some params
	
	If (Not:C34($debug))
		$rel:=Num:C11($1)
	Else 
		$rel:=3446282
	End if 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$rel)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
		C_OBJECT:C1216($Release)
		OB SET:C1220($Release; "release"; String:C10($rel))
		OB SET:C1220($Release; "customer"; CUST_getName([Customers_ReleaseSchedules:46]CustID:12))
		OB SET:C1220($Release; "line"; [Customers_ReleaseSchedules:46]CustomerLine:28)
		OB SET:C1220($Release; "po"; [Customers_ReleaseSchedules:46]CustomerRefer:3)
		OB SET:C1220($Release; "cpn"; [Customers_ReleaseSchedules:46]ProductCode:11)
		OB SET:C1220($Release; "scheduled"; String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; Internal date short special:K1:4))
		OB SET:C1220($Release; "quantity"; String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6))
		If ([Customers_ReleaseSchedules:46]MustShip:53)
			OB SET:C1220($Release; "must_ship"; String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; Internal date short special:K1:4))
		End if 
		
		If (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))
			OB SET:C1220($Release; "rfm_sent"; String:C10([Customers_ReleaseSchedules:46]user_date_1:48; Internal date short special:K1:4))
			OB SET:C1220($Release; "rfm_received"; String:C10([Customers_ReleaseSchedules:46]user_date_2:49; Internal date short special:K1:4))
		End if 
		
		$address:=[Customers_ReleaseSchedules:46]Shipto:10+"; "+ADDR_getName([Customers_ReleaseSchedules:46]Shipto:10)+"; "+ADDR_getCity([Customers_ReleaseSchedules:46]Shipto:10)+"; "+ADDR_getState([Customers_ReleaseSchedules:46]Shipto:10)+"; "+ADDR_getCountry([Customers_ReleaseSchedules:46]Shipto:10)
		OB SET:C1220($Release; "destination"; $address)
		//FG_LaunchItem ("init")
		//$launch:=FG_LaunchItem ("is";[Customers_ReleaseSchedules]ProductCode)
		//$launchHold:=FG_LaunchItem ("hold";[Customers_ReleaseSchedules]ProductCode)
		
		//get items
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33; >)
				For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
					OB SET:C1220($item; "jobit"; [Finished_Goods_Locations:35]Jobit:33; "bin"; [Finished_Goods_Locations:35]Location:2; "qty"; String:C10([Finished_Goods_Locations:35]QtyOH:9))
					$obj_by_value:=OB Copy:C1225($item)
					APPEND TO ARRAY:C911($items; $obj_by_value)
					NEXT RECORD:C51([Finished_Goods_Locations:35])
				End for 
				OB SET ARRAY:C1227($Release; "inventory"; $items)
			End if 
			
			
		Else 
			
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $_Jobit; [Finished_Goods_Locations:35]Location:2; $_Location; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
				SORT ARRAY:C229($_Jobit; $_Location; $_QtyOH; >)
				For ($i; 1; Size of array:C274($_Jobit); 1)
					OB SET:C1220($item; "jobit"; $_Jobit{$i}; "bin"; $_Location{$i}; "qty"; String:C10($_QtyOH{$i}))
					$obj_by_value:=OB Copy:C1225($item)
					APPEND TO ARRAY:C911($items; $obj_by_value)
				End for 
				OB SET ARRAY:C1227($Release; "inventory"; $items)
			End if 
			
			
		End if   // END 4D Professional Services : January 2019 First record
		
		$res:=JSON Stringify:C1217($Release; *)
		If ($debug)
			utl_LogIt("init")
			utl_LogIt($res)
			utl_LogIt("show")
		Else 
			$0:=$res
		End if 
		
	Else 
		$res:="404 "+String:C10($rel)+" not found"
	End if 
	
End if   //count parameters

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Addresses:30]; 0)
