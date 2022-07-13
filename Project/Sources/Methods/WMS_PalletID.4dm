//%attributes = {}
// Method: WMS_PalletID () -> 
// ----------------------------------------------------
// by: mel: 02/16/05, 20:50:51
// ----------------------------------------------------
// Description:
// jobit+serial+qty+cases
//812341212 001 001200 16
// Updates:

// ----------------------------------------------------
C_TEXT:C284($1)
C_TEXT:C284($0)
C_TEXT:C284($2; $3; $4; $lot; $serial; $qty)
C_LONGINT:C283($5; $6; $nextPallet; $numRecs; $i)
C_BOOLEAN:C305($gotRecord)

Case of 
	: ($2="jobit")
		$lot:=Substring:C12($1; 1; 9)
		$lot:=Insert string:C231($lot; "."; 8)
		$lot:=Insert string:C231($lot; "."; 6)
		$0:=$lot
	: ($2="serial")
		$0:=Substring:C12($1; 10; 3)
	: ($2="qty")
		$0:=Substring:C12($1; 13; 6)
	: ($2="cases")
		$0:=Substring:C12($1; 19; 2)
		
	: ($2="set")
		READ WRITE:C146([Job_Forms_Items_Skid_Counters:137])
		QUERY:C277([Job_Forms_Items_Skid_Counters:137]; [Job_Forms_Items_Skid_Counters:137]jobit:1=$3)
		If (Records in selection:C76([Job_Forms_Items_Skid_Counters:137])=0)
			CREATE RECORD:C68([Job_Forms_Items_Skid_Counters:137])
			[Job_Forms_Items_Skid_Counters:137]jobit:1:=$3
			[Job_Forms_Items_Skid_Counters:137]LastSkidCounter:2:=0
			$gotRecord:=True:C214
		Else 
			$gotRecord:=fLockNLoad(->[Job_Forms_Items_Skid_Counters:137])
		End if 
		
		$nextPallet:=[Job_Forms_Items_Skid_Counters:137]LastSkidCounter:2+1
		[Job_Forms_Items_Skid_Counters:137]LastSkidCounter:2:=$nextPallet
		SAVE RECORD:C53([Job_Forms_Items_Skid_Counters:137])
		REDUCE SELECTION:C351([Job_Forms_Items_Skid_Counters:137]; 0)
		
		$0:=Replace string:C233($3; "."; "")+String:C10($nextPallet; "000")+String:C10($5; "000000")+String:C10($6; "00")
		
	: ($2="barcode")
		$0:=BarCode_128auto($1)
		
	: ($2="human")
		$lot:=WMS_PalletID($1; "jobit")
		$serial:=WMS_PalletID($1; "serial")
		$qty:=WMS_PalletID($1; "qty")
		$cases:=WMS_PalletID($1; "cases")
		$0:=$lot+" "+$serial+" "+$qty+" "+$cases
		
	: ($2="zebra")  //let the printer do the checkdigits
		$0:=$1
End case 
//
