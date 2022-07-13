//(lop) custagedinv
//•051695  MLB  UPR 1526
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		MESSAGE:C88(".")
		If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)#"BH")
			$qtyOH:=[Finished_Goods_Locations:35]QtyOH:9
			r10:=r10+$qtyOH
			qryJMI([Finished_Goods_Locations:35]JobForm:19; [Finished_Goods_Locations:35]JobFormItem:32; [Finished_Goods_Locations:35]ProductCode:1)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				
				Case of 
					: ([Job_Forms_Items:44]Glued:33=!00-00-00!)
						r7:=r7+$qtyOH
						r8:=r8+(($qtyOH/1000)*[Job_Forms_Items:44]PldCostTotal:21)
						
					: ([Job_Forms_Items:44]Glued:33>=Under06)
						r1:=r1+$qtyOH
						r2:=r2+(($qtyOH/1000)*[Job_Forms_Items:44]PldCostTotal:21)
						
					: ([Job_Forms_Items:44]Glued:33>=Under09)
						r3:=r3+$qtyOH
						r4:=r4+(($qtyOH/1000)*[Job_Forms_Items:44]PldCostTotal:21)
						
					: ([Job_Forms_Items:44]Glued:33>=Under12)
						r5:=r5+$qtyOH
						r6:=r6+(($qtyOH/1000)*[Job_Forms_Items:44]PldCostTotal:21)
						
					Else 
						r7:=r7+$qtyOH
						r8:=r8+(($qtyOH/1000)*[Job_Forms_Items:44]PldCostTotal:21)
						
				End case 
			End if   //jmi found        
			
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
				MESSAGE:C88(Char:C90(13)+[Finished_Goods_Locations:35]CustID:16)
				
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
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCPN)
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				$recs:=Records in selection:C76([Customers_Order_Lines:41])
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					For ($i; 1; $recs)  //consume all open orders
						$openDemand:=[Customers_Order_Lines:41]Qty_Open:11+([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100))  //•051695  MLB  UPR 1526
						NEXT RECORD:C51([Customers_Order_Lines:41])
					End for 
					
					
				Else 
					
					ARRAY LONGINT:C221($_Qty_Open; 0)
					ARRAY LONGINT:C221($_Quantity; 0)
					ARRAY REAL:C219($_OverRun; 0)
					SELECTION TO ARRAY:C260(\
						[Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; \
						[Customers_Order_Lines:41]Quantity:6; $_Quantity; \
						[Customers_Order_Lines:41]OverRun:25; $_OverRun)
					
					For ($i; 1; $recs)  //consume all open orders
						$openDemand:=$_Qty_Open{$i}+($_Quantity{$i}*($_OverRun{$i}/100))  //•051695  MLB  UPR 1526
					End for 
					
				End if   // END 4D Professional Services : January 2019 query selection
				r11:=r10-$openDemand
				If (r11<0)
					r11:=0
				End if 
				
				r9:=r7+r5+r3+r1
				r12:=r8+r6+r4+r2
				
			: (Level:C101=1)
				If ([Customers:16]ID:1#[Finished_Goods_Locations:35]CustID:16)
					READ ONLY:C145([Customers:16])
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
				
				MESSAGE:C88(Char:C90(13)+[Customers:16]Name:2)
				
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