//(s) bFax
C_LONGINT:C283($errCode)
C_TEXT:C284($holdPrinterName)  //the switch printer command doesn't seem to work
$holdPrinterName:=Get current printer:C788

//$errCode:=Fax ([Vendors]Name+" "+[Vendors]DefaultAttn;[Vendors]Fax;[Vendors]City+", "+[Vendors]State;"";"";"";"PO-"+[Purchase_Orders]PONo;"")
If ($errCode=0)
	If ([Purchase_Orders:11]Status:15="Req@") | ([Purchase_Orders:11]Status:15="Rev@")
		uConfirm("This PO has not yet been approved"+Char:C90(13)+"Fax the Requistion instead of PO?"; "Print Req"; "Cancel")
		If (ok=1)
			ReqPrint([Purchase_Orders:11]PONo:1)  //print
		End if 
	Else 
		rLaserPo("PO")
	End if 
	//$errCode:=Fax 
	
	If ($errCode=0)
		PoInsertFaxDate  //• 6/18/98 cs insert date fax was sent
		SAVE RECORD:C53([Purchase_Orders:11])
	End if 
End if 

SET CURRENT PRINTER:C787($holdPrinterName)
//


