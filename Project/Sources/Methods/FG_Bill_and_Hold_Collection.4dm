//%attributes = {}
// Method: FG_Bill_and_Hold_Collection 
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 12/03/08, 16:16:39
// ----------------------------------------------------
// Description
// fifo regeneration should not value b&h amounts, this creates 
// a hash by jobit or fgKey to show qty available
// ----------------------------------------------------
// Modified by: Mel Bohince (5/15/14) don't chg r/w access
// Modified by: Mel Bohince (10/5/21) don't init if there are no B&H's

C_LONGINT:C283($0; $numFG; $numJMI; $jobCursor; $hit; $jobit; $cpn; $qty_sold)
C_TEXT:C284($msg; $1; $key; $2)

If (Count parameters:C259=0)  //for testing
	$msg:="init"
	$key:=""
Else 
	$msg:=$1
	If (Count parameters:C259>1)
		$key:=$2
	End if 
End if 

Case of 
	: ($msg="init")
		//READ ONLY([Finished_Goods])` Modified by: Mel Bohince (5/15/14) don't chg r/w access
		ARRAY TEXT:C222(aBH_FGkey; 0)
		ARRAY LONGINT:C221(aBH_Qty_Sold; 0)  //this is the quantity for a jobit adjusted by B&H amount
		ARRAY LONGINT:C221(aBH_Qty_Avail; 0)  //this is the quantity for a jobit adjusted by B&H amount
		
		ARRAY TEXT:C222(aBH_Jobit_FGkey; 0)
		ARRAY TEXT:C222(aBH_Jobit; 0)
		ARRAY LONGINT:C221(aBH_Jobit_Qty_Avail; 0)
		
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Bill_and_Hold_Qty:108>0)
		
		If (Records in selection:C76([Finished_Goods:26])>0)  // Modified by: Mel Bohince (10/5/21) don't init if there are no B&H's 
			
			SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; aBH_FGkey; [Finished_Goods:26]Bill_and_Hold_Qty:108; aBH_Qty_Sold)
			REDUCE SELECTION:C351([Finished_Goods:26]; 0)
			SORT ARRAY:C229(aBH_FGkey; aBH_Qty_Sold; >)
			$numFG:=Size of array:C274(aBH_FGkey)
			ARRAY LONGINT:C221(aBH_Qty_Avail; $numFG)
			For ($cpn; 1; $numFG)
				aBH_Qty_Avail{$cpn}:=-1  //init this for later pass since all jobits may not be visited
			End for 
			$0:=$numFG
			
			//convert to jobits
			ARRAY TEXT:C222(aBH_Jobit_FGkey; 0)
			ARRAY TEXT:C222(aBH_Jobit; 0)
			ARRAY LONGINT:C221(aBH_Jobit_Qty_Avail; 0)
			QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]FG_Key:34; aBH_FGkey)
			
			ARRAY LONGINT:C221($aQtyBin; 0)
			ARRAY TEXT:C222($aLocationJobit; 0)
			ARRAY TEXT:C222($aBH_FGkey; 0)
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $aLocationJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQtyBin; [Finished_Goods_Locations:35]FG_Key:34; $aBH_FGkey)
			REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
			$numJMI:=Size of array:C274($aLocationJobit)
			SORT ARRAY:C229($aLocationJobit; $aQtyBin; $aBH_FGkey; >)
			ARRAY LONGINT:C221(aBH_Jobit_Qty_Avail; $numJMI)
			ARRAY TEXT:C222(aBH_Jobit; $numJMI)
			ARRAY TEXT:C222(aBH_Jobit_FGkey; $numJMI)
			$jobCursor:=0
			uThermoInit($numJMI; "Collapsing inventory to jobit's")
			For ($jobit; 1; $numJMI)  //collapse inventory down to jobit's    
				$hit:=Find in array:C230(aBH_Jobit; $aLocationJobit{$jobit}; $jobCursor)
				If ($hit=-1)
					$jobCursor:=$jobCursor+1
					aBH_Jobit{$jobCursor}:=$aLocationJobit{$jobit}
					aBH_Jobit_FGkey{$jobCursor}:=$aBH_FGkey{$jobit}
					$hit:=$jobCursor
				End if 
				aBH_Jobit_Qty_Avail{$hit}:=aBH_Jobit_Qty_Avail{$hit}+$aQtyBin{$jobit}
				uThermoUpdate($jobit)
			End for 
			uThermoClose
			ARRAY TEXT:C222(aBH_Jobit_FGkey; $jobCursor)
			ARRAY LONGINT:C221(aBH_Jobit_Qty_Avail; $jobCursor)
			ARRAY TEXT:C222(aBH_Jobit; $jobCursor)
			ARRAY LONGINT:C221($aQtyBin; 0)
			ARRAY TEXT:C222($aLocationJobit; 0)
			ARRAY TEXT:C222($aBH_FGkey; 0)
			
			//now reduce jobit qty by b&h sold
			MULTI SORT ARRAY:C718(aBH_Jobit_FGkey; >; aBH_Jobit; >; aBH_Jobit_Qty_Avail)
			uThermoInit($numFG; "Processing B&H Items")
			For ($cpn; 1; $numFG)  //for each cpn that has B&H against it
				$qty_sold:=aBH_Qty_Sold{$cpn}  //will decrement this value
				//go to each distribute jobit qtys against the sold until it is satisfied
				$hit:=Find in array:C230(aBH_Jobit_FGkey; aBH_FGkey{$cpn})
				While ($qty_sold>0) & ($hit>-1)
					Case of 
						: ($qty_sold>=aBH_Jobit_Qty_Avail{$hit})  //then this jobit is totally committed to the b&h
							$qty_sold:=$qty_sold-aBH_Jobit_Qty_Avail{$hit}
							aBH_Jobit_Qty_Avail{$hit}:=0
							
						: ($qty_sold<aBH_Jobit_Qty_Avail{$hit})  //then only part of this jobit is committed and sold qty is satisfied
							aBH_Jobit_Qty_Avail{$hit}:=aBH_Jobit_Qty_Avail{$hit}-$qty_sold
							$qty_sold:=0
					End case 
					
					$hit:=Find in array:C230(aBH_Jobit_FGkey; aBH_FGkey{$cpn}; $hit+1)
				End while 
				
				uThermoUpdate($cpn)
			End for 
			uThermoClose
			
			$numJMI:=Size of array:C274(aBH_Jobit_FGkey)
			uThermoInit($numJMI; "Finding total available")
			For ($jobit; 1; $numJMI)  //find available by CPN
				$hit:=Find in array:C230(aBH_FGkey; aBH_Jobit_FGkey{$jobit})
				If ($hit>-1)
					If (aBH_Qty_Avail{$hit}=-1)  //init'd to -1 to show that no inventory existed
						aBH_Qty_Avail{$hit}:=0
					End if 
					aBH_Qty_Avail{$hit}:=aBH_Qty_Avail{$hit}+aBH_Jobit_Qty_Avail{$jobit}
				End if 
				uThermoUpdate($jobit)
			End for 
			uThermoClose
			
		End if   //any b&h's
		
	: ($msg="avail_jmi")  //find the unsold qty by jobit
		$hit:=Find in array:C230(aBH_Jobit; $key)
		If ($hit>-1)
			$0:=aBH_Jobit_Qty_Avail{$hit}
		Else 
			$0:=$hit
		End if 
		
	: ($msg="sold")  //find the sold qty by fg_key
		$hit:=Find in array:C230(aBH_FGkey; $key)
		If ($hit>-1)
			$0:=aBH_Qty_Sold{$hit}
		Else 
			$0:=$hit
		End if 
		
	: ($msg="available")  //find the unsold qty by fg_key
		$hit:=Find in array:C230(aBH_FGkey; $key)
		If ($hit>-1)
			$0:=aBH_Qty_Avail{$hit}
		Else 
			$0:=$hit
		End if 
		
	: ($msg="missing")
		utl_LogIt("init")
		utl_LogIt("B&H WITHOUT ANY INVENTORY")
		utl_LogIt("FG_KEY"+"        "+"SOLD")
		utl_LogIt("====== ")
		For ($cpn; 1; Size of array:C274(aBH_Qty_Avail))
			If (aBH_Qty_Avail{$cpn}=-1)  //no inventory was found
				utl_LogIt(aBH_FGkey{$cpn}+"  "+String:C10(aBH_Qty_Sold{$cpn}))
			End if 
		End for 
		utl_LogIt("show")
		
	: ($msg="remaining")
		utl_LogIt("init")
		utl_LogIt("REMAINING AFTER B&H ")
		utl_LogIt("FG_KEY"+"        "+"JOBIT"+"        "+"REMAINING")
		utl_LogIt("====== ")
		For ($jobit; 1; Size of array:C274(aBH_Jobit_Qty_Avail))
			If (aBH_Jobit_Qty_Avail{$jobit}>0)  //not all inventory was B&H'd
				utl_LogIt(aBH_Jobit_FGkey{$jobit}+"  "+aBH_Jobit{$jobit}+"  "+String:C10(aBH_Jobit_Qty_Avail{$jobit}))
			End if 
		End for 
		utl_LogIt("show")
		
	: ($msg="kill")
		ARRAY TEXT:C222(aBH_FGkey; 0)
		ARRAY LONGINT:C221(aBH_Qty_Sold; 0)
		ARRAY LONGINT:C221(aBH_Qty_Avail; 0)
		
		ARRAY TEXT:C222(aBH_Jobit_FGkey; 0)
		ARRAY TEXT:C222(aBH_Jobit; 0)
		ARRAY LONGINT:C221(aBH_Jobit_Qty_Avail; 0)
		$0:=0
End case 