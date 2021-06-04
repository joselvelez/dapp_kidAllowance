import './App.css';
import { useState, useEffect } from 'react';
import { Wallet } from "./hooks/getBlockchain";

// import compiled contract ABI
import { abi }  from './artifacts/contracts/allowance.sol/Allowance.json';

// import the contract address from dappconfig and store it
import { contractAddress } from './dappConfig.js';

import FamilyName from './components/FamilyName';
import AccountSummary from './components/AccountSummary';
import { ethers } from 'ethers';

function App() {
  const [userAddress, setUserAddress] = useState('connect your wallet...');
  let contract;
  let signer;

  const getBlockchainPromise = getBlockchain();

  if (!getBlockchainPromise) {
    console.log('!getBlockchainPromise');
  }

  getBlockchain()
    .then((provider: any) => {
      provider = provider;
      // set an instance of the contract to interact with
      contract = new ethers.Contract(contractAddress, abi, provider)
      // get instance of JsonRpcSigner class for connected wallet
      signer = provider.getSigner();
    })

  // // ethers API method to get signer address
  // signer.getAddress().then(address => {
  //     setUserAddress(address);
  // });

  // helper function to check if user wallet is connected
  async function checkWallet() {
    if (typeof (window as any).ethereum === 'undefined') {
      return false;
    } else {
      return true;
    };
  }

  // if (checkWallet()) {
  //   requestAccount();
  // } else {
  //   console.log('wallet is not connected...');
  // }

  return (
    <div className="app">
      <div className="container">
        container
        <div className="account-summary">
          account summary
        </div>
      </div>
      <div className="spacer"></div>
    </div>
  );

}

export default App;