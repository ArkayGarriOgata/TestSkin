//%attributes = {"publishedWeb":true}
//(p) PoInsertFaxDate
//insert the date that the user attemptd to fax the current PO
//maybe called from an apply to selection
//• 6/18/98 cs created

$Pos:=Position:C15("Faxed"; [Purchase_Orders:11]Printed:49)

If ($Pos=0)  //NOT faxed before
	[Purchase_Orders:11]Printed:49:="Faxed "+String:C10(4D_Current_date)+" "+[Purchase_Orders:11]Printed:49
Else   // replace date
	[Purchase_Orders:11]Printed:49:=Substring:C12([Purchase_Orders:11]Printed:49; 1; Position:C15("Faxed"; [Purchase_Orders:11]Printed:49)+5)+String:C10(4D_Current_date)+Substring:C12([Purchase_Orders:11]Printed:49; Position:C15("Faxed"; [Purchase_Orders:11]Printed:49)+16)
End if 