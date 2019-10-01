import Vue from 'vue'
import VueRouter from "vue-router"
import Order from './components/Order'
import LoginPage from './components/LoginPage'
import UserHistory from './components/UserHistory'
import OrderHistory from './components/OrderHistory'
import MonthlyReport from './components/MonthlyReport'
import Category from './components/Category'
import Supplier from './components/Supplier'
import UserMgmt from './components/UserMgmt'

Vue.use(VueRouter)

export const router = new VueRouter({
    mode: 'history',
    routes: [
        { path: '/login', name: "Login", component: LoginPage },
        { path: '/', name: "Order", component: Order },
        { path: '/userhistory', name: "UserHistory", component: UserHistory},
        { path: '/orderhistory', name: "OrderHistory", component: OrderHistory},
        { path: '/monthly', name: "MonthlyReport", component: MonthlyReport},
        { path: '/category', name: "Category", component: Category},
        { path: '/supplier', name: "Supplier", component: Supplier},
        { path: '/users', name: "UserMgmt", component: UserMgmt},
        { path: '*', redirect: '/' }
    ]
})

router.beforeEach((to, from, next) => {
    // redirect to login page if not logged in and trying to access a restricted page
    const publicPages = ['/login'];
    const authRequired = !publicPages.includes(to.path);
    const loggedIn = localStorage.getItem('user');

    if (authRequired && !loggedIn) {
        return next({
            path: '/login',
            query: { returnUrl: to.path }
        });
    }

    next();
})