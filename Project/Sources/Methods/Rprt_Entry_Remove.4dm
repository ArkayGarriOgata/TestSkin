//%attributes = {}
//Method:  Rprt_Entry_Remove
//Description:  This method will remove a [Rprt_Criterion] record from the list box
//.   Note:  Rprt_CriterionList_cSelected is set in the Property List:Data Source:Selected Items

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esRprt_Criterion; $esNotDropped)
	C_OBJECT:C1216($oCriterion)
	
	C_OBJECT:C1216($oConfirm)
	
	$esRprt_Criterion:=New object:C1471()
	$esNotDropped:=New object:C1471()
	
	$oCriterion:=New object:C1471()
	
	$oConfirm:=New object:C1471()
	
	$oConfirm.tMessage:="Are you sure you want to remove"+CorektSpace+\
		String:C10(Rprt_CriterionList_cSelected.length)+CorektSpace+\
		Core_PluralizeT("criterion"; Rprt_CriterionList_cSelected.length; "criteria")+"?"
	
	$oConfirm.tDefault:="No"
	$oConfirm.tCancel:="Remove"
	
End if   //Done initialize

If (Core_Dialog_ConfirmN($oConfirm)=CoreknCancel)  //Delete
	
	For each ($oCriterion; Rprt_CriterionList_cSelected)  //Selected
		
		$esRprt_Criterion:=ds:C1482.Rprt_Criterion.query("Rprt_Criterion_Key = :1"; $oCriterion.Rprt_Criterion_Key)
		
		If (Not:C34(OB Is empty:C1297($esRprt_Criterion)))  //Remove
			
			$esNotDropped:=$esRprt_Criterion.drop()
			
		End if   //Done remove
		
	End for each   //Done selected
	
End if   //Done delete

Form:C1466.esRprt_CriterionList:=ds:C1482.Rprt_Criterion.query("Report_Key = :1"; Form:C1466.tReport_Key)
