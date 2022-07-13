//%attributes = {"publishedWeb":true}
//gFCDel: [Fiscal_Calendar] Delete Procedure

ALERT:C41("Deleting may affect printing of Reports for WIP.")
gDeleteRecord(->[x_fiscal_calendars:63])