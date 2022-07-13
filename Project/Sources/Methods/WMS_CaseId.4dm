//%attributes = {}
// Method: WMS_CaseId (scannedValue;"caseOpt";t:lot;i:serial;i:qty) -> value requested or null
// ----------------------------------------------------
// by: mel: 01/21/05, 11:48:29
// ----------------------------------------------------
// Description:
// take care of formating issues with the case id htat is barcoded on the lable
//83123.01.01 =first 9 =  831230101
//case number next 7 = 0000001`don't need 7, but want even number total len
//qty next 6 = 001200, negative signals partial and would be 101200
//there would be 22 chars long = 9312301010000001001200
// Updates:
//WMS_CaseId ("";"set";[Job_Forms_Items]Jobit;Selected record number([Job_Forms_Items]);1000)
//WMS_CaseId ("";"barcode";C1)
// ----------------------------------------------------
C_TEXT:C284($1; $0; $human)
C_TEXT:C284($2; $3; $lot; $serial; $qty)
C_LONGINT:C283($4; $5)

Case of 
	: ($2="jobit")
		$lot:=Substring:C12($1; 1; 9)
		$lot:=Insert string:C231($lot; "."; 8)
		$lot:=Insert string:C231($lot; "."; 6)
		$0:=$lot
		
	: ($2="serial")
		$0:=Substring:C12($1; 10; 7)
		
	: ($2="qty")
		$0:=Substring:C12($1; 17; 6)
		
	: ($2="set")
		If ($5>=0)  //watch for negative quantity
			$0:=Replace string:C233($3; "."; "")+String:C10($4; "0000000")+String:C10($5; "000000")
		Else   //add one hundred thousand to it
			$0:=Replace string:C233($3; "."; "")+String:C10($4; "0000000")+"1"+String:C10($5; "00000")
		End if 
		
	: ($2="barcode")
		$0:=BarCode_128auto($1)
		
	: ($2="human")
		//$lot:=WMS_CaseId ($1;"jobit")
		//$serial:=txt_Pad (String(Num(WMS_CaseId ($1;"serial"));"#'###'###");" ";-1;9)
		//$qty:=String(Num(WMS_CaseId ($1;"qty"));"###,##0")
		//$qty:=txt_Pad ($qty;" ";-1;7)
		//$0:=$lot+"  "+$serial+"  "+$qty
		$human:=Insert string:C231($1; "  "; 17)
		$0:=Insert string:C231($human; "  "; 10)
		
	: ($2="zebra")  //let the printer do the checkdigits
		$0:=$1
End case 
//
//sArkayUCCid:="0000808292"  `case arkay
//$serialnumber:=txt_Pad ([WMS_ItemMaster]id;"0";-1;9)
//
//$chkMod10:=fBarCodeMod10Digit (sArkayUCCid+$serialnumber)

//t2:=fBarCodeSym (128;sArkayUCCid+$serialnumber+$chkMod10)

//t1:=sArkayUCCid+$serialnumber+$chkMod10