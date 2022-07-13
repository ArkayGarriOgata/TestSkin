//%attributes = {}
// _______
// Method: orda_action_move   ( ) ->
// By: Mel Bohince @ 08/12/19, 16:24:01
// Description
// based on JPR's Invoice example
// ----------------------------------------------------

$what2do:=$1
$page:=FORM Get current page:C276

//If (Form event#On Load)
//  //Products_InputCommonTasks($evt;"SAVE")
//End if 

$OK:=True:C214

Case of 
	: ($page=2)
		Case of 
			: ($what2do="FIRST")
				Form:C1466.clickedBin:=Form:C1466.clickedBin.first()
				Form:C1466.clickedBinPosition:=1
			: ($what2do="PREVIOUS")
				If (Not:C34(Form:C1466.clickedBin.previous()=Null:C1517))
					Form:C1466.clickedBin:=Form:C1466.clickedBin.previous()
					Form:C1466.clickedBinPosition:=Form:C1466.clickedBinPosition-1
				End if 
			: ($what2do="NEXT")
				If (Not:C34(Form:C1466.clickedBin.next()=Null:C1517))  //isLast())
					Form:C1466.clickedBin:=Form:C1466.clickedBin.next()
					Form:C1466.clickedBinPosition:=Form:C1466.clickedBinPosition+1
				End if 
			: ($what2do="LAST")
				Form:C1466.clickedBin:=Form:C1466.clickedBin.last()
				Form:C1466.clickedBinPosition:=Form:C1466.Form.clickedBin.length
			Else 
				$OK:=False:C215
		End case 
		
		If ($OK)
			Form:C1466.bin:=Form:C1466.clickedBin
			Form:C1466.rm:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; Form:C1466.bin.PartNumber).first()
			//Form.editEntity:=Form.clickedEntity
			//orda_util_EntityLoad (Form.editEntity;Form.objectsNames)
		End if 
		
	: ($page=3)
		Case of 
			: ($what2do="FIRST")
				Form:C1466.clickedPart:=Form:C1466.clickedPart.first()
			: ($what2do="PREVIOUS")
				If (Not:C34(Form:C1466.clickedPart.previous()=Null:C1517))
					Form:C1466.clickedPart:=Form:C1466.clickedPart.previous()
				End if 
			: ($what2do="NEXT")
				If (Not:C34(Form:C1466.clickedPart.next()=Null:C1517))  //isLast())
					Form:C1466.clickedPart:=Form:C1466.clickedPart.next()
				End if 
			: ($what2do="LAST")
				Form:C1466.clickedPart:=Form:C1466.clickedPart.last()
			Else 
				$OK:=False:C215
		End case 
		
		If ($OK)
			Form:C1466.part:=Form:C1466.clickedPart
			//Form.editEntity:=Form.clickedEntity
			//orda_util_EntityLoad (Form.editEntity;Form.objectsNames)
		End if 
End case 



