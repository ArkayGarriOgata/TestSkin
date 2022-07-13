//%attributes = {"publishedWeb":true}
//(p) qryRMgroup(comkey;!00/00/00!)
//`3/22/95 make descending
//5/8/95 add rtn value
//•053095  MLB  UPR 1501 add parameters

C_LONGINT:C283($0)  //rtn for uniformity
C_TEXT:C284($1; $comKey)
C_DATE:C307($2; $effective)

If (Count parameters:C259=2)
	$comKey:=$1
	$effective:=$2
Else 
	$comKey:=[Estimates_Materials:29]Commodity_Key:6
	$effective:=[Estimates_Materials:29]UseStdDated:28
End if 

If ($effective#!00-00-00!)  //•
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$comKey; *)
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]EffectivityDate:15=$effective)
Else 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$comKey)
		ORDER BY:C49([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]EffectivityDate:15; <)  //3/22/95 make descending
		FIRST RECORD:C50([Raw_Materials_Groups:22])
		ONE RECORD SELECT:C189([Raw_Materials_Groups:22])
		
	Else 
		
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$comKey)
		ORDER BY:C49([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]EffectivityDate:15; <)  //3/22/95 make descending
		ONE RECORD SELECT:C189([Raw_Materials_Groups:22])
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
End if 

$0:=Records in selection:C76([Raw_Materials_Groups:22])