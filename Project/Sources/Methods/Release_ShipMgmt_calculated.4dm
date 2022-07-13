//%attributes = {}
// _______
// Method: Release_ShipMgmt_calculated   ( ) ->
// By: Mel Bohince @ 06/12/20, 10:24:55
// Description
// calculated values
// ----------------------------------------------------
// Modified by: Mel Bohince (2/11/21) display when/if the ASN was sent in EDI
// Modified by: Mel Bohince (3/4/21) display when/if Odd Lot checkbox is ok

C_POINTER:C301($self)

If (Form:C1466.position>0)
	If (Form:C1466.editEntity#Null:C1517)
		utl_LogIt(Timestamp:C1445+"\t Release_ShipMgmt_calculated"; 0)
		If (Form:C1466.editEntity.Air_Shipment) & (Length:C16(Form:C1466.editEntity.Mode)=0)
			Form:C1466.editEntity.Mode:="AIR"
		End if 
		util_ComboBoxSetup(->aMode; Form:C1466.editEntity.Mode)
		Text23:=fGetAddressText(Form:C1466.editEntity.Billto)
		Text25:=fGetAddressText(Form:C1466.editEntity.Shipto)
		t9:=THC_decode(Form:C1466.editEntity.THC_State)
		$launch:=FG_getLaunchStatus(Form:C1466.editEntity.ProductCode; "show status")
		If (Length:C16($launch)>0)
			t10:="Launch Status: "+$launch
		Else 
			t10:=""
		End if 
		iitotal3:=FGL_getInventory(Form:C1466.editEntity.ProductCode; "fg only")
		If (Form:C1466.editEntity.Actual_Date#!00-00-00!)
			tText:="Shipped "+String:C10(Form:C1466.editEntity.Actual_Qty)+" on "+String:C10(Form:C1466.editEntity.Actual_Date)
		Else 
			tText:=""
		End if 
		
		// Modified by: Mel Bohince (2/11/21) display when/if the ASN was sent in EDI
		C_OBJECT:C1216($outbox_e)
		If (Form:C1466.editEntity.ediASNmsgID>0)
			$outbox_e:=ds:C1482.edi_Outbox.query("ID = :1 and SentTimeStamp > :2"; Form:C1466.editEntity.ediASNmsgID; 100).first()  //not already sent
			If ($outbox_e#Null:C1517)
				t1:="EDI Sent: "+TS2String($outbox_e.SentTimeStamp)
			Else   //msg was not in the sent status or missing
				t1:="EDI NOT Sent"
			End if   //outbox record found
			
		Else   //asn not prep'd
			t1:=""
		End if   //has a msg id
		
		
		$self:=OBJECT Get pointer:C1124(Object named:K67:5; "oddOk")  // Modified by: Mel Bohince (3/4/21) 
		If (Not:C34(Is nil pointer:C315($self)))
			If (Form:C1466.editEntity.UserDefined_1="odd-OK")
				$self->:=1
			Else 
				$self->:=0
			End if 
		End if 
		
	End if   //got a release entity
	
End if   //position
