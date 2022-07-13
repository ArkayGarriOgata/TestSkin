//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: sSetPspecMatl
// Description:
// See also sSetMatlEstFlex and sSetGrpFlex
// ----------------------------------------------------

C_LONGINT:C283($comm)

sMatLabel1:=""
sMatLabel2:=""
sMatLabel3:=""
sMatLabel4:=""
sMatLabel5:=""
sMatLabel6:=""

$comm:=Num:C11(Substring:C12([Process_Specs_Materials:56]Commodity_Key:8; 1; 2))

SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; False:C215)
SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; False:C215)
SetObjectProperties(""; ->[Process_Specs_Materials:56]Real3:16; True:C214; ""; False:C215)
SetObjectProperties(""; ->[Process_Specs_Materials:56]Real4:17; True:C214; ""; False:C215)
SetObjectProperties(""; ->[Process_Specs_Materials:56]alpha20_2:18; True:C214; ""; False:C215)
SetObjectProperties(""; ->[Process_Specs_Materials:56]alpha20_3:19; True:C214; ""; False:C215)

Case of 
	: ($comm=1)
		If (Position:C15("Special"; [Process_Specs_Materials:56]Commodity_Key:8)=0)
			If ([Process_Specs_Materials:56]UOM:9="")
				[Process_Specs_Materials:56]UOM:9:="LF"
			End if 
			[Process_Specs_Materials:56]Real1:14:=0
			[Process_Specs_Materials:56]Real2:15:=0
		Else 
			SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
			sMatLabel1:="lbs/MSF:"
			sMatLabel2:="$cost/MSF:"
			[Process_Specs_Materials:56]UOM:9:="MSF"
		End if 
		
	: ($comm=2)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		sMatLabel1:="% Coverage:"
		sMatLabel2:="Rotation:"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="LB"
		End if 
		
	: ($comm=3)
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="LB"
		End if 
		
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]alpha20_2:18; True:C214; ""; True:C214)
		sMatLabel1:="% Coverage:"
		sMatLabel2:="Rotation:"
		sMatLabel5:="Subform:"
		
	: ($comm=4)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real3:16; True:C214; ""; True:C214)
		sMatLabel1:="# of Film:"
		sMatLabel2:="# of Dycril:"
		sMatLabel3:="# of Wet:"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="EACH"
		End if 
		
	: ($comm=5) | ($comm=9)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real3:16; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real3:16; True:C214; ""; True:C214)
		sMatLabel1:="Steps:"
		sMatLabel2:="Rows (ref):"
		sMatLabel3:="Total Width'':"
		sMatLabel4:="Pull Length'':"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="ROLL"
		End if 
		If (Position:C15("Special"; [Process_Specs_Materials:56]Commodity_Key:8)#0)
			sMatLabel5:="Cost/ROLL:"
			sMatLabel6:="Roll  L' x W'':"
			SetObjectProperties(""; ->[Process_Specs_Materials:56]alpha20_2:18; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Process_Specs_Materials:56]alpha20_3:19; True:C214; ""; True:C214)
		Else 
			[Process_Specs_Materials:56]alpha20_2:18:=""
			[Process_Specs_Materials:56]alpha20_3:19:=""
		End if 
		
	: ($comm=6)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real3:16; True:C214; ""; True:C214)
		sMatLabel1:="Want Qty:"
		sMatLabel2:="Packing Qty:"
		sMatLabel3:="Yield Qty:"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="SHT"
		End if 
		
	: ($comm=7)
		Case of 
			: ([Process_Specs_Materials:56]Commodity_Key:8="07-Embossing@")  //old 7  `upr 1429, 1443 3/13/93     
				//above was "embossing dies"
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
				If ([Process_Specs_Materials:56]UOM:9="")
					[Process_Specs_Materials:56]UOM:9:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
				sMatLabel1:="% Embossed:"
				
			: ([Process_Specs_Materials:56]Commodity_Key:8="07-Stamping Dies")  //old 51  `upr 1429, 1443 3/13/93
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
				sMatLabel1:="# of Cartons:"
				sMatLabel2:="# @ Yield:"
				If ([Process_Specs_Materials:56]UOM:9="")
					[Process_Specs_Materials:56]UOM:9:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
				
			Else 
				sMatLabel1:="% Embossed:"
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		End case 
		
	: ($comm=8)
		If (Position:C15("Special"; [Process_Specs_Materials:56]Commodity_Key:8)#0)
			sMatLabel1:="Cost/LF:"
			SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		Else 
			[Process_Specs_Materials:56]Real1:14:=0
		End if 
		
		sMatLabel2:="Specify the"
		sMatLabel3:="Adhesive."
		
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="LF"
		End if 
		
		//: ($comm=9)
		//SetObjectProperties ("";->[Process_Specs_Materials]Real1;True;"";True)
		//sMatLabel1:="% Coverage:"
		//sMatLabel2:="Note-"
		//sMatLabel3:="Specify the"
		//sMatLabel4:="R/M Code."
		//If ([Process_Specs_Materials]UOM="")
		//[Process_Specs_Materials]UOM:="MSF"
		//End if 
		
	: ($comm=12)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real3:16; True:C214; ""; True:C214)
		sMatLabel1:="Want Qty:"
		sMatLabel3:="Yield Qty:"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="EACH"
		End if 
		
	: ($comm=13)
		Case of   //upr 1429, 1443 3/13/93
			: ([Process_Specs_Materials:56]Commodity_Key:8="13-Laser Dies")  //treat like 71
				sMatLabel1:="Ttl Rule Length"  //"Die $(opt):"
				sMatLabel2:="Blank'g 1=yes"
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
				If ([Process_Specs_Materials:56]UOM:9="")
					[Process_Specs_Materials:56]UOM:9:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
				//sMatLabel1:="Die $(opt):"
				//sMatLabel2:="Counter $(opt):"
			Else 
				sMatLabel1:="Unit Cost:"
				sMatLabel2:="Qty:"
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		End case 
		
	: ($comm=17)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		sMatLabel1:="Width'' (ref):"
		sMatLabel2:="Patch Length'':"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="LF"
		End if 
		
	: ($comm=51)  //obsolete  `upr 1429, 1443 3/13/95
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		sMatLabel1:="# of Cartons:"
		sMatLabel2:="# @ Yield:"
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="M"
		End if 
		
	: ($comm=71)  //obsolete  `upr 1429, 1443 3/13/95
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real1:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Process_Specs_Materials:56]Real2:15; True:C214; ""; True:C214)
		sMatLabel1:="Die $(opt):"
		sMatLabel2:="Counter $(opt):"
		//sMatLabel5:="Difficulty:"
		//SET CHOICE LIST([Material_PSpec]alpha20_2;"EmbossDifficulty")
		If ([Process_Specs_Materials:56]UOM:9="")
			[Process_Specs_Materials:56]UOM:9:="SQIN"
		End if 
		
End case 