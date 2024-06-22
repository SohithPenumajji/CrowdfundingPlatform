import React,{ useEffect, useState } from "react";
import { ethers } from 'ethers';

function ConnectMetamask() {

    const [account, setAccount] = useState(null);
    const [error, setError] = useState(null);


    useEffect(() => {
        if (window.ethereum) {
            window.ethereum.on('accountChanged', handleAccountsChanged);
        }

        return () => {
            if(window.ethereum) {
                window.ethereum.removeListener('accountsChanged',handleAccountsChanged);
            }
        };
    }, []);

    const handleAccountsChanged = (accounts) => {
        if (accounts.length === 0) {
            console.log('connect to metamask');
        } else {
            setAccount(accounts[0]);
        }
    };

    // important function
    const connectWallet = async () => {
        if (window.ethereum) {
            try {
                const accounts = await window.ethereum.request({ method: 'eth_requestedAccounts'});
                setAccount(accounts[0]);

                const provider  = new ethers.providers.Web3Provider(window.ethereum);
                console.log('Provider:',provider);
            } catch(err) {
                setError(err.message);
            }
        }
        else {
            setError('Metamask is not installed');
        }
    };


    return (
        <div>
            <h1>Connect to MetaMask</h1>
            <button onClick={connectWallet}>Connect Wallet</button>
            {account && <p>Connected Account: {account}</p>}
            {error && <p style={{color:'red'}}>{error}</p>}
        </div>
    )


}

export default ConnectMetamask;