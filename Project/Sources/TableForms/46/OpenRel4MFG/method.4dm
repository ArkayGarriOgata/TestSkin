//(lp) [release schedule]openrel4mfg
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_ReleaseSchedules:46]CustID:12)
		ARRAY LONGINT:C221($aQty; 0)
		ARRAY TEXT:C222($aLoc; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLoc; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
		//FIRST RECORD([FG_Locations])
		r2:=0
		r3:=0
		C_LONGINT:C283($i)
		For ($i; 1; Size of array:C274($aLoc))
			Case of 
				: (Substring:C12($aLoc{$i}; 1; 5)="FG:AV")  //•071797  mBohince  don't count payuse locations
					//PayUse
				: (Substring:C12($aLoc{$i}; 1; 2)="FG")
					r2:=r2+$aQty{$i}
				Else 
					r3:=r3+$aQty{$i}
			End case 
		End for 
		ARRAY LONGINT:C221($aQty; 0)
		ARRAY TEXT:C222($aLoc; 0)
		
		r4:=[Customers_ReleaseSchedules:46]Sched_Qty:6-(r2+r3)
		
		Case of   //•071797  mBohince 
			: (r2>=[Customers_ReleaseSchedules:46]Sched_Qty:6)
				t8:=""
				t8a:="SHIP"
			: ((r2+r3)>=[Customers_ReleaseSchedules:46]Sched_Qty:6)
				t8:="EXAM"
				t8a:=""
			Else 
				t8:="MFG"
				t8a:=""
		End case 
		
		RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
		// RELATE ONE([OrderLines]Order)`•071797  mBohince  use [relsch]custoline
		r5:=([Customers_ReleaseSchedules:46]Sched_Qty:6/1000)*([Customers_Order_Lines:41]Price_Per_M:8-[Customers_Order_Lines:41]Cost_Per_M:7)
		
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_ReleaseSchedules:46]Shipto:10)
		t9:=[Addresses:30]City:6+", "+[Addresses:30]State:7
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_ReleaseSchedules:46]OrderLine:4; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Customers_ReleaseSchedules:46]ProductCode:11)
		If (Records in selection:C76([Job_Forms_Items:44])=0)
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=[Customers_ReleaseSchedules:46]ProductCode:11; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0)
		End if 
		Case of 
			: (Records in selection:C76([Job_Forms_Items:44])=1)
				r6:=[Job_Forms_Items:44]Qty_Yield:9-[Job_Forms_Items:44]Qty_Actual:11
				r7:=[Job_Forms_Items:44]Qty_Actual:11
				
			: (Records in selection:C76([Job_Forms_Items:44])>1)
				ARRAY LONGINT:C221($aQty; 0)
				ARRAY LONGINT:C221($aAct; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $aQty; [Job_Forms_Items:44]Qty_Actual:11; $aAct)
				r6:=0
				r7:=0
				For ($i; 1; Size of array:C274($aAct))
					r6:=r6+$aQty{$i}-$aAct{$i}
					r7:=r7+$aAct{$i}
				End for 
				ARRAY LONGINT:C221($aQty; 0)
				ARRAY LONGINT:C221($aAct; 0)
				
			Else 
				r6:=0
				r7:=0
				
		End case 
		
		RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)  //•061595  MLB  UPR 1631
		
		tText:=""  //•071797  mBohince marker to should existence of other releases
		$i:=Find in array:C230(aCPN; [Customers_ReleaseSchedules:46]ProductCode:11)  //find a release
		While ($i>-1)
			If (aDate{$i}#[Customers_ReleaseSchedules:46]Sched_Date:5)
				tText:="*"
			End if 
			$i:=Find in array:C230(aCPN; [Customers_ReleaseSchedules:46]ProductCode:11; ($i+1))
		End while 
		
End case 