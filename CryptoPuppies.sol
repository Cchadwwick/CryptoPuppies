pragma solidity ^0.5.7;

import '/ERC721Token.sol';

contract CryptoPuppy is ERC721Token {
    
    struct Puppy {
        uint id;
        uint generation;
        uint geneA;
        uint geneB;
    }
    
    uint public nextId = 1;
    address public breeder;
    
    mapping(uint => Puppy) private puppies;
    
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURIBase) ERC721Token(_name, _symbol, _tokenURIBase) 
        public {
            breeder = msg.sender;
    }
    
    function breed(uint puppy1, uint puppy2) external {
        require(puppy1 < nextId && puppy2 < nextId, 'The 2 puppies must exist!');
        Puppy storage _puppy1 = puppies[puppy1];
        Puppy storage _puppy2 = puppies[puppy2];
        require(ownerOf(puppy1) == msg.sender && ownerOf(puppy2) == msg.sender, 'msg.sender must own the 2 kitties');
        uint maxGen = _puppy1.generation > _puppy2.generation ? _puppy1.generation : _puppy2.generation;
        uint geneA = _random(4) > 1 ? _puppy1.geneA : _puppy2.geneA;
        uint geneB = _random(4) > 1 ? _puppy1.geneB : _puppy2.geneB;
        puppies[nextId] = Puppy(nextId, maxGen, geneA ,geneB) ;
        _mint(msg.sender, nextId);
        nextId++;
    }
   
    function mint() external {
        require(msg.sender == breeder, 'You are not the breeder!');
        puppies[nextId] = Puppy(nextId, 1, _random(10), _random(10));
        _mint(msg.sender, nextId);
        nextId++;
    } 
    
    function _random(uint max) internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % max;
    }
}
