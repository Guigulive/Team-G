import React, { Component } from 'react'
import {BigNumber} from 'bignumber.js';
import PayrollContract from '../build/contracts/Payroll.json';
import getWeb3 from './utils/getWeb3'
import moment from 'moment';

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      employeeInfo: {
          employeeAds: {
              name: '员工地址',
              value: '0x0'
          },
          salary: {
              name: '员工月薪',
              value: '0 ETH'
          },
          lastPayDay: {
              name: '上次领取薪水时间',
              value: '--'
          }
      },
      web3: null
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const contract = require('truffle-contract')
    // const simpleStorage = contract(SimpleStorageContract)
    // simpleStorage.setProvider(this.state.web3.currentProvider)
    const payrollStorage = contract(PayrollContract);
    payrollStorage.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on SimpleStorage.
    var payrollStorageInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      payrollStorage.deployed().then((instance) => {
        payrollStorageInstance = instance

        // Stores a given value, 5 by default.
        return payrollStorageInstance.addEmployee('0x87f7953fcb4278be77609b1f16a2ea7a13eb7e57', 1, {from: accounts[0], gas: 3000000})
      }).then((result) => {
        var employeeInfo = payrollStorageInstance.employees.call('0x87f7953fcb4278be77609b1f16a2ea7a13eb7e57');
        return employeeInfo;
      }).then((result) => {
        let employeeAds = result[0];
        // salary
        let salary = new BigNumber(result[1] / 1e18).toNumber() + ' ETH';
        // lastPayDay
        let lastPayDay = moment(new Date(new BigNumber(result[2]).toNumber())).format('YYYY MMMM Do , h:mm:ss a');
        return this.setState({ employeeInfo: {
            employeeAds: {
                name: '员工地址',
                value: employeeAds
            },
            salary: {
                name: '员工月薪',
                value: salary
            },
            lastPayDay: {
                name: '上次领取薪水时间',
                value: lastPayDay
            }
        }});
      })
    })
  }

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">紫薇</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>欢迎来到紫薇薪酬管理系统!</h1>
              <p>哈哈哈~~想什么呢？一分儿钱都没有</p>
              <h2>想要钱？改bug去~~</h2>
              <p>刷新下试试</p>
              <div>
                {this.state.employeeInfo.employeeAds.name}:&nbsp;
                    <a
                        style={{color: '#2d8cf0'}}
                        href={'https://etherscan.io/address/' + this.state.employeeInfo.employeeAds.value}>
                         {this.state.employeeInfo.employeeAds.value}
                    </a><br/>
                {this.state.employeeInfo.salary.name}: <span style={{color: '#2d8cf0'}}>{this.state.employeeInfo.salary.value}</span><br/>
                {this.state.employeeInfo.lastPayDay.name}: <span style={{color: '#2d8cf0'}}>{this.state.employeeInfo.lastPayDay.value}</span>
              </div>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
