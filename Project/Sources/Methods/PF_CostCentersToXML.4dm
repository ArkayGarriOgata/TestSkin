//%attributes = {}
// -------
// Method: PF_CostCentersToXML   ( ) ->
// By: Mel Bohince @ 08/31/17, 16:29:39
// Description
// create an XML file in the format that PrintFlow will accept
// ----------------------------------------------------
// Modified by: Mel Bohince (10/10/17) Attribute names are casesensitive, fixed CostCenters and CostCenter

//<?xml version="1.0"?>
//<PrintFlowData Action="Create"Sender="Administrator"Machine="WIN-QAEA4RO0N0B"ProgramName="PrintFlowXMLCsharp.exe  2.0.0.0"Comment="Creating cost centers"Version="Prism version 123"ChangeDate="2017-08-25T14:56-04:00">
//  <CostCenters Code="CostCenters">
//    <CostCenter Code="210"Action="Create"Description="Komori 6 Color Press"Class="Normal"Type="Press"Site="Chicago"/>
//  </CostCenters>
//</PrintFlowData>

C_TEXT:C284($now; $docName; $groupLocation; $elementRef; $site)

READ ONLY:C145([Cost_Centers:27])

$now:=TS_ISO_String_TimeStamp
$now:=Change string:C234($now; "T"; 11)

$docName:="CostCenters_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xml"
$docName:=util_DocumentPath("get")+$docName

$elementRef:=DOM Create XML Ref:C861("PrintFlowData")
ARRAY TEXT:C222($AttrName; 0)
ARRAY TEXT:C222($AttrVal; 0)
APPEND TO ARRAY:C911($AttrName; "Action")
APPEND TO ARRAY:C911($AttrVal; "Create")

APPEND TO ARRAY:C911($AttrName; "Sender")
APPEND TO ARRAY:C911($AttrVal; "Administrator")

APPEND TO ARRAY:C911($AttrName; "Machine")
APPEND TO ARRAY:C911($AttrVal; "WIN-QAEA4RO0N0B")

APPEND TO ARRAY:C911($AttrName; "ProgramName")
APPEND TO ARRAY:C911($AttrVal; "PrintFlowXMLCsharp.exe  2.0.0.0")

APPEND TO ARRAY:C911($AttrName; "Comment")
APPEND TO ARRAY:C911($AttrVal; "Creating cost centers")

APPEND TO ARRAY:C911($AttrName; "Version")
APPEND TO ARRAY:C911($AttrVal; "Prism version 123")

APPEND TO ARRAY:C911($AttrName; "ChangeDate")
APPEND TO ARRAY:C911($AttrVal; $now)

DOM SET XML ATTRIBUTE:C866($elementRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})

$ref:=DOM Append XML child node:C1080($elementRef; XML ELEMENT:K45:20; "<CostCenters></CostCenters>")
DOM SET XML ATTRIBUTE:C866($ref; "Code"; "CostCenters")

QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214)
DISTINCT VALUES:C339([Cost_Centers:27]cc_Group:2; $aMachineGroup)


C_LONGINT:C283($group; $numGroups; $cc; $numCC)
$numGroups:=Size of array:C274($aMachineGroup)

uThermoInit($numGroups; "Exporting CostCenters")
For ($group; 1; $numGroups)
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214; *)
	QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]cc_Group:2=$aMachineGroup{$group})
	$numCC:=Records in selection:C76([Cost_Centers:27])
	If ($numCC>1)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]ID:1; >)
			SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $aMembers)
			FIRST RECORD:C50([Cost_Centers:27])
			
			
		Else 
			
			DISTINCT VALUES:C339([Cost_Centers:27]ID:1; $aMembers)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		If (Position:C15("2"; [Cost_Centers:27]CompanyID:6)>0)
			$groupLocation:="Roanoke"
		Else 
			$groupLocation:="Unknown"
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($cc; 1; $numCC)
				//<CostCenter Code="100" Action="Create" Description="Files In" Class="CriticalDateIn" Type="Pre Press" Site="Chicago" />
				
				$ccRef:=DOM Append XML child node:C1080($ref; XML ELEMENT:K45:20; "<CostCenter />")
				
				ARRAY TEXT:C222($AttrName; 0)
				ARRAY TEXT:C222($AttrVal; 0)
				APPEND TO ARRAY:C911($AttrName; "Code")
				APPEND TO ARRAY:C911($AttrVal; [Cost_Centers:27]ID:1)
				
				APPEND TO ARRAY:C911($AttrName; "Action")
				APPEND TO ARRAY:C911($AttrVal; "Create")
				
				APPEND TO ARRAY:C911($AttrName; "Description")
				APPEND TO ARRAY:C911($AttrVal; [Cost_Centers:27]Description:3)
				
				APPEND TO ARRAY:C911($AttrName; "Class")
				If (Position:C15([Cost_Centers:27]ID:1; <>GLUERS)=0)
					$class:="Normal"
				Else 
					$class:="CriticalDateOut"
				End if 
				APPEND TO ARRAY:C911($AttrVal; $class)
				
				APPEND TO ARRAY:C911($AttrName; "Type")
				APPEND TO ARRAY:C911($AttrVal; Substring:C12([Cost_Centers:27]cc_Group:2; 4))
				
				If (Position:C15("2"; [Cost_Centers:27]CompanyID:6)>0)
					$site:="Roanoke"
				Else 
					$site:="Unknown"
				End if 
				APPEND TO ARRAY:C911($AttrName; "Site")
				APPEND TO ARRAY:C911($AttrVal; $site)
				DOM SET XML ATTRIBUTE:C866($ccRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6})
				
				NEXT RECORD:C51([Cost_Centers:27])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_CompanyID; 0)
			ARRAY TEXT:C222($_cc_Group; 0)
			ARRAY TEXT:C222($_ID; 0)
			ARRAY TEXT:C222($_Description; 0)
			
			
			SELECTION TO ARRAY:C260([Cost_Centers:27]CompanyID:6; $_CompanyID; [Cost_Centers:27]cc_Group:2; $_cc_Group; [Cost_Centers:27]ID:1; $_ID; [Cost_Centers:27]Description:3; $_Description)
			
			
			For ($cc; 1; $numCC; 1)
				
				$ccRef:=DOM Append XML child node:C1080($ref; XML ELEMENT:K45:20; "<CostCenter />")
				ARRAY TEXT:C222($AttrName; 0)
				ARRAY TEXT:C222($AttrVal; 0)
				APPEND TO ARRAY:C911($AttrName; "Code")
				APPEND TO ARRAY:C911($AttrVal; $_ID{$cc})
				APPEND TO ARRAY:C911($AttrName; "Action")
				APPEND TO ARRAY:C911($AttrVal; "Create")
				APPEND TO ARRAY:C911($AttrName; "Description")
				APPEND TO ARRAY:C911($AttrVal; $_Description{$cc})
				APPEND TO ARRAY:C911($AttrName; "Class")
				
				If (Position:C15($_ID{$cc}; <>GLUERS)=0)
					$class:="Normal"
				Else 
					$class:="CriticalDateOut"
				End if 
				APPEND TO ARRAY:C911($AttrVal; $class)
				APPEND TO ARRAY:C911($AttrName; "Type")
				APPEND TO ARRAY:C911($AttrVal; Substring:C12($_cc_Group{$cc}; 4))
				
				If (Position:C15("2"; $_CompanyID{$cc})>0)
					$site:="Roanoke"
				Else 
					$site:="Unknown"
				End if 
				
				APPEND TO ARRAY:C911($AttrName; "Site")
				APPEND TO ARRAY:C911($AttrVal; $site)
				DOM SET XML ATTRIBUTE:C866($ccRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6})
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		$ccRef:=DOM Append XML child node:C1080($ref; XML ELEMENT:K45:20; "<CostCenter />")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Code")
		$groupId:=String:C10(Num:C11(Substring:C12($aMachineGroup{$group}; 1; 2)); "000")
		APPEND TO ARRAY:C911($AttrVal; $groupId)
		
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "Description")
		APPEND TO ARRAY:C911($AttrVal; "Parallel "+Substring:C12($aMachineGroup{$group}; 4))
		
		APPEND TO ARRAY:C911($AttrName; "Class")
		APPEND TO ARRAY:C911($AttrVal; "Parallel")
		
		APPEND TO ARRAY:C911($AttrName; "Type")
		APPEND TO ARRAY:C911($AttrVal; Substring:C12($aMachineGroup{$group}; 4))
		
		APPEND TO ARRAY:C911($AttrName; "Site")
		APPEND TO ARRAY:C911($AttrVal; $groupLocation)
		DOM SET XML ATTRIBUTE:C866($ccRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6})
		
		$memRef:=DOM Append XML child node:C1080($ccRef; XML ELEMENT:K45:20; "<Members></Members>")
		
		$numMembers:=Size of array:C274($aMembers)
		For ($m; 1; $numMembers)
			$memChilRef:=DOM Append XML child node:C1080($memRef; XML ELEMENT:K45:20; "<Member />")
			DOM SET XML ATTRIBUTE:C866($memChilRef; "Action"; "Create"; "Code"; $aMembers{$m})
		End for 
		
	Else   //just one machine in group
		$ccRef:=DOM Append XML child node:C1080($ref; XML ELEMENT:K45:20; "<CostCenter />")
		
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Code")
		APPEND TO ARRAY:C911($AttrVal; [Cost_Centers:27]ID:1)
		
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "Description")
		APPEND TO ARRAY:C911($AttrVal; [Cost_Centers:27]Description:3)
		
		APPEND TO ARRAY:C911($AttrName; "Class")
		If (Position:C15([Cost_Centers:27]ID:1; <>GLUERS)=0)
			$class:="Normal"
		Else 
			$class:="CriticalDateOut"
		End if 
		APPEND TO ARRAY:C911($AttrVal; $class)
		
		APPEND TO ARRAY:C911($AttrName; "Type")
		APPEND TO ARRAY:C911($AttrVal; Substring:C12([Cost_Centers:27]cc_Group:2; 4))
		
		If (Position:C15("2"; [Cost_Centers:27]CompanyID:6)>0)
			$site:="Roanoke"
		Else 
			$site:="Unknown"
		End if 
		APPEND TO ARRAY:C911($AttrName; "Site")
		APPEND TO ARRAY:C911($AttrVal; $site)
		DOM SET XML ATTRIBUTE:C866($ccRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6})
		
	End if 
	
	uThermoUpdate($group)
End for 

uThermoClose

DOM EXPORT TO FILE:C862($elementRef; $docName)
If (ok=1)
	BEEP:C151
Else 
	BEEP:C151
	BEEP:C151
End if 
DOM CLOSE XML:C722($elementRef)

