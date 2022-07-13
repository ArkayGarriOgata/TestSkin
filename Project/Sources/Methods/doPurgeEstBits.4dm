//%attributes = {"publishedWeb":true}
//(p) doPurgeEstBits called by doPurgeEstimate
//$1 - string (optional) - anything flag do archive/deletions now
//• 12/18/97 cs created
//•061499  mlb  

C_TEXT:C284($1)  //add current selection to set unles p

If (Count parameters:C259=0)  //if no parameters just add current selections to set
	doPurgeEstCmpnt(->[Estimates_Carton_Specs:19])
	doPurgeEstCmpnt(->[Estimates_Differentials:38])
	doPurgeEstCmpnt(->[Estimates_DifferentialsForms:47])
	doPurgeEstCmpnt(->[Estimates_Materials:29])
	doPurgeEstCmpnt(->[Estimates_Machines:20])
	doPurgeEstCmpnt(->[Estimates_FormCartons:48])
	doPurgeEstCmpnt(->[Estimates_PSpecs:57])
	doPurgeEstCmpnt(->[Work_Orders:37])
	
Else   //do achive/deletions
	doPurgeEstCmpnt(->[Estimates_Carton_Specs:19]; $1)
	doPurgeEstCmpnt(->[Estimates_Differentials:38]; $1)
	doPurgeEstCmpnt(->[Estimates_DifferentialsForms:47]; $1)
	doPurgeEstCmpnt(->[Estimates_Materials:29]; $1)
	doPurgeEstCmpnt(->[Estimates_Machines:20]; $1)
	doPurgeEstCmpnt(->[Estimates_FormCartons:48]; $1)
	doPurgeEstCmpnt(->[Estimates_PSpecs:57]; $1)
	doPurgeEstCmpnt(->[Work_Orders:37]; $1)
	doPurgeEstCmpnt(->[Estimates:17]; $1)
End if 