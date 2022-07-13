//(s)brefresh
If (Size of array:C274(<>FGLaunchItem)=0)
	FG_LaunchItem("Init")
	$trys:=1
	While (Size of array:C274(<>FGLaunchItem)=0) & ($trys<10)
		DELAY PROCESS:C323(Current process:C322; 60)
		$trys:=$trys+1
	End while 
End if 
JML_AutoUpdate

READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
ONE RECORD SELECT:C189([zz_control:1])
<>Auto_Ink_Percent:=Num:C11([zz_control:1]Auto_Ink_Percent:41)
If (<>Auto_Ink_Percent<=0)
	<>Auto_Ink_Percent:=0.029
End if 
<>Auto_Coating_Percent:=[zz_control:1]Auto_Coating_Percent:63
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([zz_control:1])
	
	
Else 
	
	//READ ONLY MODE LINE 12
	
	
	
End if   // END 4D Professional Services : January 2019 
JML_getDollars
