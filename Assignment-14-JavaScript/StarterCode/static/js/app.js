// from data.js
var tableData = data;

// Select table
var tbody = d3.select("tbody");

// YOUR CODE HERE!
// Select the filter button
var filter = d3.select("#filter-btn");

filter.on("click", function() {

    // Prevent the default (refresh) action
    d3.event.preventDefault();

    // Clear the table
    // ("tr").remove()

    // Select the input field
    var inputField = d3.select("#datetime");

    // Get the value property of the input element
    var inputDate = inputField.property("value");

    // Filter data 
    var filteredData = tableData.filter(sighting => sighting.datetime === inputDate);
    
    // Log the filtered data set
    console.log(filteredData);

    // Append each row of filtered data to the HTML table
    filteredData.forEach((ufoSighting) => {
        var row = tbody.append("tr");
        Object.entries(ufoSighting).forEach(([key,value]) => {
            var cell = row.append("td");
            cell.text(value);
        })
    })
})