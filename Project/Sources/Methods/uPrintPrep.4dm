//%attributes = {"publishedWeb":true}
//  `Procedure: uPrintPrep()  052395  MLB
//  `see also uPrintPrepCost
//  `•052295  MLB  UPR 1505 add printing procedure
//  `•061295  MLB  UPR 1636 show entire est # in header
//  `•062295  MLB  UPR 1661 add job to header
//  `•071195  MLB  UPR 222 add order to header
//C_LONGINT($i)
//C_POINTER($price)  `•061595  MLB  UPR 1636
//C_TEXT($newLine;xText)
//C_TEXT($CR)
//$CR:=Char(13)
//xText:=+$CR+$CR
//For ($i;61;93)
//$price:=Get pointer("r"+String($i))
//$newLine:=""
//If ($price->#0)  `add it to the report
//$newLine:=") "+("."*60)+"$"  ` )..........$    
//Case of 
//: ($i=61)  `*Computer Samples
//$newLine:=Change string($newLine;"Computer Samples";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=62)  `*Art Boards
//$newLine:=Change string($newLine;"Art Boards";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=63)  `*Templates Normal
//$newLine:=Change string($newLine;"Templates (Normal size)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=64)  `*Templates Oversize
//$newLine:=Change string($newLine;"Templates (Over size)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=65)  `*vandercooks
//$newLine:=Change string($newLine;"Vandercooks";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=66)  `*Computer Art (1st item)
//$newLine:=Change string($newLine;"Computer Art (1st item)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=67)  `*Computer Art (additional items)
//$newLine:=Change string($newLine;"Computer Art (additional items)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=68)  `*Press
//$newLine:=Change string($newLine;"Press";3)
//$newLine:="("++$newLine+String($price->;"^^,^^0.00")
//
//: ($i=69)  `*Colors
//$newLine:=Change string($newLine;"Colors";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=70)  `*Sheets
//$newLine:=Change string($newLine;"Sheets";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=71)  `*Image
//$newLine:=Change string($newLine;"Image";3)
//$newLine:="("++$newLine+String($price->;"^^,^^0.00")
//
//: ($i=72)  `*Dylox Stampings
//$newLine:=Change string($newLine;"Dylox Stampings";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=73)  `*Dylox Embossings
//$newLine:=Change string($newLine;"Dylox Embossings";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=74)  `*Die Sets (3x3 Flat)
//$newLine:=Change string($newLine;"Die Sets (3x3 Flat)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=75)  `*Die Sets (inches Addtl Brass)
//$newLine:=Change string($newLine;"Die Sets (inches Addtl Brass)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=76)  `*Die Sets (3x3 Combo)
//$newLine:=Change string($newLine;"Die Sets (3x3 Combo)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=77)  `*Die Sets (3x3 Embossing Originals)
//$newLine:=Change string($newLine;"Die Sets (3x3 Embossing Originals)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=78)  `*Die Samples
//$newLine:=Change string($newLine;"Die Samples";3)
//$newLine:="("+String(Records in subselection();"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=79)  `*Dyloxes
//$newLine:=Change string($newLine;"Dyloxes";3)
//$newLine:="("+String(Records in subselection();"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=80)  `*Outside Services
//$newLine:=Change string($newLine;"Outside Services";3)
//$newLine:="("+String(Records in subselection();"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=81)  `*AA Time
//$newLine:=Change string($newLine;"AA Time";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=82)  `*Art Overlay
//$newLine:=Change string($newLine;"Art Overlay";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=83)  `*Dye Sublimation
//$newLine:=Change string($newLine;"Dye Sublimation";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=84)  `*Computer Kit (Estee Co's)
//$newLine:=Change string($newLine;"Computer Kit (Estee Co's)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=85)  `*Embossing Original
//$newLine:=Change string($newLine;"Embossing Original";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=86)  `*Engineer Drawing
//$newLine:=Change string($newLine;"Engineer Drawing";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=87)  `*Fonts
//$newLine:=Change string($newLine;"Fonts";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=88)  `*Match Prints
//$newLine:=Change string($newLine;"Match Prints";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=89)  `*Separations (5 x 7)
//$newLine:=Change string($newLine;"Separations (5 x 7)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=90)  `*Separations (8 x 10)
//$newLine:=Change string($newLine;"Separations (8 x 10)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=91)  `*Separations (14 x 17)
//$newLine:=Change string($newLine;"Separations (14 x 17)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=92)  `*Separations (20 x 24)
//$newLine:=Change string($newLine;"Separations (20 x 24)";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//: ($i=93)  `*UPC or EAN
//$newLine:=Change string($newLine;"UPC or EAN";3)
//$newLine:="("+String(;"^0")+$newLine+String($price->;"^^,^^0.00")
//
//Else 
//BEEP
//ALERT("Unexpected prep type found in uPrintPrep: "+String($i))
//End case 
//
//xText:=xText+$CR+$newLine
//End if 
//
//End for 
//  `*total line
//$newLine:=("_"*76)
//xText:=xText+$CR+$newLine
//$newLine:="  "+("."*60)+"$"  ` )..........$ 
//$newLine:=Change string($newLine;"T O T A L : ";3)
//$newLine:="   "+$newLine+String(;"^^,^^0.00")
//xText:=xText+$CR+$newLine
//  `•061595  MLB  UPR 1636
//$newLine:="  "+("."*60)+"$"  ` )..........$ 
//$newLine:=Change string($newLine;"PRICE TO CUSTOMER : ";3)
//$newLine:="   "+$newLine+
//xText:=xText+$CR+$newLine+$CR
//xText:=xText+$CR+"PO Nº: "++$CR  `•071295  MLB  UPR 222
//xText:=xText+$CR+
//  `END 1636
//util_PAGE_SETUP(->;"PrepPriceRpt")
//PRINT SETTINGS
//If (ok=1)
//t2:="A R K A Y   P A C K A G I N G"
//t2b:="P R E P A R A T O R Y   P R I C E   S H E E T"
//t3:="FOR "+Uppercase([Estimates]CustomerName)+" ON PROJECT "+  `•061295  MLB  UPR 1636
//If ([Estimates]JobNo#0)  `•062295  MLB  UPR 1661
//t3:=t3+" Job Nº: "+String([Estimates]JobNo;"00000")+" Seq: "+String()
//End if 
//
//If (#0)  `•071195  MLB  UPR 222
//t3:=t3+" Order Nº: "+String(;"00000")
//End if 
//
//dDate:=4D_Current_date
//tTime:=4d_Current_time
//OUTPUT FORM(;"PrepPriceRpt")
//PRINT RECORD(;*)
//OUTPUT FORM(;"List")
//End if 
//
//  `