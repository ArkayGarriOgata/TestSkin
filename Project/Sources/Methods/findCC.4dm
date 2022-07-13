//%attributes = {"publishedWeb":true}
//(P) findCC($1;$2)
//  $1 = Cost Center to Lookup
//  $2 = effectivity date
//050196 TJF

C_TEXT:C284($1; $CC)
C_DATE:C307($2; $effective)

$CC:=$1
zzDESC:=""
zzOOP:=0

MESSAGES OFF:C175

If (Count parameters:C259=1)
	$effective:=!00-00-00!
Else 
	$effective:=$2
End if 
If ($effective#!00-00-00!)
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$CC; *)
	QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]EffectivityDate:13<=$effective)
Else 
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$CC)
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
	FIRST RECORD:C50([Cost_Centers:27])
	
Else 
	
	ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

zzDESC:=[Cost_Centers:27]Description:3
//[MachineTicket]CostCenterID:=Substring($CC;1;3)
zzOOP:=[Cost_Centers:27]MHRoopSales:7
