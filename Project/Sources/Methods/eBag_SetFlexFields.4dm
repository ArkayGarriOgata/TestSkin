//%attributes = {"publishedWeb":true}
//PM: eBag_SetFlexFields() -> 
// see also CostCtr_FlexFieldLabels
//@author mlb - 5/30/02  14:09

C_TEXT:C284($CC)
C_TEXT:C284(sMachLabel1)
C_TEXT:C284(sMachLabel2)
C_TEXT:C284(sMachLabel3)
C_TEXT:C284(sMachLabel4)
C_TEXT:C284(sMachLabel5)  // boolean
C_TEXT:C284(sMachLabel6)  //booealen
C_TEXT:C284(sMachLabel7)  //longint

sMachLabel1:=""
sMachLabel2:=""
sMachLabel3:=""
sMachLabel4:=""
sMachLabel5:=""
sMachLabel6:=""
sMachLabel7:=""
xTitle:=""  //
$CC:=[Job_Forms_Machines:43]CostCenterID:4

Case of 
		//•062598  MLB  add roanoke plate rooms
	: ($CC="401") | ($CC="402") | ($CC="403")  //plate making
		sMachLabel1:="# Plates:"  //• 062300 mlb chg to plates 
		//sMachLabel2:="# Keys:"
		//sMachLabel3:="Press Number:"
		//sMachLabel4:="# Remakes:"
		//sMachLabel7:="# Swings:"  `longint  
		//sMachLabel5:="Repeat Job"  `•062598  MLB  UPR 238
		//sMachLabel6:="Dupont (+1hr)"  `•062598  MLB  UPR 238    
		
	: (($CC="414") | ($CC="415"))  //heidelburg
		sMachLabel1:="Total # of Colors:"  //3/15/95 upr 66 swap the positions
		sMachLabel2:="Total # Plate Chgs:"
		// sMachLabel2:="# of Colors:"
		sMachLabel5:="Spot Coating:"
		sMachLabel6:="Backside:"
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xTitle:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" sheets for Color Standards"
		End if 
		
	: (Position:C15($CC; <>PRESSES)>0)  //($CC="412") | ($CC="416")  //•051096 mlb roland
		sMachLabel1:="Print Colors:"  //3/15/95 upr 66 swap the positions
		sMachLabel2:="Print Plate Chgs:"
		sMachLabel3:="Coat|FlexColors:"
		sMachLabel4:="Coat|FlexPlateChgs:"
		sMachLabel7:="Metallic Inks"  //mlb 51298 HTK chg
		sMachLabel5:="Easy Run:"
		sMachLabel6:="Backside:"
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xTitle:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" sheets for Color Standards"
		End if 
		
		
		
	: ($CC="419")  //proofing press
		sMachLabel1:="# Colors:"
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xTitle:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" sheets for Color Standards"
		End if 
		
	: ($CC="427")  //Gravure USE p-spec
		sMachLabel1:="# Act. Gravure Colors:"
		// sMachLabel2:="# AK colors"
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xTitle:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" sheets for Color Standards"
		End if 
		
	: (Position:C15($CC; <>SHEETERS)>0)
		//sMachLabel5:="Coating:"
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xTitle:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" sheets for Color Standards"  //
		End if 
		
		If ($cc="429")  // Modified by: Mel Bohince (7/29/16) add doublewide option for 429
			sMachLabel5:="Double-wide:"
		End if 
		//: ($CC="431")  //ink making
		//sMachLabel1:="Pounds:"
		//sMachLabel5:="Match Color:"
		
		//: ($CC="442") | ($CC="443")  //•031197  mBohince 
		//sMachLabel5:="Stripping Unit:"  //checkbox  
		//sMachLabel6:="Blanking Unit:"  //checkbox  
		
		//If 
		
		
	: ((Position:C15($CC; <>EMBOSSERS)>0) | (Position:C15($CC; <>STAMPERS)>0))  //bobst stamping
		sMachLabel1:="# Emboss Units:"
		sMachLabel2:="# Flat Units:"
		sMachLabel3:="# Combo Units:"
		sMachLabel4:="Position Coverage:"
		sMachLabel7:="# of Die Changes:"  //longint    
		
	: ($CC="455")  //cylinder stamper
		sMachLabel1:="Obselete!"
		
	: (Position:C15($CC; <>BLANKERS)#0)  //•042999  MLB  UPR 1947
		sMachLabel5:="Stripping Unit:"  //checkbox
		sMachLabel6:="Repeat Form:"  //checkbox
		
	: ($CC="463")  //bobst embossing
		sMachLabel1:="# Emboss Units:"
		
		//: (Position($CC;"462 465 468") # 0)  `•060696  MLB  
		//sMachLabel5:="Repeat Form:"  `checkbox
		
	: ($CC="466")  //turntable`•1/18/00  mlb  
		//leave blank
		
	: (Position:C15($CC; <>GLUERS)#0)  //gluer  `•090696  MLB 476 477
		sMachLabel1:="Want Qty:"
		sMachLabel2:="# Make Readies:"
		sMachLabel3:="Yield Qty:"
		//   sMachLabel4:="# Make Readies:"
		sMachLabel5:="Complex:"
		sMachLabel6:="Image:"
		
	: ($CC="486")  //windower
		sMachLabel1:="# of Lanes:"
		sMachLabel2:="# Up per Lane:"
		sMachLabel3:="Want Qty:"
		sMachLabel4:="Yield Qty:"
		
	: ($CC="491")
		sMachLabel1:="Want Qty:"
		sMachLabel2:="Yield Qty:"
		sMachLabel5:="Packing Sheets:"
		
	: ($CC="496") | ($CC="497")  //strate cutter
		sMachLabel1:="# of Cuts:"
		
	: ($CC="501")
		sMachLabel1:="Want Qty:"
		sMachLabel2:="Yield Qty:"
		sMachLabel5:="Handling Sheets:"
		
	: ($CC="502")
		sMachLabel1:="Want Qty:"
		sMachLabel2:="Yield Qty:"
		sMachLabel5:="Examine Sheets:"
		
	: ($CC="581")  //screen making
		sMachLabel1:="# of Screens:"
		
	: ($CC="584")  //thomson hand feed
		sMachLabel1:="# Emboss Units:"
		sMachLabel2:="# Flat Units:"
		sMachLabel3:="# Combo Units:"
		
	: ($CC="585")  //individual stamping
		sMachLabel1:="# Up (1 or 2):"
		sMachLabel2:="Want Qty:"
		sMachLabel3:="Yield Qty:"
		sMachLabel5:="Stamping Sheets:"
		
	: (Position:C15($CC; "471 472 490")#0)  //•071696  MLB  nothing required
		//leave flex fields blank
		
	Else   //•062896  MLB  supt a generic machine
		sMachLabel1:="Net:"
		sMachLabel2:="Yield:"
		sMachLabel5:="Stamping Sheets:"
End case 