<template>
  <section>
    <div id="v-for-object">
      <div v-for="obj in array" :key="obj.id">
        <nuxt-link :to="'/taskforce/' + obj.taskForce">
          <p>{{ obj.taskForce }}</p>
        </nuxt-link>
      </div>
    </div>
  </section>
</template>

<script>
import Factory from '~/build/contracts/Factory.json'
import Web3 from 'web3'
import factory from '../ethereum/factory';

export default {
    data() {
      return {
        deployedTaskForce0: '',
        taskForce: '',
        array: []
      }
    },
    mounted() {
      this.init()
    },
    methods: {
      async init() {
        var res = await factory.methods.getDeployedTaskForces().call()
        for(var i = 0;  i < 2;  i++) {
          var obj = {};
          this.taskForce = await res[i]
          console.log(i)
          obj['taskForce'] = this.taskForce;
          this.array.push(obj);
        }
      
        // this.web3 = new Web3(window.web3.currentProvider)
        // this.web3.eth.defaultAccount = this.web3.eth.accounts[0]
        // const factoryabi = Factory.abi
        // const factoryaddress = Object.values(Factory.networks)[0].address
        // this.factory = this.web3.eth
        //   .contract(factoryabi)
        //   .at(factoryaddress)
        // this.factory.getDeployedTaskForces.call((err,res) => {
        //       this.deployedTaskForce0 = res[0]
        //       this.deployedTaskForce1 = res[1]
        // })
      }
    }
}
</script>

<style>
</style>
