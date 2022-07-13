//%attributes = {"publishedWeb":true}
// Method: sCopyEstimate () -> 
//(S)CopyEst.dio_bSearch  mod 5/2/94 upr 1097
//see also sCreateBudget
//upr 1157 8/10/94
// `upr 1260 10/11/94
//1/5/94 on rfq copy, form cartons were being created
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//• 11/12/97 cs clear Freight Key if dupping RFQ only
//• 12/2/97 cs stop creation of Est_Ship_tos
//• 1/9/98 cs added code to reset the offset, and prefix if this is a new year
//•010499  MLB  fix id and chg to function
// Modified by: Garri Ogata (2/22/21) added to fix creating extra "matl" records

C_LONGINT:C283($rev; $recNo; $i; $numRecs; $numRecs2; $i2)
C_TEXT:C284($newID)

READ WRITE:C146([Estimates:17])
READ WRITE:C146([Estimates_Carton_Specs:19])

zwStatusMsg("COPY EST"; "Searching for the base estimate")
QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=sCriterion1)

If (Records in selection:C76([Estimates:17])=1)
	//*   Get related records  
	$recNo:=Record number:C243([Estimates:17])
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=sCriterion1)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CREATE SET:C116([Estimates_PSpecs:57]; "thePspecs")
		
	Else 
		
		ARRAY LONGINT:C221($_thePspecs; 0)
		LONGINT ARRAY FROM SELECTION:C647([Estimates_PSpecs:57]; $_thePspecs)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (sb1=1)  //copy rfq only
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=sCriterion1; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116([Estimates_Carton_Specs:19]; "theList")
			
			
		Else 
			
			ARRAY LONGINT:C221($_theList; 0)
			LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_theList)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		CREATE EMPTY SET:C140([Estimates_Differentials:38]; "diffs")
		CREATE EMPTY SET:C140([Estimates_DifferentialsForms:47]; "forms")
		CREATE EMPTY SET:C140([Estimates_Machines:20]; "mach")
		CREATE EMPTY SET:C140([Estimates_Materials:29]; "matl")
		
	Else   //copy the entire estimate
		
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=sCriterion1)  //find Estimate Qty worksheet
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116([Estimates_Carton_Specs:19]; "theList")
			
		Else 
			
			ARRAY LONGINT:C221($_theList; 0)
			LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_theList)
			
		End if   // END 4D Professional Services : January 2019
		
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=sCriterion1)
		CREATE SET:C116([Estimates_Differentials:38]; "diffs")
		QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=sCriterion1+"@")
		CREATE SET:C116([Estimates_DifferentialsForms:47]; "forms")
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=sCriterion1+"@")
		CREATE SET:C116([Estimates_Machines:20]; "mach")
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=sCriterion1+"@"; *)
		QUERY:C277([Estimates_Materials:29];  & ; [Estimates_DifferentialsForms:47]FormNumber:2>=0)  // Added by: Garri Ogata (2/22/21) 
		CREATE SET:C116([Estimates_Materials:29]; "matl")
		
	End if   //sb2    
	//*   Determine the new estimate number  
	If (rb1=1)  //just increment the revision number    
		$newID:=Substring:C12(sCriterion1; 1; 7)
		zwStatusMsg("COPY EST"; "Determining next revision number")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$newID+"@")
			ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; <)
			FIRST RECORD:C50([Estimates:17])
			
			
		Else 
			
			QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$newID+"@")
			ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; <)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		$rev:=Num:C11(Substring:C12([Estimates:17]EstimateNo:1; 8; 2))
		If ($rev=99)
			BEEP:C151
			ALERT:C41("Sorry, only 99 revisions allowed.")
			REJECT:C38
		End if 
		$newID:=$newID+String:C10($rev+1; "00")
		GOTO RECORD:C242([Estimates:17]; $recNo)
	Else 
		zwStatusMsg("COPY EST"; "Determining next estimate number")
		//•010499  MLB  fix and chg to function
		$newId:=EstOffsetAdjust  //• 1/9/98 cs check that offset & prefix are correctly set 
		
	End if 
	//*   Duplicate the estimate  
	zwStatusMsg("COPY EST"; "Duplicating "+sCriterion1)
	DUPLICATE RECORD:C225([Estimates:17])
	[Estimates:17]pk_id:68:=Generate UUID:C1066
	[Estimates:17]EstimateNo:1:=$newID
	[Estimates:17]Comments:34:="Based on Estimate Number "+sCriterion1+". "+[Estimates:17]Comments:34
	[Estimates:17]Status:30:="New"
	[Estimates:17]DateOriginated:19:=4D_Current_date
	[Estimates:17]EstimatedBy:14:=""  //upr 1154
	[Estimates:17]DateEstimated:64:=!00-00-00!
	[Estimates:17]DateEstimatedTime:65:=?00:00:00?
	[Estimates:17]DatePrice:60:=!00-00-00!
	[Estimates:17]DateQuoted:61:=!00-00-00!
	[Estimates:17]DateRFQ:52:=!00-00-00!
	[Estimates:17]DateRFQTime:53:=?00:00:00?
	[Estimates:17]ModWho:38:=<>zResp
	[Estimates:17]CreatedBy:59:=<>zResp
	[Estimates:17]ProjectNumber:63:=Pjt_getReferId
	
	
	If (rb2=1)  //this is a new estimate
		[Estimates:17]JobNo:50:=0
		[Estimates:17]OrderNo:51:=0
	End if 
	
	If (sb1=1)  //copy rfq only
		[Estimates:17]Last_Differential_Number:31:=0
		[Estimates:17]z_FreightKey:33:=""  //• 11/12/97 cs 
		[Estimates:17]z_ShippingTo:35:=""  //• 11/12/97 cs 
	End if 
	// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates]z_SYNC_ID;->[Estimates]z_SYNC_DATA)
	SAVE RECORD:C53([Estimates:17])
	$recNo:=Record number:C243([Estimates:17])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("theList")
	Else 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	$numRecs:=Records in selection:C76([Estimates_Carton_Specs:19])
	uThermoInit($numRecs; "Copying Carton Specs.")
	For ($i; 1; $numRecs)
		uThermoUpdate($i)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("theList")
			GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $i)
			
		Else 
			GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_theList{$i})
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
		CREATE SET:C116([Estimates_FormCartons:48]; "cartons")
		
		DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
		[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
		[Estimates_Carton_Specs:19]Estimate_No:2:=$newID
		//° [CARTON_SPEC]CartonSpecKey:=Seq444uence number([CARTON_SPEC])+◊aOffSet{19}
		[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
		[Estimates_Carton_Specs:19]z_PriceSqInYld_M:34:=0  //upr 1260
		[Estimates_Carton_Specs:19]z_PriceSqInWant_M:33:=0
		[Estimates_Carton_Specs:19]PriceFGOH_M:23:=0
		[Estimates_Carton_Specs:19]PriceFGOHin_M:24:=0
		[Estimates_Carton_Specs:19]PriceWant_Per_M:28:=0
		[Estimates_Carton_Specs:19]PriceYield_PerM:30:=0
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
		//*       Duplicate the formCartons
		USE SET:C118("cartons")
		$numRecs2:=Records in selection:C76([Estimates_FormCartons:48])
		
		For ($i2; 1; $numRecs2)
			USE SET:C118("cartons")
			GOTO SELECTED RECORD:C245([Estimates_FormCartons:48]; $i2)
			DUPLICATE RECORD:C225([Estimates_FormCartons:48])
			[Estimates_FormCartons:48]pk_id:18:=Generate UUID:C1066
			[Estimates_FormCartons:48]Carton:1:=[Estimates_Carton_Specs:19]CartonSpecKey:7
			[Estimates_FormCartons:48]DiffFormID:2:=$newID+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 10; 4)
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_FormCartons]_SYNC_ID;->[Estimates_FormCartons]_SYNC_DATA)
			SAVE RECORD:C53([Estimates_FormCartons:48])
		End for 
		CLEAR SET:C117("cartons")
	End for 
	uThermoClose
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CLEAR SET:C117("theList")
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("thePspecs")
		$numRecs:=Records in selection:C76([Estimates_PSpecs:57])
		uThermoInit($numRecs; "Copying Process Specs.")
		For ($i; 1; $numRecs)
			uThermoUpdate($i)
			USE SET:C118("thePspecs")
			GOTO SELECTED RECORD:C245([Estimates_PSpecs:57]; $i)
			DUPLICATE RECORD:C225([Estimates_PSpecs:57])
			[Estimates_PSpecs:57]pk_id:6:=Generate UUID:C1066
			[Estimates_PSpecs:57]EstimateNo:1:=$newID
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_PSpecs]z_SYNC_ID;->[Estimates_PSpecs]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_PSpecs:57])
		End for 
		uThermoClose
		CLEAR SET:C117("thePspecs")
		
	Else 
		
		$numRecs:=Records in selection:C76([Estimates_PSpecs:57])
		uThermoInit($numRecs; "Copying Process Specs.")
		For ($i; 1; $numRecs)
			uThermoUpdate($i)
			GOTO RECORD:C242([Estimates_PSpecs:57]; $_thePspecs{$i})
			DUPLICATE RECORD:C225([Estimates_PSpecs:57])
			[Estimates_PSpecs:57]pk_id:6:=Generate UUID:C1066
			[Estimates_PSpecs:57]EstimateNo:1:=$newID
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_PSpecs]z_SYNC_ID;->[Estimates_PSpecs]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_PSpecs:57])
		End for 
		uThermoClose
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (sb2=1)  //copy all
		USE SET:C118("diffs")
		$numRecs:=Records in selection:C76([Estimates_Differentials:38])
		uThermoInit($numRecs; "Copying the Differentials.")
		For ($i; 1; $numRecs)
			uThermoUpdate($i)
			USE SET:C118("diffs")
			GOTO SELECTED RECORD:C245([Estimates_Differentials:38]; $i)
			DUPLICATE RECORD:C225([Estimates_Differentials:38])
			[Estimates_Differentials:38]pk_id:46:=Generate UUID:C1066
			[Estimates_Differentials:38]estimateNum:2:=$newID
			[Estimates_Differentials:38]Id:1:=$newID+[Estimates_Differentials:38]diffNum:3
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Differentials]z_SYNC_ID;->[Estimates_Differentials]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_Differentials:38])
		End for 
		uThermoClose
		CLEAR SET:C117("diffs")
		
		USE SET:C118("forms")
		$numRecs:=Records in selection:C76([Estimates_DifferentialsForms:47])
		uThermoInit($numRecs; "Copying the Forms.")
		For ($i; 1; $numRecs)
			uThermoUpdate($i)
			USE SET:C118("forms")
			GOTO SELECTED RECORD:C245([Estimates_DifferentialsForms:47]; $i)
			DUPLICATE RECORD:C225([Estimates_DifferentialsForms:47])
			[Estimates_DifferentialsForms:47]pk_id:37:=Generate UUID:C1066
			[Estimates_DifferentialsForms:47]DiffFormId:3:=$newID+Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 10; 2)+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
			[Estimates_DifferentialsForms:47]DiffId:1:=$newID+Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_DifferentialsForms]z_SYNC_ID;->[Estimates_DifferentialsForms]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_DifferentialsForms:47])
		End for 
		uThermoClose
		CLEAR SET:C117("forms")
		
		USE SET:C118("mach")
		$numRecs:=Records in selection:C76([Estimates_Machines:20])
		uThermoInit($numRecs; "Copying the Machines.")
		For ($i; 1; $numRecs)
			uThermoUpdate($i)
			USE SET:C118("mach")
			GOTO SELECTED RECORD:C245([Estimates_Machines:20]; $i)
			DUPLICATE RECORD:C225([Estimates_Machines:20])
			[Estimates_Machines:20]pk_id:48:=Generate UUID:C1066
			[Estimates_Machines:20]DiffFormID:1:=$newID+Substring:C12([Estimates_Machines:20]DiffFormID:1; 10; 4)
			[Estimates_Machines:20]EstimateNo:14:=$newID
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Machines]_SYNC_ID;->[Estimates_Machines]_SYNC_DATA)
			SAVE RECORD:C53([Estimates_Machines:20])
		End for 
		uThermoClose
		CLEAR SET:C117("mach")
		
		USE SET:C118("matl")
		$numRecs:=Records in selection:C76([Estimates_Materials:29])
		uThermoInit($numRecs; "Copying the Materials.")
		For ($i; 1; $numRecs)
			uThermoUpdate($i)
			USE SET:C118("matl")
			GOTO SELECTED RECORD:C245([Estimates_Materials:29]; $i)
			DUPLICATE RECORD:C225([Estimates_Materials:29])
			[Estimates_Materials:29]pk_id:33:=Generate UUID:C1066
			[Estimates_Materials:29]DiffFormID:1:=$newID+Substring:C12([Estimates_Materials:29]DiffFormID:1; 10; 4)
			[Estimates_Materials:29]EstimateNo:5:=$newID
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Materials]z_SYNC_ID;->[Estimates_Materials]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_Materials:29])
		End for 
		uThermoClose
		CLEAR SET:C117("matl")
	End if   //copy all    
	
	sCopyEstimateNewValues  // Added by: Mark Zinke (1/7/14) 
	
	GOTO RECORD:C242([Estimates:17]; $recNo)
	zwStatusMsg("COPY EST"; "Finished.")
	ERASE WINDOW:C160
	
Else 
	BEEP:C151
	ALERT:C41(sCriterion1+" could not be found.")
	REJECT:C38
End if 