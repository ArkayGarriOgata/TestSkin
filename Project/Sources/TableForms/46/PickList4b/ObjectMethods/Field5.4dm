//mlb mk stuff 082098
//mlb mk stuff 082598 tweak for multiple jobs
//•UPR 1981 100598 mlb oops, didn't use the set, took 2 months to discover the bug
//•090802  mlb  don't restrict MK jobs• 
C_LONGINT:C283($i; $hit; $numLocations; $runningTotal)
C_TEXT:C284(sStock)
C_TEXT:C284($r)
$r:=Char:C90(13)
MESSAGES OFF:C175
$outline:=FG_getOutline([Customers_ReleaseSchedules:46]ProductCode:11)
$case_cnt:=PK_getCaseCount($outline)
$case_skid:=PK_getCasesPerSkid($outline)
$Suggest:=" Suggest: "
If ($case_cnt#0)
	$Suggest:=$Suggest+String:C10(Round:C94([Customers_ReleaseSchedules:46]Sched_Qty:6/$case_cnt; 1))+" cases  "
End if 
$skid_cnt:=PK_getSkidCount($outline)
If ($skid_cnt#0)
	$Suggest:=$Suggest+String:C10(Round:C94([Customers_ReleaseSchedules:46]Sched_Qty:6/$skid_cnt; 1))+" skids"
End if 

$numLocations:=FGL_InventoryPick

$runningTotal:=0
$enough:=("#"*58)
$marker_set:=False:C215
$fill_in_the_blanks:=txt_Pad("....."; " "; -1; 7)+txt_Pad("....."; " "; -1; 6)+txt_Pad("......."; " "; -1; 8)
sStock:="Packing Spec: "+String:C10($case_cnt)+"/case  "+String:C10($case_skid)+"cases/skid; = "+String:C10($skid_cnt)+"/skid; "+$Suggest+$r+$r
sStock:=sStock+txt_Pad("CUST#"; " "; 1; 6)+txt_Pad("JOBIT"; " "; 1; 13)+txt_Pad("GLUED"; " "; 1; 10)+txt_Pad("LOCATION"; " "; 1; 15)+txt_Pad("QTY-OH"; " "; -1; 11)+txt_Pad("RUN-TTL"; " "; -1; 11)+txt_Pad("CASES"; " "; -1; 7)+txt_Pad("PACK"; " "; -1; 6)+txt_Pad("#PICKED"; " "; -1; 8)+$r
sStock:=sStock+txt_Pad("-----"; " "; 1; 6)+txt_Pad("-----------"; " "; 1; 13)+txt_Pad("--------"; " "; 1; 10)+txt_Pad("------------"; " "; 1; 15)+txt_Pad("------"; " "; -1; 11)+txt_Pad("-------"; " "; -1; 11)+txt_Pad("-----"; " "; -1; 7)+txt_Pad("-----"; " "; -1; 6)+txt_Pad("-------"; " "; -1; 8)+$r+$r
For ($i; 1; $numLocations)
	$runningTotal:=$runningTotal+aQty{$i}
	
	sStock:=sStock+txt_Pad(aCustid{$i}; " "; 1; 6)+txt_Pad(aJobit{$i}; " "; 1; 13)+txt_Pad(String:C10(aGlued{$i}; Internal date short special:K1:4); " "; 1; 10)+txt_Pad(aLocation{$i}; "."; 1; 15)+txt_Pad(String:C10(aQty{$i}; "###,###,##0"); "."; -1; 11)+txt_Pad(String:C10($runningTotal; "###,###,##0"); "."; -1; 11)+$fill_in_the_blanks+$r+$r
	If (Not:C34($marker_set))
		Case of 
			: ($runningTotal=[Customers_ReleaseSchedules:46]Sched_Qty:6)
				sStock:=sStock+$enough+" ENOUGH!"+$r+$r
				$marker_set:=True:C214
				
			: ($runningTotal>[Customers_ReleaseSchedules:46]Sched_Qty:6)
				sStock:=sStock+$enough+" MORE THAN ENOUGH! "+String:C10($runningTotal-[Customers_ReleaseSchedules:46]Sched_Qty:6)+" over"+$r+$r
				$marker_set:=True:C214
		End case 
	End if 
End for 
// ******* Verified  - 4D PS - January  2019 ********

If (False:C215)  // ([ReleaseSchedule]CustID="00125")`•090802  mlb  don't restrict MK jobs
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_ReleaseSchedules:46]OrderLine:4)
	If (Records in selection:C76([Job_Forms_Items:44])=1)
		QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[Job_Forms_Items:44]Jobit:4)
	Else   //multiple linked jobs
		CREATE SET:C116([Finished_Goods_Locations:35]; "Candidates")
		CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "Linked")
		While (Not:C34(End selection:C36([Job_Forms_Items:44])))
			USE SET:C118("Candidates")
			
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[Job_Forms_Items:44]Jobit:4)
			CREATE SET:C116([Finished_Goods_Locations:35]; "theseToo")
			UNION:C120("theseToo"; "Linked"; "Linked")
			
			NEXT RECORD:C51([Job_Forms_Items:44])
		End while 
		USE SET:C118("Linked")  //•100598 mlb oops
		CLEAR SET:C117("Candidates")
		CLEAR SET:C117("Linked")
		CLEAR SET:C117("theseToo")
	End if 
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
End if 

// ******* Verified  - 4D PS - January 2019 (end) *********

If (False:C215)
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]Location:2; >)
End if 
