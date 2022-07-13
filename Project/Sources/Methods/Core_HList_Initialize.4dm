//%attributes = {}
//Method:  Core_HList_Initialize(nHierachicalNumber;papParameter{;nFormat}{;bLetter})
//Description:  This method will setup the arrays for the 
//  HList List.  It can then call Core_HList_Create
//   It assumes that the selection is complete and ordered
//   CoreknFormatCommaSpace, CoreknFormatSpace, CoreknFormatNoSpace

//Parameter should be used like this in the parameter array
//    CoreknHListTable:=1
//    CoreknHListPrimaryKey:=2
//    CoreknHListFolder:=3
//    CoreknHListTitle:=4
//    CoreknHListRelate:=5
//    CoreknHListTitleConcat1:=6
//    CoreknHListTitleConcat2:=7
//    CoreknHListTitleConcat3:=8  If this is used the folder information is from the one table
//       and the title information is from the many table
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $3; $nHListNumber; $nFormat)
	C_POINTER:C301($2; $papParameter)
	C_BOOLEAN:C305($4; $bLetter)
	C_POINTER:C301($pFolder; $pPrimaryKey; $patTitle; $patLocation; $patKey)
	C_LONGINT:C283($nFormat; $nItem; $nNumberOfPointers; $nRelation)
	
	C_TEXT:C284($tFolderName; $tTitle; $tNextFolder)
	C_TEXT:C284($tName; $tKey)
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nListNumber; $nFolderNumber; $nNumberOfParameters; $nConcateFields)
	C_LONGINT:C283($nNumberOfRows)
	C_POINTER:C301($pTable; $pTitleField; $pConcatenate1; $pConcatenate2)
	
	$nHListNumber:=$1
	$papParameter:=$2
	
	$nFormat:=CoreknFormatNoSpace
	$bLetter:=False:C215
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>2)
		$nFormat:=$3
	End if 
	
	If ($nNumberOfParameters>2)
		$bLetter:=$4
	End if 
	
	$nNumberOfPointers:=Size of array:C274($papParameter->)
	
	$pTable:=($papParameter->{CoreknHListTable})
	$pPrimaryKey:=($papParameter->{CoreknHListPrimaryKey})
	$pFolder:=($papParameter->{CoreknHListFolder})
	$pTitleField:=($papParameter->{CoreknHListTitle})
	
	RESOLVE POINTER:C394($pTable; $tName; $nTable; $nField)
	
	$bUseTable:=($nTable>0)  //pass in pointer to boolean for array
	
	$nRelation:=CoreknHListRelateNone  //Default to no relationship
	
	If ($nNumberOfPointers>CoreknHListTitle)  //Have a relationship and/or concatenation
		
		$nRelation:=($papParameter->{CoreknHListRelate})->  //How are the titles related
		
		$nConcateFields:=$nNumberOfPointers-CoreknHListRelate
		
		If ($nRelation=CoreknHListRelateNone)
			
			Case of 
				: ($nConcateFields=1)
					$pConcatenate1:=$papParameter->{CoreknHListTitleConcat1}
					
				: ($nConcateFields=2)
					$pConcatenate1:=$papParameter->{CoreknHListTitleConcat1}
					$pConcatenate2:=$papParameter->{CoreknHListTitleConcat2}
					
			End case 
			
		Else   //Theres a relationship
			
			Case of 
				: ($nConcateFields=1)  //Just a folder and title but use Relate one
					$nConcateFields:=0  //No fields to concatenate to title
					
				: ($nConcateFields=2)  //First one is the related value
					$pConcatenate1:=$papParameter->{CoreknHListTitleConcat2}
					$nConcateFields:=1  //Only one field to concatenate to title
					
				: ($nConcateFields=3)  //First one is the related value
					$pConcatenate1:=$papParameter->{CoreknHListTitleConcat2}
					$pConcatenate2:=$papParameter->{CoreknHListTitleConcat3}
					$nConcateFields:=2  //Two fields to concatenate to title
					
			End case 
			
		End if 
		
	End if   //Done have a relationship and/or concatenation
	
	Compiler_Core_Array(Current method name:C684; 0; $nHListNumber)
	
	$patTitle:=Get pointer:C304("CoreatHListTitle"+String:C10($nHListNumber))
	$patLocation:=Get pointer:C304("CoreatHListLocation"+String:C10($nHListNumber))
	$patKey:=Get pointer:C304("CoreatHListKey"+String:C10($nHListNumber))
	
	$nListNumber:=101000
	$nFolderNumber:=0
	$tFolderName:=CorektBlank
	
	If ($bUseTable)  //$nNumberOfItems
		
		$nNumberOfItems:=Records in selection:C76($pTable->)
		
	Else 
		
		$nNumberOfItems:=Size of array:C274($pPrimaryKey->)
		
	End if   //Done $nNumberOfItems
	
End if   //Done Initialize

For ($nItem; 1; $nNumberOfItems)  //Items
	
	If ($bUseTable)  //Use table
		
		GOTO SELECTED RECORD:C245($pTable->; $nItem)
		
		Case of   //Relationship
				
			: ($nRelation=CoreknHListRelateOne)
				
				RELATE ONE:C42($papParameter->{CoreknHListTitleConcat1}->)  //Get the one record that is related to
				
			: ($nRelation=CoreknHListRelateMany)
				
				RELATE MANY:C262($papParameter->{CoreknHListTitleConcat1}->)  //Get the many record that is related to
				
		End case   //Done relationship
		
	End if   //Done use table
	
	If ($bUseTable)
		
		$tNextFolder:=$pFolder->
		
	Else 
		
		$tNextFolder:=$pFolder->{$nItem}
		
	End if 
	
	If ($bLetter)
		$tNextFolder:=$tNextFolder[[1]]
	End if 
	
	If ($tNextFolder=$tFolderName)  //Same folder
		
		$nListNumber:=$nListNumber+1
		
		Case of   //Title
			: (Not:C34($bUseTable))  //using array
				$tTitle:=$pTitleField->{$nItem}
			: ($nConcateFields=1)
				$tTitle:=Core_ConcatenateT($nFormat; $pTitleField; $pConcatenate1)  //Cocatenate fields if needed
			: ($nConcateFields=2)
				$tTitle:=Core_ConcatenateT($nFormat; $pTitleField; $pConcatenate1; $pConcatenate2)  //Cocatenate fields if needed
			Else 
				$tTitle:=$pTitleField->
		End case   //Done title
		
		If ($bUseTable)
			
			$tKey:=$pPrimaryKey->
			
		Else 
			
			$tKey:=$pPrimaryKey->{$nItem}
			
		End if 
		
		APPEND TO ARRAY:C911($patTitle->; $tTitle)
		APPEND TO ARRAY:C911($patLocation->; String:C10($nListNumber))
		APPEND TO ARRAY:C911($patKey->; $tKey)
		
	Else   //Different folder
		
		If ($bUseTable)  //Add folder
			
			$tFolderName:=$pFolder->
			
		Else 
			
			$tFolderName:=$pFolder->{$nItem}
			
		End if   //Done add folder
		
		$tFolderName:=Choose:C955($bLetter; $tFolderName[[1]]; $tFolderName)
		
		$nFolderNumber:=$nFolderNumber+1
		
		$nListNumber:=($nFolderNumber*100000)+1000
		
		APPEND TO ARRAY:C911($patTitle->; $tFolderName)
		APPEND TO ARRAY:C911($patLocation->; String:C10($nListNumber))
		APPEND TO ARRAY:C911($patKey->; String:C10($nFolderNumber))
		
		//Add item 
		
		$nListNumber:=$nListNumber+1
		
		Case of   //Title
			: (Not:C34($bUseTable))  //using array
				$tTitle:=$pTitleField->{$nItem}
			: ($nConcateFields=1)
				$tTitle:=Core_ConcatenateT($nFormat; $pTitleField; $pConcatenate1)  //Cocatenate fields if needed
			: ($nConcateFields=2)
				$tTitle:=Core_ConcatenateT($nFormat; $pTitleField; $pConcatenate1; $pConcatenate2)  //Cocatenate fields if needed
			Else 
				$tTitle:=$pTitleField->
		End case   //Done title
		
		If ($bUseTable)
			
			$tKey:=$pPrimaryKey->
			
		Else 
			
			$tKey:=$pPrimaryKey->{$nItem}
			
		End if 
		
		APPEND TO ARRAY:C911($patTitle->; $tTitle)
		APPEND TO ARRAY:C911($patLocation->; String:C10($nListNumber))
		APPEND TO ARRAY:C911($patKey->; $tKey)
		
	End if   //Done same folder
	
End for   //Done items
