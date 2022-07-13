//%attributes = {"publishedWeb":true}
//x_ImportOrdObj  see also x_ExportOrder
//5/2/95 , 5/3/95 fix compile errors
// Modified by: Mel Bohince (2/17/16) add pk_id:=Generate UUID
C_TEXT:C284($order)
C_TEXT:C284($importCCO)
C_BOOLEAN:C305($reKey)
C_LONGINT:C283($newID; $importRel)

READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_Order_Change_Orders:34])
READ WRITE:C146([Customers_ReleaseSchedules:46])

$order:=Request:C163("Import which order:"; "00000")
If (OK=1)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=Num:C11($order))
	If (Records in selection:C76([Customers_Orders:40])>0)
		BEEP:C151
		ALERT:C41($order+" already exists, a new number will be assigned.")
		$reKey:=True:C214
	Else 
		$reKey:=False:C215
	End if 
	SET CHANNEL:C77(10; $order+"_01")
	RECEIVE RECORD:C79([Customers_Orders:40])
	If (OK=1)
		If ($reKey)
			C_TEXT:C284($server)
			$server:="?"
			vord:=-3
			app_getNextID(Table:C252(->[Customers_Orders:40]); ->$server; ->vord)
			$newID:=vord  //Sequ444ence number([Customers_Orders])+◊aOffSet{Table(->[Customers_Orders])}
			[Customers_Orders:40]OrderNumber:1:=$newID
			BEEP:C151
			ALERT:C41("Order has been renumbered to "+String:C10($newID; "00000"))
		End if 
		Open window:C153(20; 50; 180; 350; 1; "")
		MESSAGE:C88(Char:C90(13)+"Customer Order")
		[Customers_Orders:40]pk_id:62:=Generate UUID:C1066
		SAVE RECORD:C53([Customers_Orders:40])
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"Orderlines")
		SET CHANNEL:C77(10; ($order+"_02"))
		RECEIVE RECORD:C79([Customers_Order_Lines:41])
		While (OK=1)
			If ($reKey)
				[Customers_Order_Lines:41]OrderNumber:1:=$newID
				[Customers_Order_Lines:41]OrderLine:3:=String:C10($newID; "00000")+"."+String:C10([Customers_Order_Lines:41]LineItem:2; "00")
			End if 
			[Customers_Order_Lines:41]pk_id:71:=Generate UUID:C1066
			SAVE RECORD:C53([Customers_Order_Lines:41])
			RECEIVE RECORD:C79([Customers_Order_Lines:41])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"Change History")
		SET CHANNEL:C77(10; ($order+"_03"))
		RECEIVE RECORD:C79([Customers_Order_Change_Orders:34])
		While (OK=1)
			If ($reKey)
				[Customers_Order_Change_Orders:34]OrderNo:5:=$newID
			End if 
			$importCCO:=[Customers_Order_Change_Orders:34]ChangeOrderNumb:1
			PUSH RECORD:C176([Customers_Order_Change_Orders:34])
			QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]ChangeOrderNumb:1=$importCCO)
			If (Records in selection:C76([Customers_Order_Change_Orders:34])>0)
				$importCCO:=app_GetPrimaryKey  //app_AutoIncrement (->[Customers_Order_Change_Orders])
			End if 
			POP RECORD:C177([Customers_Order_Change_Orders:34])
			[Customers_Order_Change_Orders:34]ChangeOrderNumb:1:=$importCCO
			[Customers_Order_Change_Orders:34]pk_id:50:=Generate UUID:C1066
			SAVE RECORD:C53([Customers_Order_Change_Orders:34])
			RECEIVE RECORD:C79([Customers_Order_Change_Orders:34])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"ReleaseSchedule")
		SET CHANNEL:C77(10; ($order+"_04"))
		RECEIVE RECORD:C79([Customers_ReleaseSchedules:46])
		While (OK=1)
			If ($reKey)
				[Customers_ReleaseSchedules:46]OrderNumber:2:=$newID
				[Customers_ReleaseSchedules:46]OrderLine:4:=String:C10($newID; "00000")+Substring:C12([Customers_ReleaseSchedules:46]OrderLine:4; 6; 3)
			End if 
			$importRel:=[Customers_ReleaseSchedules:46]ReleaseNumber:1
			PUSH RECORD:C176([Customers_ReleaseSchedules:46])
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$importRel)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				$importRel:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
			End if 
			POP RECORD:C177([Customers_ReleaseSchedules:46])
			[Customers_ReleaseSchedules:46]ReleaseNumber:1:=$importRel
			[Customers_ReleaseSchedules:46]pk_id:54:=Generate UUID:C1066
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			RECEIVE RECORD:C79([Customers_ReleaseSchedules:46])
		End while 
		SET CHANNEL:C77(11)
		
	End if 
	CLOSE WINDOW:C154
	
Else 
	BEEP:C151
	ALERT:C41($order+" could not be received.")
End if 
SET CHANNEL:C77(11)

UNLOAD RECORD:C212([Customers_Orders:40])
UNLOAD RECORD:C212([Customers_Order_Lines:41])
UNLOAD RECORD:C212([Customers_Order_Change_Orders:34])
UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])