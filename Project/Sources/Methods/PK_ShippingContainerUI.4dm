//%attributes = {"publishedWeb":true}
//PK_ShippingContainerUI

C_TEXT:C284($1; $outlineNumber; $2; $actionRequested)
C_LONGINT:C283($id)

Case of 
	: (Count parameters:C259=0)
		$id:=New process:C317("PK_ShippingContainerUI"; <>lMinMemPart; "Entering Case Packs"; "new"; "")
		If (False:C215)
			PK_ShippingContainerUI
		End if 
		
	: (Count parameters:C259=1)
		$outlineNumber:=$1
		$id:=New process:C317("PK_ShippingContainerUI"; <>lMinMemPart; "Entering Case Packs"; "update"; $outlineNumber)
		
	Else 
		<>iMode:=2
		<>filePtr:=->[Finished_Goods_PackingSpecs:91]
		uSetUp(1)
		
		windowTitle:="Packing Specifications"
		$winRef:=OpenFormWindow(->[Finished_Goods_PackingSpecs:91]; "Input"; ->windowTitle)
		$actionRequested:=$1
		$outlineNumber:=$2
		C_LONGINT:C283(iPSTabs)
		iPSTabs:=0
		
		Case of 
			: ($actionRequested="new")
				iMode:=1
				READ WRITE:C146([Finished_Goods_PackingSpecs:91])
				READ WRITE:C146([Finished_Goods:26])
				ADD RECORD:C56([Finished_Goods_PackingSpecs:91]; *)
				
			: ($actionRequested="update")
				READ WRITE:C146([Finished_Goods_PackingSpecs:91])
				READ WRITE:C146([Finished_Goods:26])
				QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$outlineNumber)
				Case of 
					: (Records in selection:C76([Finished_Goods_PackingSpecs:91])=1)
						MODIFY RECORD:C57([Finished_Goods_PackingSpecs:91]; *)
					: (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
						MODIFY SELECTION:C204([Finished_Goods_PackingSpecs:91]; *)
					Else 
						uConfirm("No shipping instructions found for this Product's Outline number, "+$outlineNumber+"."; "Create"; "Cancel")
						If (ok=1)
							CREATE RECORD:C68([Finished_Goods_PackingSpecs:91])
							[Finished_Goods_PackingSpecs:91]FileOutlineNum:1:=$outlineNumber
							[Finished_Goods_PackingSpecs:91]TopPadMaterial:16:="SBS"
							SAVE RECORD:C53([Finished_Goods_PackingSpecs:91])
							MODIFY RECORD:C57([Finished_Goods_PackingSpecs:91]; *)
						End if 
				End case 
				
			Else 
				iMode:=3
				READ ONLY:C145([Finished_Goods_PackingSpecs:91])
				READ ONLY:C145([Finished_Goods:26])
				QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$outlineNumber)
				DISPLAY SELECTION:C59([Finished_Goods_PackingSpecs:91]; *)
		End case 
		
		CLOSE WINDOW:C154($winRef)
		REDUCE SELECTION:C351([Finished_Goods_PackingSpecs:91]; 0)
End case 