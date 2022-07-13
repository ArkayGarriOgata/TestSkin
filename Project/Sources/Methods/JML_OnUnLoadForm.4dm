//%attributes = {"publishedWeb":true}
//PM: JML_OnUnLoadForm() -> 
//@author mlb - 7/17/01  13:01
//zwStatusMsg ("Job Mstr Log";[JobMasterLog]JobForm+" not saved")

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([To_Do_Tasks:100]; 0)

<>jobform:=""