//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/12/10, 12:22:37
// ----------------------------------------------------
// Method: BOL_find_locked_bin
// ----------------------------------------------------
C_BOOLEAN:C305($0)
$0:=False:C215

For ($i; 1; Size of array:C274(aLocation2))
	zwStatusMsg("Checking"; aJobit2{$i}+" in "+aLocation2{$i})
	$numFGL:=FGL_qryBin(aJobit2{$i}; aLocation2{$i}; aPallet2{$i})
	If ($numFGL=1)
		If (fLockNLoad(->[Finished_Goods_Locations:35]))
			//ok
		Else 
			$0:=True:C214  //locked msg displayed
		End if 
		
	Else 
		ALERT:C41(aJobit2{$i}+" in "+aLocation2{$i}+" not found or not unique.")
	End if 
	
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		
	Else 
		
		// you have reduce selection line 32
		
	End if   // END 4D Professional Services : January 2019 
	
End for 
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
zwStatusMsg("Finished"; " Checking for locked Locations records ")