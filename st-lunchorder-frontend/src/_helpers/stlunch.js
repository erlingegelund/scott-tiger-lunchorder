export const STLunchHelper = {
    getDeadline,
    isBefore,
    validateMail
}

// Deadline klokkeslet for bestilling af frokost - timetal med 2 cifre
const deadline = "10:00"

function getDeadline() {
    return deadline
}

function isBefore(dateStr, timeInMillis) {
    /*
    Argumenter:
    - dateStr: String, valgfri, Dato
    - timeInMillis: Number, obligatorisk, Tidspunkt angivet som milliseconder siden unix epoch
    Valider 
    - hvis dateStr er angivet, dateStr er efter midnat for dato for timeInMillis ()
    - timeInMillis er før deadline
    */
    var before = true;

    var startOfDay = new Date()
    startOfDay.setHours(0)
    startOfDay.setMinutes(0)
    startOfDay.setSeconds(0)
    startOfDay.setMilliseconds(0)

    var dateDate = null
    if (dateStr) dateDate = Date.parse(dateStr)

    // console.log("orderDate: "+orderDate+", startOfDay: "+ startOfDay.getTime())
    if (dateDate && dateDate < startOfDay.getTime()) {
        before = false;
    } else {
        // Compare number of milliseconds for now to deadline
        var msDay = timeInMillis - startOfDay.getTime()
        var msDeadline = 1000 * (60 * 60 * deadline.substr(0, 2).valueOf() + 60 * deadline.substr(3).valueOf())
        // console.log("msDay: "+msDay+", msDeadline: "+msDeadline)
        before = msDay < msDeadline
    }

    return before;
}

function validateMail(email) {
    // Dette regex er ikke korrekt - tillader ikke æøå eller alle tilladt top-domæner
    return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)
}