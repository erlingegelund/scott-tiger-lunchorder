<template>
  <div>
    <navigation :showNavIcon="true"></navigation>
    <div class="row justify-content-center align-items-end">
      <div class="col col-4">
        <h2>Skift kodeord</h2>
        <b-form @submit.prevent="handleSubmit">
          <b-form-group label="Nuværende kodeord" label-for="id-brugernavn">
            <b-form-input
              id="id-current"
              type="password"
              v-model="currentPassword"
              name="currentPassword"
              :class="{ 'is-invalid': submitted && !currentPassword }"
            />
            <div
              v-show="submitted && !username"
              class="invalid-feedback"
            >Nuværende kodeord er obligatorisk</div>
          </b-form-group>
          <b-form-group label="Nyt kodeord" label-for="id-new">
            <b-form-input
              id="id-new"
              type="password"
              v-model="newPassword"
              :class="{ 'is-invalid': submitted && !newPassword }"
            />
            <div
              v-show="submitted && !password"
              class="invalid-feedback"
            >Nyt kodeord er obligatorisk</div>
          </b-form-group>
          <b-form-group label="Gentag nyt kodeord" label-for="id-new-repeat">
            <b-form-input
              id="id-new-repeat"
              type="password"
              v-model="newPasswordRepeat"
              :class="{ 'is-invalid': submitted && !newPasswordRepeat }"
            />
            <div
              v-show="submitted && !password"
              class="invalid-feedback"
            >Gentag nyt kodeord er obligatorisk</div>
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
          </div>
          <b-alert variant="danger" :show="showError">{{error}}</b-alert>
          <b-alert variant="success" :show="showSuccess">{{success}}</b-alert>
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
      currentPassword: "",
      newPassword: "",
      newPasswordRepeat: "",
      submitted: false,
      loading: false,
      success: "",
      error: ""
    };
  },
  computed: {
    showError() {
      return this.error != "";
    },
    showSuccess() {
      return this.success != "";
    }
  },
  methods: {
    handleSubmit() {
      this.error = "";
      this.submitted = true;
      const { currentPassword, newPassword, newPasswordRepeat } = this;

      // stop here if form is invalid
      if (!(currentPassword && newPassword && newPasswordRepeat)) {
        return;
      }
      this.submitted = false;
      if (newPassword !== newPasswordRepeat) {
        this.error = "Nyt kodeord er ikke det samme";
        return;
      }
      if (currentPassword === newPasswordRepeat) {
        this.error = "Nyt kodeord er det samme som nuværende kodeord";
        return;
      }
      if (newPassword.length < 8) {
        this.error = "Nyt kodeord skal være på mindst 7 tegn";
        return;
      }
      if (
        !(
          /[a-z]/.test(newPassword) &&
          /[A-Z]/.test(newPassword) &&
          /[0-9]/.test(newPassword)
        )
      ) {
        this.error = "Nyt kodeord skal indeholde tal og små og store bogstaver";
        return;
      }

      this.loading = true;

      STLunchHelper.changePassword(this);
    }
  }
};
</script>