//%attributes = {}
//Method:  Quik_List_QueryB(tQuick_Key)=>bRecordsFound
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tQuick_Key)
	C_BOOLEAN:C305($0; $bRecordsFound)
	
	C_TEXT:C284($tPathname; $tQuery)
	C_POINTER:C301($pTable)
	C_OBJECT:C1216($oAsk)
	
	$tQuick_Key:=$1
	
	$bRecordsFound:=False:C215
	
	$tPathname:=System folder:C487(Desktop:K41:16)
	
	$oAsk:=New object:C1471()
	$oAsk.tMessage:="When the query comes up, load the "
	
End if   //Done Initialize

Case of 
		
	: (Not:C34(Core_Query_UniqueRecordB(->[Quick:85]Quick_Key:1; ->$tQuick_Key)))  //Unique
		
	: ([Quick:85]ShowQuery:5)
		
		$tQuery:=[Quick:85]Name:2+CorektPeriod+Corekt4DExtnQuery
		$tPathname:=$tPathname+$tQuery
		
		BLOB TO DOCUMENT:C526($tPathname; [Quick:85]Query:8)
		
		$oAsk.tMessage:=$oAsk.tMessage+$tQuery+" file on your desktop."
		Core_Dialog_Alert($oAsk)
		
		$pTable:=Table:C252([Quick:85]ParentTable:6)
		QUERY:C277($pTable->)
		
	Else 
		
		$pTable:=Table:C252([Quick:85]ParentTable:6)
		Quik_Query_Execute(->[Quick:85]Query:8)
		
End case   //Done unique

If ([Quick:85]QueryMethod:9#CorektBlank)
	
	EXECUTE METHOD:C1007([Quick:85]QueryMethod:9)
	
End if 

$bRecordsFound:=(Records in selection:C76($pTable->)>0)

If (Not:C34($bRecordsFound))
	
	$oAsk.tMessage:="The report "+[Quick:85]Name:2+" did not find any records."
	Core_Dialog_Alert($oAsk)
	
End if 

$0:=$bRecordsFound