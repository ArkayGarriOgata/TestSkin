//%attributes = {"publishedWeb":true}
//qryCostCenter(c/c;date)                           3/15/95
//•052295  MLB  UPR 1505
//•121096  mBohince  allow inbetween dates
//•082997  MLB  don't turn Messages back on

C_TEXT:C284($1)  //[Machine_Est]CostCtrID
C_DATE:C307($2; $effective)  //[Machine_Est]UseStdDated
C_LONGINT:C283($0)  //rtn number of records

MESSAGES OFF:C175

Case of 
	: (Position:C15($1; <>EMBOSSERS)>0)
		$cc:="4"+Substring:C12($1; 2)
		
	Else 
		$cc:=$1
End case 

If (Count parameters:C259=1)  //•052295  MLB  UPR 1505
	$effective:=!00-00-00!
Else 
	$effective:=$2
End if 
If ($effective#!00-00-00!)
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$cc; *)
	QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]EffectivityDate:13<=$effective)  //•121096  mBohince  
	$0:=Records in selection:C76([Cost_Centers:27])
	Case of 
		: ($0=0)
			If (Not:C34(Application type:C494=4D Server:K5:6))
				BEEP:C151
				BEEP:C151
				zwStatusMsg("ERROR"; "Could not find cost center "+$cc+" dated "+String:C10($effective; 1))
				DELAY PROCESS:C323(Current process:C322; 3*60)
			Else 
				utl_Logfile("rollup.log"; "ERROR: Could not find cost center "+$cc+" dated "+String:C10($effective; 1)+" on "+[Job_Forms:42]JobFormID:5)
			End if 
			
		: (Records in selection:C76([Cost_Centers:27])>1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
				FIRST RECORD:C50([Cost_Centers:27])
				
			Else 
				
				ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
	End case 
Else 
	//SEARCH([COST_CENTER]; & [COST_CENTER]ProdCC=True)    
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$cc)
	$0:=Records in selection:C76([Cost_Centers:27])
	If ($0=0)
		If (Not:C34(Application type:C494=4D Server:K5:6))
			//BEEP
			//ALERT("Could not find cost center "+$cc+" flagged for production use.")
		Else 
			utl_Logfile("rollup.log"; "ERROR: Could not find cost center= "+$cc+" dated "+String:C10($effective; 1)+" on "+[Job_Forms:42]JobFormID:5)
		End if 
	Else 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
			FIRST RECORD:C50([Cost_Centers:27])
			
			
		Else 
			
			ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
	End if 
End if 