//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): JML
// ----------------------------------------------------
// Method: sRMflexFields
// Description:
// This procedure initializes the [machine_est]input layout
// to allow only relevant data entry for the cost center represented by
// the record being edited.
// ----------------------------------------------------

C_LONGINT:C283($1)  //commodity code
C_LONGINT:C283($2)  //flag POI otherwise RM

SetObjectProperties("nooption@"; -><>NULL; False:C215)  // Added by: Mark Zinke (5/9/13)
SetObjectProperties("option@"; -><>NULL; True:C214)  // Added by: Mark Zinke (5/9/13)

Case of 
	: ($1=1)  //board and paper or plastic
		sMachLabel1:="Caliper:"
		sMachLabel2:="Width:"
		sMachLabel3:="Length:"
		sMachLabel4:="Color:"
		sMachLabel5:="White/Bright/Gloss:"
		sMachLabel6:="FSC/Foil Coating:"
		
	: ($1=2)  //ink
		sMachLabel1:="Customer"
		sMachLabel2:="Project"
		sMachLabel3:="Request"
		sMachLabel4:="Note:"
		sMachLabel5:="Color:"
		sMachLabel6:="PjtName"
		
	: ($1=3)  //lacquer and coatings
		sMachLabel1:=""
		sMachLabel2:=""
		sMachLabel3:=""
		sMachLabel4:="Note:"
		sMachLabel5:="Type"
		sMachLabel6:=""
		
	: ($1=4)  //Plates
		sMachLabel1:="Caliper:"
		sMachLabel2:="Width:"
		sMachLabel3:="Length:"
		sMachLabel4:=""
		sMachLabel5:=""
		sMachLabel6:=""
		
	: ($1=5) | ($1=9)  //Leaf 
		sMachLabel1:="Caliper:"
		sMachLabel2:="Width:"
		sMachLabel3:="Length:"
		sMachLabel4:="Color:"
		sMachLabel5:=""
		sMachLabel6:=""
		
	: ($1=6)  //Corragated    
		sMachLabel1:="Length:"
		sMachLabel2:="Width:"
		sMachLabel3:="Depth:"
		sMachLabel4:="Test:"
		sMachLabel5:="Color:"
		sMachLabel6:="Note:"
		
	: ($1=7)  //Dies   
		sMachLabel1:="Counters"
		sMachLabel2:="Pins"
		sMachLabel3:="1=Original"
		sMachLabel4:="Stamp/Emboss"
		sMachLabel5:="Flat/Ptt/Cmbo"
		sMachLabel6:="Dupe/Brass"
		
	: ($1=8)  //film for lamination    
		sMachLabel1:="Caliper:"
		sMachLabel2:="Width:"
		sMachLabel3:="Length:"
		sMachLabel4:="Color:"
		sMachLabel5:=""
		sMachLabel6:=""
		
	Else 
		sMachLabel1:=""
		sMachLabel2:=""
		sMachLabel3:=""
		sMachLabel4:=""
		sMachLabel5:=""
		sMachLabel6:=""
		SetObjectProperties("nooption@"; -><>NULL; True:C214)  // Added by: Mark Zinke (5/9/13)
		SetObjectProperties("option@"; -><>NULL; False:C215)  // Added by: Mark Zinke (5/9/13)
End case 

If (Count parameters:C259=2)
	If (Length:C16(sMachLabel1)>0)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex1:31; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex1:31; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel2)>0)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex2:32; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex2:32; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel3)>0)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex3:33; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex3:33; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel4)>0)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex4:34; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex4:34; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel5)>0)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex5:35; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex5:35; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel6)>0)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex6:36; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex6:36; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	
Else 
	If (Length:C16(sMachLabel1)>0)
		SetObjectProperties(""; ->[Raw_Materials:21]Flex1:19; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Raw_Materials:21]Flex1:19; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel2)>0)
		SetObjectProperties(""; ->[Raw_Materials:21]Flex2:20; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Raw_Materials:21]Flex2:20; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel3)>0)
		SetObjectProperties(""; ->[Raw_Materials:21]Flex3:21; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Raw_Materials:21]Flex3:21; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel4)>0)
		SetObjectProperties(""; ->[Raw_Materials:21]Flex4:22; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Raw_Materials:21]Flex4:22; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel5)>0)
		SetObjectProperties(""; ->[Raw_Materials:21]Flex5:23; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Raw_Materials:21]Flex5:23; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
	If (Length:C16(sMachLabel6)>0)
		SetObjectProperties(""; ->[Raw_Materials:21]Flex6:24; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	Else 
		SetObjectProperties(""; ->[Raw_Materials:21]Flex6:24; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
	End if 
End if 