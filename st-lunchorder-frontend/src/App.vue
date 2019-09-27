<template>
  <div id="app">
    <div class="row">
      <div class="col">
        <navigation></navigation>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <order/>
      </div>
    </div>
    
  </div>
</template>

<script>
import Navigation from './components/Navigation'
import Order from './components/Order.vue'

export default {
  name: 'app',
  components: {
    Navigation,
    Order
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: left;
  color: #2c3e50;
  margin-top: 10px;
}
</style>
