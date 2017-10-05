pragma solidity ^0.4.15;

contract RewardId {

    address private owner;

    event OutputId(address indexed sender, address owner_, string nameId_);

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

    function setNewName(string _nameId) {
        nameId = _nameId;
    }



    //Abruf von Attributen

    function getName() returns (address owner_, string nameId_) {
        owner_ = owner;
        nameId_ = nameId;

        OutputId(msg.sender, owner_, nameId_);
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