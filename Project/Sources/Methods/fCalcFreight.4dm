//%attributes = {"publishedWeb":true}
//fCalcFreight
//3/23/95 add weight parameter
//• 4/9/98 cs nan checking/removal

C_LONGINT:C283($1; $freightRec)
C_LONGINT:C283($weight; $2)
C_TEXT:C284($Caseid)

$freightRec:=$1
$weight:=$2

GOTO RECORD:C242([Estimates_Materials:29]; $freightRec)
If ([Estimates:17]z_FreightKey:33="")  //this has individual differential freight
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CREATE SET:C116([Estimates_Differentials:38]; "hold")
		$CaseID:=Substring:C12([Estimates_Materials:29]DiffFormID:1; 1; 11)
		If ([Estimates_Differentials:38]Id:1#$CaseId)
			QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$CaseId)
		End if 
		//[Estimates_Materials]Cost:=nrFreight ("";$weight;[Estimates_Differentials]_FreightKey)  `update cost
		USE SET:C118("hold")
		CLEAR SET:C117("Hold")
		
	Else 
		//You don't use line 22
		
		
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	//[Estimates_Materials]Cost:=uNANCheck (nrFreight("";$weight;[Estimates]_FreightKey))  `update cost
End if 
[Estimates_Materials:29]Cost:11:=Round:C94([Estimates_Materials:29]Cost:11; 0)
[Estimates_Materials:29]Qty:9:=1
[Estimates_Materials:29]Comments:13:="See Freight Table for standards."
SAVE RECORD:C53([Estimates_Materials:29])
If ([Estimates_Materials:29]Cost:11=0)
	BEEP:C151
	BEEP:C151
	MESSAGE:C88(<>sCr+"THE MATERIAL ESTIMATE "+[Estimates_Materials:29]Commodity_Key:6+" HAS NO COST DATA!!!"+<>sCr)
End if 