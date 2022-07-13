//MESSAGES OFF
//PSpecEstimateLd ("Machines")
sOSsetup("Form")
QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
//PSpecEstimateLd ("Machines";"Materials")
ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
//MESSAGES ON
//