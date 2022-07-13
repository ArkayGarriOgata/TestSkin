//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/24/11, 15:07:05
// ----------------------------------------------------
// Method: Batch_AccessViolations
// Description
// send email of users trying to access customer's records without permission
// ----------------------------------------------------
// Modified by: Mel Bohince (3/25/15) html'ize the mailing

C_TEXT:C284($custid; $r; $b; $t)
$r:="</td></tr>"+Char:C90(13)
READ WRITE:C146([x_Usage_Stats:65])
READ ONLY:C145([Users:5])

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	QUERY:C277([x_Usage_Stats:65]; [x_Usage_Stats:65]tablenumber:6#-2)
	//distributionList:="mel.bohince@arkay.com"
	//QUERY([x_Usage_Stats];[x_Usage_Stats]when>"2015-03-19@")
	
	ORDER BY:C49([x_Usage_Stats:65]; [x_Usage_Stats:65]who:2; >; [x_Usage_Stats:65]when_:3; >)
	
	
	$who:=""
	$tableData:=""
	
	While (Not:C34(End selection:C36([x_Usage_Stats:65])))
		If ($who#[x_Usage_Stats:65]who:2)  //set up for next user
			$who:=[x_Usage_Stats:65]who:2
			$b:="<tr style=\"background-color:#fefcff\"><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
			$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
			$tableData:=$tableData+$b+$who+$t+" "+$t+" "+$t+" "+$r
			$b:="<tr style=\"background-color:#fff\"><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
			$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
		End if 
		$pos:=Position:C15("-"; [x_Usage_Stats:65]what:4)+2
		$custid:=Substring:C12([x_Usage_Stats:65]what:4; $pos; 5)
		$tableData:=$tableData+$b+" "+$t+[x_Usage_Stats:65]when_:3+$t+CUST_getName($custid)+$t+[x_Usage_Stats:65]description:5+$r
		
		[x_Usage_Stats:65]tablenumber:6:=-2
		SAVE RECORD:C53([x_Usage_Stats:65])
		NEXT RECORD:C51([x_Usage_Stats:65])
	End while 
	REDUCE SELECTION:C351([Users:5]; 0)
	
Else 
	
	QUERY:C277([x_Usage_Stats:65]; [x_Usage_Stats:65]tablenumber:6#-2)
	
	APPLY TO SELECTION:C70([x_Usage_Stats:65]; [x_Usage_Stats:65]tablenumber:6:=-2)
	SELECTION TO ARRAY:C260([x_Usage_Stats:65]who:2; $_Who; [x_Usage_Stats:65]what:4; $_what; [x_Usage_Stats:65]when_:3; $_When; [x_Usage_Stats:65]description:5; $_description)
	
	SORT ARRAY:C229($_Who; $_When; $_what; $_description; >)
	
	$who:=""
	$tableData:=""
	
	For ($i; 1; Size of array:C274($_Who); 1)
		If ($who#$_Who{$i})  //set up for next user
			$who:=$_Who{$i}
			$b:="<tr style=\"background-color:#fefcff\"><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
			$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
			$tableData:=$tableData+$b+$who+$t+" "+$t+" "+$t+" "+$r
			$b:="<tr style=\"background-color:#fff\"><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
			$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
		End if 
		$pos:=Position:C15("-"; $_what{$i})+2
		$custid:=Substring:C12($_what{$i}; $pos; 5)
		$tableData:=$tableData+$b+" "+$t+$_When{$i}+$t+CUST_getName($custid)+$t+$_description{$i}+$r
	End for 
	
	REDUCE SELECTION:C351([Users:5]; 0)
	
End if   // END 4D Professional Services : January 2019 First record

If (Length:C16($tableData)>1)  //& (False)
	$b:="<tr><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$columnHeadings:=$b+"USER            "+$t+"WHEN            "+$t+"CUSTOMER       "+$t+"DESCRIPTION         "+$r
	$tableData:=$columnHeadings+$tableData
	$prehead:="Following are users attempting to access customers' records without permission: "
	Email_html_table("Access Violations"; $prehead; $tableData; 600; distributionList)
End if 
//
