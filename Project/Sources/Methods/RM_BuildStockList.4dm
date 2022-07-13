//%attributes = {"publishedWeb":true}
//RM_BuildStockListmsg"{;->textRtnvalu;->numericRtnVal})-> handle 1/26/00  mlb
//create a hier-list of available stocks and their caliper
//trying for a list like:
// >SBS
//     18
//     20
//     22
//     24
// >PVC
//     16
//     18.22.24
// >INVERCOTE
//     16
//     18

C_TEXT:C284($1)
C_LONGINT:C283($0; $i; $numRM; hlStockTypes; $caliperList)
C_POINTER:C301($2)  //text return value

Case of 
	: ($1="pick")
		$itemPosition:=Selected list items:C379(hlStockTypes)
		If ($itemPosition>0)
			$0:=$itemPosition
			GET LIST ITEM:C378(hlStockTypes; $itemPosition; $refNum; $caliper)
			$parentRef:=List item parent:C633(hlStockTypes; $refNum)
			$itemPosition:=List item position:C629(hlStockTypes; $parentRef)
			GET LIST ITEM:C378(hlStockTypes; $itemPosition; $parentRef; $stock)
			$2->:=$stock
			If (Position:C15("Special"; $stock)=0)
				$3->:=Num:C11($caliper)
			Else 
				$3->:=0
			End if 
		End if 
		
	: ($1="init")
		//*Get list of stocks which have standards
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=1; *)
		QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
		//*Create the hierarchical list
		
		ARRAY LONGINT:C221(aListRefStack; 0)
		If (Is a list:C621(hlStockTypes))
			CLEAR LIST:C377(hlStockTypes; *)
		End if 
		
		hlStockTypes:=utl_ListNew
		hlStockCount:=0
		
		If (Records in selection:C76([Raw_Materials_Groups:22])>0)
			SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]; $aRecNo; [Raw_Materials_Groups:22]Commodity_Key:3; $aCommKey; [Raw_Materials_Groups:22]DisplayOrder:18; $aSortBy)
			SORT ARRAY:C229($aCommKey; $aSortBy; $aRecNo; >)
			$numRM:=Size of array:C274($aCommKey)
			ARRAY TEXT:C222($aCaliper; $numRM)
			
			For ($i; 1; $numRM)
				$dot:=Position:C15("."; $aCommKey{$i})
				$aCaliper{$i}:=Substring:C12($aCommKey{$i}; $dot+1)
				If ($aCaliper{$i}#$aCommKey{$i})
					$aCaliper{$i}:="0.0"+$aCaliper{$i}
				End if 
				
				If ($dot=0)
					$dot:=Length:C16($aCommKey{$i})
				Else 
					$dot:=$dot-1
				End if 
				$aCommKey{$i}:=Substring:C12($aCommKey{$i}; 4; $dot-3)
			End for 
			
			$caliperList:=0
			$currentType:=$aCommKey{1}
			$lastType:=""
			For ($i; 1; $numRM)
				hlStockCount:=hlStockCount+1
				If ($aCommKey{$i}#$lastType)  //start a new parent
					
					If (Is a list:C621($caliperList))
						APPEND TO LIST:C376(hlStockTypes; $aCommKey{$i-1}; -$aRecNo{$i-1}; $caliperList; True:C214)
					End if 
					$caliperList:=utl_ListNew
					$lastType:=$aCommKey{$i}
				End if 
				APPEND TO LIST:C376($caliperList; $aCaliper{$i}; $aRecNo{$i})  //add a new leaf      
				
			End for 
			If (Is a list:C621($caliperList))
				APPEND TO LIST:C376(hlStockTypes; $aCommKey{$i-1}; -$aRecNo{$i-1}; $caliperList; True:C214)
			End if 
		End if   //records      
		
		$0:=hlStockTypes
		
	: ($1="kill")
		utl_ListClear  //*tear down the list
		
		hlStockTypes:=0
		$0:=hlStockTypes
End case 