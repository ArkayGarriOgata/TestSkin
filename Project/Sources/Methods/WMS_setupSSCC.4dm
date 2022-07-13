//%attributes = {}

// ----------------------------------------------------
// Method: WMS_setupSSCC   ( ) ->
// By: Mel Bohince @ 09/25/15, 11:24:51
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($0; $numJMI; $numBins)

$numJMI:=qryJMI(sCriterion1)
$0:=$numJMI
If ($numJMI=0)
	uConfirm("ERROR: "+sCriterion1+" is not a job item."; "Try Again"; "Help")
	zwStatusMsg("ERROR"; sCriterion1+" is not a job item, try again or cancel.")
	sCriterion1:=""
	GOTO OBJECT:C206(sCriterion1)
	tText:=""
	sCustName:=""
	sLine:=""
	sCPN:=""
	sDesc:=""
	wms_glued:=!00-00-00!
	wms_bin_id:=""
	
Else 
	//tText:="Product Code: "+[Job_Forms_Items]ProductCode+Char(13)
	sCPN:=[Job_Forms_Items:44]ProductCode:3
	wms_glued:=[Job_Forms_Items:44]Glued:33
	RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	sCustName:=[Jobs:15]CustomerName:5
	sLine:=[Jobs:15]Line:3
	//tText:=tText+sCustName+Char(13)+sLine+Char(13)
	If (Position:C15("Proct"; sCustName)>0)
		sArkayUCCid:="0010808292"  //sscc app code+containerType+UCCregistration#
		rb1:=1
	Else 
		sArkayUCCid:="0020808292"  //sscc app code+containerType+UCCregistration#
		rb2:=1
	End if 
	wms_bin_id:="BNRCC"
	
	READ ONLY:C145([Finished_Goods:26])
	$numJMI:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
	If ($numJMI>0)
		//tText:=tText+[Finished_Goods]CartonDesc
		sDesc:=[Finished_Goods:26]CartonDesc:3
		READ ONLY:C145([Finished_Goods_PackingSpecs:91])
		QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
		If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
			sCriterion2:=String:C10([Finished_Goods_PackingSpecs:91]UnitsPerSkid:30)
			REDUCE SELECTION:C351([Finished_Goods_PackingSpecs:91]; 0)
		End if 
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	End if 
	
	// Modified by: Mel Bohince (9/8/15) set up for a move transaction if that jobit is at a vendor
	$numBins:=FGL_OutsideServiceMoveRequired(sCriterion1)
	
	
End if 
