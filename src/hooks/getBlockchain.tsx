import React from 'react';
import { useWeb3React, Web3ReactProvider } from '@web3-react/core';
import { InjectedConnector } from '@web3-react/injected-connector';
import { Web3Provider } from '@ethersproject/providers';
import { ethers } from 'ethers';

export const injectedConnector = new InjectedConnector({
    supportedChainIds: [
        1, // Mainnet
        3, // Ropsten
        4, // Rinkeby
        5, // Goerli
        42, // Kovan
    ],
})

function getLibrary(provider: any): Web3Provider {
    const library = new Web3Provider(provider);
    library.pollingInterval = 12000;
    return library;
}

export const Wallet = () => {
    const { chainId, account, activate, active } = useWeb3React<Web3Provider>();

    const onClick = () => {
        activate(injectedConnector);
    }

    return (
        <div>
            <div>ChainId: {chainId}</div>
            <div>Account: {account}</div>
            {active ? (
                <div>Checkmark</div>
            ) : (
                <button type="button" onClick={onClick}>
                    Connect
                </button>
            )}
        </div>
    )
}