pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: rootCatheter

    FileView {
        id: catheterDataWriter
        path: "/home/snowman/.config/quickshell/json/catheterData.json"

        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: jsonAdapter
            property int latestInjection: 0
        }
    }

    function setCurrentTime() {
        jsonAdapter.latestInjection = Math.floor(Date.now() / 1000);
    }

    function getElapsedTimeString() {
        var now = Math.floor(Date.now() / 1000);
        var deltaSeconds = now - jsonAdapter.latestInjection;

        var days = Math.floor(deltaSeconds / 86400);
        var hours = Math.floor((deltaSeconds % 86400) / 3600);

        return days + "d " + hours + "h";
    }

    function getFormattedDateString() {
        var timestamp = jsonAdapter.latestInjection;
        var dateObj = new Date(timestamp * 1000);

        var monthNames = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];

        var day = dateObj.getDate();
        var month = monthNames[dateObj.getMonth() - 1];
        var year = dateObj.getFullYear()

        var minutes = String(dateObj.getMinutes()).padStart(2, "0");
        var hours = String(dateObj.getHours()).padStart(2, "0");

        return day + " " + month + " " + year + " " + hours + ":" + minutes;
    }

    function getPredictionReplacementString() {
        var timeLeft = 4 - Math.floor((((Math.floor(Date.now() / 1000)) - jsonAdapter.latestInjection) / 86400));
        var finalPredictionPhrase = "";

        if (timeLeft >= 4) {
            finalPredictionPhrase = "Change in " + String(timeLeft - 1) + " or " + String(timeLeft) + " days"
        } else if (timeLeft == 3) {
            finalPredictionPhrase = "Change Tomorrow or in 2 days"
        } else if (timeLeft == 2) {
            finalPredictionPhrase = "Change Today or Tomorrow"
        } else if (timeLeft == 1) {
            finalPredictionPhrase = "Change Today"
        } else if (timeLeft <= 0) {
            finalPredictionPhrase = "Change Now!"
        } else {
            finalPredictionPhrase = "There was an issue, text: " + finalPredictionPhrase
        }

        return finalPredictionPhrase
    }
}
