//%attributes = {"publishedWeb":true}
//  ViewSetter
//mod 9/26/94 for Phy inv
//mod 10/13/94 chip
//12/6/94 
//chip 12/9/94
//`boosted memory 4/4/95, on site
//`boosted memory 7/7/95, on site
//•2/28/97 cs upr 1858 removed old Pi stuff PI
//• 1/29/98 cs added 50k to machine tickets report to stop crashing
//• 4/8/98 cs added check for empty string 'sCommkey'
//default minimum memory for process = ◊lMinMemPart
//• 6/22/98 cs moved modify actuals so that process is better named for user
// Modified by: Mel Bohince (3/23/17) up stack to at least <>lMidMemPart

C_LONGINT:C283($rptID; $1; $0; $stack)  //viewSetter(iMode;»[file];{report layout})
C_POINTER:C301($2)

<>iMode:=$1
<>filePtr:=$2
sFile:=Table name:C256(<>filePtr)

If (False:C215)  //template for pre-query
	<>PassThrough:=True:C214
	QUERY:C277([zz_control:1])
	CREATE SET:C116([zz_control:1]; "◊PassThroughSet")
End if 

If (Count parameters:C259<3)
	$what:=ViewSetterAction($1; "")
Else 
	$what:=ViewSetterAction($1; $3)
End if 
//app_Log_Usage ("log";"ViewSetter";sFile+"-"+$what)

If (<>filePtr=(->[Estimates:17]))  // Modified by: Mel Bohince (3/23/17) 
	$stack:=<>lBigMemPart
Else 
	$stack:=<>lMidMemPart
End if 

Case of 
	: ((<>filePtr=(->[Customers_Orders:40])) & ($1=1))
		uSpawnProcess("ORD_NewOrder"; $stack; "Enter:"+sFile)
		
	: ((<>filePtr=(->[Jobs:15])) & ($1=1))
		uSpawnProcess("JOB_NewJob"; $stack; "Enter:"+sFile)
		
	: ((<>filePtr=(->[Job_Forms_Machine_Tickets:61])) & ($1=1))
		uSpawnProcess("mMachTick"; $stack; "Enter:"+sFile)  //• 1/29/98 cs added 50k to process to stop crashing
		
	: ($1=1)
		$0:=uSpawnProcess("doNewRecord"; $stack; "New:"+sFile)
	: ($1=2)
		$0:=uSpawnProcess("doModifyRecord"; $stack; "Mod:"+sFile)
	: ($1=3)
		$0:=uSpawnProcess("doReviewRecord"; $stack; "Rev:"+sFile)
	: ($1=4)
		$0:=uSpawnProcess("doDeleteRecord"; $stack; "Del:"+sFile)
		
	: ($1=5)
		Case of 
			: (<>filePtr=(->[Estimates:17]))
				uSpawnProcess("doCopyEstimate"; $stack; "Copy:Estimate")
		End case 
		
	: ($1=96)  //department reports
		uSpawnProcess("DeptList"; 0; "Printing Departments"; True:C214; True:C214)
	: ($1=97)
		uSpawnProcess("DeptAndPos"; 0; "Printing Departments"; True:C214; True:C214)
		
	: (Count parameters:C259<3)
		BEEP:C151
		ALERT:C41("Must specify the report for viewSetter")
		
	: ($1=7)
		<>whichRpt:=$3
		$rptID:=uSpawnProcess("doRptRecords"; <>lBigMemPart; "Rpt:"+$3)  //phone UPR quote crashing, increased memory to 150k      
		
	: ($1=30)
		<>whichRpt:=$3
		$rptID:=uSpawnProcess("doRMRptRecords"; <>lBigMemPart; "Rpt:"+$3)
		
	: ($1=35)
		<>whichRpt:=$3
		
		If (<>WhichRpt="Month End@")
			$RptID:=uSpawnProcess("MthEndSuite_Reports"; <>lBigMemPart; "Month End Suite Reports"; True:C214; False:C215)  //stack was 450000        
		Else 
			$rptID:=uSpawnProcess("doFGRptRecords"; <>lBigMemPart; "Rpt:"+$3)
		End if 
		
	: ($1=40)
		<>whichRpt:=$3
		ALERT:C41("These Reports are no longer functional.")
		//$rptID:=uSpawnProcess ("doBkRptRecords";◊lMinMemPart;"Rpt:"+$3)
		
	: ($1=50)
		<>whichRpt:=$3
		$rptID:=uSpawnProcess("doJobRptRecords"; <>lBigMemPart; "Rpt:"+$3)
		
	: ($1=78)
		<>whichRpt:=$3  //•031897  MLB  reduce process size
		$rptID:=uSpawnProcess("doRptNoSearch"; <>lBigMemPart; "Rpt:"+$3)
End case 