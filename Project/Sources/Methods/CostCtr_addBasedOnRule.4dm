//%attributes = {}
// Method: CostCtr_addBasedOnRule ("403") -> 
// ----------------------------------------------------
// by: mel: 06/21/05, 16:42:40
// ----------------------------------------------------
// Description:
// add a cc 
// ----------------------------------------------------

C_LONGINT:C283($numPlates)
C_TEXT:C284($1)

Case of 
	: ($1="403")
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$1)
		If (Records in selection:C76([Cost_Centers:27])>0)
			SELECTION TO ARRAY:C260([Estimates_Machines:20]CostCtrID:4; $aCC)
			$hit:=Find in array:C230($aCC; $1)
			If ($hit=-1)  //only add it once
				//est # plates by counting inks & coatings
				$numPlates:=0  // Modified by: Mel Bohince (6/9/21) 
				SET QUERY DESTINATION:C396(Into variable:K19:4; $numPlates)
				QUERY SELECTION:C341([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="02@"; *)
				QUERY SELECTION:C341([Estimates_Materials:29];  | ; [Estimates_Materials:29]Commodity_Key:6="03@")
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				If ($numPlates>0)
					CREATE RECORD:C68([Estimates_Machines:20])
					[Estimates_Machines:20]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
					[Estimates_Machines:20]Sequence:5:=1
					[Estimates_Machines:20]CostCtrID:4:=$1
					[Estimates_Machines:20]CostCtrName:2:=[Cost_Centers:27]Description:3
					[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
					[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
					[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //[COST_CENTER]OOPMachRate`•071296  MLB 
					[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
					//[Machine_Est]TempSeq:=aiSeq{$X}
					[Estimates_Machines:20]SequenceID:3:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Estimates_Machines]))
					[Estimates_Machines:20]CalcScrapFlg:11:=[Cost_Centers:27]AddScrapExcess:25
					[Estimates_Machines:20]zCount:34:=1
					[Estimates_Machines:20]ModDate:35:=4D_Current_date
					[Estimates_Machines:20]ModWho:36:="TEST"
					[Estimates_Machines:20]Flex_field1:18:=$numPlates
					SAVE RECORD:C53([Estimates_Machines:20])
				End if 
				
				RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)  //reselect
			End if 
		End if   //found the cc
End case 