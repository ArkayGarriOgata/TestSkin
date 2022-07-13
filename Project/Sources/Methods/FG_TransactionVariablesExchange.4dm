//%attributes = {}
// -------
// Method: FG_TransactionVariablesExchange   ( ) ->
// By: Mel Bohince @ 12/01/18, 08:15:43
// Description
// store and restore the variables used in the ui dialog that subseqent calls use globally
// see wms_api_load_transaction_variab
// ----------------------------------------------------

C_OBJECT:C1216(objFGX_attributes)

Case of 
	: ($1="save")
		objFGX_attributes:=New object:C1471
		
		objFGX_attributes.cpn:=sCriterion1
		objFGX_attributes.custid:=sCriterion2
		objFGX_attributes.from:=sCriterion3
		objFGX_attributes.to:=sCriterion4
		objFGX_attributes.jobform:=sCriterion5
		objFGX_attributes.orderline:=sCriterion6
		objFGX_attributes.reasonComment:=sCriterion7
		objFGX_attributes.action:=sCriterion8
		objFGX_attributes.reasonCode:=sCriterion9
		objFGX_attributes.skidNumber:=sCriter10
		objFGX_attributes.user:=sCriter11
		objFGX_attributes.release:=sCriter12
		objFGX_attributes.qty:=rReal1
		objFGX_attributes.itemNumber:=i1
		
	: ($1="restore")
		sCriterion1:=objFGX_attributes.cpn
		sCriterion2:=objFGX_attributes.custid
		sCriterion3:=objFGX_attributes.from
		sCriterion4:=objFGX_attributes.to
		sCriterion5:=objFGX_attributes.jobform
		sCriterion6:=objFGX_attributes.orderline
		sCriterion7:=objFGX_attributes.reasonComment
		sCriterion8:=objFGX_attributes.action
		sCriterion9:=objFGX_attributes.reasonCode
		sCriter10:=objFGX_attributes.skidNumber
		sCriter11:=objFGX_attributes.user
		sCriter12:=objFGX_attributes.release
		rReal1:=objFGX_attributes.qty
		i1:=objFGX_attributes.itemNumber
		
	: ($1="clear")
		sCriterion1:=""  //        cpn
		sCriterion2:=""  //custid
		rReal1:=0  //             qty
		sCriterion3:=""  //from
		sCriterion4:=""  //to
		sCriterion5:=""  //jobform
		i1:=0  //                job item
		sCriterion6:=""  //orderline
		sCriterion7:=""  //reason comment
		sCriterion8:=""  //action taken
		sCriterion9:=""  //reason
		sCriter10:=""  //   skid ticket
		sCriter11:=""  //user
		sCriter12:=""  //release
		
	: ($1="remove")
		OB REMOVE:C1226(objFGX_attributes; "cpn")
		OB REMOVE:C1226(objFGX_attributes; "custid")
		OB REMOVE:C1226(objFGX_attributes; "from")
		OB REMOVE:C1226(objFGX_attributes; "to")
		OB REMOVE:C1226(objFGX_attributes; "jobform")
		OB REMOVE:C1226(objFGX_attributes; "orderline")
		OB REMOVE:C1226(objFGX_attributes; "reasonComment")
		OB REMOVE:C1226(objFGX_attributes; "action")
		OB REMOVE:C1226(objFGX_attributes; "reasonCode")
		OB REMOVE:C1226(objFGX_attributes; "skidNumber")
		OB REMOVE:C1226(objFGX_attributes; "user")
		OB REMOVE:C1226(objFGX_attributes; "release")
		OB REMOVE:C1226(objFGX_attributes; "qty")
		OB REMOVE:C1226(objFGX_attributes; "itemNumber")
End case 
