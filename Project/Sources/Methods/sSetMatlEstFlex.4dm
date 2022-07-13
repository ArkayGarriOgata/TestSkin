//%attributes = {"publishedWeb":true}
//sSetMatlEstFlex   see also sSetPspecMatl
//12/13/94
//upr 1429, 1443 3/13/93
//replaced (from 1429) all refereences to " Dies" with "@" Chip 3/15/95, onsite
//upr 1456 3/21/95 chg uom's on 7 and 13laser
//• 1/26/98 cs changed field names for Comm3 - to match inks this is
//  to being done to coorespond to changes in budgeting of Comm3
//  Coatings are now being entered as coatings and not as inks (comm2)
//• 062300 mlb chg to plates 
//• mlb - 6/17/02  09:20 add for Special Cost
//• mlb - 8/7/02  14:39 add com 12 for sensomatic labels

C_LONGINT:C283($comm)
C_TEXT:C284($1)  //the commodity key

sMatLabel1:=""
sMatLabel2:=""
sMatLabel3:=""
sMatLabel4:=""
sMatLabel5:=""
sMatLabel6:=""

If (Count parameters:C259=1)  //via job
	$comm:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
	
	Case of 
		: ($comm=1)
			If (Position:C15("Special"; [Job_Forms_Materials:55]Commodity_Key:12)#0)
				sMatLabel1:="lbs/MSF:"
				sMatLabel2:="$cost/MSF:"
				//sMatLabel5:="Slit (Yes):"
			End if 
			
		: ($comm=2)
			sMatLabel1:="% Coverage:"
			sMatLabel2:="Rotation:"
			sMatLabel5:="Subforms:"
			If ([Job_Forms_Materials:55]Commodity_Key:12="02-Special")
				sMatLabel3:="$cost/LB:"
			End if 
			
		: ($comm=3)
			sMatLabel1:="% Coverage:"  //• 1/26/98 cs 
			sMatLabel2:="Rotation:"
			If ([Job_Forms_Materials:55]Commodity_Key:12="03-Special")
				sMatLabel3:="$cost/LB:"
			End if 
			sMatLabel5:="Subforms:"
			
		: ($comm=4)  //• 062300 mlb chg to plates 
			sMatLabel1:="# of Film:"
			sMatLabel2:="# Dycril/Cyril:"
			sMatLabel3:="# of Wet:"
			
		: ($comm=5) | ($comm=9)
			sMatLabel1:="Steps:"
			sMatLabel2:="Rows (ref):"
			sMatLabel3:="Total Width'':"
			sMatLabel4:="Pull Length'':"
			If (Position:C15("Special"; [Job_Forms_Materials:55]Commodity_Key:12)#0)
				sMatLabel5:="Cost/ROLL:"
				sMatLabel6:="Roll  L' x W'':"
			End if 
			
		: ($comm=6)
			sMatLabel1:="Want Qty:"
			sMatLabel2:="Packing Qty:"
			sMatLabel3:="Yield Qty:"
			
		: ($comm=7)
			Case of 
				: (True:C214)  // • mel (3/31/05, 12:29:24)
					sMatLabel1:="Nº of Dies:"
					sMatLabel2:="Price per Die:"
					
				: ([Job_Forms_Materials:55]Commodity_Key:12="07-Embossing@")  //old 7  `upr 1429, 1443 3/13/93
					sMatLabel1:="% Embossed:"
					
				: ([Job_Forms_Materials:55]Commodity_Key:12="07-Stamping Dies")  //old 51  `upr 1429, 1443 3/13/93
					sMatLabel1:="# of Cartons:"
					sMatLabel2:="# @ Yield:"
					
				Else 
					sMatLabel1:="% Embossed:"
			End case 
			
		: ($comm=8)
			If (Position:C15("Special"; [Job_Forms_Materials:55]Commodity_Key:12)#0)
				sMatLabel1:="Cost/LF:"
			End if 
			
		: ($comm=12)
			sMatLabel1:="Want Qty:"
			sMatLabel3:="Yield Qty:"
			
		: ($comm=13)
			Case of   //upr 1429, 1443 3/13/93
				: ([Job_Forms_Materials:55]Commodity_Key:12="13-Laser Dies")  //treat like 71
					sMatLabel1:="Ttl Rule Length"  //"Die $(opt):"
					sMatLabel2:="Blank'g 1=yes"
					If ([Estimates_Materials:29]UOM:8="")
						[Estimates_Materials:29]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
					End if 
					//sMatLabel1:="Die $(opt):"
					//sMatLabel2:="Counter $(opt):"
				Else 
					sMatLabel1:="Unit Cost:"
					sMatLabel2:="Qty:"
			End case 
			
		: ($comm=17)
			sMatLabel1:="Width'' (ref):"
			sMatLabel2:="Patch Length'':"
			
		: ($comm=20)  // Modified by: Mel Bohince (5/25/16) 
			sMatLabel1:="$Cost/SHT:"
			
		: ($comm=51)  //obsolete  `upr 1429, 1443 3/13/95
			sMatLabel1:="# of Cartons:"
			sMatLabel2:="# @ Yield:"
			
		: ($comm=71)  //obsolete  `upr 1429, 1443 3/13/95
			sMatLabel1:="Die $(opt):"
			sMatLabel2:="Counter $(opt):"
			
		: ($comm=33)  //
			sMatLabel1:="Units/assembly:"
			sMatLabel2:="Used on item#:"
	End case 
	
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real1:17; (Length:C16(sMatLabel1)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real2:18; (Length:C16(sMatLabel2)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real3:19; (Length:C16(sMatLabel3)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real4:20; (Length:C16(sMatLabel4)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Alpha20_2:21; (Length:C16(sMatLabel5)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Alpha20_3:22; (Length:C16(sMatLabel6)>0))
	
Else   //via estimate  
	$comm:=Num:C11(Substring:C12([Estimates_Materials:29]Commodity_Key:6; 1; 2))
	
	Case of 
		: ($comm=1)
			If (Position:C15("Special"; [Estimates_Materials:29]Commodity_Key:6)=0)
				If ([Estimates_Materials:29]UOM:8="")
					[Estimates_Materials:29]UOM:8:="LF"
				End if 
				[Estimates_Materials:29]Real1:14:=0
				[Estimates_Materials:29]Real2:15:=0
			Else 
				sMatLabel1:="lbs/MSF:"
				sMatLabel2:="$cost/MSF:"
				[Estimates_Materials:29]UOM:8:="MSF"
			End if 
			//sMatLabel5:="Slit (Yes):"
			
		: ($comm=2)
			sMatLabel1:="% Coverage:"
			sMatLabel2:="Rotation:"
			sMatLabel5:="Subforms:"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="LB"
			End if 
			
			If ([Estimates_Materials:29]Commodity_Key:6="02-Special")
				sMatLabel3:="$cost/LB:"
			End if 
			
			
		: ($comm=3)
			sMatLabel1:="% Coverage:"
			sMatLabel2:="Rotation:"
			sMatLabel5:="Subforms:"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="LB"
			End if 
			
			If ([Estimates_Materials:29]Commodity_Key:6="03-Special")
				sMatLabel3:="$cost/LB:"
			End if 
			
		: ($comm=4)
			sMatLabel1:="# of Film:"
			sMatLabel2:="# Dycril/Cyril:"
			sMatLabel3:="# of Wet:"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="EACH"
			End if 
			
		: ($comm=5) | ($comm=9)
			sMatLabel1:="Steps:"
			sMatLabel2:="Rows (ref):"
			sMatLabel3:="Total Width'':"
			sMatLabel4:="Pull Length'':"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="ROLL"
			End if 
			If (Position:C15("Special"; [Estimates_Materials:29]Commodity_Key:6)#0)
				sMatLabel5:="Cost/ROLL:"
				sMatLabel6:="Roll  L' x W'':"
			Else 
				[Estimates_Materials:29]alpha20_2:18:=""
				[Estimates_Materials:29]alpha20_3:19:=""
			End if 
			
		: ($comm=6)
			sMatLabel1:="Want Qty:"
			sMatLabel2:="Packing Qty:"
			sMatLabel3:="Yield Qty:"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="SHT"
			End if 
			
		: ($comm=7)
			Case of 
				: (True:C214)  // • mel (3/31/05, 12:29:24)
					sMatLabel1:="Nº of Dies:"
					sMatLabel2:="Price per Die:"
				: ([Estimates_Materials:29]Commodity_Key:6="07-Embossing@")  //old 7  `upr 1429, 1443 3/13/93     
					//above was "embossing dies"          
					If ([Estimates_Materials:29]UOM:8="")
						[Estimates_Materials:29]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
					End if 
					sMatLabel1:="% Embossed:"
					
				: ([Estimates_Materials:29]Commodity_Key:6="07-Stamping Dies")  //old 51  `upr 1429, 1443 3/13/93
					sMatLabel1:="# of Cartons:"
					sMatLabel2:="# @ Yield:"
					If ([Estimates_Materials:29]UOM:8="")
						[Estimates_Materials:29]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
					End if 
					
				Else 
					sMatLabel1:="% Embossed:"
			End case 
			
		: ($comm=8)
			If (Position:C15("Special"; [Estimates_Materials:29]Commodity_Key:6)#0)
				sMatLabel1:="Cost/LF:"
			Else 
				[Estimates_Materials:29]Real1:14:=0
			End if 
			
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="LF"
			End if 
			
		: ($comm=12)
			sMatLabel1:="Want Qty:"
			sMatLabel3:="Yield Qty:"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="EACH"
			End if 
			
		: ($comm=13)
			Case of   //upr 1429, 1443 3/13/93
				: ([Estimates_Materials:29]Commodity_Key:6="13-Laser Dies")  //treat like 71
					sMatLabel1:="Ttl Rule Length"  //"Die $(opt):"
					sMatLabel2:="Blank'g 1=yes"
					If ([Estimates_Materials:29]UOM:8="")
						[Estimates_Materials:29]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
					End if 
					
				Else 
					sMatLabel1:="Unit Cost:"
					sMatLabel2:="Qty:"
			End case 
			
		: ($comm=17)
			sMatLabel1:="Width'' (ref):"
			sMatLabel2:="Patch Length'':"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="LF"
			End if 
			
		: ($comm=20)  // Modified by: Mel Bohince (5/25/16) 
			sMatLabel1:="$Cost/SHT:"
			
		: ($comm=51)  //obsolete  `upr 1429, 1443 3/13/95
			sMatLabel1:="# of Cartons:"
			sMatLabel2:="# @ Yield:"
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="M"
			End if 
			
		: ($comm=71)  //obsolete  `upr 1429, 1443 3/13/95
			//SET ENTERABLE([Material_Est]alpha20_2;True)
			sMatLabel1:="Die $(opt):"
			sMatLabel2:="Counter $(opt):"
			//sMatLabel5:="Difficulty:"
			//SET CHOICE LIST([Material_Est]alpha20_2;"EmbossDifficulty")
			If ([Estimates_Materials:29]UOM:8="")
				[Estimates_Materials:29]UOM:8:="SQIN"
			End if 
			
		: ($comm=33)
			sMatLabel1:="Units/assembly:"
			sMatLabel2:="Used on item#:"
	End case 
	
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real1:17; (Length:C16(sMatLabel1)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real2:18; (Length:C16(sMatLabel2)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real3:19; (Length:C16(sMatLabel3)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Real4:20; (Length:C16(sMatLabel4)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Alpha20_2:21; (Length:C16(sMatLabel5)>0))
	SetObjectProperties(""; ->[Job_Forms_Materials:55]Alpha20_3:22; (Length:C16(sMatLabel6)>0))
	
	SetObjectProperties(""; ->[Estimates_Materials:29]Real1:14; True:C214; ""; (Length:C16(sMatLabel1)>0))
	SetObjectProperties(""; ->[Estimates_Materials:29]Real2:15; True:C214; ""; (Length:C16(sMatLabel2)>0))
	SetObjectProperties(""; ->[Estimates_Materials:29]Real3:16; True:C214; ""; (Length:C16(sMatLabel3)>0))
	SetObjectProperties(""; ->[Estimates_Materials:29]Real4:17; True:C214; ""; (Length:C16(sMatLabel4)>0))
	SetObjectProperties(""; ->[Estimates_Materials:29]alpha20_2:18; True:C214; ""; (Length:C16(sMatLabel5)>0))
	SetObjectProperties(""; ->[Estimates_Materials:29]alpha20_3:19; True:C214; ""; (Length:C16(sMatLabel6)>0))
	
	Case of   //add some notes
		: ($comm=8)
			sMatLabel2:="Specify the"
			sMatLabel3:="Adhesive."
	End case 
End if 