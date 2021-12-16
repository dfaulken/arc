// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import Chart from "chart.js/auto"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener('turbolinks:load', () => {
  var canvasElem = document.getElementById('points_progression');
  var labelsElem = document.getElementById('points_progression_labels');
  var dataElem = document.getElementById('points_progression_data');
  if(canvasElem === null || labelsElem === null || dataElem === null) {
    return;
  }
  var ctx = canvasElem.getContext('2d');
  var labels = JSON.parse(labelsElem.textContent);
  var data = JSON.parse(dataElem.textContent);
  var datasets = [];
  var driverNames = Object.keys(data).sort((name1, name2) => {
    var d1Points = data[name1];
    var d2Points = data[name2];
    var d1MaxPoints = d1Points[d1Points.length - 1];
    var d2MaxPoints = d2Points[d2Points.length - 1];
    return compareReverse(d1MaxPoints, d2MaxPoints);
  });
  var driverNamesInTop5 = findDriverNamesInTopAtAnyPoint(data, 5);
  var colors = generateColorSpectrumForDrivers(driverNames, driverNamesInTop5);
  driverNames.forEach(driverName => {
    var points = data[driverName];
    datasets.push({
      label: driverName,
      data: points,
      borderColor: colors[driverName],
      hidden: driverNamesInTop5.indexOf(driverName) == -1
    });
  })
  var myChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: labels,
      datasets: datasets
    }
  });
});

function compareReverse(m, n) {
  if(m < n){
    return 1;
  }
  if(m > n) {
    return -1;
  }
  return 0;
}

// Assumes all drivers have the same number of data points
function findDriverNamesInTopAtAnyPoint(data, necessaryRank) {
  var driverNames = Object.keys(data);
  if(driverNames.length <= necessaryRank) {
    return driverNames;
  }
  var driverNamesInTop = [];
  var raceCount = data[driverNames[0]].length;
  for(var i = 0; i < raceCount; i++) {
    driverNames.sort((name1, name2) => {
      var d1Points = data[name1][i];
      var d2Points = data[name2][i];
      return compareReverse(d1Points, d2Points);
    });
    for(var n = 0; n < necessaryRank; n++) {
      var driverName = driverNames[n];
      if(driverNamesInTop.indexOf(driverName) == -1) {
        driverNamesInTop.push(driverName);
      }
    }
  }
  return driverNamesInTop.sort((name1, name2) => {
    var d1Points = data[name1];
    var d2Points = data[name2];
    var d1MaxPoints = d1Points[d1Points.length - 1];
    var d2MaxPoints = d2Points[d2Points.length - 1];
    return compareReverse(d1MaxPoints, d2MaxPoints);
  });
}

function generateColorSpectrumForDrivers(driverNames, firstPassDrivers) {
  var step = 360 / driverNames.length;
  var colorStrings = {}

  var hues = [];
  for(var hue = 0; hue < 360; hue = hue + step) {
    hues.push(hue);
  }

  var remainingDriverNames = Array.from(driverNames);
  if(firstPassDrivers.length < driverNames.length / 2) {
    var firstPassCount = firstPassDrivers.length;
    var firstPassStep = hues.length / firstPassCount;
    for(var i = 0; i < firstPassCount; i++) {
      // Since we're removing one element from hues per iteration,
      // step by one less than the actual step.
      var hueIndex = Math.round((firstPassStep - 1) * i);
      var hue = hues[hueIndex];
      var driverName = firstPassDrivers[i];
      colorStrings[driverName] = "hsl(" + Math.round(hue) + ", 75%, 50%)";
      hues.splice(hueIndex, 1);
      remainingDriverNames.splice(remainingDriverNames.indexOf(driverName), 1);
    }
  }

  for(var i = 0; i < remainingDriverNames.length; i++) {
    var driverName = remainingDriverNames[i];
    var hue = hues[i];
    colorStrings[driverName] = "hsl(" + Math.round(hue) + ", 75%, 50%)";
  }

  return colorStrings;
}