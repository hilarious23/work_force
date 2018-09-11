<template>
    <div>
        <section>
          <p>{{ $route.params.id }}</p>
          <p>Balance {{ balance }} ETH</p>
          <p>Owner {{ owner }}</p>
          <p>Receiver {{ receiver }}</p>
          <input type="text" v-model="receiverAddress">
          <button @click="setReceiverAddress">setReceiverAddress</button>
          <p>Task Amount {{ taskCount }}</p>
          <p>Complete {{ completedTask }}</p>
          <p>Cancel {{ canceledTask }}</p>
          <p>Fail {{ failTask }}</p>
          <p>Lost Amount {{ lostEth }} ETH</p>
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
              <p>inTime {{ struct.inTime }}</p>
              <p>{{ struct.task }}</p>
              <p>{{ struct.deadline }}</p>
              <p>{{ struct.value }} ETH</p>
              <button @click="completeTask(struct.idx)">Complete</button>
              <button @click="cancelTask(struct.idx)">Cancel</button>
              <button @click="getReward(struct.ids)">Get Reward</button>
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
        balance: '',
        owner: '',
        receiver: '',
        receiverAddress: '',
        taskCount: '',
        completedTask: '',
        canceledTask: '',
        failTask: '',
        newtask: '',
        date: '',
        idx: 0,
        inTime: true,
        task: '',
        deadline: '',
        value: '',
        array: [],
        lostEth: '',
      }
    },
    mounted() {
      this.init()
    },
    methods: {
      async init() {
        const taskforce = TaskForce(this.$route.params.id);
        const num = await web3.eth.getBalance(this.$route.params.id);
        console.log(num);
        this.balance = await Math.floor(web3.utils.fromWei(num, 'ether') * 10000) / 10000;
        this.owner = await taskforce.methods.manager().call();
        const info = await taskforce.methods.getInfo().call();
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
              .call();
            if (res[1] == false) {
              var obj = {};
              this.idx = i;
              this.task = res[2];
              this.deadline = moment(res[3]*1000).format('MMMM Do YYYY, h:mm:ss a');
              if (res[3]*1000 <= Date.now()) {
                this.inTime = false;
              }
              this.value = Math.floor(web3.utils.fromWei(res[4], 'ether') * 10000) / 10000;
              obj['idx'] = this.idx;
              obj['inTime'] = this.inTime;
              obj['task'] = this.task;
              obj['deadline'] = this.deadline;
              obj['value'] = this.value;
              this.array.push(obj);
            }
          }
        const lostValue = await taskforce.methods.lostValue().call()
        this.lostEth = Math.floor(web3.utils.fromWei(lostValue, 'ether') * 10000) / 10000
      },
      async setReceiverAddress() {
        this.loading = true;
        try {
          const taskforce = TaskForce(this.$route.params.id);
          const accounts = await web3.eth.getAccounts();
          await taskforce.methods
            .setReceiverAddress(this.receiverAddress)
            .send({ from: accounts[0] });
          console.log('success');
          this.$router.go(`/taskforce/`)
          redirect('/')
        } catch (err) {
          console.log(err);
          this.errorMessage = err.message;
        }
        this.loading = false;
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
              value: 1000000000000000
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
      async getReward() {
        this.loading = true
        try {
          const taskforce = TaskForce(this.$route.params.id);
          const accounts = await web3.eth.getAccounts();
          console.log(this.idx)
          await taskforce.methods
            .getReward(
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
