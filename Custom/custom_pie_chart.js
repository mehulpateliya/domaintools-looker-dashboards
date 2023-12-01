// custom_pie_chart_chartjs.js

(function (looker, Chart) {
  looker.plugins.visualizations.add({
    id: "custom_pie_chart_chartjs",
    label: "Custom Pie Chart",
    options: {
      color: {
        type: "string",
        label: "Color",
      },
    },
    handleErrors: function (data, resp) {
      return true;
    },
    create: function (element, config) {
      var canvas = document.createElement("canvas");
      canvas.setAttribute("id", "customPieChartCanvas");
      element.appendChild(canvas);

      // Initialize the Chart.js instance
      this.chart = new Chart(canvas, {
        type: "pie",
        options: {
          legend: {
            display: false,
          },
          onClick: function (event, elements) {
            if (elements && elements.length > 0) {
              var data = event.chart.config._config.data;
              var label = data.labels;
              var value = data.datasets[0].data;
              // Trigger drill-down
              LookerCharts.Utils.openDrillMenu({
                links: value[elements[0].index].links,
                event: { pageX: event.x, pageY: event.y },
              });
            }
          },
        },
      });
    },
    updateAsync: function (data, element, config, queryResponse, details, doneRendering) {
      // Extract the data from Looker response
      var values = data;

      // Generate the chart data
      var FinalData = [];
      var finalLabel = [];
      let sum = 0;
      var other_links = [];
      values.forEach(function (currentValue, index) {
        var cell = currentValue[queryResponse.fields.measure_like[0].name];
        if (index < 19) {
          FinalData.push(cell);
          finalLabel.push(
            currentValue[queryResponse.fields.dimensions[0].name].value
          );
        } else {
          cell.links[0].label_prefix =
            currentValue[queryResponse.fields.dimensions[0].name].value +
            "-" +
            cell.links[0].label_value;
          cell.links[0].label =
            currentValue[queryResponse.fields.dimensions[0].name].value +
            "-" +
            cell.links[0].label_value;
          other_links.push(cell.links[0]);

          sum =
            sum + currentValue[queryResponse.fields.measure_like[0].name].value;
        }
      });
      // add Other label and data
      finalLabel.push("Other");
      FinalData.push({
        rendered: sum.toString(),
        links: other_links,
        value: sum,
      });
      var finalCharData = {
        datasets: [{ data: FinalData }],
        labels: finalLabel,
      };
      // Update the chart with the data
      this.chart.data = finalCharData;
      this.chart.update();

      // Signal the completion of rendering
      doneRendering();
    },
  });
})(looker, Chart);
