//%attributes = {}
//Method:  Rprt_Pick_0000Explain
//Description:  This method will explain how the pick dialog works

//A. This dialog will bring up a list of reports a user can choose from

//.  1. The list is determined by groups the user belongs to
//.     and by the users name (see Rprt_Pick_LoadHList)

//.  2. When a user clicks on a report from the list the following will be displayed:

//.     a. The previous raw data report
//.     b. The description of the report
//.     c. The historical information
//.     d. Query options may or may not appear
//         i.   Reports that use a start date or date range and/or a value or dropdown will appear
//.        ii.  Reports that use a sheet window will appear when the report is run 
//.        iii. Reports that do not use parameters will never appear.

//.  3. When a user clicks on the run report button it will execute the method in [Report]Method

//B. How to code a report see Rprt_Pick_0000Step

