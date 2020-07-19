var SECONDS = 1000;
var MINUTES = 60 * SECONDS;

function isCurrentHourInAM(currentHour) {
  if (currentHour < 12) {
    return true;
  }
  return false;
}

function convertTwentyFourHourTimeToTwelveHourTime(currentHour) {
  if (currentHour === 0) {
    return 12;
  }

  if (currentHour === 12) {
    return 12;
  }

  if (currentHour < 12) {
    return currentHour;
  }

  if (currentHour > 12) {
    return currentHour - 12;
  }
}

function updateClock() {
  var now = new Date();
  var hour = now.getHours();

  var isAM = isCurrentHourInAM(hour);
  var convertedHour = convertTwentyFourHourTimeToTwelveHourTime(hour);

  var minute = now.getMinutes();
  if (minute < 10) minute = '0' + minute;
  $('#clock').html(convertedHour + ':' + minute + (isAM ? 'am' : 'pm'));
}

updateClock();
setInterval(updateClock, 15 * SECONDS);

var errors = 0;

function updatePage() {
  $.get(location.href, function(html) {
    var body = html.replace(/^[\S\s]*<body[^>]*?>/i, '')
                   .replace(/<\/body[\S\s]*$/i, '');
    var content = $(body).find('.wrapper').html();
    if (content) {
      $('.wrapper').html(content);
      updateClock();
      errors = 0;
    } else {
      errors++;
      if (errors >= 5)
        $('body').css('backgroundColor', 'red');
      else
        updatePage();
    }
  });
}

setInterval(updatePage, 5 * MINUTES);
