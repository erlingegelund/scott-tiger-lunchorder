// Deadline klokkeslet for bestilling af frokost - timetal med 2 cifre
const deadline = "10:00"
const reopen = "12:00"

const categoryURL = "/ords/st_lunch/stlunch_categories/";
const supplierURL = "/ords/st_lunch/stlunch_suppliers/";
const supplierMenuURL = "/ords/st_lunch/stlunch_supplier_menus/"
const menuOptionsURL = "/ords/st_lunch/stlunch_menu_options/"
const userHistoryURL = "/ords/st_lunch/get_user_order/on_date/";


export const STLunchHelper = {
    deadline,
    categoryURL,
    supplierURL,
    supplierMenuURL,
    menuOptionsURL,
    userHistoryURL,
    isBeforeDeadline,
    isAfterReopen,
    validateMail,
    dateToString,
    prepOrdersForReport
}

function isBeforeDeadline(dateStr, timeInMillis) {
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

function isAfterReopen(timeInMillis) {
    var dateDate = new Date()

    dateDate.setHours(reopen.substr(0, 2).valueOf())
    dateDate.setMinutes(reopen.substr(3).valueOf())
    dateDate.setSeconds(0)
    dateDate.setMilliseconds(0)

    //console.log(Date.now()+", "+dateDate.getTime()+", "+timeInMillis)

    return dateDate.getTime() < timeInMillis
}

function validateMail(email) {
    // Dette regex er ikke korrekt - tillader ikke æøå og alle tilladt top-domæner
    return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)
}

function dateToString(date) {
    return date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()
}

function prepOrdersForReport(orders) {
    for (var i in orders) {
        let order = orders[i];
        order.total_price = order.items_ordered * order.price;
        for (var j in order.options) {
            order.options[j].value = order.options[j].selected.split("\n");
        }
    }
}