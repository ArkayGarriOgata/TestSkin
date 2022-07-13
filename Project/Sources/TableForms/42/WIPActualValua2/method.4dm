Case of   //4/24/95
	: (Form event code:C388=On Display Detail:K2:22)
		//get cust name
		If ([Jobs:15]JobNo:1#[Job_Forms:42]JobNo:2)
			QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Job_Forms:42]JobNo:2)
		End if 
		
		//determine mat'l  
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			r1:=0
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<nextPeriod)  //
			FIRST RECORD:C50([Raw_Materials_Transactions:23])
			ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Sequence:13; >)
			For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
				r1:=r1+([Raw_Materials_Transactions:23]ActExtCost:10*-1)  //convert to relative to wip
				NEXT RECORD:C51([Raw_Materials_Transactions:23])
			End for 
			
			//determine hrs, $labor & $burden
			r2:=0
			r3:=0
			r6:=0
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<nextPeriod)
			ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >)
			FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
			For ($i; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
				qryCostCenter([Job_Forms_Machine_Tickets:61]CostCenterID:2; !00-00-00!)
				$hrs:=[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				r6:=r6+$hrs
				r2:=r2+($hrs*[Cost_Centers:27]MHRlaborSales:4)
				r3:=r3+($hrs*[Cost_Centers:27]MHRburdenSales:5)
				NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
			End for 
			
			//dtermine total
			r4:=r1+r2+r3
			
			//determine cartons transfered
			r5:=0
			MESSAGE:C88("c")
			//SEARCH([JobMakesItem];[JobMakesItem]JobForm=[JobForm]JobFormID)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<nextPeriod; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
			//change to a search of the fg transfers
			FIRST RECORD:C50([Finished_Goods_Transactions:33])
			For ($i; 1; Records in selection:C76([Finished_Goods_Transactions:33]))
				r5:=r5+[Finished_Goods_Transactions:33]Qty:6
				NEXT RECORD:C51([Finished_Goods_Transactions:33])
			End for 
			
		Else 
			
			r1:=0
			
			ARRAY INTEGER:C220($_Sequence; 0)
			ARRAY REAL:C219($_ActExtCost; 0)
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<nextPeriod)  //
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Sequence:13; $_Sequence; [Raw_Materials_Transactions:23]ActExtCost:10; $_ActExtCost)
			SORT ARRAY:C229($_Sequence; $_ActExtCost; >)
			
			For ($i; 1; Size of array:C274($_ActExtCost); 1)
				
				r1:=r1+($_ActExtCost{$i}*-1)
				
			End for 
			
			r2:=0
			r3:=0
			r6:=0
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<nextPeriod)
			
			ARRAY INTEGER:C220($_Sequence; 0)
			ARRAY TEXT:C222($_CostCenterID; 0)
			ARRAY REAL:C219($_MR_Act; 0)
			ARRAY REAL:C219($_Run_Act; 0)
			
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Sequence:3; $_Sequence; [Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; [Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; [Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act)
			
			SORT ARRAY:C229($_Sequence; $_CostCenterID; $_MR_Act; $_Run_Act; >)
			
			For ($i; 1; Size of array:C274($_CostCenterID); 1)
				qryCostCenter($_CostCenterID{$i}; !00-00-00!)
				$hrs:=$_MR_Act{$i}+$_Run_Act{$i}
				r6:=r6+$hrs
				r2:=r2+($hrs*[Cost_Centers:27]MHRlaborSales:4)
				r3:=r3+($hrs*[Cost_Centers:27]MHRburdenSales:5)
			End for 
			
			//dtermine total
			r4:=r1+r2+r3
			
			//determine cartons transfered
			
			r5:=0
			MESSAGE:C88("c")
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<nextPeriod; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
			
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Qty:6; $_Qty)
			
			For ($i; 1; Size of array:C274($_Qty); 1)
				
				r5:=r5+$_Qty{$i}
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		If (fSave)
			SEND PACKET:C103(vDoc; [Job_Forms:42]JobFormID:5+Char:C90(9))
			SEND PACKET:C103(vDoc; [Jobs:15]CustomerName:5+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(r1)+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(r2)+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(r3)+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(r4)+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(r5)+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(r6)+Char:C90(13))
		End if 
		
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=0)
				If ([Customers:16]ID:1#[Finished_Goods_Locations:35]CustID:16)
					READ ONLY:C145([Customers:16])
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Locations:35]CustID:16)
				End if 
				r1:=Round:C94(Subtotal:C97(r1); 0)
				r2:=Round:C94(Subtotal:C97(r2); 0)
				r3:=Round:C94(Subtotal:C97(r3); 0)
				r4:=Round:C94(Subtotal:C97(r4); 0)
				r5:=Round:C94(Subtotal:C97(r5); 0)
				r6:=Round:C94(Subtotal:C97(r6); 0)
				
				If (fSave)
					SEND PACKET:C103(vDoc; Char:C90(13)+Char:C90(9)+"GRAND TOTALS:"+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(Round:C94(r1; 2))+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(Round:C94(r2; 2))+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(Round:C94(r3; 2))+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(Round:C94(r4; 2))+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r5)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r6)+Char:C90(13)+Char:C90(13))
				End if 
		End case 
		
End case 
//