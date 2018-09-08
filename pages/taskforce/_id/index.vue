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
              <p>Index: {{ struct.idx }}</p>
              <p>{{ struct.status }}</p>
              <p>{{ struct.task }}</p>
              <p>{{ struct.deadline }}</p>
              <p>{{ struct.value }}</p>
              <button @click="completeTask(struct.idx)">Complete</button>
              <button @click="cancelTask(struct.idx)">Cancel</button>
            </div>
          </div>
        </section>
    </div>
</template>

<script>
import web3 from '../../../ethereum/web3'
import TaskForce from '../../../ethereum/taskForce';
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
      }
    },
    mounted() {
      this.init()
    },
    methods: {
      async init() {
        const taskforce = TaskForce(this.$route.params.id);
        this.owner = await taskforce.methods.manager().call()
        const info = await taskforce.methods.getInfo().call();
          this.timestampnow = info[0]
          this.taskCount = info[1]
          this.completedTask = info[2]
          this.canceledlTask = info[3]
          this.failTask = info[4]
        this.receiver = await taskforce.methods.receiverAddress().call()
          for(var i = 0;  i < this.taskCount;  i++) {
            var res = await taskforce.methods
              .addresstotasks(
                this.owner,
                i
              )
              .call()
            console.log(res)
            var obj = {};
            this.idx = i
            this.status = res[1]
            this.task = res[2]
            this.deadline = moment(res[3]*1000).format('MMMM Do YYYY, h:mm:ss a')
            this.value = res[4]
            obj['idx'] = this.idx;
            obj['status'] = this.status;
            obj['task'] = this.task;
            obj['deadline'] = this.deadline;
            obj['value'] = this.value;
            this.array.push(obj);
          }
        
      },
      async setReceiverAddress() {
        this.loading = true
        try {
          const taskforce = TaskForce(this.$route.params.id);
          const accounts = await web3.eth.getAccounts();
          await taskforce.methods
            .setReceiverAddress(this.receiverAddress)
            .send({ from: accounts[0] })
          console.log('success')
          this.$router.go(`/taskforce/`)
          redirect('/')
        } catch (err) {
          console.log(err)
          this.errorMessage = err.message
        }
        this.loading = false
      },
      async createTask() {
        this.loading = true
        try {
          const taskforce = TaskForce(this.$route.params.id);
          const accounts = await web3.eth.getAccounts();
          await taskforce.methods
            .createTask(
              this.newtask.toString(),
              this.date
            )
            .send(
            {
              from: accounts[0],
              value: 1  
            })
          console.log('success')
          this.$router.go(`/taskforce/`)
          redirect('/')
        } catch (err) {
          console.log(err)
          this.errorMessage = err.message
        }
        this.loading = false
      },
      async completeTask() {
        this.loading = true
        try {
          const taskforce = TaskForce(this.$route.params.id);
          const accounts = await web3.eth.getAccounts();
          console.log(this.idx)
          await taskforce.methods
            .completeTask(
              this.idx
            )
            .send({ from: accounts[0] })
          console.log('success')
          this.$router.go(`/taskforce/`)
          redirect('/')
        } catch (err) {
          console.log(err)
          this.errorMessage = err.message
        }
        this.loading = false
      },
      async cancelTask() {
        this.loading = true
        try {
          const taskforce = TaskForce(this.$route.params.id);
          const accounts = await web3.eth.getAccounts();
          console.log(this.idx)
          await taskforce.methods
            .cancelTask(
              this.idx
            )
            .send({ from: accounts[0] })
          console.log('success')
          this.$router.go(`/taskforce/`)
          redirect('/')
        } catch (err) {
          console.log(err)
          this.errorMessage = err.message
        }
        this.loading = false
      },
    }    
}
</script>
