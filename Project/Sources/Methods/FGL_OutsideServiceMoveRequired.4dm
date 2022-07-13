//%attributes = {}
// ----------------------------------------------------
// Method: FGL_OutsideServiceMoveRequired   ( ) ->
// By: Mel Bohince @ 09/25/15, 11:09:07
// Description
// used by new sscc to setup for a inventory move when making the labels
// Modified by: Mel Bohince (1/13/16) was FG:OS@, but now they also use CC:OS@

C_TEXT:C284($1)  //jobit
C_LONGINT:C283($0; $qtyOS)
$0:=0
$qtyOS:=0
If (Length:C16($1)=11)  //appear to be a reasonable jobit
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$1; *)
	// Modified by: Mel Bohince (1/13/16) was FG:OS@, but now they also use CC:OS@
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="@:OS@")
	$numBins:=Records in selection:C76([Finished_Goods_Locations:35])
	If ($numBins>0)
		$0:=$numBins
		sArkayUCCid:="0030808292"
		wms_bin_id:="BNVFG_OUTSIDE_SERVICE"
		rb4:=1
		rb1:=0
		rb2:=0
		sCriterion4:="1"  //num skids
		cbSuperCase:=1
		cbReceiveAMS:=0
		cbMoveOS:=1
		fromLocation:=[Finished_Goods_Locations:35]Location:2
		sCriter10:=[Finished_Goods_Locations:35]skid_number:43
		//try to calc number of skids
		$qtyOS:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
		$skidCnt:=Num:C11(sCriterion2)
		If ($skidCnt>=$qtyOS) | ($skidCnt=0)  //less than a skid or std not set
			sCriterion2:=String:C10($qtyOS)  //1 skid with all the qty
			
		Else 
			If ($skidCnt>0)
				sCriterion4:=String:C10($qtyOS/$skidCnt; "####")  //number of full skids
			End if 
		End if 
		
	End if   //@ o/s vendor
	
End if 