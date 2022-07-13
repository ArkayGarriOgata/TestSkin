//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/20/15, 16:10:35
// ----------------------------------------------------
// Method: RM_AQ_Coating_Usage
// Description
// epa reporting the estimated coating used by press
//
// ----------------------------------------------------
//this would be better if we could depend on the target coatings always having a comkey 03-WB Coating, Inlin
//SET MENU BAR(<>DefaultMenu)
//All 470# a drum with exception of  841254 is 460#
// Modified by: Mel Bohince (6/6/17) forget it, just count PH77144 plates

C_DATE:C307(dDateBegin; dDateEnd; $1; $2)
C_LONGINT:C283($issuedQty)

If (False:C215)  // Modified by: Mel Bohince (6/6/17) 
	C_LONGINT:C283($i; $numFound; $ttlSheets; $hit; $col; $cc)
	
	
	ARRAY TEXT:C222($aCC_ID; 0)
	ARRAY TEXT:C222($aCC_Name; 0)
	
	ARRAY TEXT:C222($aCC; 0)
	ARRAY LONGINT:C221($aSheets; 0)
	ARRAY REAL:C219($aAllocation; 0)
	
	ARRAY TEXT:C222($aRM; 0)
	ARRAY REAL:C219($aPounds; 0)
	ARRAY LONGINT:C221($aPoundCalcd; 0)
End if 

If (Count parameters:C259=0)
	$distributionList:=Email_WhoAmI
	dDateBegin:=Date:C102(Request:C163("Based on what date?"; String:C10(Current date:C33; Internal date short:K1:7)))
	If (ok=0)
		dDateBegin:=!00-00-00!
	End if 
	dDateEnd:=Add to date:C393(dDateBegin; 0; 1; -1)
	
Else 
	dDateBegin:=$1
	dDateEnd:=$2
	$distributionList:=$3
End if 

If (dDateBegin>!00-00-00!)
	Begin SQL
		select sum(qty) from Raw_Materials_Transactions where upper(Xfer_Type) = 'ISSUE'
		and upper(Raw_Matl_Code) = 'PH77144'
		and XferDate between :dDateBegin and :dDateEnd
		into :$issuedQty
	End SQL
	$issuedQty:=Abs:C99($issuedQty)
	
	$subject:="PH77144 usage from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)
	
	$prehead:="Cyrel plate usage from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)+" based on R/M issues."
	
	$tBody:="<p style=\"padding:0 1em;\">There were "+String:C10($issuedQty)+" PH77144 plates used from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)+" based on R/M issues to jobs.</p>"
	
	$tBody:=$tBody+"<p style=\"padding:0 1em;\">ref: RM_AQ_Coating_Usage(dDateBegin;dDateEnd), also available from the R/M palette Report popup as report called PH77144 Usage</p>"
	
	Email_html_table($subject; $prehead; $tBody; 960; $distributionList)
	
	If (False:C215)  // Modified by: Mel Bohince (6/6/17) 
		// press names cause i hate joins
		ARRAY TEXT:C222($aCC_ID; 0)
		ARRAY TEXT:C222($aCC_Name; 0)
		ARRAY TEXT:C222($aCC; 0)
		ARRAY LONGINT:C221($aSheets; 0)
		ARRAY TEXT:C222($aRM; 0)
		ARRAY REAL:C219($aPounds; 0)
		
		Begin SQL
			SELECT ID, Description from Cost_Centers where cc_Group like '20%' and ProdCC = true order by ID
			into :$aCC_ID, :$aCC_Name
		End SQL
		
		
		//Begin SQL
		//SELECT CostCenterID as PRESS, (sum(Good_Units) + sum(Waste_Units)) as SHEETS
		//from Job_Forms_Machine_Tickets
		//where DateEntered between :dDateBegin and :dDateEnd and
		//CostCenterID in ('417', '418', '419', '420', '421') and
		//JobForm in
		//(select distinct(JobForm) from Job_Forms_Materials where upper(Raw_Matl_Code) in ('841254', 'AQ126', 'AQ17-1', 'AQ223-2', 'AQ25-2', 'AQ703') and JobForm > '95000.00') 
		//group by CostCenterID
		//order by CostCenterID
		//into :$aCC, :$aSheets
		//End SQL
		$targetCC:="'"
		For ($press; 1; Size of array:C274(<>aPRESSES))
			$targetCC:=$targetCC+<>aPRESSES{$press}+"', "
		End for 
		$targetCC:=Substring:C12($targetCC; 1; Length:C16($targetCC)-2)
		
		Begin SQL
			SELECT CostCenterID as PRESS, (sum(Good_Units) + sum(Waste_Units)) as SHEETS
			from Job_Forms_Machine_Tickets
			where DateEntered between :dDateBegin and :dDateEnd and
			CostCenterID in (:$targetCC) and
			JobForm in
			(select distinct(JobForm) from Job_Forms_Materials where upper(Raw_Matl_Code) in ('841254', 'AQ126', 'AQ17-1', 'AQ223-2', 'AQ25-2', 'AQ703') and JobForm > '95000.00') 
			group by CostCenterID
			order by CostCenterID
			into :$aCC, :$aSheets
		End SQL
		
		$numFound:=Size of array:C274($aCC)
		$ttlSheets:=0
		For ($i; 1; $numFound)  //get total sheets and sub name for cc#
			$hit:=Find in array:C230($aCC_ID; $aCC{$i})
			If ($hit>-1)
				$aCC{$i}:=$aCC{$i}+"-"+$aCC_Name{$hit}
			End if 
			$ttlSheets:=$ttlSheets+$aSheets{$i}
		End for 
		
		ARRAY REAL:C219($aAllocation; $numFound)
		For ($i; 1; $numFound)
			$aAllocation{$i}:=Round:C94($aSheets{$i}/$ttlSheets; 4)
		End for 
		//$alloc:=0
		//For ($i;1;$numFound)
		//$alloc:=$alloc+$aAllocation{$i}
		//End for 
		//ASSERT($alloc=1;"Total allocation not one")
		
		
		
		Begin SQL
			select Raw_Matl_Code, sum(Qty) 
			from Raw_Materials_Transactions 
			where (upper(Xfer_Type) = 'RECEIPT' or upper(Xfer_Type)  = 'RETURN') and 
			(XferDate between :dDateBegin and :dDateEnd) and 
			(upper(Raw_Matl_Code) in ('841254', 'AQ126', 'AQ17-1', 'AQ223-2', 'AQ25-2', 'AQ703')) 
			group by Raw_Matl_Code 
			order by Raw_Matl_Code 
			into :$aRM, :$aPounds
		End SQL
		
		ARRAY LONGINT:C221($aPoundCalcd; Size of array:C274($aRM))
		
		$tBody:=""
		$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$r:="</td></tr>"+Char:C90(13)
		
		//$b:=""
		//$t:=Char(9)
		//$r:=Char(13)
		
		$tBody:=$tBody+$b+"RM Code"
		For ($col; 1; Size of array:C274($aRM))
			$tBody:=$tBody+$t+$aRM{$col}
		End for 
		$tBody:=$tBody+$t+"Press Ttl"+$t+"%"+$t+"Sheets"+$r
		
		
		
		$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
		$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
		
		//$b:=""
		//$t:=Char(9)
		
		For ($cc; 1; Size of array:C274($aCC))
			$tBody:=$tBody+$b+$aCC{$cc}
			$ccTotal:=0
			For ($col; 1; Size of array:C274($aRM))
				$distribution:=Round:C94($aPounds{$col}*$aAllocation{$cc}; 0)  // hide the roundoff error
				$tBody:=$tBody+$t+String:C10($distribution; "#,###,###")
				$aPoundCalcd{$col}:=$aPoundCalcd{$col}+$distribution
				$ccTotal:=$ccTotal+$distribution
			End for 
			$tBody:=$tBody+$t+String:C10($ccTotal; "###,###,##0")+$t+String:C10(Round:C94(100*$aAllocation{$cc}; 0))+$t+String:C10($aSheets{$cc}; "###,###,##0")+$r
		End for 
		
		
		$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		//
		//$b:=""
		//$t:=Char(9)
		
		$tBody:=$tBody+$b+"TTL LBS"
		$grandTotal:=0
		For ($col; 1; Size of array:C274($aRM))
			$tBody:=$tBody+$t+String:C10($aPoundCalcd{$col}; "#,###,###")
			$grandTotal:=$grandTotal+$aPoundCalcd{$col}
		End for 
		$tBody:=$tBody+$t+String:C10($grandTotal; "###,###,##0")+$t+"100"+$t+String:C10($ttlSheets; "###,###,##0")+$r
		
		//utl_LogIt ("init")
		//utl_LogIt ($tBody)
		//utl_LogIt ("show")
		$subject:="Water Base Inline Coating usage from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)
		
		$prehead:="Water Base Inline Coating usage from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)+" based on R/M receipts and coated sheets thru each press."
		
		Email_html_table($subject; $prehead; $tBody; 960; $distributionList)
	End if 
	
Else   //no basis date
	BEEP:C151
End if   //got a target date
