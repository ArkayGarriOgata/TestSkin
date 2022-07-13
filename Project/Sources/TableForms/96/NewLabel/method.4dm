//FM: NewLabel() -> 
//@author mlb - 2/20/02  14:30

Case of 
	: (Form event code:C388=On Clicked:K2:4) | (Form event code:C388=On Data Change:K2:15)  // Modified by: Mel Bohince (9/8/15) set up for a move transaction if that jobit is at a vendor
		wms_qty_moved:=Num:C11(sCriterion2)*Num:C11(sCriterion4)
		toLocation:=wms_convert_bin_id("ams"; wms_bin_id)
		OBJECT SET TITLE:C194(cbMoveOS; "Move "+String:C10(wms_qty_moved)+" from "+fromLocation+" to "+toLocation)
		SetObjectProperties("supercase@"; -><>NULL; (cbSuperCase=1))
		
	: (Form event code:C388=On Load:K2:1)
		sCriterion2:=""  //qty on skid
		sCriterion3:=""  //po
		sCriterion4:="1"  //num pallets
		sCriterion5:="2"  // lablels per pallet
		
		cbSuperCase:=0
		cbReceiveAMS:=0  //only turn on for outside service not when pallet is built with scanner
		cbMoveOS:=0
		wms_bin_id:=""
		wms_glued:=!00-00-00!
		sArkayUCCid:=""
		wms_qty_moved:=0
		fromLocation:=""
		toLocation:=""
		sCriter10:=""
		
		sCriterion7:=""  //reason comment
		sCriterion8:="SSCC Blue Label"  //action taken
		sCriterion9:="Rtn from vendor"  //reason
		
		READ WRITE:C146([Job_Forms_Items:44])  // Modified by: Mel Bohince (10/23/13) 
		READ ONLY:C145([Job_Forms:42])
		READ ONLY:C145([Jobs:15])
		READ ONLY:C145([Finished_Goods:26])
		READ ONLY:C145([Finished_Goods_PackingSpecs:91])
		
		If (Length:C16(<>JOBIT)=11)
			sCriterion1:=<>JOBIT
			$numJMI:=WMS_setupSSCC(sCriterion1)
			
		Else 
			sCriterion1:=""
			tText:="Enter a job item"+Char:C90(13)+" (example 85123.01.01)"
			sCustName:=""
			sLine:=""
			sCPN:=""
			sDesc:=""
			sArkayUCCid:=""
		End if 
		//fromLocation qtyOS
		SetObjectProperties("supercase@"; -><>NULL; (cbSuperCase=1))
		wms_qty_moved:=Num:C11(sCriterion2)*Num:C11(sCriterion4)
		toLocation:=wms_convert_bin_id("ams"; wms_bin_id)
		OBJECT SET TITLE:C194(cbMoveOS; "Move "+String:C10(wms_qty_moved)+" from "+fromLocation+" to "+toLocation)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 