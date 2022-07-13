//%attributes = {}
// Method: WMS_SkidId(scannedValue;option;apptype;counter)

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/12/08, 12:29:03
// ----------------------------------------------------
// Description

// ----------------------------------------------------
C_TEXT:C284($1; $0; $human)
C_TEXT:C284($2; $3; $lot; $serial; $qty)
C_LONGINT:C283($4; $5)

Case of 
	: ($2="app-type")  //3rd digit = Type(0=wip, 1=p&g, 2=fg)
		If (Substring:C12($1; 1; 1)="(")  //human readable
			$apptype:=Substring:C12($1; 5; 1)
		Else 
			$apptype:=Substring:C12($1; 3; 1)
		End if 
		Case of 
			: ($apptype="0")
				$0:="WIP"
			: ($apptype="1")
				$0:="P&G"
			: ($apptype="2")
				$0:="F/G"
			: ($apptype="3")
				$0:="O/S"
			: ($apptype="4")
				$0:="RGA"
			: ($apptype="9")
				$0:="PRE"  //Supercase export
		End case 
		
	: ($2="serial")
		If (Substring:C12($1; 1; 1)="(")  //human readable
			$0:=Substring:C12($1; 15; 9)
		Else 
			$0:=Substring:C12($1; 11; 9)
		End if 
		
	: ($2="arkay-ucc")
		$0:="0808292"
		
	: ($2="set")
		If ($4=0)  //CREATE RECORD([WMS_SerializedShippingLabels])
			wmsSkidNumber:=1  //get next counter value
		Else 
			wmsSkidNumber:=$4
		End if 
		$serialnumber:=String:C10(wmsSkidNumber; "000000000")
		$sArkayUCCid:="00"+$3+"0808292"  //sscc app code+containerType(0=wip, 1=p&g, 2=fg)+UCCregistration#
		$chkMod10:=fBarCodeMod10Digit($sArkayUCCid+$serialnumber)
		$barcodeValue:="00"+$3+"0808292"+$serialnumber+$chkMod10
		$0:=$barcodeValue
		
	: ($2="value")  //make ready for barcode font
		$SSCC_HumanReadable:=$1
		$SSCC_Barcode:=Replace string:C233($SSCC_HumanReadable; "("; "")
		$SSCC_Barcode:=Replace string:C233($SSCC_Barcode; ")"; "")
		$SSCC_Barcode:=Replace string:C233($SSCC_Barcode; " "; "")
		$0:=$SSCC_Barcode
		
	: ($2="barcode")  //make ready for barcode font
		$SSCC_HumanReadable:=$1
		$barcodeValue:=WMS_SkidId($SSCC_HumanReadable; "value")
		$0:=BarCode_128auto($barcodeValue)
		
	: ($2="human")  //pretty format
		$barcodeValue:=$1
		$SSCC_HumanReadable:=Insert string:C231($barcodeValue; " "; 20)
		$SSCC_HumanReadable:=Insert string:C231($SSCC_HumanReadable; " "; 11)
		$SSCC_HumanReadable:=Insert string:C231($SSCC_HumanReadable; " "; 4)
		$SSCC_HumanReadable:=Insert string:C231($SSCC_HumanReadable; ")"; 3)
		$SSCC_HumanReadable:=Insert string:C231($SSCC_HumanReadable; "("; 1)
		$0:=$SSCC_HumanReadable
		
	: ($2="zebra")  //let the printer do the checkdigits
		$serialnumber:=String:C10($4; "000000000")
		$sArkayUCCid:="00"+$3+"0808292"  //sscc app code+containerType(0=wip, 1=p&g, 2=fg)+UCCregistration#
		$barcodeValue:="00"+$3+"0808292"+$serialnumber
		$0:=$barcodeValue
		
End case 

