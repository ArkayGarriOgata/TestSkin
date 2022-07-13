//%attributes = {"publishedWeb":true}
//PM: eBag_unloadRelated() -> 
//@author mlb - 6/3/02  14:05

CLEAR SET:C117("materials")
CLEAR SET:C117("machines")
zwStatusMsg("eBag"; "Last Job "+[Job_Forms:42]JobFormID:5+" available to others")

REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
REDUCE SELECTION:C351([Customers_Projects:9]; 0)
REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
REDUCE SELECTION:C351([Process_Specs:18]; 0)
REDUCE SELECTION:C351([Job_Forms_Production_Histories:121]; 0)
REDUCE SELECTION:C351([Raw_Materials:21]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([Job_Forms_Loads:162]; 0)  // Modified by: Mel Bohince (5/5/19) 
REDUCE SELECTION:C351([Users:5]; 0)  // Modified by: Mel Bohince (7/16/21)  

//ToDo_StdTaskList ("kill")