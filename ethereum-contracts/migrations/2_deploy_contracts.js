const CredentialsContract = artifacts.require("CredentialsContract");
const SafeCredentialsContract = artifacts.require("SafeCredentialsContract");

module.exports = function(deployer) {
  deployer.deploy(CredentialsContract);
  deployer.deploy(SafeCredentialsContract);
};
