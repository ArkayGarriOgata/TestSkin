//%attributes = {}
// -------
// Method: FGL_NoValueInventory   ( ) ->
// By: Mel Bohince @ 03/22/16, 09:02:58
// Description
// find inventory that no order or release exists
// ----------------------------------------------------
// Modified by: Mel Bohince (4/21/16) give 3, 6, or 9 mth choice
// Modified by: Mel Bohince (5/13/16) check for liability set

C_TEXT:C284($1)
C_DATE:C307($notNullDate; $overXmths)
C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $numElements; $hit; $bin)
READ ONLY:C145([Finished_Goods:26])


If (Count parameters:C259=0)  //pattern_Self_calling_process
	$pid:=New process:C317("FGL_NoValueInventory"; <>lMidMemPart; "NoValueInventory"; "init")
	If (False:C215)
		FGL_NoValueInventory
	End if 
	
Else 
	
	Case of 
		: ($1="init")
			//get supply
			ARRAY TEXT:C222($fgl_cpn; 0)
			ARRAY TEXT:C222($fgl_bin; 0)
			ARRAY LONGINT:C221($fgl_qty; 0)
			ARRAY TEXT:C222($fgl_jobit; 0)
			ARRAY LONGINT:C221($fgl_jobit_qty; 0)
			
			$choice:=uYesNoCancel("All surplus or just old surplus?"; "Old"; "All"; "Cancel")
			Case of 
				: ($choice="Old")
					
					$notNullDate:=!1994-01-01!
					
					$choice:=uYesNoCancel("How old?"; "9 Months"; "6 Months"; "3 Months")
					Case of 
						: ($choice="9 Months")
							$overXmths:=Add to date:C393(Current date:C33; 0; -9; 0)
							$title:="Items with inventory over 9 months old and no open order, release, or forecast.\r\r"
						: ($choice="6 Months")
							$overXmths:=Add to date:C393(Current date:C33; 0; -6; 0)
							$title:="Items with inventory over 6 months old and no open order, release, or forecast.\r\r"
						: ($choice="3 Months")
							$overXmths:=Add to date:C393(Current date:C33; 0; -3; 0)
							$title:="Items with inventory over 3 months old and no open order, release, or forecast.\r\r"
					End case 
					
					//grabbing the fg_key so that we have access to the cust id, later need to substring to remove before lookups in ords and rels
					Begin SQL
						SELECT FG_Key, sum(QtyOH) from Finished_Goods_Locations where QtyOH > 0 and jobit in 
						(select Jobit from Job_Forms_Items where Glued < :$overXmths and Glued > :$notNullDate ) 
						GROUP BY FG_Key order by FG_Key
						into :$fgl_cpn, :$fgl_qty
					End SQL
					
				: ($choice="All")
					$title:="Items with inventory and no open order, release, or forecast.\r\r"
					//grabbing the fg_key so that we have access to the cust id, later need to substring to remove before lookups in ords and rels
					Begin SQL
						SELECT FG_Key, sum(QtyOH) from Finished_Goods_Locations where QtyOH > 0 
						GROUP BY FG_Key order by FG_Key
						into :$fgl_cpn, :$fgl_qty
					End SQL
					
			End case 
			
			If ($choice#"Cancel")
				
				//get demand, including forecast
				ARRAY TEXT:C222($rel_cpn; 0)
				ARRAY LONGINT:C221($rel_qty; 0)
				
				Begin SQL
					SELECT ProductCode, sum(Sched_Qty) from Customers_ReleaseSchedules where Actual_Qty = 0 GROUP BY ProductCode
					into :$rel_cpn, :$rel_qty
				End SQL
				
				//get demand from open orders
				ARRAY TEXT:C222($ol_cpn; 0)
				ARRAY LONGINT:C221($ol_qty; 0)
				
				Begin SQL
					SELECT ProductCode, sum(Qty_Open) from Customers_Order_Lines where 
					Qty_Open > 0 and 
					UPPER(Status) not in ('CLOSED', 'CANCEL', 'CANCELLED', 'KILL', 'REJECTED')
					GROUP BY ProductCode
					into :$ol_cpn, :$ol_qty
				End SQL
				
				$numElements:=Size of array:C274($fgl_cpn)
				ARRAY TEXT:C222($excess_cpn; 0)
				ARRAY LONGINT:C221($excess_qty; 0)
				
				//excess if no order or release, then total qty is excess. not considering qty over demand
				uThermoInit($numElements; "Testing for demand...")
				For ($i; 1; $numElements)
					$cpn:=Substring:C12($fgl_cpn{$i}; 7)
					$hit:=Find in array:C230($ol_cpn; $cpn)
					If ($hit=-1)  //no order
						$hit:=Find in array:C230($rel_cpn; $cpn)
						If ($hit=-1)  //no release
							APPEND TO ARRAY:C911($excess_cpn; $fgl_cpn{$i})  //save full fgkey
							APPEND TO ARRAY:C911($excess_qty; $fgl_qty{$i})
						End if 
					End if 
					
					uThermoUpdate($i)
				End for 
				uThermoClose
				
				//save it to excel
				$text:=""
				$docName:="NoDemandFound"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
				$docRef:=util_putFileName(->$docName)
				
				If ($docRef#?00:00:00?)
					SEND PACKET:C103($docRef; $title)
					
					$text:="Customer\tProductCode\tOnHand\tLiability\tNumHrs\tNumBins\tBinList1\tBinList2\tBinList3\tBinList4\tBinList5\tBinList6\tBinList7\r"
					$total:=0
					$ttl_liability:=0
					$ttl_hours:=0
					$numElements:=Size of array:C274($excess_cpn)
					uThermoInit($numElements; "Saving results...")
					For ($i; 1; $numElements)
						If (Length:C16($text)>25000)
							SEND PACKET:C103($docRef; $text)
							$text:=""
						End if 
						
						$cpn:=Substring:C12($excess_cpn{$i}; 7)
						$cust:=CUST_getName(Substring:C12($excess_cpn{$i}; 1; 5))
						
						QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=$excess_cpn{$i}; *)  // Modified by: Mel Bohince (5/13/16) check for liability set
						QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]InventoryLiability:111>0)
						If (Records in selection:C76([Finished_Goods:26])>0)
							$liability:=[Finished_Goods:26]InventoryLiability:111
						Else 
							$liability:=0
						End if 
						$ttl_liability:=$ttl_liability+$liability
						
						$text:=$text+$cust+"\t"+$cpn+"\t"+String:C10($excess_qty{$i})+"\t"+String:C10($liability)+"\t"
						$total:=$total+$excess_qty{$i}
						//calc hours wasted
						Begin SQL
							SELECT Jobit, QtyOH from Finished_Goods_Locations where ProductCode = :$cpn order by Jobit desc
							into :$fgl_jobit, :$fgl_jobit_qty
						End SQL
						$hrs:=0
						$numJobits:=Size of array:C274($fgl_jobit)
						For ($jobit; 1; $numJobits)
							$hrs:=$hrs+JMI_ConvertQuantityToHrs($fgl_jobit{$jobit}; $fgl_jobit_qty{$jobit})
						End for 
						$text:=$text+String:C10($hrs)+"\t"
						$ttl_hours:=$ttl_hours+$hrs
						
						//show the bins
						Begin SQL
							SELECT Location from Finished_Goods_Locations where ProductCode = :$cpn
							into :$fgl_bin
						End SQL
						$numBins:=Size of array:C274($fgl_bin)
						$text:=$text+String:C10($numBins)+"\t"
						For ($bin; 1; $numBins)
							$text:=$text+$fgl_bin{$bin}+"\t"
						End for 
						$text:=$text+"\r"
						
						uThermoUpdate($i)
					End for 
					uThermoClose
					
					$text:=$text+"\r\tTTL Excess\t"+String:C10($total)+"\t"+String:C10($ttl_liability)+"\t"+String:C10($ttl_hours)+"\t"+String:C10(Round:C94(($ttl_hours*114); 0); "$###,###,##0")+"\tGluing Hrs x Gluing $_OOP\r"
					
					
					SEND PACKET:C103($docRef; $text)
					SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
					CLOSE DOCUMENT:C267($docRef)
					
					
					$err:=util_Launch_External_App($docName)
				End if 
				
			End if   //not cancel
	End case   //$1
	
End if 