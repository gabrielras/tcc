// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CredentialsContract {
    struct Credential {
        string id;
        string name;
        string institution_id;
        string author;
        string metadata;
        string event_id;
    }

    mapping(string => Credential) credentials;

    function addCredential(string memory _id, string memory _name, string memory _institution_id, string memory _author, string memory _metadata, string memory _event_id) public {
        Credential memory newCredential = Credential(_id, _name, _institution_id, _author, _metadata, _event_id);
        credentials[_id] = newCredential;
    }

    function editCredential(string memory _id, string memory _name, string memory _institution_id, string memory _author, string memory _metadata, string memory _event_id) public {
        Credential storage credential = credentials[_id];
        credential.name = _name;
        credential.institution_id = _institution_id;
        credential.author = _author;
        credential.metadata = _metadata;
        credential.event_id = _event_id;
    }

    function removeCredential(string memory _id) public {
        delete credentials[_id];
    }
}
