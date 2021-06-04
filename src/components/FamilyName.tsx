import React from 'react';
import './FamilyName.css';

interface IFamilyName {
    userAddress: string;
    provider: string;
    contract: {};
}

function FamilyName(props: IFamilyName) {
    // const provider = props.provider;
    let familyName;

    props.contract.getFamilyName(userAddress).then(result => {
        familyName = result;
    })

    return (
        // <p>Address: {props.userAddress}</p>
        <p>Family Name: </p>
    );
}

export default FamilyName;