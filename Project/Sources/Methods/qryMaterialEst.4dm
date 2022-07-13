//%attributes = {"publishedWeb":true}
//Procedure: qryMaterialEst()  052395  MLB
//•060796  MLB 

C_TEXT:C284($1; $estimate)
C_TEXT:C284($2; $CommKey)
C_TEXT:C284($3; $type)
C_TEXT:C284($7)  //$uom
C_LONGINT:C283($4; $sequence; $0)
C_BOOLEAN:C305($create)
C_REAL:C285($5; $6)  //cost and qty•060796  MLB 

$estimate:=$1
$CommKey:=$2
$type:=$3
$sequence:=$4

$create:=("@"#Substring:C12($CommKey; 1; 1))  //don't make a new record if wild card is passed for commodity
If (Not:C34($create))
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]EstimateNo:5=$estimate; *)
		QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]Commodity_Key:6=$CommKey; *)
		QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]EstimateType:7=$type)
		If (Count parameters:C259=4)
			QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12=$sequence)
		End if 
		
	Else 
		If (Count parameters:C259=4)
			QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12=$sequence; *)
		End if 
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]EstimateNo:5=$estimate; *)
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6=$CommKey; *)
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]EstimateType:7=$type)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
Else 
	USE SET:C118("PrepMatl")
	
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6=$CommKey; *)
	QUERY SELECTION:C341([Estimates_Materials:29];  & ; [Estimates_Materials:29]Sequence:12=$sequence)
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
End if 

If (Records in selection:C76([Estimates_Materials:29])=0)
	If (($sequence>0) & ($create))
		CREATE RECORD:C68([Estimates_Materials:29])
		[Estimates_Materials:29]DiffFormID:1:=$estimate
		If ("@"=Substring:C12($CommKey; Length:C16($CommKey); 1))
			[Estimates_Materials:29]Commodity_Key:6:=Substring:C12($CommKey; 1; (Length:C16($CommKey)-1))
		Else 
			[Estimates_Materials:29]Commodity_Key:6:=$CommKey
		End if 
		
		[Estimates_Materials:29]EstimateNo:5:=$estimate
		[Estimates_Materials:29]EstimateType:7:=$type
		[Estimates_Materials:29]Sequence:12:=$sequence
		If (Count parameters:C259>=5)
			[Estimates_Materials:29]Cost:11:=$5
		End if 
		If (Count parameters:C259>=6)
			[Estimates_Materials:29]Qty:9:=$6
		End if 
		If (Count parameters:C259>=7)
			[Estimates_Materials:29]UOM:8:=$7
		End if 
		
		SAVE RECORD:C53([Estimates_Materials:29])
		ADD TO SET:C119([Estimates_Materials:29]; "PrepMatl")
	End if 
End if 

$0:=Records in selection:C76([Estimates_Materials:29])