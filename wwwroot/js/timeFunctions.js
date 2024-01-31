// timeFunctions.js
function GetTimeAgo(postedTime) {
    var currentTime = new Date();
    var timeDifference = currentTime - new Date(postedTime);

    var seconds = Math.floor(timeDifference / 1000);
    var minutes = Math.floor(seconds / 60);
    var hours = Math.floor(minutes / 60);
    var days = Math.floor(hours / 24);

    console.log(seconds);
    console.log(minutes);
    console.log(hours);
    console.log(days);

    if (days > 0) {
        return days + " day(s)";
    } else if (hours > 0) {
        return hours + " hour(s)";
    } else if (minutes > 0) {
        return minutes + " minute(s)";
    } else {
        return seconds + " second(s)";
    }
}