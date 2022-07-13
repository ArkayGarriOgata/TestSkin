//%attributes = {"publishedWeb":true}
//PM:  CostCtr_FlexFieldLabels  111099  mlb
//   see also eBag_SetFlexFields
// see also uInit_CostCenterGroups
//formerly `BeforeMachineEs()     -JML    8/19/93 , mod mlb 11/10/93, 2/9/94, 3/25
//this procedure initializes the [machine_est]input layout
//to allow only relevant data entry for the cost center represented by
//the record being edited.
//consider also (P) uDefaultMatls
//see also eBag_SetFlexFields
//upr 69 02/28/95 chip
//3/2/95 add a param
//3/15/95 upr 66
//•051096 mlb add the roland
//•060696  MLB  add 462 & 468 like 465
//•062896  MLB  supt a generic machine
//•062896  MLB  markAndy
//•071696  MLB  nothing extra required, leave flex fields blank
//•071896  MLB  MarkAndy
//•090696  MLB 476 477
//•031197  mBohince  add the 443
//•062598  MLB  UPR 238
//•042999  MLB  UPR 1947
//•1/18/00  mlb  UPR add trun table
//• 062300 mlb chg to plates 
//•9/22/00  mlb  add 452
//•12/08/00  mlb  add 454
// • mel (11/3/04, 14:29:37)
// Modified by: Mel Bohince (7/29/16) add doublewide option for 429
// Modified by: Mel Bohince (7/9/21) //set up group ipv's, since change to storage

CostCtrInit  // Modified by: Mel Bohince (7/9/21) //set up group ipv's

C_TEXT:C284($1)  //if a paramter is pased, then Jobs clled this procedure
C_TEXT:C284(sMachLabel1)
C_TEXT:C284(sMachLabel2)
C_TEXT:C284(sMachLabel3)
C_TEXT:C284(sMachLabel4)
C_TEXT:C284(sMachLabel5)  // boolean
C_TEXT:C284(sMachLabel6)  //booealen
C_TEXT:C284(sMachLabel7)  //longint
C_TEXT:C284($CC)
C_BOOLEAN:C305($enterable)
C_POINTER:C301($flexPtr1; $flexPtr2; $flexPtr3; $flexPtr4; $flexPtr5; $flexPtr6; $flexPtr7)

sMachLabel1:=""
sMachLabel2:=""
sMachLabel3:=""
sMachLabel4:=""
sMachLabel5:=""
sMachLabel6:=""
sMachLabel7:=""
$enterable:=True:C214

If (Count parameters:C259>0)
	If ($1="Jobs")
		$enterable:=False:C215
		$CC:=[Job_Forms_Machines:43]CostCenterID:4
		$flexPtr1:=->[Job_Forms_Machines:43]Flex_field1:6
		$flexPtr2:=->[Job_Forms_Machines:43]Flex_field2:7
		$flexPtr3:=->[Job_Forms_Machines:43]Flex_field3:17
		$flexPtr4:=->[Job_Forms_Machines:43]Flex_field4:26
		$flexPtr5:=->[Job_Forms_Machines:43]Flex_Field5:27
		$flexPtr6:=->[Job_Forms_Machines:43]Flex_field6:34
		$flexPtr7:=->[Job_Forms_Machines:43]Flex_field7:35
	Else 
		$CC:=[Process_Specs_Machines:28]CostCenterID:4
		$flexPtr1:=->[Process_Specs_Machines:28]Flex_Field1:12
		$flexPtr2:=->[Process_Specs_Machines:28]Flex_Field2:13
		$flexPtr3:=->[Process_Specs_Machines:28]Flex_Field3:14
		$flexPtr4:=->[Process_Specs_Machines:28]Flex_Field4:15
		$flexPtr5:=->[Process_Specs_Machines:28]Flex_Field5:16
		$flexPtr6:=->[Process_Specs_Machines:28]Flex_Field6:17
		$flexPtr7:=->[Process_Specs_Machines:28]Flex_Field7:18
	End if 
Else 
	$CC:=[Estimates_Machines:20]CostCtrID:4
	$flexPtr1:=->[Estimates_Machines:20]Flex_field1:18
	$flexPtr2:=->[Estimates_Machines:20]Flex_Field2:19
	$flexPtr3:=->[Estimates_Machines:20]Flex_Field3:20
	$flexPtr4:=->[Estimates_Machines:20]Flex_Field4:21
	$flexPtr5:=->[Estimates_Machines:20]Flex_Field5:25
	$flexPtr6:=->[Estimates_Machines:20]Flex_field6:37
	$flexPtr7:=->[Estimates_Machines:20]Flex_Field7:38
End if 

Case of 
		//•062598  MLB  add roanoke plate rooms
	: (Position:C15($CC; <>PLATEMAKING)>0)
		sMachLabel1:="# Plates:"  //• 062300 mlb chg to plates 
		//sMachLabel2:="# Keys:"
		//sMachLabel3:="Press Number:"
		//sMachLabel4:="# Remakes:"
		//sMachLabel7:="# Swings:"  `longint  
		//sMachLabel5:="Repeat Job"  `•062598  MLB  UPR 238
		//sMachLabel6:="Dupont (+1hr)"  `•062598  MLB  UPR 238
		
		//: ($CC="405")  //imaging
		
		//: ($CC="411")  //•0071896  MLB  MarkAndy
		//sMachLabel1:="Total # of Colors:"
		//sMachLabel2:="Total # Plate Chgs:"
		//sMachLabel3:="# Common Colors:"
		//  //sMachLabel4:="Coat|FlexPlateChgs:"
		//  //sMachLabel7:="# of Colors:"
		//sMachLabel5:="Cutting Die:"
		//sMachLabel6:="Recycled Stock:"
		
		//: (($CC="414") | ($CC="415"))  //heidelburg
		//sMachLabel1:="Total # of Colors:"  //3/15/95 upr 66 swap the positions
		//sMachLabel2:="Total # Plate Chgs:"
		//  // sMachLabel2:="# of Colors:"
		//sMachLabel5:="Spot Coating:"
		//sMachLabel6:="Backside:"
		
	: (Position:C15($CC; <>PRESSES)>0)
		sMachLabel1:="Print Colors:"  //3/15/95 upr 66 swap the positions
		sMachLabel2:="Print Plate Chgs:"
		sMachLabel3:="Coat|FlexColors:"
		sMachLabel4:="Coat|FlexPlateChgs:"
		sMachLabel7:="Metallic Inks"  //mlb 51298 HTK chg
		sMachLabel5:="Difficult Run:"
		sMachLabel6:="Backside:"
		
		//: ($CC="419")  //proofing press
		//sMachLabel1:="# Colors:"
		
		//: ($CC="427")  //Gravure USE p-spec
		//sMachLabel1:="# Act. Gravure Colors:"
		//  // sMachLabel2:="# AK colors"
		
		//: ($CC="426")  //sheeter
		//sMachLabel5:="Coating:"
		
	: (Position:C15($CC; <>SHEETERS)>0)
		
		If ($cc="429")  // Modified by: Mel Bohince (7/29/16) add doublewide option for 429
			sMachLabel5:="Double-wide:"
		End if 
		
		
		
		//: ($CC="431")  //ink making
		//sMachLabel1:="Pounds:"
		//sMachLabel5:="Match Color:"
		
		//: ($CC="442") | ($CC="443")  //•031197  mBohince 
		//sMachLabel5:="Stripping Unit:"  //checkbox  
		//sMachLabel6:="Blanking Unit:"  //checkbox  
		
	: (Position:C15($CC; <>STAMPERS)>0)  //($CC="451") | ($CC="452") | ($CC="454") | ($CC="455")  //bobst stamping
		sMachLabel1:="# Emboss Units:"
		sMachLabel2:="# Flat Units:"
		sMachLabel3:="# Combo Units:"
		sMachLabel4:="Position Coverage:"
		sMachLabel7:="# of Die Changes:"  //longint    
		
	: (Position:C15($CC; <>EMBOSSERS)>0)  //($CC="551") | ($CC="552") | ($CC="554") | ($CC="555")  //bobst embossing
		sMachLabel1:="# Emboss Units:"
		sMachLabel2:="# Flat Units:"
		sMachLabel3:="# Combo Units:"
		sMachLabel4:="Position Coverage:"
		sMachLabel7:="# of Die Changes:"  //longint    
		
		//: ($CC="455")  `cylinder stamper
		//sMachLabel1:="Obselete!"
		
	: (Position:C15($CC; <>BLANKERS)#0)  //•042999  MLB  UPR 1947
		sMachLabel5:="Strip/BCK:"  //checkbox
		sMachLabel6:="Repeat Form:"  //checkbox
		
		//: (Position($CC;"561 562 565 568 569")#0)  //•042999  MLB  UPR 1947
		//sMachLabel5:="Stripping Unit:"  //checkbox
		//sMachLabel6:="Repeat Form:"  //checkbox
		
		//: ($CC="463") | ($CC="563")  //bobst embossing
		//sMachLabel1:="# Emboss Units:"
		
		//: (Position($CC;"462 465 468") # 0)  `•060696  MLB  
		//sMachLabel5:="Repeat Form:"  `checkbox
		
		//: ($CC="466")  `turntable`•1/18/00  mlb  
		//  `leave blank
		
	: (Position:C15($CC; <>GLUERS)#0)  //gluer  `•090696  MLB 476 477
		sMachLabel1:="Want Qty:"
		sMachLabel2:="# Make Readies:"
		sMachLabel3:="Yield Qty:"
		//   sMachLabel4:="# Make Readies:"
		sMachLabel5:="Complex:"
		sMachLabel6:="Image/Sensor:"
		
	: (Position:C15($CC; <>WINDOWERS)#0)  //windower <>WINDOWERS
		sMachLabel1:="# of Lanes:"
		sMachLabel2:="# Up per Lane:"
		sMachLabel3:="Want Qty:"
		sMachLabel4:="Yield Qty:"
		
	: ($CC="491") | ($CC="493")
		sMachLabel1:="Want Qty:"
		sMachLabel2:="Yield Qty:"
		sMachLabel5:="Packing Sheets:"
		
	: ($CC="496") | ($CC="497")  //strate cutter
		sMachLabel1:="# of Cuts:"
		
	: ($CC="501")
		sMachLabel1:="Want Qty:"
		sMachLabel2:="Yield Qty:"
		sMachLabel3:="CentsPerUnit:"
		sMachLabel5:="Handling Sheets:"
		sMachLabel6:="Seperating:"
		
		//: ($CC="502")
		//sMachLabel1:="Want Qty:"
		//sMachLabel2:="Yield Qty:"
		//sMachLabel3:="CentsPerUnit:"
		//sMachLabel5:="Examine Sheets:"
		//sMachLabel6:="Seperating:"
		
	: ($CC="505")
		sMachLabel1:="Want Qty:"
		sMachLabel2:="Yield Qty:"
		
		//: ($CC="581")  //screen making
		//sMachLabel1:="# of Screens:"
		
		//: ($CC="584")  //thomson hand feed
		//sMachLabel1:="# Emboss Units:"
		//sMachLabel2:="# Flat Units:"
		//sMachLabel3:="# Combo Units:"
		
		//: ($CC="585")  //individual stamping
		//sMachLabel1:="# Up (1 or 2):"
		//sMachLabel2:="Want Qty:"
		//sMachLabel3:="Yield Qty:"
		//sMachLabel5:="Stamping Sheets:"
		
		//: (Position($CC;"471 490")#0)  //•071696  MLB  nothing required
		//leave flex fields blank
		
	Else   //•062896  MLB  supt a generic machine
		sMachLabel1:="Net:"
		sMachLabel2:="Yield:"
		sMachLabel5:="Stamping Sheets:"
End case 

OBJECT SET ENTERABLE:C238($flexPtr1->; (Length:C16(sMachLabel1)>0) & ($enterable))
OBJECT SET ENTERABLE:C238($flexPtr2->; (Length:C16(sMachLabel2)>0) & ($enterable))
OBJECT SET ENTERABLE:C238($flexPtr3->; (Length:C16(sMachLabel3)>0) & ($enterable))
OBJECT SET ENTERABLE:C238($flexPtr4->; (Length:C16(sMachLabel4)>0) & ($enterable))
OBJECT SET ENTERABLE:C238($flexPtr5->; (Length:C16(sMachLabel5)>0) & ($enterable))
OBJECT SET ENTERABLE:C238($flexPtr6->; (Length:C16(sMachLabel6)>0) & ($enterable))
OBJECT SET ENTERABLE:C238($flexPtr7->; (Length:C16(sMachLabel7)>0) & ($enterable))

OBJECT SET VISIBLE:C603($flexPtr1->; (Length:C16(sMachLabel1)>0))
OBJECT SET VISIBLE:C603($flexPtr2->; (Length:C16(sMachLabel2)>0))
OBJECT SET VISIBLE:C603($flexPtr3->; (Length:C16(sMachLabel3)>0))
OBJECT SET VISIBLE:C603($flexPtr4->; (Length:C16(sMachLabel4)>0))
OBJECT SET VISIBLE:C603($flexPtr5->; (Length:C16(sMachLabel5)>0))
OBJECT SET VISIBLE:C603($flexPtr6->; (Length:C16(sMachLabel6)>0))
OBJECT SET VISIBLE:C603($flexPtr7->; (Length:C16(sMachLabel7)>0))

MESSAGES OFF:C175  //3/16/95 upr 66

If (Count parameters:C259=0)  //called from machine est
	QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]DiffFormID:1=[Estimates_Machines:20]DiffFormID:1; *)
	QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]Sequence:12=[Estimates_Machines:20]Sequence:5; *)
	QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]CostCtrID:2=[Estimates_Machines:20]CostCtrID:4)  //get material est records
	If (Records in selection:C76([Estimates_Materials:29])>1)
		ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6)
	Else 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Estimates_Materials:29])
			
		Else 
			
			//see line 266
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
	End if 
	gSetMatEstTitle([Estimates_Materials:29]Commodity_Key:6; Records in selection:C76([Estimates_Materials:29]))  //3/2/95
	ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Real2:15; >; [Estimates_Materials:29]Commodity_Key:6; >)
Else 
	If ($1="PSpec")
		QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs_Machines:28]ProcessSpec:1; *)  //√ wit
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Sequence:4=[Process_Specs_Machines:28]Seq_Num:3; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CustID:2=[Process_Specs:18]Cust_ID:4; *)  // • mel (11/3/04, 14:29:37)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CostCtrID:3=[Process_Specs_Machines:28]CostCenterID:4)  //get material est records
		If (Records in selection:C76([Process_Specs_Materials:56])>1)
			ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Commodity_Key:8; >)
		Else 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Process_Specs_Materials:56])
				
				
			Else 
				
				//see line 289
				
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
		End if 
		gSetMatEstTitle([Process_Specs_Materials:56]Commodity_Key:8; Records in selection:C76([Process_Specs_Materials:56]))  //3/2/95
		ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Real2:15; >; [Process_Specs_Materials:56]Commodity_Key:8; >)
	Else 
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms_Machines:43]JobForm:1; *)  //√ wit
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=[Job_Forms_Machines:43]Sequence:5; *)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]CostCenterID:2=[Job_Forms_Machines:43]CostCenterID:4)  //get material est records
		If (Records in selection:C76([Job_Forms_Materials:55])>1)
			ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12; >)
		Else 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Job_Forms_Materials:55])
				
				
			Else 
				
				//see line 311
				
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
		End if 
		gSetMatEstTitle([Job_Forms_Materials:55]Commodity_Key:12; Records in selection:C76([Job_Forms_Materials:55]))  //3/2/95
		ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Real2:18; >; [Job_Forms_Materials:55]Commodity_Key:12; >)
	End if 
End if 
MESSAGES ON:C181  //3/16/95 upr 66
//upr 69 02/28/95 chip end