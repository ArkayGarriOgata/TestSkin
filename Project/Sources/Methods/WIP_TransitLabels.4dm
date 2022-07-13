//%attributes = {}
// Method: WIP_TransitLabels () -> 
// ----------------------------------------------------
// by: mel: 07/11/05, 16:20:38
// ----------------------------------------------------
// Description:
// see also Barcode_SSCC_PnG
// 

// ----------------------------------------------------
C_LONGINT:C283(numRecs1; $2; iQty; $3; $sscc)
C_TEXT:C284(sJobForm)
C_TEXT:C284(sJobit; $1; xText)
xText:="Single Item Load"
//containerType = 0 carton, 1 = pallet
sArkayUCCid:="0000808292"  //sscc app code+containerType+UCCregistration#
sArkayLotPrefix:=""  //assigned by P&G, plus RV for Roanoke, HN for Hauppauge
READ ONLY:C145([Job_Forms_Items:44])

If (Count parameters:C259=0)
	$winRef:=Open form window:C675([WMS_SerializedShippingLabels:96]; "CreateWIPrecords")
	DIALOG:C40([WMS_SerializedShippingLabels:96]; "CreateWIPrecords")
	CLOSE WINDOW:C154($winRef)
	
Else 
	sJobForm:=Substring:C12($1; 1; 8)
	sJobit:=$1
	sHead1:=$1
	numRecs1:=$2
	iQty:=$3
	sIssType:=$4
	xText:="Single Item Load"
	rActCost:=0
	rActPrice:=0
	ok:=1
End if 



If (ok=1)
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE EMPTY SET:C140([WMS_SerializedShippingLabels:96]; "newOnes")
		
	Else 
		
		ARRAY LONGINT:C221($_newOnes; 0)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	For ($sscc; 1; numRecs1)
		CREATE RECORD:C68([WMS_SerializedShippingLabels:96])
		$serialnumber:=app_set_id_as_string(Table:C252(->[WMS_SerializedShippingLabels:96]); "00000000")  //fGetNextID (->[WMS_SerializedShippingLabels];9)
		$chkMod10:=fBarCodeMod10Digit(sArkayUCCid+$serialnumber)
		
		[WMS_SerializedShippingLabels:96]ShippingUnitSerialNumber:1:=fBarCodeSym(129; sArkayUCCid+$serialnumber+$chkMod10)
		
		[WMS_SerializedShippingLabels:96]HumanReadable:5:=sArkayUCCid+$serialnumber+$chkMod10
		If (User in group:C338(Current user:C182; "Roanoke"))
			[WMS_SerializedShippingLabels:96]PlantNumber:8:="RV"
		Else 
			[WMS_SerializedShippingLabels:96]PlantNumber:8:="HN"
		End if 
		[WMS_SerializedShippingLabels:96]Jobit:3:=sJobit
		[WMS_SerializedShippingLabels:96]LotNumber:6:=sHead1  //sArkayLotPrefix+[SerializedShippingLabels]PlantNumber+Replace string($jobit;".";"")
		If ([Job_Forms_Items:44]Jobit:4#sJobit)
			READ ONLY:C145([Job_Forms_Items:44])
			$numFound:=qryJMI(sJobit)
		Else 
			$numFound:=1
		End if 
		If ($numFound>0)
			[WMS_SerializedShippingLabels:96]CPN:2:=[Job_Forms_Items:44]ProductCode:3
			$numFound:=qryFinishedGood("#CPN"; [WMS_SerializedShippingLabels:96]CPN:2)
			If ($numFound>0)
				[WMS_SerializedShippingLabels:96]CartonDesc:7:=Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 25))
			Else 
				[WMS_SerializedShippingLabels:96]CartonDesc:7:=""
			End if 
		Else 
			[WMS_SerializedShippingLabels:96]CPN:2:="MIXED"
			[WMS_SerializedShippingLabels:96]CartonDesc:7:="SEE BELOW"
		End if 
		[WMS_SerializedShippingLabels:96]Quantity:4:=iQty
		[WMS_SerializedShippingLabels:96]CreateDate:9:=4D_Current_date
		[WMS_SerializedShippingLabels:96]POnumber:10:=sPOnum2
		[WMS_SerializedShippingLabels:96]SkidNumber:11:=""  //these would have to be filled in after creation, linking paperform# to sscc
		[WMS_SerializedShippingLabels:96]ContainerType:13:=sIssType
		[WMS_SerializedShippingLabels:96]Comment:17:=xText
		[WMS_SerializedShippingLabels:96]WIPprice:19:=rActCost
		[WMS_SerializedShippingLabels:96]FGprice:20:=rActPrice
		SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			ADD TO SET:C119([WMS_SerializedShippingLabels:96]; "newOnes")
			
		Else 
			
			APPEND TO ARRAY:C911($_newOnes; Record number:C243([WMS_SerializedShippingLabels:96]))
			
		End if   // END 4D Professional Services : January 2019 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([WMS_SerializedShippingLabels:96])
			
		Else 
			
			//see line 115 
			
		End if   // END 4D Professional Services : January 2019 
		
	End for 
	
	REDUCE SELECTION:C351([WMS_SerializedShippingLabels:96]; 0)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		COPY SET:C600("newOnes"; "◊PassThroughSet")
		CLEAR SET:C117("newOnes")
		
	Else 
		
		CREATE SET FROM ARRAY:C641([WMS_SerializedShippingLabels:96]; $_newOnes; "newOnes")
		
		COPY SET:C600("newOnes"; "◊PassThroughSet")
		CLEAR SET:C117("newOnes")
		
	End if   // END 4D Professional Services : January 2019 
	
	<>PassThrough:=True:C214
	ViewSetter(2; ->[WMS_SerializedShippingLabels:96])
End if 
