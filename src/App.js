import './App.css';
import { useState, useEffect } from 'react';

// import compiled contract
import Allowance from './artifacts/contracts/allowance.sol/Allowance.json';

// import the contract address from dappconfig and store it
import { contractAddress } from './dappConfig';

// import ethers library
const { ethers, BigNumber } = require("ethers");

function App() {

  // state variables
  const [userAddress, setUserAddress] = useState('Connect your wallet to login...');
  const [userBalance, setUserBalance] = useState('zero');
  const [userLimit, setUserLimit] = useState('0');
  const [familyName, setFamilyName] = useState('');
  const [accountStatus, setAccountStatus] = useState('');

  // helper function to check if wallet is installed, if so, connect to it
  async function checkWallet() {
    if (typeof window.ethereum === 'undefined') {
      return false;
    } else {
      return true;
    }
  }

  // request access to the user's wallet
  async function requestAccount() {
    await window.ethereum.request({method: 'eth_requestAccounts'});
    console.log('connected to your wallet');
  }

  // update the component after loading
  useEffect(() => {
    
    if (checkWallet()) {
      // if a wallet is defined, set an instance of provider to that wallet
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      // set an instance of the contract to interact with
      const contract = new ethers.Contract(contractAddress, Allowance.abi, provider);
      // get instance of JsonRpcSigner class for connected wallet
      const signer = provider.getSigner();

      // update UI with user's connected address, balance, spending limit
      signer.getAddress().then((address) => {
        setUserAddress(address)

        contract.checkBalance(address).then((balance) => {
          setUserBalance(balance.toNumber());
        })

        contract.getFamilyName(address).then(familyName => {
          setFamilyName(familyName);
        })

        contract.getSpendLimit(address).then((limit) => {
          setUserLimit(limit.toNumber());
        })

        contract.getAccountStatus(address).then(actStatus => {
          if (actStatus) {
            setAccountStatus('Active');
          } else {
            setAccountStatus('Frozen');
          }
        })

      })
      
      requestAccount();
    } else {
      console.log('wallet is not connected');
    }

  }, [userAddress, userBalance])

  async function getFamilyName() {
    
  }

  return (
    <div className="app">
      <div className="container">
        <p className="family-name">{familyName}</p>
        <div className="main">
          <div className="account-summary">
            <p><b>Account Summary</b></p>
            <br />
            <p>Account Number</p>
            <p>{userAddress}</p>
            <br />
            <p>Account Balance</p>
            <p>${userBalance}</p>
            <br />
            <p>Spending Limit</p>
            <p>${userLimit}</p>
            <br />
            <p>Status</p>
            <p>{accountStatus}</p>
          </div>
          <div className="account-txs">
            Transactions
          </div>
        </div>
      </div>
      <div className="spacer"></div>
    </div>
  );

}

export default App;
