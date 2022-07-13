//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceStateChange(event) -> 
//@author mlb - 2/28/03  16:45
// • mel (5/25/04, 16:18:38) stop emailing the purge letter
// SetObjectProperties, Mark Zinke (5/16/13)

C_TEXT:C284($event; $1)
C_DATE:C307($2)
C_BOOLEAN:C305($0; $success)

$event:=$1
$success:=True:C214

Case of 
	: ($event="Submit")
		//[FG_Specification]DateSubmitted:=$2
		//don't allow backdating
		If (4d_Current_time<=?13:00:00?)  // • mel (2/25/04, 12:34:25)
			[Finished_Goods_Specifications:98]DateSubmitted:5:=4D_Current_date
		Else 
			[Finished_Goods_Specifications:98]DateSubmitted:5:=4D_Current_date+1
		End if 
		Case of   // • mel (2/25/04, 12:34:25)
			: (Day number:C114([Finished_Goods_Specifications:98]DateSubmitted:5)=7)  //saturday
				[Finished_Goods_Specifications:98]DateSubmitted:5:=[Finished_Goods_Specifications:98]DateSubmitted:5+2
			: (Day number:C114([Finished_Goods_Specifications:98]DateSubmitted:5)=1)  //sundaty
				[Finished_Goods_Specifications:98]DateSubmitted:5:=[Finished_Goods_Specifications:98]DateSubmitted:5+1
		End case 
		
		bSubmit:=1
		//FG_PrepServiceEmail   ` • mel (5/25/04, 16:18:38) stop emailing the purge letter
		
	: ($event="Preflight-Pass")
		[Finished_Goods_Specifications:98]PreflightBy:58:=<>zResp
		[Finished_Goods_Specifications:98]DatePreflighted:85:=4D_Current_date
		cbPFfail:=0
		
	: ($event="Preflight-Fail")
		[Finished_Goods_Specifications:98]PreflightBy:58:=<>zResp
		[Finished_Goods_Specifications:98]DatePreflighted:85:=4D_Current_date
		cbPFpass:=0
		[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!
		bSubmit:=0
		[Finished_Goods_Specifications:98]CommentsFromImaging:20:="Preflight Failed "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromImaging:20
		
		
	: ($event="PrepDone")
		[Finished_Goods_Specifications:98]DatePrepDone:6:=$2
		bPrepDone:=1
		[Finished_Goods_Specifications:98]Priority:50:=0
		[Finished_Goods_Specifications:98]PrepBy:57:=<>zResp
		// • mel (12/28/04, 12:29:53)
		FG_PrepServiceStateChange("Sent"; 4D_Current_date)
		FG_PrepServicePreApproved
		
		If ([Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!)
			OBJECT SET ENABLED:C1123(bOrder; False:C215)
		Else 
			OBJECT SET ENABLED:C1123(bOrder; True:C214)
		End if 
		
	: ($event="ProofRead")
		[Finished_Goods_Specifications:98]DateProofRead:7:=$2
		bQADone:=1
		
	: ($event="Sent")
		[Finished_Goods_Specifications:98]DateSentToCustomer:8:=$2
		bQAfiled:=1
		bsent:=1
		
	: ($event="Returned")  //obsolete
		[Finished_Goods_Specifications:98]DateReturned:9:=$2  //4D_Current_date
		bReturned:=1
		
	: ($event="Approved")
		[Finished_Goods_Specifications:98]Approved:10:=True:C214  //FG_PrepServiceApprove(date)
		[Finished_Goods_Specifications:98]DateReturned:9:=$2  //FG_PrepServiceApprove(date)
		[Finished_Goods:26]ControlNumber:61:=[Finished_Goods_Specifications:98]ControlNumber:2  //FG_PrepServiceApprove(date)
		bRejected:=0
		SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateReturned:9; False:C215)
		SetObjectProperties(""; ->[Finished_Goods:26]DateArtApproved:46; True:C214)
		
	: ($event="Rejected")
		[Finished_Goods_Specifications:98]DateReturned:9:=$2
		[Finished_Goods_Specifications:98]Approved:10:=False:C215
		SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateReturned:9; True:C214)
		SetObjectProperties(""; ->[Finished_Goods:26]DateArtApproved:46; False:C215)
		
End case 

$0:=$success