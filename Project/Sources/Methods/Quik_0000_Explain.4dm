//%attributes = {}
// _______
// Method: Quik_0000_Explain  ( ) ->
// By: Garri Ogata @ 07/06/20, 09:00:31
// Description:  This explains the quick report editor option
// 
// ----------------------------------------------------

// This is used when people ask for reports that can be done with quick reports

//How it works:

//0.  Use Shortcuts:Search...
//.    a. Create search and save from listing use report and save
//.    b. Make sure to save with the report name that you will use
//.    c. These will be opened with step 2 dialog entry

//1. Quik_Dialog_List
//.    a. An HList of saved reports for a user depending on Group they are in
//.    b. Category - Report name
//.    c. New - allows you to add a report (created in step 0) brings up form Quik_Entry
//.    d. Excel - Runs query and Quick Report and opens the document in excel

//2. Quik_Dialog_Entry
//.    a. Group - who can see report [Coded in use dropdown] Should work with Users and Groups
//.    b. Category - Where Report name will show up [dropdown with modify option]
//.    c. Name - Report name (will use to load)
//.    d. Show Find - bring up query so values can be changed
//.    e. Save
//.        Only when Group, Category and Name is filled in
//.        Name must find report name in aMs Documents Quick folder
//.        When save if Report name exists replaces if not creates
//.        Query [ReportName].4df is parsed and saved 
//.        Quick Report is converted to a blob and saved

