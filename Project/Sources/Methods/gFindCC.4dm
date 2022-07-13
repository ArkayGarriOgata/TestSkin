//%attributes = {"publishedWeb":true}
//(P) gFindCC
//  $1 = Cost Center to Lookup
//1/10/95
// Modified by: Mel Bohince (6/9/21) use Storage

C_LONGINT:C283($i)
C_TEXT:C284($1; $CC; zzDESC)
C_REAL:C285(zzOOP; $cc_found)

$CC:=$1  //done for search
zzDESC:=""
zzOOP:=0

If (Length:C16($CC)>=3)
	If (True:C214)  // Modified by: Mel Bohince (6/9/21) use Storage
		$cc_found:=CostCtrCurrent("desc"; $CC; ->zzDESC)
		zzOOP:=CostCtrCurrent("oop"; $CC)
		
	Else   // old way
		
		MESSAGES OFF:C175
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$CC)
		If (Records in selection:C76([Cost_Centers:27])>=1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
				FIRST RECORD:C50([Cost_Centers:27])
				
			Else 
				
				ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
			// zzDESC:=Substring([COST_CENTER]Description;7)  `1/10/95
			zzDESC:=[Cost_Centers:27]Description:3
			[Job_Forms_Machine_Tickets:61]CostCenterID:2:=Substring:C12($CC; 1; 3)
			zzOOP:=[Cost_Centers:27]MHRoopSales:7
		End if 
	End if   //new way
	
Else 
	zzDESC:="C/C Not Specified to gFindCC"
	zzOOP:=0
End if 
