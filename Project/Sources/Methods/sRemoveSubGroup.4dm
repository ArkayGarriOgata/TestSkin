//%attributes = {"publishedWeb":true}
//(p) sRemoveSubgroup
//give allowed users the ability to remove subgroups
//• 3/25/98 cs created

Repeat 
	uDialog("RemoveSubgroup"; 250; 120; 4; "Delete SubGroup")
Until (OK=0)