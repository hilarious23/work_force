<template>
    <div>
        <section>
          <p>{{ $route.params.id }}</p>
          <p>Owner {{ owner }}</p>
          <p>Receiver {{ receiver }}</p>
          <input type="text" v-model="receiverAddress">
          <button @click="setReceiverAddress">setReceiverAddress</button>
          <p>{{ timestampnow }}</p>
          <p>Task Amount {{ taskCount }}</p>
          <p>Complete {{ completedTask }}</p>
          <p>Cancel {{ canceledTask }}</p>
          <p>Fail {{ failTask }}</p>
        </section>
        <section>
          <input type="text" v-model="newtask">
          <input type="int" v-model="date">
          <button @click="createTask">create New Task</button>            
        </section>
        <section>
          <div id="v-for-object">
            <div v-for="struct in array" :key="struct.id">
              <p>{{ struct.status }}</p>
              <p>{{ struct.task }}</p>
              <p>{{ struct.deadline }}</p>
              <p>{{ struct.value }}</p>
              <p>{{ struct.idx }}</p>
              <button @click="completeTask(index)">Complete</button>
              <button @click="cancelTask(index)">Cancel</button>
            </div>
          </div>
        </section>
    </div>
</template>

<script>
import TaskForce from '~/build/contracts/TaskForce.json'
import Web3 from 'web3'
import moment from 'moment'

export default {
    data() {
      return {
        loading: false,
        owner: '',
        receiver: '',
        receiverAddress: '',
        timestampnow: '',
        taskCount: '',
        completedTask: '',
        canceledTask: '',
        failTask: '',
        newtask: '',
        date: '',
        idx: 0,
        status: false,
        task: '',
        deadline: '',
        value: '',
        array: [],
        index: 0,
      }
    },
    mounted() {
      this.$nextTick(() => {
        this.init()
      });
    },
    methods: {
      async init() {
        this.web3 = new Web3(window.web3.currentProvider)
        this.web3.eth.defaultAccount = this.web3.eth.accounts[0]
        const taskforceabi = TaskForce.abi
        const taskforceaddress = this.$route.params.id
        this.taskforce = this.web3.eth
          .contract(taskforceabi)
          .at(taskforceaddress)
        this.taskforce.manager.call((err,res) => {
          this.owner = res
          this.taskforce.getInfo.call((err,res) => {
          this.timestampnow = res[0]
          this.taskCount = res[1]
          this.completedTask = res[2]
          this.canceledlTask = res[3]
          this.failTask = res[4]
          for(var i = 0;  i < this.taskCount;  i++) {
            this.idx = i
            console.log(this.idx)
            this.taskforce.addresstotasks.call(
              this.owner,
              i,
              (err, res) => {
                var obj = {};
                this.status = res[1]
                this.task = res[2]
                this.deadline = moment(res[3].toNumber()*1000).format('MMMM Do YYYY, h:mm:ss a')
                this.value = res[4].toNumber()
                obj['idx'] = this.idx;
                obj['status'] = this.status;
                obj['task'] = this.task;
                obj['deadline'] = this.deadline;
                obj['value'] = this.value;
                this.array.push(obj);
              }
            )
          }
        })
        })
        this.taskforce.receiverAddress.call((err,res) => {
          this.receiver = res
        })
      },
      async setReceiverAddress() {
        this.loading = true
        try {
          await this.taskforce.setReceiverAddress.sendTransaction(
            this.receiverAddress,
            { from: this.web3.eth.accounts[0] },
          (err, transactionhash) => {
            console.log(transactionhash)
            const timer = setInterval(() => {
              this.web3.eth.getTransactionReceipt(
                transactionhash,
                (err, res) => {
                  if (res === null) {
                    return
                  } else if (res.status === '0x0') {
                    console.error(res)
                  } else {
                    console.log('success')
                    this.$router.go(`/taskforce/${this.$route.params.id}`)
                    redirect('/')
                    clearInterval(timer)
                  }
                }
              )
            }, 1000)
          }
        )
      } catch (err) {
        console.log(err)
        this.errorMessage = err.message
      }
      this.loading = false
      },
      async createTask() {
        this.loading = true
        try {
          await this.taskforce.createTask.sendTransaction(
            this.newtask.toString(),
            this.date,
            {
              from: this.web3.eth.accounts[0],
              value: 1  
            },
          (err, transactionhash) => {
            console.log(transactionhash)
            const timer = setInterval(() => {
              this.web3.eth.getTransactionReceipt(
                transactionhash,
                (err, res) => {
                  if (res === null) {
                    return
                  } else if (res.status === '0x0') {
                    console.error(res)
                  } else {
                    console.log('success')
                    this.$router.go(`/taskforce/${this.$route.params.id}`)
                    redirect('/')
                    clearInterval(timer)
                  }
                }
              )
            }, 1000)
          }
        )
      } catch (err) {
        console.log(err)
        this.errorMessage = err.message
      }
      this.loading = false
      },
      async completeTask(index) {
        this.loading = true
        this.index = 1
        console.log(this.index)
        try {
          await this.taskforce.completeTask.sendTransaction(
            this.index,
            { from: this.web3.eth.accounts[0] },
          (err, transactionhash) => {
            console.log(transactionhash)
            const timer = setInterval(() => {
              this.web3.eth.getTransactionReceipt(
                transactionhash,
                (err, res) => {
                  if (res === null) {
                    return
                  } else if (res.status === '0x0') {
                    console.error(res)
                  } else {
                    console.log('success')
                    this.$router.go(`/taskforce/${this.$route.params.id}`)
                    redirect('/')
                    clearInterval(timer)
                  }
                }
              )
            }, 1000)
          }
        )
      } catch (err) {
        console.log(err)
        this.errorMessage = err.message
      }
      this.loading = false
      },
      async cancelTask(index) {
        this.loading = true
        this.index = 1
        console.log(this.index)
        try {
          await this.taskforce.cancelTask.sendTransaction(
            this.index,
            { from: this.web3.eth.accounts[0] },
          (err, transactionhash) => {
            console.log(transactionhash)
            const timer = setInterval(() => {
              this.web3.eth.getTransactionReceipt(
                transactionhash,
                (err, res) => {
                  if (res === null) {
                    return
                  } else if (res.status === '0x0') {
                    console.error(res)
                  } else {
                    console.log('success')
                    this.$router.go(`/taskforce/${this.$route.params.id}`)
                    redirect('/')
                    clearInterval(timer)
                  }
                }
              )
            }, 1000)
          }
        )
      } catch (err) {
        console.log(err)
        this.errorMessage = err.message
      }
      this.loading = false
      },
    }    
}
</script>
