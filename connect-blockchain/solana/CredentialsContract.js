const { Keypair, Connection, Transaction, PublicKey } = require('@solana/web3.js');

// Defina as informações necessárias para se conectar à rede Solana local
const rpcUrl = 'http://127.0.0.1:8899';
const connection = new Connection(rpcUrl, 'confirmed');

// Defina a chave privada do remetente
const privateKey = Uint8Array.from([/* inserir a chave privada do remetente aqui */]);
const payerAccount = Keypair.fromSecretKey(privateKey);

// Importe a chave pública e o endereço do contrato Solana
const contractPublicKey = new PublicKey(/* inserir a chave pública do contrato Solana aqui */);

// Defina os dados da instrução para a operação desejada
const instructionData = {
  id: '123',
  name: 'John Doe',
  institution_id: 'ABC123',
  author: 'Alice',
  metadata: 'Some metadata'
};

// Converta os dados da instrução para um buffer antes de enviar
const instructionBuffer = Buffer.from(JSON.stringify(instructionData));

const transaction = new Transaction().add({
    keys: [{ pubkey: contractPublicKey, isSigner: false, isWritable: true }],
    programId: contractPublicKey,
    data: instructionBuffer,
});

// Assine a transação com a chave privada do remetente
transaction.sign(payerAccount);

// Envie a transação para a rede Solana
(async () => {
    try {
        const signature = await connection.sendTransaction(transaction, [payerAccount]);
        console.log('Transação enviada. Aguardando confirmação...');

        // Aguarde a confirmação da transação
        await connection.confirmTransaction(signature, 'confirmed');
        console.log('Transação confirmada com sucesso.');
    } catch (error) {
        console.error('Erro ao enviar transação:', error);
    }
})();
