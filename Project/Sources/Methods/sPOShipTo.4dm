//%attributes = {"publishedWeb":true}
//(p)sPOShipto
//called from radio buttons on PO entry form
//•041096  mBohince  
//• 1/31/97cs add code to save value to table
//• 6/30/97 cs added code to look fo rone parameter (string anything) as flag
//   to suppress message
//• 8/12/97 cs modification to correctly update budgets if division change
// • mel (3/31/05, 11:15:22)use address table

C_TEXT:C284($OldCompany; $1)
C_TEXT:C284($location)

$OldCompany:=[Purchase_Orders:11]CompanyID:43
[Purchase_Orders:11]SupplyChainPO:55:=""  //◊CHAIN_OF_CUSTODY ` used as a marker to find in database
Case of 
	: (rbShipTo1=1)  // | (rbShipTo3=1)
		$location:="Hauppauge"
		If (cb1=0)
			[Purchase_Orders:11]CompanyID:43:="1"
		Else 
			[Purchase_Orders:11]CompanyID:43:="3"
		End if 
		
	: (rbShipTo2=1)
		$location:="Roanoke"
		If (cb1=0)
			[Purchase_Orders:11]CompanyID:43:="2"
		Else 
			[Purchase_Orders:11]CompanyID:43:="3"
		End if 
		
	: (rbShipTo3=1)
		$location:="NYC"
		If (cb1=0)
			[Purchase_Orders:11]CompanyID:43:="4"
		Else 
			[Purchase_Orders:11]CompanyID:43:="3"
		End if 
		
	: (rbShipTo4=1)
		//$location:=Request("Enter the Address's 'ArkayPOAddress':")
		$msg:="Supply Chain means to ship this Commodity 17 material to another vendor(s) for additional processing. You may link multiple PO's in this manner. START WITH THE LAST AND WORK FORWARD.\n\n"
		$msg:=$msg+"This PO will need to be fully received BEFORE the next vendors material is recieved. "
		$msg:=$msg+"The next PO material will need to be FULLY received so that the unit cost of this "
		$msg:=$msg+"PO is spread evenly to the units of the next.    "
		$msg:=$msg+"When you recive this PO, a R/M location named with the next PO's number will be created. "
		$msg:=$msg+"When receiving the next PO, the temporary location will be relieved with a 'SupplyChain' transaction and its cost will be passed forward.\n\n"
		$msg:=$msg+"When the final PO in the chain is recieved, its unit cost will include all the costs accumlated in the chain. ALWAY RECEIVE BY THE PROCESS STEPS."
		util_FloatingAlert($msg)
		$msg:=""
		
		Repeat 
			$cool:=True:C214  //optimistic, eh?
			$supplyTo:=Request:C163("Enter the PO# to issue this to:"; "1234567"; "Build Supply Chain"; "Ship To Hauppauge")
			If (ok=1)
				If (util_isNumeric($supplyTo))  //this posible a PO
					If (Length:C16($supplyTo)=7) | (Length:C16($supplyTo)=9)
						$destinationPO:=Substring:C12($supplyTo; 1; 7)
						SET QUERY DESTINATION:C396(Into variable:K19:4; $found)
						QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$destinationPO)
						SET QUERY DESTINATION:C396(Into current selection:K19:1)
						If ($found=0)
							BEEP:C151
							ALERT:C41("PO number "+$destinationPO+" was not found.")
							$cool:=False:C215
						End if 
						
					Else 
						BEEP:C151
						ALERT:C41("Enter a 7 or 9 digit PO number.")
						$cool:=False:C215
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41("Enter a PO number.")
					$cool:=False:C215
				End if 
			End if 
		Until ($cool) | (ok=0)
		
		If (ok=1)
			[Purchase_Orders:11]SupplyChainPO:55:=$supplyTo
			$location:="SupplyChain-"+$supplyTo
			[Purchase_Orders:11]CompanyID:43:="5"
		Else 
			$location:="Default"
			[Purchase_Orders:11]CompanyID:43:="2"
			rbShipTo2:=1
			rbShipTo4:=0
		End if 
		
End case 

PO_SetAddress($location)

If ($OldCompany#[Purchase_Orders:11]CompanyID:43)  //user made change in division
	If (Count parameters:C259=0)
		If (Records in selection:C76([Purchase_Orders_Items:12])>0)  //after entering po_items
			xText:="The 'Division' charged for this purchase order has been changed "
			xText:=xText+"from '"+ChrgCodeToLoc($OldCOmpany)+"' to '"+ChrgCodeToLoc([Purchase_Orders:11]CompanyID:43)+"'."+Char:C90(13)
			xText:=xText+Char:C90(13)+"Do you want to change the "+"G/L code, on all the PO's Items, to match?"
			uConfirm(xText; "Change"; "Ignore")
		Else   //• 9/22/97 cs stop extra attempt to update non existing po_items
			OK:=0
		End if   //no items
	Else   //suppress confirm
		OK:=1
	End if   //suppress confrim
	
	If (OK=1)  //user wants to chage
		APPLY TO SELECTION:C70([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CompanyID:45:=[Purchase_Orders:11]CompanyID:43)
	End if   //change ok'd
End if   //changed company