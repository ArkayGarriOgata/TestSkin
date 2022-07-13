//%attributes = {}
//Method:  Core_Compiler_SetDeclarationT(tType)=>tCompilerDeclaration
//Description:  This method will return a compiler declaration for a type.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tType; $0; $tCompilerDeclaration)
	
	$tType:=$1
	
	$tCompilerDeclaration:=CorektBlank
	
End if   //Done Initialize

Case of   //Set $tCompilerDeclaration
		
	: ($tType=CorektTypeReal)
		$tCompilerDeclaration:=Command name:C538(285)+CorektLeftParen
		
	: ($tType=CorektTypePointer)
		$tCompilerDeclaration:=Command name:C538(301)+CorektLeftParen
		
	: ($tType=CorektTypeText)
		$tCompilerDeclaration:=Command name:C538(284)+CorektLeftParen
		
	: ($tType=CorektTypePicture)
		$tCompilerDeclaration:=Command name:C538(286)+CorektLeftParen
		
	: ($tType=CorektTypeDate)
		$tCompilerDeclaration:=Command name:C538(307)+CorektLeftParen
		
	: ($tType=CorektTypeBoolean)
		$tCompilerDeclaration:=Command name:C538(305)+CorektLeftParen
		
	: ($tType=CorektTypeLongint)
		$tCompilerDeclaration:=Command name:C538(283)+CorektLeftParen
		
	: ($tType=CorektTypeTime)
		$tCompilerDeclaration:=Command name:C538(306)+CorektLeftParen
		
	: ($tType=CorektTypeBlob)
		$tCompilerDeclaration:=Command name:C538(604)+CorektLeftParen
		
	: ($tType=CorektTypeObject)
		$tCompilerDeclaration:="C_OBJECT ("  //Command name(604)+CorektLeftParen
		
	: ($tType=CorektTypeCollection)
		$tCompilerDeclaration:="C_COLLECTION ("  //Command name(604)+CorektLeftParen
		
	: ($tType=CorektTypeBlob)
		$tCompilerDeclaration:=Command name:C538(604)+CorektLeftParen
		
	: ($tType=CorektTypeArrayReal)
		$tCompilerDeclaration:=Command name:C538(219)+CorektLeftParen
		
	: ($tType=CorektTypeArrayLongint)
		$tCompilerDeclaration:=Command name:C538(221)+CorektLeftParen
		
	: ($tType=CorektTypeArrayDate)
		$tCompilerDeclaration:=Command name:C538(224)+CorektLeftParen
		
	: ($tType=CorektTypeArrayTime)
		$tCompilerDeclaration:=Command name:C538(222)+CorektLeftParen
		
	: ($tType=CorektTypeArrayPicture)
		$tCompilerDeclaration:=Command name:C538(279)+CorektLeftParen
		
	: ($tType=CorektTypeArrayPointer)
		$tCompilerDeclaration:=Command name:C538(280)+CorektLeftParen
		
	: ($tType=CorektTypeArrayText)
		$tCompilerDeclaration:=Command name:C538(218)+CorektLeftParen
		
	: ($tType=CorektTypeArrayBoolean)
		$tCompilerDeclaration:=Command name:C538(223)+CorektLeftParen
		
	: ($tType=CorektTypeArrayObject)
		$tCompilerDeclaration:="ARRAY OBJECT("  //Command name(223)+CorektLeftParen
		
		
End case   //Done set $tCompilerDeclaration

$0:=$tCompilerDeclaration