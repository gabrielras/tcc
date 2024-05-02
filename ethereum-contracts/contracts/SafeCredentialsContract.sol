// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeCredentialsContract {
    struct Credential {
        string id;
        string name;
        string institution_id;
        string author;
        string metadata;
        string event_id;
    }

    mapping(string => Credential) credentials;

    function addCredentials(string[] memory _ids, string[] memory _names, string[] memory _institution_ids, string[] memory _authors, string[] memory _metadata, string[] memory _event_ids) public {
        require(_ids.length == _names.length && _ids.length == _institution_ids.length && _ids.length == _authors.length && _ids.length == _metadata.length && _ids.length == _event_ids.length, "Arrays length mismatch");
        
        for(uint i = 0; i < _ids.length; i++) {
            credentials[_ids[i]] = Credential(_ids[i], _names[i], _institution_ids[i], _authors[i], _metadata[i], _event_ids[i]);
        }
    }

    function editCredentials(string[] memory _ids, string[] memory _names, string[] memory _institution_ids, string[] memory _authors, string[] memory _metadata, string[] memory _event_ids) public {
        require(_ids.length == _names.length && _ids.length == _institution_ids.length && _ids.length == _authors.length && _ids.length == _metadata.length && _ids.length == _event_ids.length, "Arrays length mismatch");

        for(uint i = 0; i < _ids.length; i++) {
            Credential storage credential = credentials[_ids[i]];
            credential.name = _names[i];
            credential.institution_id = _institution_ids[i];
            credential.author = _authors[i];
            credential.metadata = _metadata[i];
            credential.event_id = _event_ids[i]; // Atualiza o event_id
        }
    }

    function removeCredentials(string[] memory _ids) public {
        for(uint i = 0; i < _ids.length; i++) {
            delete credentials[_ids[i]];
        }
    }
}
