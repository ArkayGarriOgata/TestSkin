//%attributes = {"publishedWeb":true}
//(p) gtruncCustName
//$1 cust ame to truncate
//$2 pointer to array to fill with cust name truncates
//Last mod - 1/11/95
//upr 1404 1/19/95 add 'Records'
//•2/11/97 cs - Mail request Jim B. Names like "E.B. White" would pull many hits
//  modify code so that numbe2r of hits is reduced/eliminated 
//•2/17/97 cs modification so that names which contain embedded apostrophes
// (not those that are possesive) can be located correctly

C_LONGINT:C283($SpaceLoc)
C_BOOLEAN:C305($Skip)
C_TEXT:C284($name; $1; $ParseStr)
C_POINTER:C301($2)

READ ONLY:C145([y_Customers_Name_Exclusions:76])

$SpaceLoc:=0
$Name:=$1

Repeat 
	$SpaceLoc:=Position:C15(" "; $Name)
	
	Case of 
		: ($SpaceLoc>0)
			$ParseStr:=Substring:C12($Name; 1; $SpaceLoc-1)  //save off first part of name
			$Name:=Substring:C12($Name; $SpaceLoc+1; Length:C16($Name))  //truncate name to exclude above removed string
		: ($SpaceLoc<=0) & (Length:C16($Name)>0)
			$ParseStr:=$Name
			$Name:=""
		Else 
			$ParseStr:=""
			$Name:=""
	End case 
	
	If ($ParseStr#"")  //if there is a string to work with
		$Skip:=False:C215
		If (uOccurs("."; $ParseStr)=1)  //•2/11/97 determine if a period exists more than once
			$ParseStr:=Replace string:C233($ParseStr; "."; "")  //remove extraneous characters before search
		Else 
			//do nothing, if multiple periods, do not strip      
		End if 
		//end mods 2/11/97    
		
		//• 2/17/97 simple removal of apostrophes fails...
		// names like "l'oreal" get screwed up and are not correctly found.
		// so.. removed lne below and replaced with code in this modificatoin block
		//$ParseStr:=Replace string($ParseStr;"'";"")
		$Pos:=Position:C15("'"; $ParseStr)
		If ($Pos#(Length:C16($ParseStr)-1)) & ($Pos>0)  //if the apostrophe is NOT for an "'s"
			If (uOccurs("'"; $ParseStr)>1)
				$ParseStr:=Substring:C12($Parsestr; 1; $Pos)+Replace string:C233(Substring:C12($ParseStr; $Pos+1); "'"; "")
			End if 
		Else   //possesive or no apostrophe at all
			$ParseStr:=Replace string:C233($ParseStr; "'"; "")
		End if 
		//2/ 17/97mods    
		$ParseStr:=Replace string:C233($ParseStr; " "; "")  //replace empty spaces
		$ParseStr:=Replace string:C233($ParseStr; ","; "")  //replace commas.
		$ParseStr:=Replace string:C233($ParseStr; "!"; "")  //replace exclemation marks
		QUERY:C277([y_Customers_Name_Exclusions:76]; [y_Customers_Name_Exclusions:76]Name:1=$Parsestr)
		If (Records in selection:C76([y_Customers_Name_Exclusions:76])#0)
			$Skip:=True:C214
		End if 
		
		If (Not:C34($Skip))
			INSERT IN ARRAY:C227($2->; 1)
			$2->{1}:=$ParseStr
		End if 
	End if 
Until ($ParseStr="")