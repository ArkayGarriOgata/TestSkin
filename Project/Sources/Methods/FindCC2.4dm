//%attributes = {"publishedWeb":true}
//(P) findCC2
//looks up current cost center in set of effective standards
//  $1 = Cost Center to Lookup
//based on FindCC
//• 8/6/98 cs created

C_TEXT:C284($1; $CC)

USE SET:C118("Effective")  //set is created in rNewCloseout, set of current CCs
$CC:=$1
zzDESC:=""
zzOOP:=0
MESSAGES OFF:C175
QUERY SELECTION:C341([Cost_Centers:27]; [Cost_Centers:27]ID:1=$CC)
zzDESC:=[Cost_Centers:27]Description:3
zzOOP:=[Cost_Centers:27]MHRoopSales:7
MESSAGES ON:C181