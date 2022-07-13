// _______
// Form Method: [Raw_Materials_Transactions].ColdFoilUsage   ( ) ->
// By: Mel Bohince @ 07/21/21, 15:40:43
// Description
// respond to user clicked buttons to resolve to 
// a specific inventory record, 
// once funnelled down to one rm code, enable the submit
// ----------------------------------------------------
// Modified by: Garri Ogata (9/1/21) Changed Holographic to Pillars N-S commented out ref to other
// Modified by: Mel Bohince (10/4/21) no inventory required for issuing butt
// Modified by: MelvinBohince (1/28/22) chg qty 3 & 4 to 1/2 & 1/4
// Modified by: MelvinBohince (2/13/22) chg 1/2 to 3, "Partial (0.5)" issues 1/2 or 0
// Modified by: MelvinBohince (4/20/22) add 16" option

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(*; "submit"; False:C215)
		SET WINDOW TITLE:C213("Cold Foil Usage by "+Form:C1466.costCenter)
		Form:C1466.picks_c:=New collection:C1472("[ w]"; "[ c]"; "[ v]"; "[ q]")
		
	: (Form event code:C388=On Clicked:K2:4)
		
		$cancelPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "cancel")
		$submitlPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "submit")
		
		Case of 
			: ($cancelPtr->=1)
				//pass, bailing out
				
			: ($submitlPtr->=1)
				//do 'it'
				
			Else 
				
				Case of   //width
					: (srb10=1)  // Modified by: MelvinBohince (4/20/22) add 16" option
						Form:C1466.width:=14
						
					: (srb11=1)  // Modified by: MelvinBohince (4/20/22) add 16" option
						Form:C1466.width:=16
						
					: (srb12=1)
						Form:C1466.width:=20
						
					: (srb13=1)
						Form:C1466.width:=26
						
					: (srb14=1)
						Form:C1466.width:=28
						
					: (srb15=1)
						Form:C1466.width:=40
				End case 
				
				Case of   //color
					: (crb01=1)
						Form:C1466.color:="Silver"
						
					: (crb02=1)
						Form:C1466.color:="Gold"
						
					: (crb03=1)
						Form:C1466.color:="Rainbow"
						
					: (crb04=1)
						//Form.color:="Holographic"
						Form:C1466.color:="Pillars N-S"
						
						//: (crb05=1)
						//Form.color:=Form.otherColor  //Holographic
				End case 
				
				Case of   //vendor
					: (vrb31=1)
						Form:C1466.vendorID:="03070"
						Form:C1466.vendorName:="ITW"
						
					: (vrb32=1)
						Form:C1466.vendorID:="11128"
						Form:C1466.vendorName:="Kurz"
						
					: (vrb33=1)
						Form:C1466.vendorID:="00690"
						Form:C1466.vendorName:="Univacco"
						
						//: (vrb34=1)
						//Form.vendorID:=Form.otherVendor
						//C_OBJECT($vendor_e)
						//$vendor_e:=ds.Vendors.query("ID = :1";Form.vendorID).first()
						//If ($vendor_e#Null)
						//Form.vendorName:=$vendor_e.Name
						//Else 
						//Form.vendorName:="other"
						//End if 
						
				End case 
				
				Case of   //qty rolls
					: (qrb41=1)
						Form:C1466.quantity:="Partial (0.5)"  // Modified by: MelvinBohince (2/13/22) was butt
						
					: (qrb42=1)
						Form:C1466.quantity:="1 Roll"
						
					: (qrb43=1)
						Form:C1466.quantity:="2 Rolls"
						
					: (qrb44=1)  // Modified by: MelvinBohince (1/28/22) 
						Form:C1466.quantity:="3 Rolls"  // Modified by: MelvinBohince (2/13/22) 
						
						// Removed by: MelvinBohince (2/13/22) 
						//: (qrb45=1)  // Modified by: MelvinBohince (1/28/22) 
						//Form.quantity:="0.25 Roll"
				End case 
				
				Form:C1466.picks_c[0]:=Form:C1466.width
				Form:C1466.picks_c[1]:=Form:C1466.color
				Form:C1466.picks_c[2]:=Form:C1466.vendorName
				Form:C1466.picks_c[3]:=Form:C1466.quantity
				
				//narrow down the possibilities
				Form:C1466.matchingInventory_es:=Form:C1466.inventory_es.query("RAW_MATERIAL.Flex4 = :1 and RAW_MATERIAL.Flex2=:2 and PO_ITEM.VendorID  = :3 and "; Form:C1466.color; Form:C1466.width; Form:C1466.vendorID).orderBy("POItemKey")
				
				
				
				$rmCodeNotes:=""  //later we test for mixed rm codes and leave note in log if that is true
				
				Case of 
						
						
					: (Form:C1466.width=0)
						//pass, width not specified
						
					: (Char:C90(At sign:K15:46)=Form:C1466.color)
						//pass, color  not specifed
						
					: (Char:C90(At sign:K15:46)=Form:C1466.vendorID)
						//pass, vendor  not specifed
						
					: (Form:C1466.quantity="")
						//pass, qty  not specifed
						
					: (Form:C1466.matchingInventory_es.length=0) & (Form:C1466.quantity="Partial (0.5)")  // Modified by: Mel Bohince (10/4/21) no inventory required for issuing butt
						OBJECT SET ENABLED:C1123(*; "submit"; True:C214)  //at this point we can allow Submit
						//fake some data to record a transaction
						Form:C1466.rawMatlCode:="Out-of-stock "+String:C10(Form:C1466.width)+Form:C1466.color+Form:C1466.vendorName
						Form:C1466.poItemKey:=""
						Form:C1466.location:=""
						Form:C1466.commodityKey:="09-Cold Foil"
						Form:C1466.unitCost:=0  //butts have already been charged off by definition
						
						Form:C1466.actual_c[0]:=Form:C1466.rawMatlCode
						Form:C1466.actual_c[1]:=Form:C1466.color+"-"+String:C10(Form:C1466.width)
						
					: (Form:C1466.matchingInventory_es.length>=1)  //now test if in budget
						OBJECT SET ENABLED:C1123(*; "submit"; True:C214)  //at this point we can allow Submit
						
						//grab some attributes needed for the transaction
						C_OBJECT:C1216($rmLocation_e)
						$rmLocation_e:=Form:C1466.matchingInventory_es.first()
						Form:C1466.rawMatlCode:=$rmLocation_e.Raw_Matl_Code
						Form:C1466.poItemKey:=$rmLocation_e.POItemKey
						Form:C1466.location:=$rmLocation_e.Location
						Form:C1466.commodityKey:=$rmLocation_e.Commodity_Key
						Form:C1466.unitCost:=$rmLocation_e.ActCost
						
						Form:C1466.actual_c[0]:=$rmLocation_e.Raw_Matl_Code
						Form:C1466.actual_c[1]:=$rmLocation_e.RAW_MATERIAL.VendorPartNum
						
						
						// Removed by: MelvinBohince (2/13/22) 
						//see if the matching inventory is all under the same rm code
						//$testSameRMcode_es:=Form.matchingInventory_es.query("Raw_Matl_Code = :1";Form.rawMatlCode)
						
						//If (Form.matchingInventory_es.length#$testSameRMcode_es.length)
						//ALERT("More than one R/M code matches that description.")
						//$rmCodeNotes:="!!!multiple R/M codes possible!!! "
						//Else 
						//$rmCodeNotes:="[ "+Form.rawMatlCode+" ] "
						//End if 
						// end Removed by: MelvinBohince (2/13/22) 
						
						//If ((vrb31+vrb32+vrb33+vrb34)=0)  //click the vendor button
						//Form.vendorID:=Form.matchingInventory_es.first().PO_ITEM.VendorID
						//Form.vendorName:=Form.vendorID
						//End if 
						
						//If ((crb01+crb02+crb03+crb04)=0)  //click the color button
						//Form.color:=Form.matchingInventory_es.first().RAW_MATERIAL.Flex4
						//End if 
						
					Else 
						BEEP:C151
						ALERT:C41("Out of "+String:C10(Form:C1466.width)+" inch "+Form:C1466.color+" from "+Form:C1466.vendorName+" Use Butt or try a different vendor or width or Contact accounting department.")
						qrb41:=1
						Form:C1466.quantity:="Partial (0.5)"
						Form:C1466.rawMatlCode:="Out-of-stock"
						Form:C1466.commodityKey:="09-Cold Foil"
						qrb42:=0
						qrb43:=0
						qrb44:=0
						
						Form:C1466.actual_c[0]:=Form:C1466.rawMatlCode
						Form:C1466.actual_c[1]:=Form:C1466.color+"-"+String:C10(Form:C1466.width)
						
						$rmCodeNotes:="[ out of stock ] "
						OBJECT SET ENABLED:C1123(*; "submit"; True:C214)  //at this point we can allow Submit
				End case 
				
				//description of what should be issued
				Form:C1466.usageDesc:=$rmCodeNotes+String:C10(Form:C1466.width)+"\" "+Form:C1466.color+" from "+Form:C1466.vendorName+" using "+Form:C1466.quantity
				
		End case   //not cancel or submit
		
End case 
