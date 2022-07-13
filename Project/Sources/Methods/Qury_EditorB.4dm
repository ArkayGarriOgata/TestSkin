//%attributes = {}
//Method:  Qury_EditorB(oQuery;lQuery)=>bRecordsFound
//Description:  This method will bring up the query editor if needed

If (True:C214)  //Initialize 
	
	C_OBJECT:C1216($1; $oQuery)
	C_BLOB:C604($2; $lQuery)
	C_BOOLEAN:C305($0; $bRecordsFound)
	
	C_TEXT:C284($tPathname; $tQuery)
	C_POINTER:C301($pTable)
	C_OBJECT:C1216($oAsk)
	
	$oQuery:=New object:C1471()
	
	$oQuery:=$1
	$lQuery:=$2
	
	$bRecordsFound:=False:C215
	
	$tPathname:=System folder:C487(Desktop:K41:16)
	
	$oAsk:=New object:C1471()
	$oAsk.tMessage:="When the query comes up, load the "
	
End if   //Done Initialize

Case of   //Unique
		
	: ($oQuery.bShowQuery)
		
		$tQuery:=$oQuery.tName+CorektPeriod+Corekt4DExtnQuery
		$tPathname:=$tPathname+$tQuery
		
		BLOB TO DOCUMENT:C526($tPathname; $lQuery)
		
		$oAsk.tMessage:=$oAsk.tMessage+$tQuery+" file on your desktop."
		Core_Dialog_Alert($oAsk)
		
		$pTable:=Table:C252($oQuery.nParentTable)
		QUERY:C277($pTable->)
		
	Else 
		
		$pTable:=Table:C252($oQuery.nParentTable)
		Quik_Query_Execute(->[Quick:85]Query:8)
		
End case   //Done unique

$bRecordsFound:=(Records in selection:C76($pTable->)>0)

If (Not:C34($bRecordsFound))
	
	$oAsk.tMessage:="The report "+$oQuery.tName+" did not find any records."
	Core_Dialog_Alert($oAsk)
	
End if 

$0:=$bRecordsFound