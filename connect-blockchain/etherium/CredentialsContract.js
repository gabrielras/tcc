require('dotenv').config();

const Web3 = require('web3');
const web3 = new Web3(process.env.WEB3_PROVIDER_URL);

const contractAddress = process.env.CONTRACT_ADDRESS;
const contractAbi = require('../../ethereum-contracts/build/contracts/CredentialsContract.json').abi;

async function estimateGas(method, params) {
  try {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const accounts = await web3.eth.getAccounts();
    const estimatedGas = await method.estimateGas({ from: accounts[0] });
    return estimatedGas;
  } catch (error) {
    throw error;
  }
}

async function addCredential(id, name, institution_id, author, metadata, event_id) {
  try {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const accounts = await web3.eth.getAccounts();
    const method = contract.methods.addCredential(id, name, institution_id, author, metadata, event_id);
    const estimatedGas = await estimateGas(method);

    const transaction = await method.send({ from: accounts[0], gas: estimatedGas });
    return transaction;
  } catch (error) {
    throw error;
  }
}

async function editCredential(id, name, institution_id, author, metadata, event_id) {
  try {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const accounts = await web3.eth.getAccounts();
    const method = contract.methods.editCredential(id, name, institution_id, author, metadata, event_id);
    const estimatedGas = await estimateGas(method);

    const transaction = await method.send({ from: accounts[0], gas: estimatedGas });
    return transaction;
  } catch (error) {
    throw error;
  }
}

async function removeCredential(id) {
  try {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const accounts = await web3.eth.getAccounts();
    const method = contract.methods.removeCredential(id);
    const estimatedGas = await estimateGas(method);

    const transaction = await method.send({ from: accounts[0], gas: estimatedGas });
    return transaction;
  } catch (error) {
    throw error;
  }
}

const functions = {
  addCredential: async (args) => {
    // args = [id, name, institution_id, author, metadata, event_id]
    const transaction = await contract.methods.addCredential(...args)
      .send({ from: (await web3.eth.getAccounts())[0] });
    return transaction;
  },
  editCredential: async (args) => {
    const transaction = await contract.methods.editCredential(...args)
      .send({ from: (await web3.eth.getAccounts())[0] });
    return transaction;
  },
  removeCredential: async (args) => {
    const transaction = await contract.methods.removeCredential(...args)
      .send({ from: (await web3.eth.getAccounts())[0] });
    return transaction;
  },
  addCredentialEstimate: async (args) => {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const method = contract.methods.addCredential(...args);
    return await estimateGas(method);
  },
  editCredentialEstimate: async (args) => {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const method = contract.methods.editCredential(...args);
    return await estimateGas(method);
  },
  removeCredentialEstimate: async (args) => {
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
    const method = contract.methods.removeCredential(...args[0]);
    return await estimateGas(method);
  }
};

const main = async () => {
  const functionName = process.argv[2]; // e.g., "addCredentialEstimate"
  const attributes = process.argv.slice(3); // e.g., ["123", "John Doe", "ABC123", "Alice", "Some metadata", "Event123"]
  
  if (functions[functionName]) {
    try {
      const result = await functions[functionName](attributes);
      if (functionName.includes('Estimate')) {
        console.log(`${result}`);
      } else {
        console.log(result);
      }
    } catch (error) {
      console.error(error);
    }
  } else {
    console.error('Function not found');
  }
};

main();
