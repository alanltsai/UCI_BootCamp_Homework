// @TODO: YOUR CODE HERE!
// Define SVG dimensions
var svgWidth = 960;
var svgHeight = 500;

// Define margin dimensions
var margin = {
    top: 50,
    bottom: 50,
    left: 50,
    right: 50
};

// Define plot height and width dimensions relative to SVG
var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// Create the SVG wrapper and append the svg element to the HTML ID
var svg = d3.select("#scatter")
.append("svg")
.attr("width", svgWidth)
.attr("height", svgHeight);


var chartGroup = svg.append("g")
.attr("transform", `translate(${margin.left}, ${margin.top})`);

// Import the data
d3.csv("assets/data/data.csv").then(function(healthData) {

    // Parse Data / Cast as numbers
    healthData.forEach(function(data) {
        data.income = +data.income;
        data.obesity = +data.obesity;
    });
    
    // Create scale functions
    var xLinearScale = d3.scaleLinear()
    .domain([d3.min(healthData, d=>d.income)-5000, d3.max(healthData, d => d.income)])
    .range([0,width]);

    var yLinearScale = d3.scaleLinear()
    .domain([d3.min(healthData, d => d.obesity), d3.max(healthData, d => d.obesity)])
    .range([height, 0]);

    // Create axes functions
    var bottomAxis = d3.axisBottom(xLinearScale);
    var leftAxis = d3.axisLeft(yLinearScale);

    // Append axes to plot
    chartGroup.append("g")
    .attr("transform", `translate(0, ${height})`)
    .call(bottomAxis);

    chartGroup.append("g").call(leftAxis);


    // Create circles
    var circlesGroup = chartGroup.selectAll("g")
    .data(healthData)
    .enter()
    .append("circle")
    .attr("cx", d => xLinearScale(d.income))
    .attr("cy", d => yLinearScale(d.obesity))
    .attr("fill", "green")
    .attr("r", 10)
    .attr("opacity", 0.5);

    var circleText = chartGroup.selectAll("g")
    .data(healthData)
    .enter()
    .append("text")
    .attr("x", d => xLinearScale(d.income))
    .attr("y", d => yLinearScale(d.obesity))
    .attr(d => (d.abbr))
    .attr("class", "stateText")
    .attr("font-size", "12px")


});