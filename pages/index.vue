<template>
  <div>
    <section>
      <div id="v-for-object">
        <div v-for="obj in array" :key="obj.id">
          <nuxt-link :to="'/taskforce/' + obj.taskForce">
            <p>{{ obj.taskForce }}</p>
          </nuxt-link>
        </div>
      </div>
    </section>
    <section>
      <button @click="createTaskForce">Create</button> 
    </section>
  </div>
</template>

<script>
import web3 from '../ethereum/web3'
import factory from '../ethereum/factory'

export default {
    data() {
      return {
        loading: '',
        deployedTaskForce0: '',
        taskForce: '',
        array: [],
        errorMessage: ''
      }
    },
    mounted() {
      this.init()
    },
    methods: {
      async init() {
        var res = await factory.methods.getDeployedTaskForces().call()
        for(var i = 0;  i < res.length;  i++) {
          var obj = {};
          this.taskForce = await res[i]
          obj['taskForce'] = this.taskForce;
          this.array.push(obj);
        }
      },
      async createTaskForce() {
        this.loading = true
        try {
          const accounts = await web3.eth.getAccounts();
          await factory.methods
            .createTaskForce()
            .send({ from: accounts[0] });
          console.log('success')
          this.$router.go(`/taskforce/`)
          redirect('/')
        }
        catch (err) {
          console.log(err)
          this.errorMessage = err.message
        }
        this.loading = false
      },
    }
}
</script>

<style>
</style>
