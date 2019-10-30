<template>
  <div>
    <navigation :showNavIcon="false"></navigation>
    <div class="row justify-content-center align-items-end">
      <div class="col col-4">
        <h2>Login</h2>
        <b-form @submit.prevent="handleSubmit">
          <b-form-group label="Brugernavn" label-for="id-brugernavn">
            <b-form-input
              id="id-brugernavn"
              type="email"
              v-model="username"
              name="username"
              :class="{ 'is-invalid': submitted && !username }"
            />
            <div v-show="submitted && !username" class="invalid-feedback">Brugernavn er obligatorisk</div>
          </b-form-group>
          <b-form-group label="Kodeord" label-for="id-password">
            <b-form-input
              id="id-password"
              type="password"
              v-model="password"
              name="password"
              :class="{ 'is-invalid': submitted && !password }"
            />
            <div v-show="submitted && !password" class="invalid-feedback">kodeord er obligatorisk</div>
          </b-form-group>
          <div class="d-flex align-items-baseline">
            <div class="p-0 flex-grow-1">
              <div class="form-group">
                <button class="btn btn-primary" :disabled="loading">Login</button>
                <img
                  v-show="loading"
                  src="data:image/gif;base64,R0lGODlhEAAQAPIAAP///wAAAMLCwkJCQgAAAGJiYoKCgpKSkiH/C05FVFNDQVBFMi4wAwEAAAAh/hpDcmVhdGVkIHdpdGggYWpheGxvYWQuaW5mbwAh+QQJCgAAACwAAAAAEAAQAAADMwi63P4wyklrE2MIOggZnAdOmGYJRbExwroUmcG2LmDEwnHQLVsYOd2mBzkYDAdKa+dIAAAh+QQJCgAAACwAAAAAEAAQAAADNAi63P5OjCEgG4QMu7DmikRxQlFUYDEZIGBMRVsaqHwctXXf7WEYB4Ag1xjihkMZsiUkKhIAIfkECQoAAAAsAAAAABAAEAAAAzYIujIjK8pByJDMlFYvBoVjHA70GU7xSUJhmKtwHPAKzLO9HMaoKwJZ7Rf8AYPDDzKpZBqfvwQAIfkECQoAAAAsAAAAABAAEAAAAzMIumIlK8oyhpHsnFZfhYumCYUhDAQxRIdhHBGqRoKw0R8DYlJd8z0fMDgsGo/IpHI5TAAAIfkECQoAAAAsAAAAABAAEAAAAzIIunInK0rnZBTwGPNMgQwmdsNgXGJUlIWEuR5oWUIpz8pAEAMe6TwfwyYsGo/IpFKSAAAh+QQJCgAAACwAAAAAEAAQAAADMwi6IMKQORfjdOe82p4wGccc4CEuQradylesojEMBgsUc2G7sDX3lQGBMLAJibufbSlKAAAh+QQJCgAAACwAAAAAEAAQAAADMgi63P7wCRHZnFVdmgHu2nFwlWCI3WGc3TSWhUFGxTAUkGCbtgENBMJAEJsxgMLWzpEAACH5BAkKAAAALAAAAAAQABAAAAMyCLrc/jDKSatlQtScKdceCAjDII7HcQ4EMTCpyrCuUBjCYRgHVtqlAiB1YhiCnlsRkAAAOwAAAAAAAAAAAA=="
                />
              </div>
            </div>
            <div class="p-0">
              <router-link :to="{name: 'Reset'}">Glemt kodeord</router-link>
            </div>
          </div>
          <div v-if="error" class="alert alert-danger">{{error}}</div>
        </b-form>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation.vue";
import { STLunchHelper } from "../_helpers/stlunch";

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
    sessionStorage.removeItem(STLunchHelper.userStorage);
    sessionStorage.removeItem(STLunchHelper.tokenStorage);

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

      this.loading = true;

      STLunchHelper.doLogin(this, username, password);
    }
  }
};
</script>