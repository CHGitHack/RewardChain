pragma solidity ^0.4.15;

contract RewardTask {

    address private owner;
    address private executer;
    address[] private suggestionAddresses;


    bool public booked;
    bool public done;

    event OutputTaskData(address indexed sender, address owner_, uint offerValue_);
    event OutputSuggestion(address indexed sender, address suggestionAddress_, uint suggestionValue_);
    event OutputSuggestionAddresses(address indexed sender, uint countAddresses_, uint aktCount_, address suggestionAddress_);
    event OutputAlreadyBookedAnonym(address indexed sender, string messaageBooked_);
    event OutputAlreadyBooked(address indexed sender, string messaageBooked_, address executer_, uint executionValue_);
    event OutputBooked(address indexed sender, string messaageBooked_, address executer_, uint executionValue_);
    event OutputError(address indexed sender, string messageError_, address wrongAddress_);
    event OutputExecution(address indexed sender, string messageExecution, address executer_, uint executionValue_);

    //Primitive Implementierung der Attribute als Variablen.

    uint public offerValue;
    uint private executionValue;
    
    mapping(address => Suggestion) private suggestions;

    struct Suggestion {
        uint suggestionValue;
    }    

    /**
     * Konstruktor
     */

    function RewardTask(uint offerValue_) payable {
        owner = msg.sender;

        booked = false;
        done = false;

        offerValue = offerValue_;
    }

    /**
     * Fallback für Pay
     */

    function () payable {}

    /**
     * Funktionen zum Aktualisieren von Attributen.
     */

    function insertSuggestion(uint _suggeestionValue) notBy(owner) {
        if (!booked) {
            if (_suggeestionValue <= offerValue) {
                booked = true;
                executer = msg.sender;
                executionValue = _suggeestionValue;
                OutputBooked(msg.sender, "Task booked", executer, executionValue);
            } else {
                insertSuggestionAddress(msg.sender);

                suggestions[msg.sender].suggestionValue = _suggeestionValue;

                OutputSuggestion(msg.sender, msg.sender, _suggeestionValue);
            }
        } else {
            OutputAlreadyBookedAnonym(msg.sender, "Task already booked");
        }
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

     function acceptSuggestion(address _suggestionAddress) onlyBy(owner) {
        if (!booked) {
            bool exists;
            exists = false;
            for (uint i = 0; i < suggestionAddresses.length; i++) {
                if (suggestionAddresses[i] == _suggestionAddress) { 
                    exists = true;
                }
            }

            if (exists) {
                executer = _suggestionAddress;
                executionValue = suggestions[_suggestionAddress].suggestionValue;
                booked = true;

                OutputBooked(msg.sender, "Task booked", executer, executionValue);
            } else {
                OutputError(msg.sender, "No suggestion from this User", _suggestionAddress);
            }
        } else {
            OutputAlreadyBooked(msg.sender, "Task already booked", executer, executionValue);
        }
    }

    function confirmExecution() payable onlyBy(owner) {
        if (booked && !done) {
            done = true;

            executer.transfer(executionValue * 1000000000000000000);

            OutputExecution(msg.sender, "Confirmed execution of Task", executer, executionValue);
        } else {
            if (booked && done) {
                OutputError(msg.sender, "Already booked and done", executer);
            }
            if (!booked) {
                OutputError(msg.sender, "Not yet booked", 0x0);
            }
        }
    }

    //Abruf von Attributen

    function getSuggestionAddresses() onlyBy(owner) returns(uint countAddresses_, uint aktCount_, address suggestionAddress_) {
        if (!booked) {
                countAddresses_ = suggestionAddresses.length;

            for (uint i = 0; i < suggestionAddresses.length; i++) {
                aktCount_ = i;
                suggestionAddress_ = suggestionAddresses[i];
                OutputSuggestionAddresses(msg.sender, countAddresses_, aktCount_, suggestionAddresses[i]);
            }  
        } else {
            OutputAlreadyBooked(msg.sender, "Task already booked", executer, executionValue);
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