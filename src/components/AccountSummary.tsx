import React from 'react';
import './AccountSummary.css';

interface IAccountSummary {
  userAddress: string;
}

function AccountSummary(props: IAccountSummary) {
    return (
      <p>{props.userAddress}</p>  
    );
}

export default AccountSummary;