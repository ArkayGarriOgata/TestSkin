//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/28/07, 19:53:46
// Modified by: Mel Bohince (6/25/10)
//read only  jobs if had to search, was locking ReviseJob
// Modified by: Mel Bohince (8/26/10)
//always have a summary record present
// ----------------------------------------------------
// Method: trigger_JobForm()  --> 
// ----------------------------------------------------

//

//If (Database event=On Saving Existing Record Event)
//see also doNewJCloseRec, else this code locks the record
//C_BOOLEAN($set_date;$created_record)
//$created_record:=False
//$set_date:=False
//READ WRITE([Job_Forms_CloseoutSummaries])
//SET QUERY LIMIT(1)
//QUERY([Job_Forms_CloseoutSummaries];[Job_Forms_CloseoutSummaries]JobForm=[Job_Forms]JobFormID)
//SET QUERY LIMIT(0)
//If (Records in selection([Job_Forms_CloseoutSummaries])=0)  ` one to one, always exists , 8/26/10
//CREATE RECORD([Job_Forms_CloseoutSummaries])
//[Job_Forms_CloseoutSummaries]JobForm:=[Job_Forms]JobFormID
//If ([Jobs]JobNo#[Job_Forms]JobNo)
//READ ONLY([Jobs])
//RELATE ONE([Job_Forms]JobNo)
//End if 
//[Job_Forms_CloseoutSummaries]Customer:=[Jobs]CustomerName
//[Job_Forms_CloseoutSummaries]Line:=[Jobs]Line
//$created_record:=True
//End if 
//
//If ([Job_Forms]ClosedDate#!00/00/00!)
//[Job_Forms_CloseoutSummaries]CloseDate:=[Job_Forms]ClosedDate
//$set_date:=True
//End if 
//
//If ($created_record) | ($set_date)
//SAVE RECORD([Job_Forms_CloseoutSummaries])
//End if 
//
//UNLOAD RECORD([Job_Forms_CloseoutSummaries])
//REDUCE SELECTION([Job_Forms_CloseoutSummaries];0)

//End if 