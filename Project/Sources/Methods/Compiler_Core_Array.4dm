//%attributes = {}
//Method:  Compiler_Core_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_POINTER:C301($patTitle; $patLocation; $patKey)
	C_POINTER:C301($patQuryComparatorLast)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tMethodName:=$1
	
	$nRows:=0
	$nColumns:=0
	
	If ($nNumberOfParameters>=2)  //Optional
		$nRows:=$2
		If ($nNumberOfParameters>=3)
			$nColumns:=$3
		End if 
	End if   //Done optional
	
End if   //Done initialization

Case of   //Method name
		
	: ($tMethodName="Core_VdVl_LoadHList")
		
		ARRAY POINTER:C280(CoreapParameter; $nRows)
		
	: ($tMethodName="Core_VdVl_Initialize")
		
		ARRAY TEXT:C222(Core_atVdVl_Identifier; $nRows)
		ARRAY TEXT:C222(Core_atVdVl_Value; $nRows)
		
		
	: ($tMethodName="Core_NmKy_Initialize")
		
		ARRAY BOOLEAN:C223(Core_abNmKy_Name; $nRows)
		ARRAY TEXT:C222(Core_atNmKy_Name; $nRows)
		
		ARRAY BOOLEAN:C223(Core_abNmKy_NameValue; $nRows)
		ARRAY TEXT:C222(Core_atNmKy_NameValue; $nRows)
		
		ARRAY BOOLEAN:C223(Core_abNmKy_Key; $nRows)
		ARRAY TEXT:C222(Core_atNmKy_Key; $nRows)
		
		ARRAY BOOLEAN:C223(Core_abNmKy_KeyValue; $nRows)
		ARRAY TEXT:C222(Core_atNmKy_KeyValue; $nRows)
		
	: ($tMethodName="Core_HList_Create")
		
		$panListID:=Get pointer:C304("CoreanHListID"+String:C10($nColumns))
		
		ARRAY LONGINT:C221($panListID->; $nRows)
		
	: ($tMethodName="Core_HList_Initialize")
		
		$patTitle:=Get pointer:C304("CoreatHListTitle"+String:C10($nColumns))
		$patLocation:=Get pointer:C304("CoreatHListLocation"+String:C10($nColumns))
		$patKey:=Get pointer:C304("CoreatHListKey"+String:C10($nColumns))
		
		ARRAY TEXT:C222($patTitle->; $nRows)
		ARRAY TEXT:C222($patLocation->; $nRows)
		ARRAY TEXT:C222($patKey->; $nRows)
		
	: ($tMethodName="Core_Pick_Initialize")  //Clear the arrays
		
		ARRAY TEXT:C222(Core_atPick_Value; $nRows)
		ARRAY BOOLEAN:C223(Core_abPick; $nRows)
		ARRAY BOOLEAN:C223(Core_abPick_Picked; $nRows)
		ARRAY LONGINT:C221(Core_anPick_RowControl; $nRows)
		
	: ($tMethodName="Core_Pick_Initialize2")  //Resize to Core_atPick_Value
		
		ARRAY BOOLEAN:C223(Core_abPick; $nRows)  //Listbox array
		ARRAY BOOLEAN:C223(Core_abPick_Picked; $nRows)  //Check box
		ARRAY LONGINT:C221(Core_anPick_RowControl; $nRows)  //Listbox settings Row Control Array
		ARRAY LONGINT:C221(Core_anPick_RowBackground; $nRows)  //Background color
		
	: ($tMethodName="Core_Dialog_PickT")  //Called to clear arrays
		
		ARRAY BOOLEAN:C223(Core_abPick; $nRows)  //Doubles as the check box column and name of ListBox
		
		ARRAY LONGINT:C221(Core_anPick_RowControl; $nRows)  //Listbox settings Row Control Array
		
		ARRAY TEXT:C222(Core_atPick_ColumnKey; $nRows)  //Unique key array always hidden
		
		ARRAY TEXT:C222(Core_atPick_Column1; $nRows)  //Allow up to 4 columns
		ARRAY TEXT:C222(Core_atPick_Column2; $nRows)
		ARRAY TEXT:C222(Core_atPick_Column3; $nRows)
		ARRAY TEXT:C222(Core_atPick_Column4; $nRows)
		
End case   //Done method name

