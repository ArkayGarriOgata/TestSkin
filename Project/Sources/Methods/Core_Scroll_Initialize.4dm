//%attributes = {}
//Method:  Core_Scroll_Initialize(nFormEvent;pArea{;papColumn}{;panWidth}{;patTitle}{;patMethod})
//Description:  This method will set up the listbox replacement for scrollable area

If (True:C214)  //Initialize 
	
	C_POINTER:C301($2; $pArea; $3; $papColumn; $4; $panWidth; $5; $patTitle; $6; $patMethod)
	C_LONGINT:C283($1; $nFormEvent)
	
	C_LONGINT:C283($nNumberOfParameters)
	$nNumberOfParameters:=Count parameters:C259
	
	$nFormEvent:=$1
	$pArea:=$2
	
	$papColumn:=Null:C1517
	$panWidth:=Null:C1517
	$patTitle:=Null:C1517
	$patMethod:=Null:C1517
	
	If ($nNumberOfParameters>=3)
		$papColumn:=$3
		If ($nNumberOfParameters>=4)
			$panWidth:=$4
			If ($nNumberOfParameters>=5)
				$patTitle:=$5
				If ($nNumberOfParameters>=6)
					$patMethod:=$6
				End if 
			End if 
		End if 
	End if 
	
End if   //Done Initialize

Case of   //Phase
		
	: ($nFormEvent=On Load:K2:1)
		
		$nNumberOfColumns:=Size of array:C274($papColumn->)
		
		For ($nColumn; 1; $nNumberOfColumns)  //Loop thru Columns
			
			$paColumn:=$papColumn->{$nColumn}
			
			RESOLVE POINTER:C394($paColumn; $tColumnName; $nTable; $nField)
			
			$tHeaderName:=$tColumnName+"Header"
			
			$pnHeaderVariable:=Get pointer:C304("Core_nScroll_Header"+String:C10($nColumn))
			
			LISTBOX INSERT COLUMN:C829($pArea->; $nColumn; $tColumnName; $paColumn->; $tHeaderName; $pnHeaderVariable->)
			
			LISTBOX SET COLUMN WIDTH:C833($paColumn->; $panWidth->{$nColumn})
			
			OBJECT SET TITLE:C194($pnHeaderVariable->; $patTitle->{$nColumn})
			
		End for   //Done loop thru columns
		
	: ($nFormEvent=On Clicked:K2:4)
		
		ALERT:C41("hello")
		
End case   //Done phase
