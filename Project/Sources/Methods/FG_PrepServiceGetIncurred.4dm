//%attributes = {}
// Method: FG_PrepServiceGetIncurred ({controlnumber}) -> Sum([PrepCharges]PriceActual)
// ----------------------------------------------------
// by: mel: 12/10/04, 11:39:27
// ----------------------------------------------------
// Description:
// make method that can be used in QRpt that totals
//the prep service incurred.
//see also FG_PrepServiceGetQuote, FG_PrepServiceGetRevised
// ----------------------------------------------------

C_REAL:C285($0)
C_TEXT:C284($1; $controlNumber)

If (Count parameters:C259=1)
	$controlNumber:=$1
Else 
	$controlNumber:=[Finished_Goods_Specifications:98]ControlNumber:2
End if 

QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$controlNumber)
If (Records in selection:C76([Prep_Charges:103])>0)
	$0:=Round:C94(Sum:C1([Prep_Charges:103]PriceActual:5); 2)
Else 
	$0:=0
End if 

REDUCE SELECTION:C351([Prep_Charges:103]; 0)