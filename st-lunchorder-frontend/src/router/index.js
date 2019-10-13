import Vue from 'vue'
import VueRouter from "vue-router"
import Order from '@/components/Order'
import LoginPage from '@/components/LoginPage'
import UserHistory from '@/components/UserHistory'
import OrderHistory from '@/components/OrderHistory'
import MonthlyReport from '@/components/MonthlyReport'
import Category from '@/components/Category'
import Supplier from '@/components/Supplier'
import SupplierMenu from '@/components/SupplierMenu'
import UserMgmt from '@/components/UserMgmt'

Vue.use(VueRouter)

export const router = new VueRouter({
    mode: 'history',
    routes: [
        { path: '/login', name: "Login", component: LoginPage, props: true},
        { path: '/', name: "Order", component: Order, props: true},
        { path: '/userhistory', name: "UserHistory", component: UserHistory, props: true},
        { path: '/orderhistory', name: "OrderHistory", component: OrderHistory, props: true},
        { path: '/monthly', name: "MonthlyReport", component: MonthlyReport, props: true},
        { path: '/category', name: "Category", component: Category, props: true},
        { path: '/supplier', name: "Supplier", component: Supplier, props: true},
        { path: '/menu/:supplier', name: "Menu", component: SupplierMenu, props: true},
        { path: '/users', name: "UserMgmt", component: UserMgmt, props: true},
        { path: '*', redirect: '/' }
    ]
})

router.beforeEach((to, from, next) => {
    // redirect to login page if not logged in and trying to access a restricted page
    const publicPages = ['/login'];
    const authRequired = !publicPages.includes(to.path);
    const loggedIn = sessionStorage.getItem('user');

    if (authRequired && !loggedIn) {
        return next({
            path: '/login',
            query: { returnUrl: to.path }
        });
    }

    next();
})