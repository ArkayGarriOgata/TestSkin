//%attributes = {"publishedWeb":true}
//sSetGrpFlex  see also fcalcmaterials
//mod upr 1054
//upr 1429, 1443 3/13/95
//upr 1456 3/21/95 chg uom's on 7 and 13laser
//•052395  MLB  UPR 1486 chg comm 8 uom from LF to LB
//•071195  MLB  UPR 1673 more changes to 8
//• 062300 mlb chg to 13 lasers 
// Modified by: Mel Bohince (7/29/16) Allow for double wide rolls

C_LONGINT:C283($1)  //the commodity

sFlex1:="Std (Estimating) Cost"
sFlex2:=""
sFlex3:=""
sFlex4:=""

SetObjectProperties(""; ->[Raw_Materials_Groups:22]Std_Cost:4; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex2:14; True:C214; ""; True:C214)
SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; False:C215)
SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex4:17; True:C214; ""; False:C215)
Case of 
	: ($1=1)
		sFlex2:="Waste Factor:"
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="LF"
		End if 
		sFlex3:="LB/Unit:"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		//sFlex4:="Sheets/cut:"  // Modified by: Mel Bohince (7/29/16) Allow for double wide rolls, 1 slice = double roll
		//SetObjectProperties ("";->[Raw_Materials_Groups]Flex4;True;"";True)
		
	: ($1=2)
		sFlex2:="Fountain Factor:"
		sFlex3:="Base for Usage:"
		sFlex4:="Usage per Base:"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex4:17; True:C214; ""; True:C214)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="LB"
		End if 
		
	: ($1=3)
		sFlex2:="Usage per MSF:"
		sFlex3:="Fountain Factor:"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="LB"
		End if 
		
	: ($1=4)
		sFlex1:="Film Plate Cost:"
		sFlex2:="Dycril/Cyril Plate Cost:"
		sFlex3:="Wet/Screen Plate Cost:"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="EACH"
		End if 
		
	: ($1=5) | ($1=9)
		sFlex2:="Feet/Roll:"
		sFlex3:="Width''/Roll:"
		sFlex4:="Waste Factor:"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex4:17; True:C214; ""; True:C214)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="ROLL"
		End if 
		
	: ($1=6)
		sFlex2:="#Cases/SHT:"
		sFlex3:="Waste Factor:"
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="SHT"
		End if 
		
	: ($1=7)  //upr 1429, 1443 3/13/95
		sFlex2:="Minimum Dies:"
		Case of 
			: ([Raw_Materials_Groups:22]SubGroup:10="Embossing Dies")  //old 7
				If ([Raw_Materials_Groups:22]UOM:8="")
					[Raw_Materials_Groups:22]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
				
			: ([Raw_Materials_Groups:22]SubGroup:10="Stamping Dies")  //like old 51
				If ([Raw_Materials_Groups:22]UOM:8="")
					[Raw_Materials_Groups:22]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
				
			Else 
				If ([Raw_Materials_Groups:22]UOM:8="")
					[Raw_Materials_Groups:22]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
		End case 
		
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="EACH"
		End if 
		
	: ($1=8)  //•071195  MLB  UPR 1673
		If ([Raw_Materials_Groups:22]UOM:8="LF")
			sFlex2:="Waste Factor:"
			sFlex3:="Adhes $/LB:"  //•052395  MLB  UPR 1486
			SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
			
		Else 
			If ([Raw_Materials_Groups:22]UOM:8="")
				[Raw_Materials_Groups:22]UOM:8:="LB"  //•052395  MLB  UPR 1486
			End if 
			sFlex2:="LBS/MSF (Lam):"
			sFlex3:="$/LB (Adh):"  //•052395  MLB  UPR 1486
			SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
			sFlex4:="LBS/MSF (Adh):"  //•052395  MLB  UPR 1486
			SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex4:17; True:C214; ""; True:C214)
		End if 
		
	: ($1=12)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="EACH"
		End if 
		
	: ($1=13)  //upr 1429, 1443 3/13/95
		Case of 
			: ([Raw_Materials_Groups:22]SubGroup:10="Laser Dies")  //old 71
				// Laser Dies calculation for Bobs
				//(Total Rule Length X .995)+$656
				
				//Laser Dies calculation for Bobs
				//(Total Rule Length X .635)+$500
				sFlex1:="Die Cutting/Rule inch"
				sFlex2:="plus Die Cutting Base"
				sFlex3:=" or Blank'g/Rule inch"
				sFlex4:="plus Blank'g Base"
				SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex4:17; True:C214; ""; True:C214)
				If ([Raw_Materials_Groups:22]UOM:8="")
					[Raw_Materials_Groups:22]UOM:8:="EACH"  //upr 1456 3/21/95 chg uom's on 7 and 13laser
				End if 
				
			Else 
				sFlex:="No Standard"
				SetObjectProperties(""; ->[Raw_Materials_Groups:22]Std_Cost:4; True:C214; ""; False:C215)
				SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex2:14; True:C214; ""; False:C215)
		End case 
		
	: ($1=17)
		sFlex2:="Waste Factor:"
		sFlex3:="SqIn/LB (if $/LB):"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="LB"
		End if 
		
	: ($1=51)  //obsolete `upr 1429, 1443 3/13/95
		sFlex2:="Waste Factor:"
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="M"
		End if 
		
	: ($1=71)  //obsolete  `upr 1429, 1443 3/13/95
		sFlex1:="Misc Cost:"
		sFlex2:="Die Cost:"
		sFlex3:="Counter Cost:"
		sFlex4:="Waste Factor:"
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex3:16; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Raw_Materials_Groups:22]Flex4:17; True:C214; ""; True:C214)
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="SQIN"
		End if 
		
	: ($1=33)  //subcomponent assembly
		sFlex2:="Per M Cost:"
		If ([Raw_Materials_Groups:22]UOM:8="")
			[Raw_Materials_Groups:22]UOM:8:="M"
		End if 
		
End case 