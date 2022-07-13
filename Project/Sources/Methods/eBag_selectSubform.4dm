//%attributes = {"publishedWeb":true}
//PM: eBag_selectSubform(aSubform{aSubform}) -> 
//@author mlb - 10/17/02  14:33
// • mel (12/3/04, 12:25:36) change to a "contains" search

USE SET:C118("materials")
If ($1>0)
	$sfNum:="@"+String:C10($1)+"@"  // • mel (12/3/04, 12:25:36) change to a "contains" search
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Alpha20_2:21="0"; *)
	QUERY SELECTION:C341([Job_Forms_Materials:55];  | ; [Job_Forms_Materials:55]Alpha20_2:21="@all@"; *)
	QUERY SELECTION:C341([Job_Forms_Materials:55];  | ; [Job_Forms_Materials:55]Alpha20_2:21=""; *)
	QUERY SELECTION:C341([Job_Forms_Materials:55];  | ; [Job_Forms_Materials:55]Alpha20_2:21=$sfNum; *)
	QUERY SELECTION:C341([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
	If (Records in selection:C76([Job_Forms_Materials:55])>0)
		zwStatusMsg("SUBFORM "+$sfNum; "Materials filtered to show only a single subform.")
		ORDER BY FORMULA:C300([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Real2:18; >; Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2); >)
	Else 
		BEEP:C151
		ALERT:C41("No materials specify subform "+$sfNum)
		USE SET:C118("materials")
		zwStatusMsg("ALL SUBFORMS"; "Materials not filtered")
		QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
		ORDER BY FORMULA:C300([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Alpha20_2:21; >; [Job_Forms_Materials:55]Real2:18; >; Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2); >)
	End if 
Else 
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
	ORDER BY FORMULA:C300([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Alpha20_2:21; >; [Job_Forms_Materials:55]Real2:18; >; Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2); >)
	zwStatusMsg("ALL SUBFORMS"; "Materials not filtered")
	
End if 