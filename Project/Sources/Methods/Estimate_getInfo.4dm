//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/24/06, 14:45:42
// ----------------------------------------------------
// Method: Estimate_getInfo({estimate_no})
// Description
// rtn text about workflow dates and team members
// ----------------------------------------------------

C_TEXT:C284($1; $estimate; $r)
C_TEXT:C284($info; $0)

$r:=Char:C90(13)

If (Count parameters:C259=1)
	$estimate:=$1
	If ([Estimates:17]EstimateNo:1#$estimate)
		READ ONLY:C145([Estimates:17])
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$estimate)
	End if 
Else 
	$estimate:=[Estimates:17]EstimateNo:1
End if 

$info:=""

If (Length:C16([Estimates:17]CreatedBy:59)>0)
	$info:=$info+"Created by: "+[Estimates:17]CreatedBy:59+$r
End if 

If (Length:C16([Estimates:17]EstimatedBy:14)>0)
	$info:=$info+"Estimated by: "+[Estimates:17]EstimatedBy:14+$r
End if 

If (Length:C16([Estimates:17]PricedBy:15)>0)
	$info:=$info+"Priced by: "+[Estimates:17]PricedBy:15+$r
End if 

If (Length:C16([Estimates:17]PlannedBy:16)>0)
	$info:=$info+"Planned by: "+[Estimates:17]PlannedBy:16+$r
End if 

If (Length:C16([Estimates:17]Sales_Rep:13)>0)
	$info:=$info+"Salesman: "+[Estimates:17]Sales_Rep:13+$r
End if 

If (Length:C16([Estimates:17]SaleCoord:46)>0)
	$info:=$info+"Coordinator: "+[Estimates:17]SaleCoord:46+$r
End if 

If (Length:C16([Estimates:17]Terms:7)>0)
	$info:=$info+"Terms: "+[Estimates:17]Terms:7+$r
End if 

If (Length:C16([Estimates:17]ShippingVia:6)>0)
	$info:=$info+"Ship Via: "+[Estimates:17]ShippingVia:6+$r
End if 

If (Length:C16([Estimates:17]FOB:8)>0)
	$info:=$info+"FOB: "+[Estimates:17]FOB:8+$r
End if 

If ([Estimates:17]DateOriginated:19#!00-00-00!)
	$info:=$info+"Created: "+String:C10([Estimates:17]DateOriginated:19; Internal date short:K1:7)+$r
End if 

If ([Estimates:17]DateRFQ:52#!00-00-00!)
	$info:=$info+"RFQ'd: "+String:C10([Estimates:17]DateRFQ:52; Internal date short:K1:7)+$r
End if 

If ([Estimates:17]DatePrice:60#!00-00-00!)
	$info:=$info+"Priced: "+String:C10([Estimates:17]DatePrice:60; Internal date short:K1:7)+$r
End if 

If ([Estimates:17]DatePrepared:20#!00-00-00!)
	$info:=$info+"Prepared: "+String:C10([Estimates:17]DatePrepared:20; Internal date short:K1:7)+$r
End if 

If ([Estimates:17]DateQuoted:61#!00-00-00!)
	$info:=$info+"Quoted: "+String:C10([Estimates:17]DateQuoted:61; Internal date short:K1:7)+$r
End if 

$0:=$info