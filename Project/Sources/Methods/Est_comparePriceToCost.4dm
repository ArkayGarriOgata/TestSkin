//%attributes = {}
// Method: Est_comparePriceToCost () -> 
// ----------------------------------------------------
// by: mel: 06/22/05, 10:50:40
// ----------------------------------------------------

C_TEXT:C284($1; $2)
C_TEXT:C284($t; $r)
C_TEXT:C284(RFT_CLEAR1; RFT_CLEAR2)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$t:=Char:C90(9)
$r:=Char:C90(13)

Case of 
	: (Count parameters:C259=0)
		RFT_CLEAR1:="Comparison of Cost/M to LastPrice/M"
		RFT_CLEAR2:="ESTIMATE"+$t+"CUST_ID"+$t+"PRODUCT_CODE"+$t+"COST_WANT"+$t+"LAST_PRICE"+$r
		
	: (Count parameters:C259=1)
		gEstimateLDWkSh("All")
		
		$break:=False:C215
		$numRecs:=Records in selection:C76([Estimates_Carton_Specs:19])
		
		uThermoInit($numRecs; "Getting Last Price for cartons on "+[Estimates:17]EstimateNo:1)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				If (Length:C16(RFT_CLEAR2)>32000)
					BEEP:C151
					ALERT:C41("Pricing Comparison document has been truncated.")
				Else 
					RFT_CLEAR2:=RFT_CLEAR2+[Estimates:17]EstimateNo:1+$t+[Estimates_Carton_Specs:19]CustID:6+$t+[Estimates_Carton_Specs:19]ProductCode:5+$t+String:C10([Estimates_Carton_Specs:19]CostWant_Per_M:25)+$t+String:C10(FG_getLastPrice([Estimates_Carton_Specs:19]CustID:6+":"+[Estimates_Carton_Specs:19]ProductCode:5))+$r
				End if 
				NEXT RECORD:C51([Estimates_Carton_Specs:19])
				uThermoUpdate($i)
			End for 
			
			
		Else 
			
			ARRAY TEXT:C222($_CustID; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY REAL:C219($_CostWant_Per_M; 0)
			
			SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]CustID:6; $_CustID; [Estimates_Carton_Specs:19]ProductCode:5; $_ProductCode; [Estimates_Carton_Specs:19]CostWant_Per_M:25; $_CostWant_Per_M)
			
			For ($i; 1; $numRecs)
				
				If (Length:C16(RFT_CLEAR2)>32000)
					BEEP:C151
					ALERT:C41("Pricing Comparison document has been truncated.")
				Else 
					
					RFT_CLEAR2:=RFT_CLEAR2+[Estimates:17]EstimateNo:1+$t+$_CustID{$i}+$t+$_ProductCode{$i}+$t+String:C10($_CostWant_Per_M{$i})+$t+String:C10(FG_getLastPrice($_CustID{$i}+":"+$_ProductCode{$i}))+$r
					
				End if 
				
				uThermoUpdate($i)
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 First record
		
		uThermoClose
		
	Else 
		docName:="PRICING_BATCH"
		$docRef:=util_putFileName(->docName)
		SEND PACKET:C103($docRef; RFT_CLEAR1+$r+$r)
		SEND PACKET:C103($docRef; RFT_CLEAR2)
		RFT_CLEAR1:=""
		RFT_CLEAR2:=""
		CLOSE DOCUMENT:C267($docRef)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
End case 