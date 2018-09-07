<template>
  <section>
    <div>
      <nuxt-link :to="'/taskforce/' + deployedTaskForce0">
        {{ deployedTaskForce0 }}
      </nuxt-link>
    </div>
    <div>
      <nuxt-link :to="'/taskforce/' + deployedTaskForce1">
        {{ deployedTaskForce1 }}
      </nuxt-link>
    </div>
  </section>
</template>

<script>
import Factory from '~/build/contracts/Factory.json'
import Web3 from 'web3'

export default {
    data() {
      return {
        deployedTaskForce0: '',
        deployedTaskForce1: ''
      }
    },
    mounted() {
      this.init()
    },
    methods: {
      async init() {
        this.web3 = new Web3(window.web3.currentProvider)
        this.web3.eth.defaultAccount = this.web3.eth.accounts[0]
        const factoryabi = Factory.abi
        const factoryaddress = Object.values(Factory.networks)[0].address
        this.factory = this.web3.eth
          .contract(factoryabi)
          .at(factoryaddress)
        this.factory.getDeployedTaskForces.call((err,res) => {
              this.deployedTaskForce0 = res[0]
              this.deployedTaskForce1 = res[1]
        })
      }
    }
}
</script>

<style>
</style>
