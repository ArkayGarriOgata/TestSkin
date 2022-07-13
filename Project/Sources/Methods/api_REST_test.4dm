//%attributes = {"publishedWeb":true}
// _______
// Method: api_REST_test   ( ) ->
// By: Thomas MAUL @ https://forums.4d.com/Post/EN/31020445/1/31030501#31030501
// Description
// call with url like: http://127.0.0.1:8080/4daction/api_REST_test?name=13415.12
//     or http://127.0.0.1:8080/4daction/api_REST_test?pjt=02135

// returns a json collection, like below if empty arg 1 in toCollection:

//[{"__KEY":"C45EC6D610B646E2A1FDD08B5813A16C","__STAMP":19,"NeedDate":"2019-05-14","JobNo":13415,"FormNumber":12,"IssueVarience":0,\
//     "JobFormID":"13415.12","Status":"Closed","ModDate":"2019-06-12","ModWho":"JHC","CaseFormID":"9-0376.00AA12","StartDate":"2019-05-03",\
//     "ClosedDate":"2019-06-12","zCount":1,"ActFormCost":14286.16855,"Pld_CostTtl":18968,"DyluxSub":"0000-00-00","DyluxApp":"0000-00-00",\
//     "StockRecd":"0000-00-00","Completed":"2019-05-31","Pld_CostTtlMatl":9564,"Pld_CostTtlLabor":5941,"Pld_CostTtlOH":3463,"QtyWant":73000,\
//     "Width":24,"Lenth":29,"SqInches":0,"NumberUp":4,"EstGrossSheets":24931,"EstNetSheets":18600,"EstCost_M":259.83561643836,"QtyYield":74400,\
//     "EstS_ECost":0,"Notes":"COMPLETED BY aMs! EMBOSS INLINE                       ","JobType":"3 Prod","EstWasteSheets":6331,"QtyActProduced":73000,\
//     "ActualFlag":false,"ActLabCost":4855,"ActOvhdCost":2265.75,"ActS_ECost":0,"ActMatlCost":7165.41855,"ActCost_M":195.7,"AvgSellPrice":490,\
//     "OutsideComm":0,"1stPressCount":24931,"OverrunPct":0,"ProcessSpec":"New Treat/Bksde","EstimateNo":"9-0376.00","ShortGrain":false,"Caliper":0.018,\
//     "UnBudgetedVFIss":false,"IssuingComplete":false,"CustomerOK":false,"ActualGluedQty":88200,"InkPONumber":"","Run_Location":"VA","ProjectNumber":"02135",\
//     "VersionNumber":2,"VersionDate":"2019-04-22","PlnnerReleased":"2019-04-23","ColorStdSheets":0,"SubForms":2,"CustomerLine":"Travel Ret.Treatment",\
//     "ProcessType":"","ColorSpecMaster":"","OutlineNumber":"A070803","z_SYNC_ID":"","NoticeGiven":1,"z_SYNC_DATA":null,"Internal_ID":81021,\
//     "CreationDate":"0000-00-00","CreationTime":0,"CreationDateTime":0,"CreatedBy":"","ModificationDate":"0000-00-00","ModificationTime":0,\
//     "ModificationDateTime":20190612.094935,"ModificationBy":"","MySQL_ID":0,"MySQL_LastModifDateTime":"","MySQL_IsDeleted":false,"Is_Do_Not_Run_Trigger":false,\
//     "cust_id":"00121","PandGProblems":null,"PandGProbsCkByMgr":false,"PandGProbsComments":"","PandGProbsEmail":"","pk_id":"C45EC6D610B646E2A1FDD08B5813A16C",\
//     "JobTypeDescription":"","VersionZeroDate":"2019-03-26","RnD_Tested":"","RnD_Results":"",\
//     "Job":{"__KEY":13415},"JobFormID_58_":{"__KEY":"13415.12"},"Project":{"__KEY":"02135"},"Customer":{"__KEY":"00121"}}]
// ----------------------------------------------------

C_OBJECT:C1216($sel; $result)
C_TEXT:C284($answer)
ARRAY TEXT:C222($namearray; 0)
ARRAY TEXT:C222($valuearray; 0)
WEB GET VARIABLES:C683($namearray; $valuearray)
If (Size of array:C274($namearray)>0)
	Case of 
		: ($namearray{1}="name")
			$sel:=ds:C1482.Job_Forms.query("JobFormID=:1 & Status#:2"; $valuearray{1}; "Closed")
		: ($namearray{1}="pjt")
			$sel:=ds:C1482.Job_Forms.query("ProjectNumber=:1 & Status#:2"; $valuearray{1}; "Closed")
		Else 
			$sel:=ds:C1482.Job_Forms.newSelection()
	End case 
	$result:=$sel.toCollection("JobFormID, cust_id, CustomerLine, Status, pk_id")  //;dk with primary key+dk with stamp)
End if 

$answer:=JSON Stringify:C1217($result)
WEB SEND TEXT:C677($answer; "application/json")