//%attributes = {}
// _______
// Method: patternQueryByFormula   ( ) ->
// By: mel from 4d-PS, 14:10:40
// Description
// this was pretty wild, thought to save it see in use in ELC_RFM ( )
// ----------------------------------------------------
//would not have beleived that join in the first test would work

QUERY SELECTION BY FORMULA:C207([Customers_ReleaseSchedules:46]; \
([Customers_ReleaseSchedules:46]Shipto:10=[Addresses:30]ID:1)\
 & ([Addresses:30]RequestForModeEmailTo:17#"")\
 & ([Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!)\
 & ([Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")\
 & ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)\
)