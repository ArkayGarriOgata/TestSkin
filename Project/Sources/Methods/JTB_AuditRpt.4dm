//%attributes = {"publishedWeb":true}
//JTB_AuditRpt 04/02/02

FORM SET OUTPUT:C54([JTB_Job_Transfer_Bags:112]; "LocationReport")
util_PAGE_SETUP(->[JTB_Job_Transfer_Bags:112]; "LocationReport")
PRINT SELECTION:C60([JTB_Job_Transfer_Bags:112]; *)
FORM SET OUTPUT:C54([JTB_Job_Transfer_Bags:112]; "List")