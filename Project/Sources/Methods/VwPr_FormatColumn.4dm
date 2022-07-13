//%attributes = {}
//Method:  VwPr_FormatColumn(tViewProArea;nColumn;tFormat{;nStart}{;nEnd})
//Description:  This method will format a column and tally values
//  It will clean out tValue

//Valid Formats:

//. $   Dollar
//. #   Number
//. %   Percent

//. B   Bold
//. I   Italic

//. L   Left
//. C   Center
//. R   Right

//. S#  Sum # is break level 
//      This is executed at the end

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tViewProArea)
	
	C_LONGINT:C283($2; $nColumn)
	C_TEXT:C284($3; $tFormat)
	
	C_LONGINT:C283($4; $nStart)
	C_LONGINT:C283($5; $nEnd)
	
	C_BOOLEAN:C305($bTally)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_OBJECT:C1216($oRange)
	C_OBJECT:C1216($oStyle)
	
	$tViewProArea:=$1
	$nColumn:=$2
	$tFormat:=$3
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=4)  //Parameters
		$nStart:=$4
		If ($nNumberOfParameters>=5)
			$nEnd:=$5
		End if 
	End if   //Done parameters
	
	VP SET SELECTION(VP Cells($tViewProArea; $nColumn; $nStart; 1; $nEnd))
	
	$oRange:=New object:C1471()
	$oRange:=VP Get selection($tViewProArea)
	
	$oStyle:=New object:C1471()
	
	$bTally:=False:C215
	
End if   //Done initialize

While ($tFormat#CorektBlank)  //Format
	
	//$oStyle:=VP Get cell style ($oRange)
	
	Case of   //Style
			
		: (Position:C15(CorektDoubleQuote; $tFormat)>0)  //Custom style
			
			//get format
			//apply format
			//remove format
			
		: (Position:C15("($)"; $tFormat)>0)  //(Dollar)
			
			$oStyle.formatter:=("$###,###.##;($###,###.##);-")
			VP SET CELL STYLE($oSelectedRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "($)"; CorektBlank)
			
		: (Position:C15("$"; $tFormat)>0)  //Dollar
			
			$oStyle.formatter:="$ ###,###.00"
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "$"; CorektBlank)
			
		: (Position:C15("%"; $tFormat)>0)  //Percentage
			
			$oStyle.formatter:="###.## %"
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "%"; CorektBlank)
			
		: (Position:C15("(#)"; $tFormat)>0)  //(Number)
			
			$oStyle.formatter:=("###,###.##;(###,###.##);-")
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "(#)"; CorektBlank)
			
		: (Position:C15("#"; $tFormat)>0)  //Number
			
			$oStyle.formatter:="###,###"
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "#"; CorektBlank)
			
		: (Position:C15("B"; $tFormat)>0)  //Bold
			
			//$oFont:=VP Font to object ($oStyle.font)
			//$oFont.weight:="bold"
			//$oStyleFont:=New object(VP Object to font ($oFont))
			
			//VP SET CELL STYLE ($oRange;$oStyleFont)
			
			$tFormat:=Replace string:C233($tFormat; "B"; CorektBlank)
			
		: (Position:C15("I"; $tFormat)>0)  //Italic
			
			$oFont:=VP Font to object($oStyle.font)
			$oFont.style:="italic"
			$styleTmp:=New object:C1471("font"; VP Object to font($oFont))
			VP SET CELL STYLE($range; $styleTmp)
			
			$tFormat:=Replace string:C233($tFormat; "I"; CorektBlank)
			
		: (Position:C15("C"; $tFormat)>0)  //Center
			
			$oStyle.hAlign:=vk horizontal align center:K89:40
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "C"; CorektBlank)
			
		: (Position:C15("L"; $tFormat)>0)  //Left
			
			$oStyle.hAlign:=vk horizontal align left:K89:42
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "L"; CorektBlank)
			
		: (Position:C15("R"; $tFormat)>0)  //Right
			
			$oStyle.hAlign:=vk horizontal align center:K89:40
			VP SET CELL STYLE($oRange; $oStyle)
			
			$tFormat:=Replace string:C233($tFormat; "R"; CorektBlank)
			
		: (Position:C15("S"; $tFormat)>0)  //Sum
			
			$bTally:=True:C214
			$tFormat:=Replace string:C233($tFormat; "S"; CorektBlank)
			
		Else 
			
			$tFormat:=CorektBlank
			
	End case   //Done style
	
End while   //Done format

If ($bTally)  //Tally
	
	//$tCurrent:=
	
	//For each ()  //Sum
	
	//$tComparator:=  //Comparator
	
	//Initial
	
	//$rTotal:=$rValue
	
	//Same
	
	//$rTotal:=$rTotal+$rValue
	
	//Different
	
	//Insert Row
	
	//VP SET FORMULA (VP Cell ("ViewProArea";13;1);"SUM($M$2:$M$3)")  // 
	
	//$rTotal:=$rValue
	
	//Value 
	//Column
	
	//End for each   //Done sum
	
End if   //Done tally
