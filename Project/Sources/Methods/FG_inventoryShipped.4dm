//%attributes = {"publishedWeb":true}
//PM: FG_inventoryShipped(fgkey;date) -> success or failure
//@author mlb - 9/3/02  11:47 called by FGL_inventoryShipped
// • mel (5/6/04, 14:51:18) make "repeat" after first shipment
// • mel (10/12/04, 17:02:33) see also FG_PrepServiceAutoContractInvi

C_TEXT:C284($fgKey; $1)
C_DATE:C307($date; $2)
C_BOOLEAN:C305($0; $success)

$fgKey:=$1
$date:=$2
$success:=False:C215

If (Position:C15("Prep:"; $fgKey)=0)  //not interested in things like 00121:Prep:1234-12-1234
	READ WRITE:C146([Finished_Goods:26])
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=$fgKey)
	
	If (Records in selection:C76([Finished_Goods:26])=0)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=(Substring:C12($fgKey; 7)))
	End if 
	
	If (Records in selection:C76([Finished_Goods:26])=1)
		If (fLockNLoad(->[Finished_Goods:26]))
			[Finished_Goods:26]LastShipDate:19:=$date
			If ([Finished_Goods:26]OriginalOrRepeat:71="Original")  // • mel (5/6/04, 14:51:18)
				[Finished_Goods:26]OriginalOrRepeat:71:="repeat"
				[Finished_Goods:26]DateFirstShipped:95:=$date  // • mel (10/12/04, 16:57:46) used by FG_PrepServiceAutoContractInvi
			End if 
			
			SAVE RECORD:C53([Finished_Goods:26])
			$success:=True:C214
			
		Else 
			$success:=False:C215
			utl_Logfile("shipping.log"; "F/G "+$fgKey+" LOCKED, was not updated by shipment. (see fgx-trigger)")
		End if 
		
	Else 
		$success:=False:C215
		utl_Logfile("shipping.log"; "F/G "+$fgKey+" N/F, was not updated by shipment. (see fgx-trigger)")
	End if 
End if 

$0:=$success