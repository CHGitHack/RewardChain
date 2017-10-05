pragma solidity ^0.4.15;

contract RewardId {

    address private owner;

    event Output(address indexed sender, address owner_, string nameId_);

    //Primitive Implementierung der Attribute als Variablen.

    string private nameId;

    /**
     * Konstruktor
     */

    function RewardId(string _nameId) {
        owner = msg.sender;

        nameId = _nameId;
    }

    /**
     * Funktionen zum Aktualisieren von Attributen.
     */

    function setNewInterest(int _interest) onlyBy(bank) {
        interest = _interest;
    }

    function setNewPayed(int _payedValue) onlyBy(owner) {
        payedValue = _payedValue;
    }


    //Abruf von Attributen

    function getActValues() returns() {

    }

    function getInterest() returns() {

    }


    //Authorisierungsmodifier 

    modifier onlyBy(address _account) {
        if (msg.sender != _account) {
            revert();
        }
        _;
    }

    //Löschung der Instanz.

    function kill() onlyBy(owner) returns(uint) {
        selfdestruct(owner);
    }
}