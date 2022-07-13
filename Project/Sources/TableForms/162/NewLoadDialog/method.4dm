// _______
// Method: [Job_Forms_Loads].NewLoadDialog   ( ) ->
// By: MelvinBohince @ 03/28/22, 13:53:47
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (3/28/22) if PO then issue option

Case of 
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.calcGross:=Form:C1466.qty*Form:C1466.numberLoads
		If (Form:C1466.calcGross>Form:C1466.grossSheets)
			//uConfirm("Gross sheet count will be exceeded by "+String(Form.grossSheets-Form.calcGross))
			//$numberLoads:=$numberLoads-1
			//$addPartial:=True
		Else 
			//beep
			//$addPartial:=False
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		If (Length:C16(Form:C1466.po)=9)  // Modified by: MelvinBohince (3/28/22) 
			OBJECT SET TITLE:C194(*; "ok"; "Issue")
		End if 
		
End case 
