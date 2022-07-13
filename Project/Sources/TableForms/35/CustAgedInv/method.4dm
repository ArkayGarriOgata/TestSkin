//(lop) custagedinv
//•051695  MLB  UPR 1526
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		//MESSAGE(".")
		If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)#"BH")
			r10:=r10+[Finished_Goods_Locations:35]QtyOH:9
		End if 
		
	: (Form event code:C388=On Header:K2:17)
		Case of 
			: (Level:C101=2)  //cpn changed
				r10:=0
				sCPN:=[Finished_Goods_Locations:35]ProductCode:1
				
			: (Level:C101=1)  //cust
				t10:=""
				r1:=0
				r2:=0
				r3:=0
				r4:=0
				r5:=0
				r6:=0
				r7:=0
				r8:=0
				r10:=0
				r11:=0
				r9:=0
				r12:=0
				//MESSAGE(Char(13)+[FG_Locations]CustID)
				
			: (Level:C101=0)
				r21:=0
				r22:=0
				r23:=0
				r24:=0
				r25:=0
				r26:=0
				r27:=0
				r28:=0
				r29:=0
				r32:=0
				r33:=0  //•051695  MLB  UPR 1526
		End case 
		
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=2)  //all qty of cpn is totaled, now age and price it
				C_LONGINT:C283($i; $recs)
				C_LONGINT:C283($openDemand)  //•051695  MLB  UPR 1526 include overrun  
				USE SET:C118("opens")
				QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCPN)
				
				$recs:=Records in selection:C76([Customers_Order_Lines:41])
				If ($recs>0)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
						
						ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; <)
						For ($i; 1; $recs)  //consume all open orders
							$openDemand:=[Customers_Order_Lines:41]Qty_Open:11+([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100))  //•051695  MLB  UPR 1526
							Case of 
								: (r10<=$openDemand)  //[OrderLines]Qty_Open)  `all goes in to that bucket
									Case of 
										: ([Customers_Order_Lines:41]DateOpened:13>=Under06)
											r1:=r1+r10
											r2:=r2+((r10/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
										: ([Customers_Order_Lines:41]DateOpened:13>=Under09)
											r3:=r3+r10
											r4:=r4+((r10/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
										: ([Customers_Order_Lines:41]DateOpened:13>=Under12)
											r5:=r5+r10
											r6:=r6+((r10/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
										Else 
											r7:=r7+r10
											r8:=r8+((r10/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
									End case 
									r10:=r10-r10
									
								: (r10>$openDemand)  //[OrderLines]Qty_Open)  `use the open qty
									Case of 
										: ([Customers_Order_Lines:41]DateOpened:13>=Under06)
											r1:=r1+$openDemand  //[OrderLines]Qty_Open
											r2:=r2+(($openDemand/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
										: ([Customers_Order_Lines:41]DateOpened:13>=Under09)
											r3:=r3+$openDemand  //[OrderLines]Qty_Open
											r4:=r4+(($openDemand/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
										: ([Customers_Order_Lines:41]DateOpened:13>=Under12)
											r5:=r5+$openDemand  //[OrderLines]Qty_Open
											r6:=r6+(($openDemand/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
										Else 
											r7:=r7+$openDemand  //[OrderLines]Qty_Open
											r8:=r8+(($openDemand/1000)*[Customers_Order_Lines:41]Price_Per_M:8)
									End case 
									r10:=r10-$openDemand  //[OrderLines]Qty_Open
							End case 
							//MESSAGE("!")
							
							If (r10<=0)
								$i:=$i+$recs  //break
							Else 
								NEXT RECORD:C51([Customers_Order_Lines:41])
							End if 
							
						End for 
						
					Else 
						
						ARRAY DATE:C224($_DateOpened; 0)
						ARRAY LONGINT:C221($_Qty_Open; 0)
						ARRAY LONGINT:C221($_Quantity; 0)
						ARRAY REAL:C219($_OverRun; 0)
						ARRAY REAL:C219($_Price_Per_M; 0)
						
						
						SELECTION TO ARRAY:C260([Customers_Order_Lines:41]DateOpened:13; $_DateOpened; [Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]OverRun:25; $_OverRun; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M)
						
						SORT ARRAY:C229($_DateOpened; $_Qty_Open; $_Quantity; $_OverRun; $_Price_Per_M; <)
						
						For ($i; 1; $recs; 1)  //consume all open orders
							$openDemand:=$_Qty_Open{$i}+($_Quantity{$i}*($_OverRun{$i}/100))  //•051695  MLB  UPR 1526
							Case of 
								: (r10<=$openDemand)  //[OrderLines]Qty_Open)  `all goes in to that bucket
									Case of 
										: ($_DateOpened{$i}>=Under06)
											r1:=r1+r10
											r2:=r2+((r10/1000)*$_Price_Per_M{$i})
										: ($_DateOpened{$i}>=Under09)
											r3:=r3+r10
											r4:=r4+((r10/1000)*$_Price_Per_M{$i})
										: ($_DateOpened{$i}>=Under12)
											r5:=r5+r10
											r6:=r6+((r10/1000)*$_Price_Per_M{$i})
										Else 
											r7:=r7+r10
											r8:=r8+((r10/1000)*$_Price_Per_M{$i})
									End case 
									r10:=r10-r10
									
								: (r10>$openDemand)  //[OrderLines]Qty_Open)  `use the open qty
									Case of 
										: ($_DateOpened{$i}>=Under06)
											r1:=r1+$openDemand  //[OrderLines]Qty_Open
											r2:=r2+(($openDemand/1000)*$_Price_Per_M{$i})
										: ($_DateOpened{$i}>=Under09)
											r3:=r3+$openDemand  //[OrderLines]Qty_Open
											r4:=r4+(($openDemand/1000)*$_Price_Per_M{$i})
										: ($_DateOpened{$i}>=Under12)
											r5:=r5+$openDemand  //[OrderLines]Qty_Open
											r6:=r6+(($openDemand/1000)*$_Price_Per_M{$i})
										Else 
											r7:=r7+$openDemand  //[OrderLines]Qty_Open
											r8:=r8+(($openDemand/1000)*$_Price_Per_M{$i})
									End case 
									r10:=r10-$openDemand  //[OrderLines]Qty_Open
							End case 
							//MESSAGE("!")
							
							If (r10<=0)
								$i:=$i+$recs  //break
							Else 
								
							End if 
							
						End for 
						
					End if   // END 4D Professional Services : January 2019 First record
					
					If (r10>0)
						r11:=r11+r10
					End if 
					
				Else   //excess stock
					If (r10>0)
						r11:=r11+r10
					End if 
					
				End if 
				
				r9:=r7+r5+r3+r1
				r12:=r8+r6+r4+r2
			: (Level:C101=1)
				If ([Customers:16]ID:1#[Finished_Goods_Locations:35]CustID:16)
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Locations:35]CustID:16)
				End if 
				
				r21:=r21+r1
				r22:=r22+Round:C94(r2; 0)
				r23:=r23+r3
				r24:=r24+Round:C94(r4; 0)
				r25:=r25+r5
				r26:=r26+Round:C94(r6; 0)
				r27:=r27+r7
				r28:=r28+Round:C94(r8; 0)
				r29:=r29+r9
				r32:=r32+Round:C94(r12; 0)
				r33:=r33+r11  //•051695  MLB  UPR 1526
				
				//MESSAGE(Char(13)+[CUSTOMER]Name)
				
				If (fSave)
					SEND PACKET:C103(vDoc; [Customers:16]Name:2+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r1)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r2)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r3)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r4)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r5)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r6)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r7)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r8)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r11)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r9)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r12)+Char:C90(13))
				End if 
				
			: (Level:C101=0)
				
				If (fSave)
					SEND PACKET:C103(vDoc; Char:C90(13)+"GRAND TOTALS:"+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r21)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r22)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r23)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r24)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r25)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r26)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r27)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r28)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r33)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r29)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r32)+Char:C90(9))
					SEND PACKET:C103(vDoc; Char:C90(13)+Char:C90(13))
				End if 
		End case 
		
End case 
//