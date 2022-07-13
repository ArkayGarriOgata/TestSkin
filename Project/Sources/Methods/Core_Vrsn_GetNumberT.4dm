//%attributes = {}
//Method:  Core_Vrsn_GetNumberT(nOS;tVersionFull)=>tVersionNumber
//Description: This method will get the version number

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nOS)
	C_TEXT:C284($2; $tVersionFull)
	C_TEXT:C284($0; $tVersionNumber)
	
	$nOS:=$1
	$tVersionFull:=$2
	
	$tVersionNumber:=CorektBlank
	
End if   //Done initialize

Case of   //OS
		
	: ($nOS=Mac OS:K25:2)  //macOS ##.##.# (##H#)
		
		$nStart:=(Position:C15("S"+CorektSpace; $tVersionFull)+2)
		$nEnd:=(Position:C15(CorektLeftParen; $tVersionFull)-$nStart)
		
		$tVersionNumber:=Substring:C12($tVersionFull; $nStart; $nEnd)  //##.##.#
		
	: ($nOS=Windows:K25:3)  //Microsoft Windows 10 Pro 1809 (#####.###)
		
		$nStart:=(Position:C15(CorektLeftParen; $tVersionFull)+1)
		$nEnd:=(Position:C15(CorektRightParen; $tVersionFull)-$nStart)
		
		$tVersionNumber:=Substring:C12($tVersionFull; $nStart; $nEnd)  //#####.###
		
End case   //Done OS

$0:=$tVersionNumber