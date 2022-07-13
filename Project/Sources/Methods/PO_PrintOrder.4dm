//%attributes = {}
// Method: PO_PrintOrder () -> 
// ----------------------------------------------------
// by: mel: 10/21/04, 10:06:16
// ----------------------------------------------------
// Description:
// rewrite of rLaserPO
// ----------------------------------------------------

C_BOOLEAN:C305(showSignature)

SET WINDOW TITLE:C213("Printing PURCHASE ORDER "+[Purchase_Orders:11]PONo:1)
FORM SET OUTPUT:C54([Purchase_Orders:11]; "LaserPO")

PDF_setUp("PO"+[Purchase_Orders:11]PONo:1+".pdf"; False:C215)

If ($1="Print")
	showSignature:=True:C214
Else 
	showSignature:=False:C215
End if 

PRINT RECORD:C71([Purchase_Orders:11]; *)

If (showSignature) & (<>fContinue)  //• 3/26/98 cs make this so that the printed state is updated ONLY if sig is used
	[Purchase_Orders:11]Printed:49:="Printed"
	[Purchase_Orders:11]StatusTrack:51:="Printed "+TS2String(TSTimeStamp)+" by "+<>zResp+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
	SAVE RECORD:C53([Purchase_Orders:11])
End if 

FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")