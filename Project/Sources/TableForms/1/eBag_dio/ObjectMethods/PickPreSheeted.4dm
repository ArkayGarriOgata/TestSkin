// _______
// Method: [zz_control].eBag_dio.PickPreSheeted   ( rm_code ) ->
// By: MelvinBohince @ 03/28/22, 12:48:22
// Description
// present and issue dialog for the budgeted board
// t7:=[Job_Forms_Materials]Raw_Matl_Code
// ----------------------------------------------------

C_TEXT:C284($rmCode; $po)  //;$1)
$po:=""  //this will be selected if more that one on hand

C_LONGINT:C283($qty)
C_OBJECT:C1216($rm_e; $inventory_es; $thePick)

$rmCode:=t7
$rm_e:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; $rmCode).first()  //validate RM
If ($rm_e#Null:C1517)  //invalid RM code
	
	If (Position:C15($rm_e.IssueUOM; " Sht Each")>0)  //validate presheeted
		
		
		$qty:=Int:C8(Num:C11(t8))  //Sheets-to-press on eBag
		
		//look for inventory, get the PO#
		$inventory_es:=ds:C1482.Raw_Materials_Locations.query("Raw_Matl_Code = :1"; $rmCode)
		
		Case of 
			: ($inventory_es.length=1)
				$po:=$inventory_es.first().POItemKey
				
			: ($inventory_es.length>1)  //select the po from a list
				$thePick:=util_PickOne_UI($inventory_es; "POItemKey")
				If ($thePick.success)
					$po:=$thePick.value
				Else 
					uConfirm("No selection made for "+$rmCode+" po's."; "Ok"; "Thanks")
				End if 
				
			Else   //no inventory
				uConfirm("No inventory found for "+$rmCode+"."; "Ok"; "Thanks")
		End case 
		
	Else 
		uConfirm($rmCode+" is not pre-sheeted, use the 'Issue Raw Mat'l' button and scan the roll tag."; "Ok"; "Thanks")
	End if 
	
Else   //shouldn't happen
	uConfirm($rmCode+" is not valid."; "Ok"; "Sorry")
End if 

If (Length:C16($po)=9)
	Job_LoadLabel("new"; sCriterion1; $po)
	
End if 


