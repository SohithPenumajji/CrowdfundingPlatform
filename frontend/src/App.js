import React, { Component } from 'react';
import Header from "./components/Header";
import ReactDOM from "react-dom";
import ConnectMetamask from './ConnectMetamask';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <Header/>
        <ConnectMetamask />
      </div>
    );
  }
}

export default App;
