//Layout Proc.: GluerAnalysis()  071495  MLB

Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Job_Forms_Machine_Tickets:61]Run_Act:7#0)
			r1:=([Job_Forms_Machine_Tickets:61]Good_Units:8+[Job_Forms_Machine_Tickets:61]Waste_Units:9)/[Job_Forms_Machine_Tickets:61]Run_Act:7
		Else 
			r1:=0
		End if 
		If ([Job_Forms_Machine_Tickets:61]BudRunSpeed:13#0)
			r2:=(([Job_Forms_Machine_Tickets:61]BudRunSpeed:13-r1)/[Job_Forms_Machine_Tickets:61]BudRunSpeed:13)*100
		Else 
			r2:=0
		End if 
		
		If (([Job_Forms_Items:44]JobForm:1#[Job_Forms_Machine_Tickets:61]JobForm:1) | ([Job_Forms_Items:44]ItemNumber:7#[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ItemNumber:7=[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4)
			RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
		End if 
		If ([Finished_Goods:26]FG_KEY:47#([Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3))  //for glue type and size
			qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		End if 
		If ([Process_Specs:18]ID:1#[Job_Forms:42]ProcessSpec:46)
			QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Job_Forms:42]ProcessSpec:46; *)
			QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Job_Forms_Items:44]CustId:15)
		End if 
		
	: (Form event code:C388=On Printing Break:K2:19)
		If (Level:C101=3)
			r3:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Good_Units:8)
			r4:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Waste_Units:9)
			r5:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_Act:6)
			r6:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_AdjStd:14)
			r7:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_Act:7)
			r8:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_AdjStd:15)
			If (r7#0)
				r9:=(r3+r4)/r7
			Else 
				r9:=0
			End if 
			If ([Job_Forms_Machine_Tickets:61]BudRunSpeed:13#0)
				r10:=(([Job_Forms_Machine_Tickets:61]BudRunSpeed:13-r9)/[Job_Forms_Machine_Tickets:61]BudRunSpeed:13)*100
			Else 
				r10:=0
			End if 
			If (fSave)
				SEND PACKET:C103(vDoc; [Job_Forms_Machine_Tickets:61]CostCenterID:2+Char:C90(9)+[Job_Forms_Machine_Tickets:61]JobForm:1+Char:C90(9)+String:C10([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4)+Char:C90(9))
				SEND PACKET:C103(vDoc; String:C10(r3)+Char:C90(9)+String:C10(r4)+Char:C90(9)+String:C10(r5)+Char:C90(9))
				SEND PACKET:C103(vDoc; String:C10(r6)+Char:C90(9)+String:C10(r7)+Char:C90(9)+String:C10(r8)+Char:C90(9))
				SEND PACKET:C103(vDoc; String:C10([Job_Forms_Machine_Tickets:61]BudRunSpeed:13)+Char:C90(9)+String:C10(r9)+Char:C90(9)+String:C10(r10)+Char:C90(9))
				SEND PACKET:C103(vDoc; [Finished_Goods:26]GlueType:34+Char:C90(9)+String:C10([Finished_Goods:26]Width_Dec:10)+Char:C90(9)+String:C10([Finished_Goods:26]Depth_Dec:11)+Char:C90(9)+String:C10([Finished_Goods:26]Height_Dec:12)+Char:C90(9)+String:C10([Process_Specs:18]Caliper:8)+Char:C90(9))
				SEND PACKET:C103(vDoc; [Process_Specs:18]Stock:7+Char:C90(9)+[Process_Specs:18]iCoat1Matl:20+Char:C90(9)+[Process_Specs:18]FilmLaminate:11+Char:C90(9))
				SEND PACKET:C103(vDoc; [Process_Specs:18]ID:1+Char:C90(13))
			End if 
		End if 
		
End case 
//