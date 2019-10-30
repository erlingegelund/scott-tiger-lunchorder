<template>
  <div>
    <navigation :showNavIcon="false"></navigation>
    <div class="row justify-content-center align-items-end">
      <div class="col col-4">
        <h2>Glemt kodeord</h2>
        <p>Bestil et nyt genereret kodeord, der bliver sendt til din e-mail</p>
        <b-form @submit.prevent="handleSubmit">
          <b-form-group label="E-mail" label-for="id_email">
            <b-form-input
              id="id-email"
              type="email"
              v-model="username"
              name="username"
              :class="{ 'is-invalid': submitted && !username }"
            />
            <div v-show="submitted && !username" class="invalid-feedback">E-mail er obligatorisk</div>
          </b-form-group>
          <b-form-group>
            <button class="btn btn-primary" :disabled="loading">Bestil</button>
            <img
              v-show="loading"
              src="data:image/gif;base64,R0lGODlhEAAQAPIAAP///wAAAMLCwkJCQgAAAGJiYoKCgpKSkiH/C05FVFNDQVBFMi4wAwEAAAAh/hpDcmVhdGVkIHdpdGggYWpheGxvYWQuaW5mbwAh+QQJCgAAACwAAAAAEAAQAAADMwi63P4wyklrE2MIOggZnAdOmGYJRbExwroUmcG2LmDEwnHQLVsYOd2mBzkYDAdKa+dIAAAh+QQJCgAAACwAAAAAEAAQAAADNAi63P5OjCEgG4QMu7DmikRxQlFUYDEZIGBMRVsaqHwctXXf7WEYB4Ag1xjihkMZsiUkKhIAIfkECQoAAAAsAAAAABAAEAAAAzYIujIjK8pByJDMlFYvBoVjHA70GU7xSUJhmKtwHPAKzLO9HMaoKwJZ7Rf8AYPDDzKpZBqfvwQAIfkECQoAAAAsAAAAABAAEAAAAzMIumIlK8oyhpHsnFZfhYumCYUhDAQxRIdhHBGqRoKw0R8DYlJd8z0fMDgsGo/IpHI5TAAAIfkECQoAAAAsAAAAABAAEAAAAzIIunInK0rnZBTwGPNMgQwmdsNgXGJUlIWEuR5oWUIpz8pAEAMe6TwfwyYsGo/IpFKSAAAh+QQJCgAAACwAAAAAEAAQAAADMwi6IMKQORfjdOe82p4wGccc4CEuQradylesojEMBgsUc2G7sDX3lQGBMLAJibufbSlKAAAh+QQJCgAAACwAAAAAEAAQAAADMgi63P7wCRHZnFVdmgHu2nFwlWCI3WGc3TSWhUFGxTAUkGCbtgENBMJAEJsxgMLWzpEAACH5BAkKAAAALAAAAAAQABAAAAMyCLrc/jDKSatlQtScKdceCAjDII7HcQ4EMTCpyrCuUBjCYRgHVtqlAiB1YhiCnlsRkAAAOwAAAAAAAAAAAA=="
            />
          </b-form-group>
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
      submitted: false,
      loading: false,
      error: ""
    };
  },
  methods: {
    handleSubmit() {
      this.submitted = true;
      const { username } = this;

      // stop here if form is invalid
      if (!(username)) {
        return;
      }

      this.loading = true;

      STLunchHelper.resetPassword(this);
    }
  }
};
</script>