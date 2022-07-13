//%attributes = {"publishedWeb":true}
//(p) JCOCloseInkPO
//mark the InkPo as closed - so that it can be archived
//7/28/98 cs created
//071807 mlb, also get non-ink poitems

If ([Job_Forms:42]InkPONumber:54#"")  //if this jobform has a PO number associated with it
	READ WRITE:C146([Purchase_Orders:11])
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=[Job_Forms:42]InkPONumber:54)
	If (fLockNLoad(->[Purchase_Orders:11]))
		[Purchase_Orders:11]Status:15:="Closed"  //mark as closed
		[Purchase_Orders:11]StatusBy:16:="Syst"  //who
		[Purchase_Orders:11]StatusDate:17:=4D_Current_date  //when
		[Purchase_Orders:11]Comments:21:=[Purchase_Orders:11]Comments:21+Char:C90(13)+"Closed by Job Close out."
		[Purchase_Orders:11]INX_autoPO:48:=False:C215  //stops ability to receive against this now that it is closed
		[Purchase_Orders:11]StatusTrack:51:=[Purchase_Orders:11]StatusTrack:51+"; Closeout "+String:C10(4D_Current_date)
		SAVE RECORD:C53([Purchase_Orders:11])
	End if 
	READ WRITE:C146([Purchase_Orders_Items:12])
	RELATE MANY:C262([Purchase_Orders:11]PONo:1)  //get POitems
	
	//Repeat 
	APPLY TO SELECTION:C70([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27:=0)  //zero open qty
	If (Records in set:C195("LockedSet")>0)
		utl_Logfile("recordlock.log"; "Locked: "+String:C10(Records in set:C195("LockedSet"))+" in "+Table name:C256(->[Purchase_Orders_Items:12]))
	End if 
	
	REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
	REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	REDUCE SELECTION:C351([Purchase_Orders_Job_forms:59]; 0)
End if 