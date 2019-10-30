import axios from "axios";

// Deadline klokkeslet for bestilling af frokost - timetal med 2 cifre
const deadline = "10:00"
const reopen = "12:00"

const loginURL = "/ords/stlunch/login/user/";
const resetPasswordURL = "/ords/stlunch/login/reset/";

const categoryURL = "/ords/stlunch/categories/";
const supplierURL = "/ords/stlunch/suppliers/";
const supplierMenuURL = "/ords/stlunch/supplier_menus/"
const menuOptionsURL = "/ords/stlunch/menu_options/"
const activeUserURL = "/ords/stlunch/active_users/";

const changePasswordURL = "/ords/stlunch/api/change-password/";
const prepOrderURL = "/ords/stlunch/api/prep-order/";
const createOrderURL = "/ords/stlunch/api/create-order/";

const userStorage = "user";
const tokenStorage = "access_token";


export const STLunchHelper = {
    deadline,
    categoryURL,
    supplierURL,
    supplierMenuURL,
    menuOptionsURL,
    userStorage,
    tokenStorage,
    isBeforeDeadline,
    isAfterReopen,
    validateMail,
    dateToString,
    prepOrdersForReport,
    doLogin,
    doLogoff,
    resetPassword,
    changePassword,
    prepOrderSuppliers,
    prepMenuOptions,
    submitOrder,
    submitCategory,
    deleteCategory,
    fetchCategories,
    isAdministrator
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
    }
}

function doLogin(loginComponent, username, password) {
    let loginObj = { user_email: username, password: password };
    axios.post(loginURL, loginObj).then(response => {
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
            axios.post(authURL, "grant_type=client_credentials", config).then(response => {
                let token = response.data.access_token;
                sessionStorage.setItem(STLunchHelper.tokenStorage, token);
                axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
                var user = JSON.stringify(users[0]);
                sessionStorage.setItem(STLunchHelper.userStorage, user);
                loginComponent.$router.push(loginComponent.returnUrl);
                /*
                // Timer funktionalitet til at hente nyt token, når dette udløber
                // Der er en problematik om beskyttelse af client ID og secret. 
                // Derfor er funktionaliteten udkommenteret 
                let tokenExpires = response.data.expires_in
                setTimeout(refreshOAuthToken, (tokenExpires-1)*1000);
                */
            },
                error => {
                    loginComponent.error = error.toString();
                    loginComponent.loading = false;
                })
        } else {
            loginComponent.error = "Brugernavn eller kodeord er forkert";
            loginComponent.loading = false;
        }
    });
}

/*
function refreshOAuthToken() {
    const basicAuth = "Basic " + btoa(oauth[0].client_id + ":" + oauth[0].client_secret);
    const authURL = "/ords/stlunch/oauth/token";
    const config = {
        headers: {
            Authorization: basicAuth,
            "Content-Type": "application/x-www-form-urlencoded"
        }
    };
    let token = sessionStorage.setItem(STLunchHelper.tokenStorage);
    axios.post(authURL, "grant_type=refresh_token&refresh_token="+token, config).then(response => {
        let token = response.data.access_token;
        sessionStorage.setItem(STLunchHelper.tokenStorage, token);
        axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    });
}
*/

function doLogoff() {
    sessionStorage.removeItem(tokenStorage);
    sessionStorage.removeItem(userStorage);
    axios.defaults.headers.common["Authorization"] = null;
}

function resetPassword(resetComponent) {
    let resetObj = { user_email: resetComponent.username };
    axios.post(resetPasswordURL, resetObj).then(response => {
        resetComponent.$router.push('{name: "Login"}');
    },
        error => {
            resetComponent.loading = false;
            resetComponent.error = "E-mail tilhører ikke en registreret bruger";
        });
}

function changePassword(changeComponent) {
    let userId = JSON.parse(sessionStorage.getItem("user")).user_id
    let changeObj = { user_id: userId, old_password: changeComponent.currentPassword, new_password: changeComponent.newPassword };
    axios.post(changePasswordURL, changeObj)
        .then(response => {
            console.log(response)
            changeComponent.success = "Dit kodeord er ændret";
            changeComponent.loading = false;
        })
        .catch(error => {
            console.log(error)
            changeComponent.loading = false;
            changeComponent.error = "Nuværende kodeord er ikke korrekt";
        });
}

function prepareMenuItems(menuItems) {
    for (var i in menuItems) {
        if (menuItems[i].options) {
            for (var n in menuItems[i].options) {
                var _selections = [];
                if (menuItems[i].options[n].selectables) {
                    _selections = menuItems[i].options[n].selectables.split("\n");
                }
                menuItems[i].options[n].selections = _selections;
                menuItems[i].options[n].value = [];
            }
        } else {
            menuItems[i].options = [];
        }
        menuItems[i].items_ordered = 0;
    }
    return menuItems;
}

function prepOrderSuppliers(orderComponent) {
    // Check at token er sat i axios headers common
    if (!axios.defaults.headers.common["Authorization"]) {
        let token = sessionStorage.getItem(STLunchHelper.tokenStorage);
        axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    }
    if (isAdministrator()) {
        axios.get(activeUserURL).then(
            response => {
                let userJSON = JSON.stringify(response.data.items);
                userJSON = userJSON.replace(
                    /\"user_id\":/g,
                    '"value":'
                );
                userJSON = userJSON.replace(/\"user_name\":/g, '"text":');
                orderComponent.userList = JSON.parse(userJSON).sort((u1, u2) => u1.text > u2.text ? 1 : -1);
            }
        )
    }
    axios.get(prepOrderURL + orderComponent.order.user_id.toString()).then(
        response => {
            var suppliersCategories = response.data.suppliers;
            for (let i in suppliersCategories) {
                for (let j in suppliersCategories[i].categories) {
                    suppliersCategories[i].categories[j].menu_items = [];
                    // Hent menu for brugerens sidst bestilte leverandør / kategori
                    if (
                        suppliersCategories[i].display === "Y" &&
                        suppliersCategories[i].categories[j].display === "Y"
                    ) {
                        axios.get(
                            prepOrderURL +
                            suppliersCategories[i].id +
                            "/" +
                            suppliersCategories[i].categories[j].id
                        ).then(response => {
                            suppliersCategories[i].categories[j].menu_items = prepareMenuItems(
                                response.data.menu_items
                            );
                        });
                    }
                }
            }
            orderComponent.suppliers = suppliersCategories;
        }
    );
}

function prepMenuOptions(orderComponent, supplierId, menuId) {
    axios.get(prepOrderURL + supplierId + "/" + menuId).then(
        response => {
            let supplier = orderComponent.suppliers.filter(
                s => s.id === supplierId
            )[0];
            let category = supplier.categories.filter(
                c => c.id === menuId
            )[0];
            category.menu_items = prepareMenuItems(
                response.data.menu_items
            );
        }
    );
}

function submitOrder(order, router) {
    axios.post(createOrderURL, order).then(response => {
        router.push({
            name: "UserHistory",
            params: { orderItems: JSON.stringify(response.data) }
        });
    });
}

function submitCategory(cat) {
    if (cat.category_name) {
        if (cat.category_id < 0) {
            axios.post(categoryURL, cat).then(response => {
                cat.category_id = response.data.category_id;
            });
        } else {
            axios.put(categoryURL + cat.category_id, cat);
        }
        cat.edit = false;
        cat.submitted = false;
    } else {
        cat.submitted = true;
    }
}

function deleteCategory(cat, categoryComponent) {
    axios.delete(categoryURL + cat.category_id).then(
        response => {
            var filtered = categoryComponent.categories.filter(
                c => c.category_id != cat.category_id
            );
            categoryComponent.categories = filtered;
        }
    );
}

function fetchCategories(categoryComponent) {
    axios.get(categoryURL).then(response => {
        var categories = response.data.items;
        for (let i in categories) {
            categories[i].edit = false;
            categories[i].submitted = false;
        }
        categories.sort((c1, c2) =>
            c1.category_name > c2.category_name ? 1 : -1
        );
        categoryComponent.categories = categories;
    });

}

function isAdministrator() {
    // Læs bruger info fra sessionStorage
    let user = JSON.parse(sessionStorage.getItem("user"));
    if (user) {
        return user.administrator_yn === "Y";
    } else {
        return false;
    }
}
