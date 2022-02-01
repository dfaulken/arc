$(document).ready(() => {
    $('.projection ul.drivers').sortable({
        create: recalculateProjection,
        update: recalculateProjection
    });
    $('.led-lap, .dnf').click(markSelected);
    $('.points #pole_position').change(recalculateProjection);
    $('.points #led_most_laps').change(recalculateProjection);
});

function markSelected() {
    $(this).toggleClass('selected');
    recalculateProjection();
}

function recalculateProjection() {
    $('.projection-results .results').text('Calculating projection...');
    var requestData = {};
    requestData.drivers = $('.projection ul.drivers li.driver')
      .map(extractDriverListItemData).toArray();
    requestData.polePosition = $('.points #pole_position').val();
    requestData.ledMostLaps = $('.points #led_most_laps').val();
    const url = document.location.href.split('?')[0];
    $.getJSON(url, requestData).done(displayProjectionResults);
}

function extractDriverListItemData() {
    var driverID = $(this).data('driver-id');
    var position = $(this).index() + 1;
    var ledLap = $(this).find('.led-lap').hasClass('selected');
    var dnf = $(this).find('.dnf').hasClass('selected');
    return { driverID, position, ledLap, dnf };
}

function displayProjectionResults(data) {
    $('.projection-results .results').html(constructResultsTable(data));
}

function constructResultsTable(data) {
    var table = [];
    table.push('<table>');
    data.forEach((driverData, index) => {
        const position = index + 1;
        const driverName = driverData[0];
        const driverPoints = driverData[1];
        table.push('<tr>');
            table.push('<td>');
                table.push(position);
            table.push('</td>');
            table.push('<td>');
                table.push(driverName);
            table.push('</td>');
            table.push('<td>');
                table.push(driverPoints);
            table.push('</td>');
        table.push('</tr>');
    });
    table.push('</table>');
    return table.join('');
}