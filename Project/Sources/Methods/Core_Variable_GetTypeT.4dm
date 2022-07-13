//%attributes = {}
//Method:  Core_Variable_GetTypeT(tObjectName{;bUseName}{;bUseFirstLetter})=>tType (using our abbreviations)
//Description:  This method returns the type of variable based on its name.

If (True:C214)  //Initiallization
	
	C_TEXT:C284($1; $tObjectName)
	C_BOOLEAN:C305($2; $bUseName; $3; $bUseFirstLetter)
	C_TEXT:C284($0; $tType)
	
	C_POINTER:C301($pObject)
	C_LONGINT:C283($nTypeNumber)
	C_LONGINT:C283($nNumberOfParameters)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tObjectName:=$1
	
	$bUseName:=Flase
	$bUseFirstLetter:=False:C215
	
	If ($nNumberOfParameters>=2)  //Options
		$bUseName:=$2
		If ($nNumberOfParameters>=3)
			$bUseFirstLetter:=$3
		End if 
	End if   //Done options
	
End if   //Done Initialize

Case of   //Object name
		
	: ($bUseName & $bUseFirstLetter)  //Used to get type of a parameter
		
		$tType:=$tObjectName[[1]]
		
	: ($bUseName)  //  the name could be either:  ({$;◊;<>}{Modl}{a;2Da}Type
		
		$tType:=$tObjectName[[1]]
		
		Case of   //Remove the local and interprocess symbol and Module Acronym
				
			: ($tType="$")
				
				$tObjectName:=Substring:C12($tObjectName; 2)  //remove the local indicator
				
			: ($tType="<")
				
				$tObjectName:=Substring:C12($tObjectName; 7)  //Remove <>Modl
				
			Else   //It is a global variable
				
				$tObjectName:=Substring:C12($tObjectName; 5)  //Remove Modl
				
		End case   //Done remove the local or interprocess symbol and Module Acronym
		
		$tType:=$tObjectName[[1]]
		
		If ($tType="p")  //Remove pointer [Could now have patName, p2DatName, ptName, or ptName]
			
			$tObjectName:=Substring:C12($tObjectName; 2)  //Remove the p for the pointer
			
			$tType:=$tObjectName[[1]]
			
		End if   //Dome remove pointer
		
		Case of   //Remove the array indicators if present
				
			: ($tType="a")  // then at, as, ab etc...
				
				$tType:=$tObjectName[[2]]
				
			: ($tType="2")  //then  2Dat; 2Das etc..
				
				$tType:=$tObjectName[[4]]
				
		End case   //Done remove the array indicators if present
		
	Else   //Type
		
		$pObject:=Get pointer:C304($tObjectName)
		
		$nTypeNumber:=Type:C295($pObject->)
		$tType:=CorektBlank
		
		Case of   //Use type
				
			: ($nTypeNumber=Is real:K8:4)
				$tType:=CorektTypeReal
				
			: ($nTypeNumber=Is text:K8:3)
				$tType:=CorektTypeText
				
			: ($nTypeNumber=Is picture:K8:10)
				$tType:=CorektTypePicture
				
			: ($nTypeNumber=Is date:K8:7)
				$tType:=CorektTypeDate
				
			: ($nTypeNumber=Is undefined:K8:13)
				$tType:=CorektTypeString
				
			: ($nTypeNumber=Is boolean:K8:9)
				$tType:=CorektTypeBoolean
				
			: ($nTypeNumber=Is integer:K8:5)
				$tType:=CorektTypeLongint
				
			: ($nTypeNumber=Is longint:K8:6)
				$tType:=CorektTypeLongint
				
			: ($nTypeNumber=Is time:K8:8)
				$tType:=CorektTypeTime
				
			: ($nTypeNumber=Is pointer:K8:14)
				$tType:=CorektTypePointer
				
			: ($nTypeNumber=Is object:K8:27)
				$tType:=CorektTypeObject
				
			: ($nTypeNumber=Is collection:K8:32)
				$tType:=CorektTypeCollection
				
			: ($nTypeNumber=Array 2D:K8:24)
				$tType:=CorektTypeArray2D
				
			: ($nTypeNumber=Real array:K8:17)
				$tType:=CorektTypeArrayReal
				
			: ($nTypeNumber=Integer array:K8:18)
				$tType:=CorektTypeArrayLongint
				
			: ($nTypeNumber=LongInt array:K8:19)
				$tType:=CorektTypeArrayLongint
				
			: ($nTypeNumber=Date array:K8:20)
				$tType:=CorektTypeArrayDate
				
			: ($nTypeNumber=Text array:K8:16)
				$tType:=CorektTypeArrayText
				
			: ($nTypeNumber=Picture array:K8:22)
				$tType:=CorektTypeArrayPicture
				
			: ($nTypeNumber=Pointer array:K8:23)
				$tType:=CorektTypeArrayPointer
				
			: ($nTypeNumber=Text array:K8:16)
				$tType:=CorektTypeArrayText
				
			: ($nTypeNumber=Boolean array:K8:21)
				$tType:=CorektTypeArrayBoolean
				
			: ($nTypeNumber=Object array:K8:28)
				$tType:=CorektTypeArrayObject
				
		End case   //Done use type
		
End case   //Done object name

$0:=$tType