// Globals
var columnDefs = [];
var gridOptions = {};

$(document).ready(function () {

			// specify the columns
		columnDefs = [
			{ headerName: "Product Code", field: "JobFormID", sortable: true, filter: true, width: 140  },
			{ headerName: "Description", field: "cust_id", sortable: true, filter: true, width: 240 },
			{ headerName: "On Hand", field: "Caliper", sortable: true, filter: true, width: 120 },
			{ headerName: "Released", field: "Width", sortable: false, filter: true, width: 110 }
		];
	
		// let the grid know which columns and what data to use
		gridOptions = {
			columnDefs: columnDefs,
			rowSelection: 'multiple',
			rowData: [],
			onSelectionChanged: onSelectionChanged
		};
	
		fillGrid("");


});




    
function onSelectionChanged() {
	var selectedNodes = gridOptions.api.getSelectedNodes();
	var selectedData = selectedNodes.map(function (node) { return node.data });
	var selectedDataStringPresentation = selectedData.map(function (node) { return fillRecordTemplate(node) }).join('<br>');
	document.getElementById("gridDetail").innerHTML = selectedDataStringPresentation;
};

function fillRecordTemplate(record) {
	recordHtml = "<div><h2 class=\"mt-5\">JobForm:  " + record.JobFormID + ",   Version:  " + record.VersionNumber + "</h2>";
	// recordHtml += '<img src="/4DACTION/getCustomerPhoto?id=' + record.Customer_ID + '&thumbnail=1"Â /><br>';

	recordHtml += "<b>Jobit: </b>" + record.Jobit + "<br>";
	recordHtml += "<b>Cust_id: </b>" + record.cust_id + "<br>";
	recordHtml += "<b>CustomerLine: </b>" + record.CustomerLine + "<br>";
	recordHtml += "<b>Notes: </b>" + record.Notes + "<br>";
	recordHtml += "<b>JobType: </b>" + record.JobType + "<br>";
	recordHtml += "<b>ProcessSpec: </b>" + record.ProcessSpec + "<br>";
	recordHtml += "<b>ShortGrain: </b>" + record.ShortGrain + "<br>";

	recordHtml += "<b>Style: </b>" + record.GlueStyle + "<br>";

	return recordHtml;
};
    
function queryGrid() {

	queryValue = document.getElementById("queryBox").value;
	fillGrid(queryValue);

};
    
function fillGrid(queryValue) {


	// lookup the container we want the Grid to use
	document.getElementById('myGrid').innerHTML = ''; // Force refreshing of grid
	var eGridDiv = document.querySelector('#myGrid');

	// create the grid passing in the div to use together with the columns & data we want to use
	new agGrid.Grid(eGridDiv, gridOptions);

	//Call to the API

	if (queryValue !== "") {
		url = "/api/Job_Forms?q=(JobFormID='" + queryValue + "')";

	} else {
		url = "/api/Job_Forms";

	}


	fetch(url).then(function (response) {
		return response.json();
	}).then(function (resp) {
		gridOptions.api.setRowData(resp.data);
	});

};





function initProductCodeScreen(){

    loadSessionData(function (){
		queryByProductCode("");
    });


};

function queryByProductCode(ttQueryString){


};
