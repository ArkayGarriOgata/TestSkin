//%attributes = {}
//Method:  Core_4D_FixDebbuger
//Description:  This method is used to reset the 4D debugger window when the
//.  preferences get screwed up and the window is not drawing correctly

If (True:C214)  //Initialize
	
	C_TEXT:C284($tVersion; $tDebuggerPathname)
	
	C_OBJECT:C1216($oAsk)
	
	$tVersion:=CorektBlank
	$tDebuggerPathname:=CorektBlank
	
	$oAsk:=New object:C1471()
	$oAsk.tMessage:="Version is not supported"
	
	$tVersion:=Application version:C493
	
End if   //Done Initialize

Case of   //4D version
		
	: ($tVersion="16@")
		
		$tDebuggerPathname:=Get 4D folder:C485(Active 4D Folder:K5:10)+\
			"4D Window Bounds v"+Substring:C12(Application version:C493; 1; 2)+Folder separator:K24:12+\
			"coreDialog"+Folder separator:K24:12+\
			"[projectForm]"+Folder separator:K24:12+\
			"4ddebugger.json"
		
	: (($tVersion="17@") | ($tVersion="18@"))
		
		$tDebuggerPathname:=Get 4D folder:C485(Active 4D Folder:K5:10)+\
			"4D Window Bounds v"+Substring:C12(Application version:C493; 1; 2)+Folder separator:K24:12+\
			"runtime"+Folder separator:K24:12+\
			"[projectForm]"+Folder separator:K24:12+\
			"4ddebugger.json"
		
	Else   //Not supported yet
		
		Core_Dialog_Alert($oAsk)
		
End case   //Done 4D version

If (Test path name:C476($tDebuggerPathname)=Is a document:K24:1)
	
	DELETE DOCUMENT:C159($tDebuggerPathname)
	BEEP:C151
	
End if 
