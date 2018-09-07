<template>
    <div>
        <p>{{ $route.params.id }}</p>
        <p>{{ timestampnow }}</p>
        <p>Task Amount {{ taskCount }}</p>
        <p>Complete {{ completeTask }}</p>
        <p>Cancel {{ cancelTask }}</p>
        <p>Fail {{ failTask }}</p>
    </div>
</template>

<script>
import TaskForce from '~/build/contracts/TaskForce.json'
import Web3 from 'web3'

export default {
    data() {
      return {
        timestampnow: '',
        taskCount: '',
        completeTask: '',
        cancelTask: '',
        failTask: ''
      }
    },
    mounted() {
      this.init()
    },
    methods: {
      async init() {
        this.web3 = new Web3(window.web3.currentProvider)
        this.web3.eth.defaultAccount = this.web3.eth.accounts[0]
        const taskforceabi = TaskForce.abi
        const taskforceaddress = '0xc0b23b4907376f64c1d84281c6b6e4a88159f269'
        this.taskforce = this.web3.eth
          .contract(taskforceabi)
          .at(taskforceaddress)
        this.taskforce.getInfo.call((err,res) => {
          this.timestampnow = res[0]
          this.taskCount = res[1]
          this.completeTask = res[2]
          this.cancelTask = res[3]
          this.failTask = res[4]
        })
      }
    }
}
</script>
