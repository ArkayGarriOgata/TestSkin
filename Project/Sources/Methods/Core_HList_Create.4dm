//%attributes = {}
//Method:  Core_HList_Create(nHListNumber{;bExpanded})
//Description:  This method will create a HList based on these arrays being defined
//. by Core_HList_Initialize four records
// Example:

//  CoreatTitle{1}:="Folder1"
//  CoreatTitle{2}:="Item 1.1"
//  CoreatTitle{3}:="Item 1.2"
//  CoreatTitle{4}:="Folder2"
//  CoreatTitle{5}:="Item 2.1"
//  CoreatTitle{6}:="Item 1"

//  CoreatLocation{1}:="101000"
//  CoreatLocation{2}:="101001"
//  CoreatLocation{3}:="101002"
//  CoreatLocation{4}:="201000"
//  CoreatLocation{5}:="201001"
//  CoreatLocation{6}:="001"

//  CoreatKey{1}:="1"
//  CoreatKey{2}:="a33gadfce2"
//  CoreatKey{3}:="a33gacade2"
//  CoreatKey{4}:="2"
//  CoreatKey{5}:="a33gacdfe2"
//  CoreatKey{6}:="Ia33gace2"

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nHListNumber)
	C_BOOLEAN:C305($2; $bExpanded)
	
	C_POINTER:C301($panListID)  //longint array that keeps track of H List ID's
	//  This is CoreanHListID# it has to be maintained for executing lists.
	C_POINTER:C301($pnHListNumber)  //This is a pointer to the HList
	//  that is being displayed on the  form
	
	C_POINTER:C301($patTitle; $patLocation)
	
	C_LONGINT:C283($nLine; $nList; $nLevel; $nNewLevel)
	C_LONGINT:C283($nElement; $nLocation)
	
	$nHListNumber:=$1
	
	$bExpanded:=True:C214
	If (Count parameters:C259>=2)
		$bExpanded:=$2
	End if 
	
	Compiler_Core_Array(Current method name:C684; 1; $nHListNumber)
	
	$panListID:=Get pointer:C304("CoreanHListID"+String:C10($nHListNumber))
	$pnHListNumber:=Get pointer:C304("CorenHList"+String:C10($nHListNumber))
	
	$patTitle:=Get pointer:C304("CoreatHListTitle"+String:C10($nHListNumber))
	$patLocation:=Get pointer:C304("CoreatHListLocation"+String:C10($nHListNumber))
	
	$pnHListNumber->:=New list:C375
	
	ARRAY LONGINT:C221($anFolderLocation; 0)
	
	$panListID->{1}:=$pnHListNumber->
	
	$nList:=1  //What List I'm at in $panListID->
	$nLevel:=0  //How many levels from the root directory are we at.
	
End if   //Done Initialize

For ($nLine; 1; Size of array:C274($patLocation->))  //Loop through the Location array
	
	If (Position:C15("000"; $patLocation->{$nLine})>2)  //Is this a new folder (ie are the last three numbers 000)
		
		$nNewLevel:=(Length:C16($patLocation->{$nLine})/3)-1  //What level is this folder from the root
		
		While ($nLevel>=$nNewLevel)  //If we want to append the sublist to this  folder 
			
			$nElement:=Size of array:C274($anFolderLocation)  //Get the last folder
			$nLocation:=$anFolderLocation{$nElement}  //Get its location in the Location array
			
			If ($nLevel=1)  //We are just one level from the root then append this folder to the root
				APPEND TO LIST:C376($panListID->{1}; $patTitle->{$nLocation}; $anFolderLocation{$nElement}; $panListID->{$nList}; $bExpanded)
			Else   //This is a subfolder so keep nesting down.
				APPEND TO LIST:C376($panListID->{$nList-1}; $patTitle->{$nLocation}; $anFolderLocation{$nElement}; $panListID->{$nList}; $bExpanded)
			End if   //Done we are just one level from the root then append this folder to the root
			
			SET LIST ITEM PROPERTIES:C386($panListID->{$nList}; 0; True:C214; Plain:K14:1; 0)
			
			DELETE FROM ARRAY:C228($anFolderLocation; $nElement)  //Delete it from the folder array since its now been added
			
			$nLevel:=$nLevel-1
			$nList:=$nList-1  //Move back to the previous level
			
		End while   //Done checking if want to append the sublist to this  folder
		
		$nLevel:=$nLevel+1  //We are one more level away from the root level
		
		$nList:=Size of array:C274($panListID->)+1  //Reset the list to say this is the location of the next folder
		$nLocation:=Size of array:C274($anFolderLocation)+1  //Add a new element to the titlelocation
		
		INSERT IN ARRAY:C227($panListID->; $nList)
		INSERT IN ARRAY:C227($anFolderLocation; $nLocation)
		
		$panListID->{$nList}:=New list:C375
		$anFolderLocation{$nLocation}:=$nLine
		
	Else   //We aren't at a new folder so just add it on
		
		APPEND TO LIST:C376($panListID->{$nList}; $patTitle->{$nLine}; $nLine)
		SET LIST ITEM PROPERTIES:C386($panListID->{$nList}; 0; True:C214; Plain:K14:1; 0)
		
	End if   //Done checking if its a new folder
	
End for   //Done looping through the Location array

While ($nLevel#0)  //We want to append the rest of the sublists
	
	$nElement:=Size of array:C274($anFolderLocation)  //Get the last element in the array
	$nLocation:=$anFolderLocation{$nElement}  //Get its location
	
	If ($nLevel=1)  //We are just one level from the root then append this folder to the root
		APPEND TO LIST:C376($panListID->{1}; $patTitle->{$nLocation}; $anFolderLocation{$nElement}; $panListID->{$nList}; $bExpanded)
	Else   //This is a subfolder so keep nesting down.
		APPEND TO LIST:C376($panListID->{$nList-1}; $patTitle->{$nLocation}; $anFolderLocation{$nElement}; $panListID->{$nList}; $bExpanded)
	End if   //Done we are just one level from the root then append this folder to the root
	
	SET LIST ITEM PROPERTIES:C386($panListID->{$nList}; 0; True:C214; Plain:K14:1; 0)
	
	$nLevel:=$nLevel-1
	$nList:=$nList-1
	
End while   //Done we want to append the rest of the sublists

