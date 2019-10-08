<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Brugeradministration</h2>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col">
          <div class="container-fluid">
            <div class="row row-supplier align-items-center">
              <div class="col col-md-4">E-mail</div>
              <div class="col col-md-4">Navn</div>
              <div class="col col-md-2">Administrator</div>
              <div class="col" style="text-align: right;">
                <span @click="add()">
                  <octicon name="plus"></octicon>
                </span>
              </div>
            </div>
            <div class="row row-item align-items-center" v-for="user in users" :key="user.vkey">
              <div class="col col-md-4">
                <b-form-input
                  type="text"
                  size="sm"
                  v-model="user.user_email"
                  v-if="user.edit == true"
                  required
                  :class="{ 'is-invalid': user.submitted && !validateMail(user) }"
                ></b-form-input>
                <span v-else>{{user.user_email}}</span>
              </div>
              <div class="col col-md-4">
                <b-form-input
                  type="email"
                  size="sm"
                  v-model="user.user_name"
                  v-if="user.edit == true"
                  required
                  :class="{ 'is-invalid': user.submitted && !user.user_name }"
                ></b-form-input>
                <span v-else>{{user.user_name}}</span>
              </div>
              <div class="col col-md-2" style="text-align: center;">
                <b-form-checkbox
                  v-model="user.administrator_yn"
                  value="Y"
                  unchecked-value="N"
                  :disabled="user.edit != true"
                  switch
                />
              </div>
              <div class="col" style="text-align: right;">
                <span class="btn-check" v-if="user.edit" @click="submit(user)">
                  <octicon name="check"></octicon>
                </span>
                <span class="btn-edit" v-else @click="edit(user)">
                  <octicon name="pencil"></octicon>
                </span>
                <span class="btn-delete" @click="del(user)">
                  <octicon name="x"></octicon>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation";
import Axios from "axios";
import Octicon from "vue-octicon/components/Octicon.vue";
import { STLunchHelper } from "../_helpers/stlunch";
import "vue-octicon/icons";

const userURL = "/ords/st_lunch/stlunch_users/";
const activeUserURL = "/ords/st_lunch/stlunch_active_users/"

export default {
  components: { Navigation, Octicon },
  data() {
    return {
      users: []
    };
  },
  methods: {
    validateMail(user) {
      return STLunchHelper.validateMail(user.user_email);
    },
    add() {
      var user = {
        user_id: -this.users.length,
        user_email: "",
        user_name: "",
        administrator_yn: "N",
        edit: true
      };
      this.users.push(user);
    },
    edit(user) {
      user.edit = true;
      user.submitted = false;
      this.setVKey(user);
    },
    submit(user) {
      if (user.user_email && user.user_name && this.validateMail(user)) {
        if (user.user_id < 0) {
          Axios.post(userURL, user)
            .then(response => {
              user.user_id = response.data.user_id;
            })
            .catch(error => console.log(error));
        } else {
          Axios.put(userURL + user.user_id.toString(), user).catch(error =>
            console.log(error)
          );
        }
        user.edit = false;
        user.submitted = false;
      } else {
        user.submitted = true;
      }
      this.setVKey(user);
    },
    del(user) {
      user.inactive_yn = 'Y'
      Axios.put(userURL + user.user_id.toString(), user)
        .then(response => {
          var filtered = this.users.filter(u => u.user_id != user.user_id);
          this.users = filtered;
        })
        .catch(error => console.log(error));
    },
    setVKey(user) {
      if (user.edit != true) user.edit = false;
      user.vkey = user.user_id.toString() + ":" + user.edit.toString();
      if (user.submitted === true || user.submitted === false) {
        user.vkey += ":" + user.submitted.toString();
      }
    }
  },
  created: function() {
    Axios.get(activeUserURL).then(response => {
      var users = response.data.items;
      for (var i in users) {
        this.setVKey(users[i]);
      }
      users.sort((u1, u2) => (u1.user_name > u2.user_name ? 1 : -1));
      this.users = users;
    });
  }
};
</script>