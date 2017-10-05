pragma solidity ^0.4.15;

contract RewardTask {

    address private owner;
    address[] suggestionAddresses;

    event OutputSuggestion(address indexed sender, address suggestionAddress_, uint suggestionValue_);
    event OutputSuggestionAddresses(address indexed sender, uint countAddresses_, uint aktCount_, address suggestionAddress_);

    //Primitive Implementierung der Attribute als Variablen.

    uint private offerValue;
    
    mapping(address => Suggestion) private suggestions;

    struct Suggestion {
        uint suggestionValue;
    }    

    /**
     * Konstruktor
     */

    function RewardTask(uint offerValue_) {
        owner = msg.sender;

        offerValue = offerValue_;
    }

    /**
     * Funktionen zum Aktualisieren von Attributen.
     */

    function insertSuggestion(uint _suggeestionValue) notBy(owner) {
        insertSuggestionAddress(msg.sender);

        suggestions[msg.sender].suggestionValue = _suggeestionValue;
    }

    function insertSuggestionAddress(address _suggestionAddress) notBy(owner) {
        bool exists;
        exists = false;
        for (uint i = 0; i < suggestionAddresses.length; i++) {
            if (suggestionAddresses[i] == _suggestionAddress) { 
                exists = true;
            }
        }

        if (!exists) {
            suggestionAddresses.push(_suggestionAddress);
        }
    }

    //Abruf von Attributen

    function getSuggestionAddresses() onlyBy(owner) returns(uint countAddresses_, uint aktCount_, address suggestionAddress_) {
        countAddresses_ = suggestionAddresses.length;

        for (uint i = 0; i < suggestionAddresses.length; i++) {
            aktCount_ = i;
            suggestionAddress_ = suggestionAddresses[i];
            OutputSuggestionAddresses(msg.sender, countAddresses_, aktCount_, suggestionAddresses[i]);
        }
        
    }

    function getSuggestions(address _suggestionAddress) onlyBy(owner) returns (address suggestionAddress_, uint suggestionValue_) {
        suggestionAddress_ = _suggestionAddress;
        suggestionValue_ = suggestions[_suggestionAddress].suggestionValue;

        OutputSuggestion(msg.sender, suggestionAddress_, suggestionValue_);
    }

    //Authorisierungsmodifier 

    modifier onlyBy(address _account) {
        if (msg.sender != _account) {
            revert();
        }
        _;
    }

    modifier notBy(address _account) {
        if (msg.sender == _account) {
            revert();
        }
        _;
    }

    //Löschung der Instanz.

    function kill() onlyBy(owner) returns(uint) {
        selfdestruct(owner);
    }
}