//(s) aUOM [poitems]input
[Raw_Materials:21]IssueUOM:10:=Substring:C12(util_ComboBoxAction(->aUOM2; aUOM2{0}); 1; 4)
If (Length:C16([Raw_Materials:21]IssueUOM:10)=0)
	[Raw_Materials:21]IssueUOM:10:=Old:C35([Raw_Materials:21]IssueUOM:10)
End if 