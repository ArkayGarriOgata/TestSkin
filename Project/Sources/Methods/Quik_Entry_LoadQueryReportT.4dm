//%attributes = {}
//Method:  Quik_Entry_LoadQueryReportT(pnParentTable;plQuery;plQuickReport)=>tReportName
//Description:  This method will bring up a request to open either a quick report or query
//.    It will fill in the nParentTable of the query, load the query blob, load the QuickReport blob
//.      and returns the name of the report.

If (True:C214)  //Initialize
	
	C_TEXT:C284($0; $tReportName)
	C_POINTER:C301($1; $pnParentTable)
	C_POINTER:C301($2; $plQuery)
	C_POINTER:C301($3; $plQuickReport)
	
	C_BOOLEAN:C305($bReadLine)
	C_BOOLEAN:C305($bNew; $bCanceled)
	
	C_TEXT:C284($tPathToQuery)
	C_TEXT:C284($tPathToQuickReport)
	C_TEXT:C284($tExtension)
	C_TEXT:C284($tPathname; $tQueryLine)
	C_TEXT:C284($tQueryLineTerminator)
	
	C_TIME:C306($hDocument; $hQueryDocument)
	
	C_OBJECT:C1216($oAsk)
	
	$pnParentTable:=$1
	$plQuery:=$2
	$plQuickReport:=$3
	
	$tExtension:=CorektBlank
	$tReportName:=CorektBlank
	$tPathname:=CorektBlank
	$tPathToQuery:=CorektBlank
	$tPathToQuickReport:=CorektBlank
	
	$oAsk:=New object:C1471()
	$bReadLine:=True:C214
	$bCanceled:=False:C215
	$tQueryLineTerminator:=Char:C90(Line feed:K15:40)
	$bNew:=(BLOB size:C605(Quik_lEntry_Query)=0)
	
End if   //Done Initialize

$hDocument:=Open document:C264($tPathname; Corekt4DExtnQuery+CorektSemiColon+Corekt4DExtnQuickReport; Read mode:K24:5)

If (OK=1)  //Document
	
	$tExtension:=Core_Document_GetExtensionT
	$tReportName:=Core_Document_GetNameT
	
Else   //Canceled
	
	$bCanceled:=True:C214
	
End if   //Done document

Case of   //Pathnames
		
	: ($bCanceled)
		
	: ($tExtension=Corekt4DExtnQuery)  //Opened query
		
		$tPathToQuery:=Document
		$tPathToQuickReport:=Replace string:C233(Document; Corekt4DExtnQuery; Corekt4DExtnQuickReport)
		
	: ($tExtension=Corekt4DExtnQuickReport)  //Opened quickreport
		
		$tPathToQuery:=Replace string:C233(Document; Corekt4DExtnQuickReport; Corekt4DExtnQuery)
		$tPathToQuickReport:=Document
		
End case   //Done pathnames

Case of   //Blobs
		
	: ($bCanceled)
	: ($bNew & ($tPathToQuery=CorektBlank))
		
		$oAsk.tMessage:="The query:  "+$tReportName+Corekt4DExtnQuery+" does not exist. Please make sure to create one."
		Core_Dialog_Alert($oAsk)
		
	: ($bNew & ($tPathToQuickReport=CorektBlank))
		
		$oAsk.tMessage:="The quick report:  "+$tReportName+Corekt4DExtnQuickReport+" does not exist. Please make sure to create one."
		Core_Dialog_Alert($oAsk)
		
		
	Else   //Assign blobs
		
		If (($tPathToQuery#CorektBlank) & (Test path name:C476($tPathToQuery)=Is a document:K24:1))  //Query blob
			
			$hQueryDocument:=Open document:C264($tPathToQuery; Corekt4DExtnQuery; Read mode:K24:5)
			
			While ($bReadLine)  //Find parent table
				
				RECEIVE PACKET:C104($hQueryDocument; $tQueryLine; $tQueryLineTerminator)
				
				If (Position:C15("mainTable"; $tQueryLine)>0)  //ParentTable
					
					$pnParentTable->:=Num:C11($tQueryLine)  //Get parent table number
					$bReadLine:=False:C215  //Terminate
					
				Else   //No
					
					$bReadLine:=(OK=1)
					
				End if   //Done  parent table
				
			End while   //Done find parent table
			
			CLOSE DOCUMENT:C267($hQueryDocument)
			
			DOCUMENT TO BLOB:C525($tPathToQuery; $plQuery->)
			
		End if   //Done query blob
		
		If (($tPathToQuickReport#CorektBlank) & (Test path name:C476($tPathToQuickReport)=Is a document:K24:1))  //Quick report blob
			
			DOCUMENT TO BLOB:C525($tPathToQuickReport; $plQuickReport->)
			
		End if   //Done quick report blob
		
End case   //Done blobs

$0:=$tReportName
