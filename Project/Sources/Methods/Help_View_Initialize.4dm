//%attributes = {}
//Method:  Help_View_Initialize(tStatus{;pOption1})
//Description:  This method will inititlaize the values for the
//  Help_View form.
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_BOOLEAN:C305($bExpanded)
	
	C_COLLECTION:C1488($cKeyword)
	
	C_OBJECT:C1216($eHelp; $esHelp; $oArchive; $oZipFolder; $oZipFile)
	
	C_LONGINT:C283($nItemReference; $nSubListReference)
	
	C_POINTER:C301($patHlistKey)
	
	C_TEXT:C284($tHelp_Key; $tItem; $tKeyword; $tPathName; $tQuery; $tTableName)
	
	$tPhase:=$1
	
	$tTableName:=Table name:C256(->[Help:36])
	
	$tQuery:=CorektBlank
	
End if   //Done initialize

Case of   // Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		GET LIST ITEM:C378(CorenHList1; *; $nItemReference; $tItem; $nSubListReference; $bExpanded)
		
		$patHListKey:=Get pointer:C304("CoreatHListKey1")
		
		$tHelp_Key:=$patHListKey->{$nItemReference}
		
		$tQuery:="Help_Key = "+$tHelp_Key
		
		$esHelp:=ds:C1482[$tTableName].query($tQuery)
		
		If ($esHelp.length=1)  //Unique
			
			$eHelp:=$esHelp.first()
			
			$oLocation:=Help_Fetch_Files($eHelp.PathName)
			
			//$oArchive:=ZIP Read archive($oLocation)
			
			//$oZipFolder:=$oArchive.root()
			
			//$oZipFile:=$oZipFolder.files()[0]  //
			
			WA OPEN URL:C1020(*; "WebArea"; $eHelp.PathName)
			
		End if   //Done unique
		
	: ($tPhase=CorektPhaseInitialize)
		
		Case of   //Query
				
			: (OB Is defined:C1231(Form:C1466; "tHelp_Key"))
				
				$tQuery:=$tQuery+"Help_Key = "+CorektSingleQuote+Form:C1466.tHelp_Key+CorektSingleQuote
				
			: (OB Is defined:C1231(Form:C1466; "tKeyword"))
				
				$cKeyword:=Split string:C1554(Form:C1466.tKeyword; CorektPipe; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
				
				For each ($tKeyword; $cKeyword)  //Keyword
					
					$tQuery:=$tQuery+"Keyword = "+CorektSingleQuote+"@"+$tKeyword+"@"+CorektSingleQuote+" OR "
					
				End for each   //Done keyword
				
				$tQuery:=Substring:C12($tQuery; 1; Length:C16($tQuery)-4)
				
		End case   //Done query
		
		$esHelp:=ds:C1482[$tTableName].query($tQuery)
		
		Help_View_LoadHList($esHelp)
		
End case   //Done phase