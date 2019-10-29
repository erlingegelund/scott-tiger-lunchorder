import Axios from "axios";

// Deadline klokkeslet for bestilling af frokost - timetal med 2 cifre
const deadline = "10:00"
const reopen = "12:00"

const loginURL = "/ords/stlunch/login/user/";

const categoryURL = "/ords/stlunch/categories/";
const supplierURL = "/ords/stlunch/suppliers/";
const supplierMenuURL = "/ords/stlunch/supplier_menus/"
const menuOptionsURL = "/ords/stlunch/menu_options/"
const userHistoryURL = "/ords/stlunch/api/get_user_order/on_date/";

const userStorage = "user";
const tokenStorage = "access_token";


export const STLunchHelper = {
    deadline,
    categoryURL,
    supplierURL,
    supplierMenuURL,
    menuOptionsURL,
    userHistoryURL,
    userStorage,
    tokenStorage,
    isBeforeDeadline,
    isAfterReopen,
    validateMail,
    dateToString,
    prepOrdersForReport,
    doLogin
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
    // date.toISOString() anvender altid UTC tidszone. 
    // fordi jeg ikke er sikker på tidspunkt har lavet denne hjemmestrikkede funktion
    let ret = date.getFullYear() + "-";
    let month = (date.getMonth() + 1);
    if (month < 10) ret += "0";
    ret += month.toString() + "-";
    let day = date.getDate()
    if (day < 10) ret += "0";
    ret += day.toString();
    
    return ret;
}

function prepOrdersForReport(orders) {
    for (var i in orders) {
        let order = orders[i];
        order.total_price = order.items_ordered * order.price;
        // for (var j in order.options) {
        //     order.options[j].value = order.options[j].selected.split("\n");
        // }
    }
}

function doLogin(loginComponent, username, password) {
    let loginObj = { user_email: username, password: password };
    Axios.post(loginURL, loginObj).then(response => {
      var users = response.data.user;
      if (users && users.length > 0) {
        // Hent OAuth token
        let oauth = response.data.oauth;
        const basicAuth = "Basic " + btoa(oauth[0].client_id + ":" + oauth[0].client_secret);
        const authURL = "/ords/stlunch/oauth/token";
        const config = {
          headers: {
            Authorization: basicAuth,
            "Content-Type": "application/x-www-form-urlencoded"
          }
        };
        Axios.post(authURL, "grant_type=client_credentials", config).then(response => {
          sessionStorage.setItem(STLunchHelper.tokenStorage, response.data.access_token);
          var user = JSON.stringify(users[0]);
          sessionStorage.setItem(STLunchHelper.userStorage, user);
          loginComponent.$router.push(loginComponent.returnUrl);
        },
        error => {
          console.log(error);

        })
      } else {
        loginComponent.error = "Brugernavn eller kodeord er forkert";
        loginComponent.loading = false;
      }
    });
}