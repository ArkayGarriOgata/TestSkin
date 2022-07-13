//%attributes = {"publishedWeb":true}
//uDefaultMatlCre(commKey,cc,Sequence)` mlb 072396
//called exclusively by uDefaultMatls
C_TEXT:C284($commKey; $1)
$commKey:=$1
C_TEXT:C284($cc; $2)
$cc:=$2
C_LONGINT:C283($seq; $3)
$seq:=$3
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$commKey)
	FIRST RECORD:C50([Raw_Materials_Groups:22])
	
Else 
	
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$commKey)
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

If (Records in selection:C76([Raw_Materials_Groups:22])>=1)
	CREATE RECORD:C68([Process_Specs_Materials:56])
	[Process_Specs_Materials:56]ProcessSpec:1:=[Process_Specs:18]ID:1
	[Process_Specs_Materials:56]CustID:2:=[Process_Specs:18]Cust_ID:4
	
	[Process_Specs_Materials:56]CostCtrID:3:=$cc
	[Process_Specs_Materials:56]RMName:6:=[Raw_Materials_Groups:22]Description:2
	[Process_Specs_Materials:56]Comments:7:="Effectivity:"+String:C10([Raw_Materials_Groups:22]EffectivityDate:15; 1)
	[Process_Specs_Materials:56]Commodity_Key:8:=[Raw_Materials_Groups:22]Commodity_Key:3
	[Process_Specs_Materials:56]UOM:9:=[Raw_Materials_Groups:22]UOM:8
	//   [material_pspec]Qty :=1
	[Process_Specs_Materials:56]ModWho:10:=<>zResp
	[Process_Specs_Materials:56]ModDate:11:=4D_Current_date
	[Process_Specs_Materials:56]zCount:12:=1
	[Process_Specs_Materials:56]TempSeq:5:=$seq
	[Process_Specs_Materials:56]Sequence:4:=$seq
	SAVE RECORD:C53([Process_Specs_Materials:56])
Else 
	BEEP:C151
	ALERT:C41("Couldn't find a commdity key = "+$commKey)
End if   //found a rm group        
//