//%attributes = {"publishedWeb":true}
//(p) MkSetupOnHand
//set the onhand vars for MaryKay report
//• 1/15/98 cs created
//• 3/19/98 cs setup so this procedure returns new (adjusted) carryfwd
//• 5/18/98 cs allow carry forward of excess as an option

C_TEXT:C284($NextCPN)
C_REAL:C285($CarryFwd; $2; $0)

$NextCPN:=$1
$CarryFwd:=$2

//rReal7 = Qty on hand
If ($nextCPN#sCpn)  //the next product is different  
	rReal7:=$CarryFwd  //Gross onhand - items in payuse
Else 
	
	Case of 
		: (rReal3=0)  //no production on this line and more orders for this CPN
			rReal7:=0
		: ($CarryFwd>=rReal8)  //Net on hand ≥ bal due , and there is production
			rReal7:=rReal8
			$CarryFwd:=$CarryFwd-rReal8
		Else   //bal due > Net on hand, and there is production
			rReal7:=$CarryFwd
			$CarryFwd:=0
	End case 
End if 

If (rReal7<0)
	rReal7:=0
End if 

Case of 
	: (rReal8<=0) & (rReal6>0)  //balance due on order is less than qty in Payuse
		rReal9:=rReal6  //set amount Cust resp = Payuse bin
	: (rReal7>rReal8)  //on hand > Balance due
		rReal9:=rReal8+rReal6  //Customer Resp =  Bal due+Payuse
	Else 
		rReal9:=rReal7+rReal6  //Customer Resp =  on hand+Payuse
End case 

$0:=$CarryFwd