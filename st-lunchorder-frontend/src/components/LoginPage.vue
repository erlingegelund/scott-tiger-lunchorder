<template>
  <div>
    <navigation :showNavIcon="false"></navigation>
    <div class="row justify-content-center align-items-end">
      <div class="col col-4">
        <h2>Login</h2>
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label for="username">Brugernavn</label>
            <input
              type="text"
              v-model="username"
              name="username"
              class="form-control"
              :class="{ 'is-invalid': submitted && !username }"
            />
            <div v-show="submitted && !username" class="invalid-feedback">Brugernavn er obligatorisk</div>
          </div>
          <div class="form-group">
            <label for="password">Kodeord</label>
            <input
              type="password"
              v-model="password"
              name="password"
              class="form-control"
              :class="{ 'is-invalid': submitted && !password }"
            />
            <div v-show="submitted && !password" class="invalid-feedback">kodeord er obligatorisk</div>
          </div>
          <div class="form-group">
            <button class="btn btn-primary" :disabled="loading">Login</button>
            <img
              v-show="loading"
              src="data:image/gif;base64,R0lGODlhEAAQAPIAAP///wAAAMLCwkJCQgAAAGJiYoKCgpKSkiH/C05FVFNDQVBFMi4wAwEAAAAh/hpDcmVhdGVkIHdpdGggYWpheGxvYWQuaW5mbwAh+QQJCgAAACwAAAAAEAAQAAADMwi63P4wyklrE2MIOggZnAdOmGYJRbExwroUmcG2LmDEwnHQLVsYOd2mBzkYDAdKa+dIAAAh+QQJCgAAACwAAAAAEAAQAAADNAi63P5OjCEgG4QMu7DmikRxQlFUYDEZIGBMRVsaqHwctXXf7WEYB4Ag1xjihkMZsiUkKhIAIfkECQoAAAAsAAAAABAAEAAAAzYIujIjK8pByJDMlFYvBoVjHA70GU7xSUJhmKtwHPAKzLO9HMaoKwJZ7Rf8AYPDDzKpZBqfvwQAIfkECQoAAAAsAAAAABAAEAAAAzMIumIlK8oyhpHsnFZfhYumCYUhDAQxRIdhHBGqRoKw0R8DYlJd8z0fMDgsGo/IpHI5TAAAIfkECQoAAAAsAAAAABAAEAAAAzIIunInK0rnZBTwGPNMgQwmdsNgXGJUlIWEuR5oWUIpz8pAEAMe6TwfwyYsGo/IpFKSAAAh+QQJCgAAACwAAAAAEAAQAAADMwi6IMKQORfjdOe82p4wGccc4CEuQradylesojEMBgsUc2G7sDX3lQGBMLAJibufbSlKAAAh+QQJCgAAACwAAAAAEAAQAAADMgi63P7wCRHZnFVdmgHu2nFwlWCI3WGc3TSWhUFGxTAUkGCbtgENBMJAEJsxgMLWzpEAACH5BAkKAAAALAAAAAAQABAAAAMyCLrc/jDKSatlQtScKdceCAjDII7HcQ4EMTCpyrCuUBjCYRgHVtqlAiB1YhiCnlsRkAAAOwAAAAAAAAAAAA=="
            />
          </div>
          <div v-if="error" class="alert alert-danger">{{error}}</div>
        </form>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation.vue";
import Axios from "axios";

const loginURL = "/ords/stlunch/login/user/";

export default {
  components: { Navigation },
  data() {
    return {
      username: "",
      password: "",
      submitted: false,
      loading: false,
      returnUrl: "",
      error: ""
    };
  },
  created() {
    // reset login status
    sessionStorage.removeItem("user");

    // get return url from route parameters or default to '/'
    this.returnUrl = this.$route.query.returnUrl || "/";
  },
  methods: {
    handleSubmit() {
      this.submitted = true;
      const { username, password } = this;

      // stop here if form is invalid
      if (!(username && password)) {
        return;
      }

      var router = this.$router;
      this.loading = true;
      let loginObj = { user_email: username, password: password };
      Axios.post(loginURL, loginObj).then(response => {
        var users = response.data.user;
        if (users && users.length > 0) {
          // Hent OAuth token
          //curl -i --user HvbYD_3cxzDojROh5SkNPQ..:LA39duWgf--s94lQEXsweg..
          //  --data "grant_type=client_credentials" http://192.168.122.10:8080/ords/stlunch/oauth/token
          // content-type application/x-www-form-urlencoded
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
            console.log(response.data);
            sessionStorage.setItem("access_token", response.data.access_token);
            var user = JSON.stringify(users[0]);
            sessionStorage.setItem("user", user);
            router.push(this.returnUrl);
          },
          error => {
            console.log(error);

          })
        } else {
          this.error = "Brugernavn eller kodeord er forkert";
          this.loading = false;
        }
      });
    }
  }
};
</script>