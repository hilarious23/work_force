<template>
  <div>
    <nuxt-link :to="'/taskforce/' + deployedContract">
      {{ deployedContract }}
    </nuxt-link>
  </div>
</template>

<script>
import Factory from '~/build/contracts/Factory.json'
import Web3 from 'web3'

export default {
    data() {
      return {
        deployedContract: ''
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
          res.map(address => {
              this.deployedContract = address
          })
        })
      }
    }
}
</script>

<style>
</style>
