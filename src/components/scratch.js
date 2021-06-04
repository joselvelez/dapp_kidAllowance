async function addFamilyMember() {

    const [familyMemberAddress, setFamilyMemberAddress] = useState('');

    if (checkWallet()) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(contractAddress, Allowance.abi, provider);
      const tx = await contract.addFamilyMember(familyMemberAddress, familyMemberName);
      await tx.wait();
    } else {
      console.log('wallet is not connected...');
    }
  }


  <div className="family-manage">
          <div className="main">
            <div className="manage-main">
              <p><b>Manage Family</b></p>
              <br />
              <p>Add family member</p>
              <div className="manage-form">
                <form action="javascript:void(0)" method="POST">
                  <label>Name: </label>
                  <input type="text" name="familyMemberName" />
                  <label>Address:</label>
                  <input type="text" name="familyMemberAddress" />
                  <input type="button" value="Submit" onClick={addFamilyMember()} />
                </form>
              </div>
            </div>
          </div>
        </div>

const [userAddress, setUserAddress] = useState('Connect your wallet to login...');
  const [userBalance, setUserBalance] = useState('zero');
  const [userLimit, setUserLimit] = useState('0');
  const [familyName, setFamilyName] = useState('');
  const [accountStatus, setAccountStatus] = useState('');

  // update the component after loading
  useEffect(() => {

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
            <p><b>Send Money</b></p>
            <br />
            <label>Select payee</label>
            <select name="payTo" id="payTo"></select>
            <br />
            <label name="payAmount">Amount</label>
            <input type="text"></input>
            <br />
            <button className="btn">Pay</button>
          </div>