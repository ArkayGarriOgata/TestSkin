
Case of 
	: (Form event code:C388=On Load:K2:1)
		ListBox:=0  //deselect?
		
		C_LONGINT:C283($i; $numElements)
		$numElements:=Size of array:C274(ListBox)
		For ($i; 1; $numElements)
			ListBox{$i}:=False:C215
		End for 
		
		recNum:=-1
		OBJECT SET ENABLED:C1123(*; "use"; False:C215)
		
End case 
