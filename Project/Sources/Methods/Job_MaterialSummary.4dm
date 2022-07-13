//%attributes = {"publishedWeb":true}
//PM: Job_MaterialSummary($msg{;row;col}) -> 
//@author mlb - 9/25/01  11:17

C_TEXT:C284($msg; $1)
C_LONGINT:C283($2; $3; $i)
C_REAL:C285($0)

$msg:=$1
Case of 
	: ($msg="get")
		$0:=aMatl{$2}{$3}
		
	: ($msg="init")
		RELATE MANY:C262([Job_Forms:42]JobFormID:5)
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
		
		ARRAY REAL:C219(aMatl; 12; 4)  //row per commodity, col for act, bud, var, var%
		//*   Get Budget  
		$board:=0
		$ink:=0
		$coating:=0  //• mlb - 9/24/01  08:41
		$plates:=0
		$leaf:=0
		$corragate:=0  //• mlb - 9/24/01  08:41
		$stamping:=0  //• mlb - 9/24/01  08:41
		$acetate:=0
		$laser:=0  //• mlb - 9/24/01  08:41
		$other:=0
		$security:=0
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			For ($j; 1; Records in selection:C76([Job_Forms_Materials:55]))
				$comm:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
				Case of 
					: ($comm=1)  //board
						$board:=$board+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=2)  //ink
						$ink:=$ink+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=3)  //coatins
						$coating:=$coating+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=4)  //plates
						$plates:=$plates+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=5)  //leaf
						$leaf:=$leaf+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=6)  //corragee
						$corragate:=$corragate+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=7)  //stampoing dies
						$stamping:=$stamping+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=8)  //acetate
						$acetate:=$acetate+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=12)  //acetate
						$security:=$security+[Job_Forms_Materials:55]Planned_Cost:8
					: ($comm=13)  //`• mlb - 9/24/01  08:43
						If ([Job_Forms_Materials:55]Commodity_Key:12="13-LASER DIES")
							$laser:=$laser+[Job_Forms_Materials:55]Planned_Cost:8
						End if 
					Else 
						$other:=$other+[Job_Forms_Materials:55]Planned_Cost:8
				End case 
				NEXT RECORD:C51([Job_Forms_Materials:55])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_Commodity_Key; 0)
			ARRAY REAL:C219($_Planned_Cost; 0)
			C_LONGINT:C283($size)
			
			SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $_Commodity_Key; \
				[Job_Forms_Materials:55]Planned_Cost:8; $_Planned_Cost)
			$size:=Size of array:C274($_Planned_Cost)
			
			For ($j; 1; $size; 1)
				$comm:=Num:C11(Substring:C12($_Commodity_Key{$j}; 1; 2))
				Case of 
					: ($comm=1)  //board
						$board:=$board+$_Planned_Cost{$j}
					: ($comm=2)  //ink
						$ink:=$ink+$_Planned_Cost{$j}
					: ($comm=3)  //coatins
						$coating:=$coating+$_Planned_Cost{$j}
					: ($comm=4)  //plates
						$plates:=$plates+$_Planned_Cost{$j}
					: ($comm=5)  //leaf
						$leaf:=$leaf+$_Planned_Cost{$j}
					: ($comm=6)  //corragee
						$corragate:=$corragate+$_Planned_Cost{$j}
					: ($comm=7)  //stampoing dies
						$stamping:=$stamping+$_Planned_Cost{$j}
					: ($comm=8)  //acetate
						$acetate:=$acetate+$_Planned_Cost{$j}
					: ($comm=12)  //acetate
						$security:=$security+$_Planned_Cost{$j}
					: ($comm=13)  //`• mlb - 9/24/01  08:43
						If ($_Commodity_Key{$j}="13-LASER DIES")
							$laser:=$laser+$_Planned_Cost{$j}
						End if 
					Else 
						$other:=$other+$_Planned_Cost{$j}
				End case 
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		aMatl{1}{2}:=Round:C94($board; 0)
		aMatl{2}{2}:=Round:C94($ink; 0)
		aMatl{3}{2}:=Round:C94($coating; 0)
		aMatl{4}{2}:=Round:C94($plates; 0)
		aMatl{5}{2}:=Round:C94($leaf; 0)
		aMatl{6}{2}:=Round:C94($corragate; 0)
		aMatl{7}{2}:=Round:C94($stamping; 0)
		aMatl{8}{2}:=Round:C94($acetate; 0)
		aMatl{9}{2}:=Round:C94($laser; 0)
		aMatl{10}{2}:=Round:C94($other; 0)
		aMatl{11}{2}:=Round:C94($security; 0)
		$matlCost:=Round:C94($board+$ink+$coating+$plates+$leaf+$corragate+$stamping+$acetate+$laser+$other+$security; 0)
		aMatl{12}{2}:=$matlCost
		
		//*   Get Actual       
		$board:=0
		$ink:=0
		$coating:=0  //• mlb - 9/24/01  08:41
		$plates:=0
		$leaf:=0
		$corragate:=0  //• mlb - 9/24/01  08:41
		$stamping:=0  //• mlb - 9/24/01  08:41
		$acetate:=0
		$laser:=0  //• mlb - 9/24/01  08:41
		$other:=0
		$security:=0
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			For ($j; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
				Case of 
					: ([Raw_Materials_Transactions:23]CommodityCode:24=1) | ([Raw_Materials_Transactions:23]CommodityCode:24=20)  //board
						$board:=$board+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=2)  //ink
						$ink:=$ink+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=3)  //ink
						$coating:=$coating+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=4)  //plates
						$plates:=$plates+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=5)  //leaf
						$leaf:=$leaf+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=6)  //leaf
						$corragate:=$corragate+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=7)  //leaf
						$stamping:=$stamping+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=8)  //acetate
						$acetate:=$acetate+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=12)  //$security
						$security:=$security+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
					: ([Raw_Materials_Transactions:23]CommodityCode:24=13)  //`• mlb - 9/24/01  08:43
						If ([Raw_Materials_Transactions:23]Commodity_Key:22="13-LASER DIES")
							$laser:=$laser+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
						End if 
					Else 
						$other:=$other+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
				End case 
				NEXT RECORD:C51([Raw_Materials_Transactions:23])
			End for 
			
		Else 
			
			ARRAY INTEGER:C220($_CommodityCode; 0)
			ARRAY REAL:C219($_ActExtCost; 0)
			ARRAY TEXT:C222($_Commodity_Key; 0)
			
			C_LONGINT:C283($size)
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]CommodityCode:24; $_CommodityCode; \
				[Raw_Materials_Transactions:23]ActExtCost:10; $_ActExtCost; \
				[Raw_Materials_Transactions:23]Commodity_Key:22; $_Commodity_Key)
			$size:=Size of array:C274($_ActExtCost)
			
			For ($j; 1; $size; 1)
				
				Case of 
					: ($_CommodityCode{$j}=1) | ($_CommodityCode{$j}=20)  //board
						$board:=$board+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=2)  //ink
						$ink:=$ink+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=3)  //ink
						$coating:=$coating+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=4)  //plates
						$plates:=$plates+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=5)  //leaf
						$leaf:=$leaf+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=6)  //leaf
						$corragate:=$corragate+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=7)  //leaf
						$stamping:=$stamping+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=8)  //acetate
						$acetate:=$acetate+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=12)  //$security
						$security:=$security+($_ActExtCost{$j}*-1)
					: ($_CommodityCode{$j}=13)  //`• mlb - 9/24/01  08:43
						If ($_Commodity_Key{$j}="13-LASER DIES")
							$laser:=$laser+($_ActExtCost{$j}*-1)
						End if 
					Else 
						$other:=$other+($_ActExtCost{$j}*-1)
				End case 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		aMatl{1}{1}:=Round:C94($board; 0)
		aMatl{2}{1}:=Round:C94($ink; 0)
		aMatl{3}{1}:=Round:C94($coating; 0)
		aMatl{4}{1}:=Round:C94($plates; 0)
		aMatl{5}{1}:=Round:C94($leaf; 0)
		aMatl{6}{1}:=Round:C94($corragate; 0)
		aMatl{7}{1}:=Round:C94($stamping; 0)
		aMatl{8}{1}:=Round:C94($acetate; 0)
		aMatl{9}{1}:=Round:C94($laser; 0)
		aMatl{10}{1}:=Round:C94($other; 0)
		aMatl{11}{1}:=Round:C94($security; 0)
		$matlCost:=Round:C94($board+$ink+$coating+$plates+$leaf+$corragate+$stamping+$acetate+$laser+$other+$security; 0)
		aMatl{12}{1}:=$matlCost
		
		For ($i; 1; 12)
			aMatl{$i}{3}:=aMatl{$i}{1}-aMatl{$i}{2}
			If (aMatl{$i}{2}#0)
				aMatl{$i}{4}:=Round:C94(aMatl{$i}{3}/aMatl{$i}{2}*100; 0)
			Else 
				aMatl{$i}{4}:=0
			End if 
		End for 
		$0:=$matlCost
		
	: ($msg="kill")
		ARRAY REAL:C219(aMatl; 0; 0)
		
End case 