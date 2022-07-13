RMX_IssueToJob("eBag"; sCriterion1)

// Modified by: Mel Bohince (1/13/20) restore label selection
QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Raw_Matl_Code:4=t7)
ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)