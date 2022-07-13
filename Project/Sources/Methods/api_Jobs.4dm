//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/18/17, 14:07:02
// ----------------------------------------------------
// Method: api_Jobs
// Description
// http://localhost:8080/api/jobs
//http://localhost:8080/api/jobs/98626.01
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($i; $numElements)
C_TEXT:C284($jobform; $1; $0; $res; $salerep; $coord; $plnr)
C_OBJECT:C1216($obj_by_value)
C_BOOLEAN:C305($debug)
$debug:=False:C215
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Materials:55])

If (Count parameters:C259=0) & (Not:C34($debug))  //rtn a collection
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"Closed"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Complete"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Kill"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5#"020@")
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
		If (Records in selection:C76([Job_Forms:42])>0)
			
			
			Case of 
				: (True:C214)
					CREATE SET:C116([Job_Forms:42]; "openJobs")
					C_LONGINT:C283($i; $numRecs)
					C_BOOLEAN:C305($break)
					
					$break:=False:C215
					$numRecs:=Records in selection:C76([Job_Forms:42])
					$res:=""
					uThermoInit($numRecs; "Updating Records")
					For ($i; 1; $numRecs)
						USE SET:C118("openJobs")
						GOTO SELECTED RECORD:C245([Job_Forms:42]; $i)
						$res:=$res+api_Jobs([Job_Forms:42]JobFormID:5)+" \r"
						uThermoUpdate($i)
					End for 
					uThermoClose
					CLEAR SET:C117("openJobs")
					
				: (False:C215)
					SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJF; [Job_Forms:42]StartDate:10; $aStarted; [Job_Forms:42]cust_id:82; $aCust; [Job_Forms:42]CustomerLine:62; $aLine; [Job_Forms:42]EstNetSheets:28; $aNet; [Job_Forms:42]VersionDate:58; $aVersion; [Job_Forms:42]VersionNumber:57; $aVersionNumber; [Job_Forms:42]ProjectNumber:56; $aPjt)
					$numElements:=Size of array:C274($aJF)
					C_OBJECT:C1216($Jobs; $Job)
					ARRAY OBJECT:C1221($jobCollection; 0)
					
					$res:=""
					$numElements:=Size of array:C274($aJF)
					
					For ($i; 1; ($numElements))
						OB SET:C1220($Job; "jobform"; $aJF{$i})
						OB SET:C1220($Job; "customer"; CUST_getName($aCust{$i}))
						OB SET:C1220($Job; "line"; $aLine{$i})
						OB SET:C1220($Job; "project"; Pjt_getName($aPjt{$i}))
						Cust_getTeam($aCust{$i}; ->$salerep; ->$coord; ->$plnr)
						OB SET:C1220($Job; "planner"; User_GetName($plnr))
						OB SET:C1220($Job; "netsheets"; $aNet{$i})
						OB SET:C1220($Job; "version"; String:C10($aVersion{$i}; Internal date short special:K1:4)+"v"+String:C10($aVersionNumber{$i}))
						$obj_by_value:=OB Copy:C1225($Job)
						APPEND TO ARRAY:C911($jobCollection; $obj_by_value)
					End for 
					
					OB SET ARRAY:C1227($Jobs; "jobs"; $jobCollection)
					
					$res:=JSON Stringify:C1217($Jobs; *)
					
					
				: (False:C215)  //false, no control over date or customer
					$res:=Selection to JSON:C1234([Job_Forms:42]; [Job_Forms:42]JobFormID:5; [Job_Forms:42]StartDate:10; [Job_Forms:42]cust_id:82)
			End case   //false
			
			//  utl_LogIt ("init")
			//utl_LogIt ($res)
			//  utl_LogIt ("show")
			
		Else 
			$res:="501"
		End if 
		
	Else 
		//change line 43 44 45
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"Closed"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Complete"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Kill"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5#"020@")
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
		
		If (Records in selection:C76([Job_Forms:42])>0)
			
			ARRAY TEXT:C222($_JobFormID; 0)
			SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $_JobFormID)
			
			C_LONGINT:C283($i; $numRecs)
			C_BOOLEAN:C305($break)
			
			$break:=False:C215
			$numRecs:=Size of array:C274($_JobFormID)
			$res:=""
			uThermoInit($numRecs; "Updating Records")
			For ($i; 1; $numRecs)
				$res:=$res+api_Jobs($_JobFormID{$i})+" \r"
			End for 
			
			
		Else 
			$res:="501"
		End if 
		
	End if   // END 4D Professional Services : January 2019 
	
	$0:=$res
	
Else   //got me some params
	
	If (Not:C34($debug))
		$jobform:=$1
	Else 
		$jobform:="98626.01"  //"98707.01"  //"98626.01" 
	End if 
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
	If (Records in selection:C76([Job_Forms:42])=1)
		C_OBJECT:C1216($Job)
		OB SET:C1220($Job; "jobform"; $jobform)
		OB SET:C1220($Job; "customer"; CUST_getName([Job_Forms:42]cust_id:82))
		OB SET:C1220($Job; "line"; [Job_Forms:42]CustomerLine:62)
		OB SET:C1220($Job; "project"; Pjt_getName([Job_Forms:42]ProjectNumber:56))
		Cust_getTeam([Job_Forms:42]cust_id:82; ->$salerep; ->$coord; ->$plnr)
		OB SET:C1220($Job; "planner"; User_GetName($plnr))
		OB SET:C1220($Job; "netsheets"; [Job_Forms:42]EstNetSheets:28)
		OB SET:C1220($Job; "sheetsize"; (String:C10([Job_Forms:42]Width:23)+" x "+String:C10([Job_Forms:42]Lenth:24)+" "+(Num:C11([Job_Forms:42]ShortGrain:48)*" SHORT GRAIN")))
		OB SET:C1220($Job; "version"; String:C10([Job_Forms:42]VersionDate:58; Internal date short special:K1:4)+"v"+String:C10([Job_Forms:42]VersionNumber:57))
		//$res:=JSON Stringify($Job)
		
		//get items
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >)
				For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
					OB SET:C1220($item; "item"; [Job_Forms_Items:44]ItemNumber:7; "cpn"; [Job_Forms_Items:44]ProductCode:3; "wantqty"; [Job_Forms_Items:44]Qty_Want:24; "up"; [Job_Forms_Items:44]NumberUp:8; "outline"; [Job_Forms_Items:44]OutlineNumber:43; "ready"; String:C10([Job_Forms_Items:44]MAD:37; Internal date short special:K1:4))
					$obj_by_value:=OB Copy:C1225($item)
					APPEND TO ARRAY:C911($items; $obj_by_value)
					NEXT RECORD:C51([Job_Forms_Items:44])
				End for 
				OB SET ARRAY:C1227($Job; "items"; $items)
			End if 
			
			//get route
			C_OBJECT:C1216($operation)
			ARRAY OBJECT:C1221($route; 0)
			
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
			If (Records in selection:C76([Job_Forms_Machines:43])>0)
				ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
				For ($i; 1; Records in selection:C76([Job_Forms_Machines:43]))
					OB SET:C1220($operation; "sequence"; [Job_Forms_Machines:43]Sequence:5; "c/c"; [Job_Forms_Machines:43]CostCenterID:4; "plannedqty"; [Job_Forms_Machines:43]Planned_Qty:10)
					
					C_OBJECT:C1216($matl)
					ARRAY OBJECT:C1221($materials; 0)
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$jobform; *)
					QUERY:C277([Job_Forms_Materials:55];  & [Job_Forms_Materials:55]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
					If (Records in selection:C76([Job_Forms_Materials:55])>0)
						ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Real2:18; >)
						For ($j; 1; Records in selection:C76([Job_Forms_Materials:55]))
							OB SET:C1220($matl; "sequence"; [Job_Forms_Materials:55]Sequence:3; "commodity"; [Job_Forms_Materials:55]Commodity_Key:12)
							If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
								OB SET:C1220($matl; "r/m"; [Job_Forms_Materials:55]Raw_Matl_Code:7)
							Else 
								OB REMOVE:C1226($matl; "r/m")
							End if 
							$obj_by_value:=OB Copy:C1225($matl)
							APPEND TO ARRAY:C911($materials; $obj_by_value)
							NEXT RECORD:C51([Job_Forms_Materials:55])
						End for 
						
						OB SET ARRAY:C1227($operation; "materials"; $materials)
					End if 
					
					
					$obj_by_value:=OB Copy:C1225($operation)
					APPEND TO ARRAY:C911($route; $obj_by_value)
					
					NEXT RECORD:C51([Job_Forms_Machines:43])
				End for 
				
				OB SET ARRAY:C1227($Job; "route"; $route)
				
			End if 
			
			
		Else 
			
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			ARRAY LONGINT:C221($_ItemNumber; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY LONGINT:C221($_Qty_Want; 0)
			ARRAY LONGINT:C221($_NumberUp; 0)
			ARRAY TEXT:C222($_OutlineNumber; 0)
			ARRAY DATE:C224($_MAD; 0)
			
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]ItemNumber:7; $_ItemNumber; [Job_Forms_Items:44]ProductCode:3; $_ProductCode; [Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; [Job_Forms_Items:44]NumberUp:8; $_NumberUp; [Job_Forms_Items:44]OutlineNumber:43; $_OutlineNumber; [Job_Forms_Items:44]MAD:37; $_MAD)
				SORT ARRAY:C229($_ItemNumber; $_ProductCode; $_Qty_Want; $_NumberUp; $_OutlineNumber; $_MAD; >)
				
				For ($i; 1; Size of array:C274($_MAD))
					OB SET:C1220($item; "item"; $_ItemNumber{$i}; "cpn"; $_ProductCode{$i}; "wantqty"; $_Qty_Want{$i}; "up"; $_NumberUp{$i}; "outline"; $_OutlineNumber{$i}; "ready"; String:C10($_MAD{$i}; Internal date short special:K1:4))
					$obj_by_value:=OB Copy:C1225($item)
					APPEND TO ARRAY:C911($items; $obj_by_value)
				End for 
				OB SET ARRAY:C1227($Job; "items"; $items)
			End if 
			
			//get route
			C_OBJECT:C1216($operation)
			ARRAY OBJECT:C1221($route; 0)
			
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
			If (Records in selection:C76([Job_Forms_Machines:43])>0)
				ARRAY INTEGER:C220($_Sequence; 0)
				ARRAY TEXT:C222($_CostCenterID; 0)
				ARRAY REAL:C219($_Planned_Qty; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Sequence:5; $_Sequence; [Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID; [Job_Forms_Machines:43]Planned_Qty:10; $_Planned_Qty)
				
				SORT ARRAY:C229($_Sequence; $_CostCenterID; $_Planned_Qty; >)
				
				For ($i; 1; Size of array:C274($_Sequence); 1)
					OB SET:C1220($operation; "sequence"; $_Sequence{$i}; "c/c"; $_CostCenterID{$i}; "plannedqty"; $_Planned_Qty{$i})
					
					C_OBJECT:C1216($matl)
					ARRAY OBJECT:C1221($materials; 0)
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$jobform; *)
					QUERY:C277([Job_Forms_Materials:55];  & [Job_Forms_Materials:55]Sequence:3=$_Sequence{$i})
					If (Records in selection:C76([Job_Forms_Materials:55])>0)
						
						ARRAY REAL:C219($_Real2; 0)
						ARRAY INTEGER:C220($_Sequence_Mat; 0)
						ARRAY TEXT:C222($_Commodity_Key; 0)
						ARRAY TEXT:C222($_Raw_Matl_Code; 0)
						
						SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Real2:18; $_Real2; [Job_Forms_Materials:55]Sequence:3; $_Sequence_Mat; [Job_Forms_Materials:55]Commodity_Key:12; $_Commodity_Key; [Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code)
						
						SORT ARRAY:C229($_Real2; $_Sequence_Mat; $_Commodity_Key; $_Raw_Matl_Code; >)
						
						For ($j; 1; Size of array:C274($_Real2); 1)
							OB SET:C1220($matl; "sequence"; $_Sequence_Mat{$j}; "commodity"; $_Commodity_Key{$j})
							If (Length:C16($_Raw_Matl_Code{$j})>0)
								OB SET:C1220($matl; "r/m"; $_Raw_Matl_Code{$j})
							Else 
								OB REMOVE:C1226($matl; "r/m")
							End if 
							$obj_by_value:=OB Copy:C1225($matl)
							APPEND TO ARRAY:C911($materials; $obj_by_value)
							
						End for 
						
						OB SET ARRAY:C1227($operation; "materials"; $materials)
					End if 
					
					
					$obj_by_value:=OB Copy:C1225($operation)
					APPEND TO ARRAY:C911($route; $obj_by_value)
					
					
				End for 
				
				OB SET ARRAY:C1227($Job; "route"; $route)
				
			End if 
			
			
		End if   // END 4D Professional Services : January 2019 First record
		//get matl as a separate array of matl's
		//C_OBJECT($matl)
		//ARRAY OBJECT($materials;0)
		//QUERY([Job_Forms_Materials];[Job_Forms_Materials]JobForm=$jobform)
		//If (Records in selection([Job_Forms_Materials])>0)
		//ORDER BY([Job_Forms_Materials];[Job_Forms_Materials]Sequence;>)
		//For ($i;1;Records in selection([Job_Forms_Machines]))
		//OB SET($matl;"sequence";[Job_Forms_Materials]Sequence;"commodity";[Job_Forms_Materials]Commodity_Key;"r/m";[Job_Forms_Materials]Raw_Matl_Code)
		//$obj_by_value:=OB Copy($matl)
		//APPEND TO ARRAY($materials;$obj_by_value)
		//NEXT RECORD([Job_Forms_Materials])
		//End for 
		//OB SET ARRAY($Job;"materials";$materials)
		//End if 
		
		$res:=JSON Stringify:C1217($Job; *)
		If ($debug)
			utl_LogIt("init")
			utl_LogIt($res)
			utl_LogIt("show")
		Else 
			$0:=$res
		End if 
		
	Else 
		$res:="404 "+$jobform+" not found"
	End if 
	
End if   //count parameters

REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)