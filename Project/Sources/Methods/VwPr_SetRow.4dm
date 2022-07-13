//%attributes = {}
//Method:  VwPr_SetRow(tViewProArea;cAttribute;esORDAClasss{;bTitle})
//Description:  This method will use an entity selection
//   and add the rows appropriately

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tViewProArea)
	C_COLLECTION:C1488($2; $cAttribute)
	C_OBJECT:C1216($3; $esORDAClass)
	
	C_BOOLEAN:C305($bTitle)
	
	C_COLLECTION:C1488($cAttribute)
	C_COLLECTION:C1488($cColumnFormat)
	C_COLLECTION:C1488($cFormat)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nPeriod; $nType)
	C_LONGINT:C283($nColumn; $nRow)
	
	C_OBJECT:C1216($oInherent)
	
	C_TEXT:C284($tAttribute)
	
	C_OBJECT:C1216($oProgress)
	
	C_BOOLEAN:C305($bProgress)
	C_LONGINT:C283($nLoop; $nNumberOfLoops)
	
	$cAttribute:=New collection:C1472()
	$cColumnFormat:=New collection:C1472()
	$cFormat:=New collection:C1472()
	
	$tViewProArea:=$1
	$cAttribute:=$2
	$esORDAClass:=$3
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=4)  //Parameters
		
		$bTitle:=$4
		
	End if   //Done parameters
	
	$nPeriod:=0
	$nType:=0
	$nColumn:=0
	$nRow:=0
	
	$tAttribute:=CorektBlank
	
	$nStart:=1
	$nEnd:=$esORDAClass.length
	
	For each ($tAttribute; $cAttribute)  //Set Format
		
		$nFormat:=Position:C15(CorektPipe; $tAttribute)
		
		If ($nFormat>0)  //Format
			
			$cFormat.push(New collection:C1472($nColumn; $nStart; $nEnd; Substring:C12($tAttribute; $nFormat+1)))
			
			$cAttribute[$nColumn]:=Substring:C12($tAttribute; 1; $nFormat-1)
			
		End if   //Done format
		
		$nColumn:=$nColumn+1
		
	End for each   //Done set format
	
	$nColumn:=0
	
	$bProgress:=True:C214
	
	$nNumberOfLoops:=$nEnd
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfLoops
	$oProgress.tTitle:="Processing values ... "
	
	
End if   //Done initialize

If ($bTitle)  //Title
	
	VP NEW DOCUMENT($tViewProArea)
	
	VwPr_SetTitle($tViewProArea; $cAttribute)
	
End if   //Done title

For each ($eORDAClass; $esORDAClass) While ($bProgress)  //Selection
	
	$nLoop:=$nLoop+1
	$nRow:=$nRow+1
	$nColumn:=0
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$oProgress.nLoop:=$nLoop
		$oProgress.tMessage:="Processing thru each value"
		
		Prgr_Message($oProgress)
		
		For each ($tAttribute; $cAttribute)  //Attribute
			
			$nPeriod:=Position:C15(CorektPeriod; $tAttribute)
			
			If ($nPeriod>0)  //Inherent
				
				$tInherent:=Substring:C12($tAttribute; 1; $nPeriod-1)
				
				$tAttribute:=Substring:C12($tAttribute; $nPeriod+1)
				
				$oInherent:=New object:C1471()
				
				$oInherent:=OB Get:C1224($eORDAClass; $tInherent)
				
				$nType:=OB Get type:C1230($oInherent; $tAttribute)
				
				Case of   //Field type
						
					: ($nType=Is date:K8:7)
						
						VP SET DATE VALUE(VP Cell($tViewProArea; $nColumn; $nRow); OB Get:C1224($oInherent; $tAttribute))
						
					: (($nType=Is text:K8:3) | ($nType=Is alpha field:K8:1))
						
						VP SET TEXT VALUE(VP Cell($tViewProArea; $nColumn; $nRow); OB Get:C1224($oInherent; $tAttribute))
						
					: (($nType=Is real:K8:4) | ($nType=Is longint:K8:6))
						
						VP SET NUM VALUE(VP Cell($tViewProArea; $nColumn; $nRow); OB Get:C1224($oInherent; $tAttribute))
						
				End case   //Done field type
				
			Else   //eORDAClass
				
				$nType:=OB Get type:C1230($eORDAClass; $tAttribute)
				
				Case of   //Field type
						
					: ($nType=Is date:K8:7)
						
						VP SET DATE VALUE(VP Cell($tViewProArea; $nColumn; $nRow); OB Get:C1224($eORDAClass; $tAttribute))
						
					: (($nType=Is text:K8:3) | ($nType=Is alpha field:K8:1))
						
						VP SET TEXT VALUE(VP Cell($tViewProArea; $nColumn; $nRow); OB Get:C1224($eORDAClass; $tAttribute))
						
					: (($nType=Is real:K8:4) | ($nType=Is longint:K8:6))
						
						VP SET NUM VALUE(VP Cell($tViewProArea; $nColumn; $nRow); OB Get:C1224($eORDAClass; $tAttribute))
						
				End case   //Done field type
				
			End if   //Done inherent
			
			$nColumn:=$nColumn+1
			
		End for each   //Done attribute
		
	Else   //Progress canceled
		
		$bProgress:=False:C215
		
	End if   //Done progress
	
End for each   //Done selection

For each ($cColumnFormat; $cFormat)
	
	$nColumn:=$cColumnFormat[0]
	$nStart:=$cColumnFormat[1]
	$nEnd:=$cColumnFormat[2]
	$tFormat:=$cColumnFormat[3]
	
	VwPr_FormatColumn($tViewProArea; $nColumn; $tFormat; $nStart; $nEnd)
	
End for each 

Prgr_Quit($oProgress)