//If (Length([QA_Corrective_ActionsLocations]Contact1Email)#0)
//$to:=[QA_Corrective_ActionsLocations]Contact1Email
//If (Length([QA_Corrective_ActionsLocations]Contact2Email)#0)
//$to:=$to+","+[QA_Corrective_ActionsLocations]Contact2Email
//End if 
[QA_Corrective_Actions:105]DateReported:22:=4D_Current_date
SAVE RECORD:C53([QA_Corrective_Actions:105])
$cr:=Char:C90(13)  //"%0D"  `"%1D%1A"
$t:=""  //"        "

$lb:="#"  //"%23"  `#

$cc:=Replace string:C233(Current user:C182; " "; ".")+"@arkay.com"
$inline:=Uppercase:C13("Arkay Packaging Corporation")+$cr
$inline:=$inline+"CORRECTIVE ACTION REPORT"+$cr+$cr
$inline:=$inline+"ITEM: "+[QA_Corrective_Actions:105]ProductCode:7+$cr
$inline:=$inline+"DESC: "+[Finished_Goods:26]CartonDesc:3+$cr
$inline:=$inline+"LINE: "+[Finished_Goods:26]Line_Brand:15+$cr
$inline:=$inline+"QTY: "+String:C10([QA_Corrective_Actions:105]QtyComplaint:23; "###,###,##0")+$cr  //
$inline:=$inline+"P.O.: "+[QA_Corrective_Actions:105]CustomerPO:12+$cr  //
$inline:=$inline+"CUSTOMER REFERENCE: "+[QA_Corrective_Actions:105]CustomerRefer:11+$cr
$inline:=$inline+"REASON: "+[QA_Corrective_Actions:105]ReasonCustomer:24+$cr+$cr

$inline:=$inline+"ARKAY LOT: "+[QA_Corrective_Actions:105]Jobit:9+$cr
$inline:=$inline+"DOM: "+String:C10([Job_Forms_Items:44]Glued:33; Internal date short special:K1:4)+$cr  //
$inline:=$inline+"QTY PRODUCED: "+String:C10([Job_Forms_Items:44]Qty_Actual:11; "###,###,##0")+$cr
$inline:=$inline+"CAR: "+[QA_Corrective_Actions:105]RequestNumber:1+$cr

If (Length:C16([QA_Corrective_Actions:105]RGA:4)>0)
	$inline:=$inline+"RGA: "+[QA_Corrective_Actions:105]RGA:4+$cr+$cr
Else 
	$inline:=$inline+$cr+$cr
End if 

$inline:=$inline+"ROOT CAUSE: "+[QA_Corrective_Actions:105]RootCause:17+$cr+$cr
$inline:=$inline+"CORRECTIVE ACTION: "+[QA_Corrective_Actions:105]ActionTaken:18+$cr+$cr
$inline:=$inline+"EFFECTIVE DATE: "+String:C10([QA_Corrective_Actions:105]DateEffective:19; Internal date short:K1:7)+$cr+$cr

$closing:=$cr+$cr
//$closing:=$closing+"John Sheridan"+$cr
//$closing:=$closing+"Quality Assurance Manager"+$cr
//$closing:=$closing+"Arkay Packaging Corporation"+$cr
//$closing:=$closing+"100 Marcus Blvd"+$cr
//$closing:=$closing+"Suite 2"+$cr
//$closing:=$closing+"Hauppauge, NY 11788  USA"+$cr+$cr
//$closing:=$closing+"Ph: 540-278-2605"+$cr
//$closing:=$closing+"Fx: 540-977-2503"+$cr
//$closing:=$closing+"Email: John.Sheridan@arkay.com"+$cr


utl_LogIt("init")
utl_LogIt($inline)
utl_LogIt("show")

//util_OpenEmailClient ($to;$cc;"";"Arkay Corrective Action for "+[QA_Corrective_Actions]RequestNumber;$inline+$closing)

//Else 
//BEEP
//ALERT("You need to enter an email address for contact 1.")
//End if 