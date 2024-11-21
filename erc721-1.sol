// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//IERC 721 contract
contract ERC721{
    //name and symbol

    string public tokenName = "basicNFT";
    string public tokenSymbol = "BNFT";

    // MAPPINGS

    mapping (uint => address) public tokenOwner ;// tokenId to address
    mapping (address => uint) public Balance;// balance of address
    mapping(uint =>address) public tokenApproval; // tokenId to approved address
    mapping(address  => mapping(address => bool)) public approveOperator; // approve the operator of the tokens

    // EVENTS

    event transfer(address indexed From, address indexed To, uint TokenId);
    event approval(address indexed from, address indexed operator, bool approval);
    event approvedToken(address indexed owner, address indexed  operator, uint indexed tokeId);


    // FUNCTIONS

    //to see the balance of any address
    function balanceOf(address _user)public view returns (uint){
        require(_user != address(0),"enter a valid address");
        return Balance[_user];
    }

    //to see the owner of any token Id
    function OwnerOf(uint _token)public view returns (address){
        address owner =tokenOwner[_token];
        require(owner != address(0));
        return  tokenOwner[_token];
    }

    // mint token
    function mint(
    address _to,
    uint _tokenId
    ) public returns(bool)
    {
        require(_to != address(0), "cant mint to invalid address");
        require(tokenOwner[_tokenId] == address(0),"token-Id already exists");

        tokenOwner[_tokenId] =_to;//assign ownership
        Balance[_to] += 1;
        
        emit transfer(address(0), _to, _tokenId);
        return true;
    }

    //transfer the token
    function TransferToken( 
    address _oldOwner,
    address _newOwner,
    uint _tokenId
     )public returns(bool)
     {
        require(_newOwner != address(0), "enter a valid address");
        require(_oldOwner ==msg.sender,"only the owner can transfer");
        require(tokenOwner[_tokenId] == _oldOwner,"token id does not belong to the sender");

        Balance[_oldOwner] -= 1;
        Balance[_newOwner] += 1;
        tokenOwner[_tokenId] =_newOwner;

        emit transfer(_oldOwner, _newOwner, _tokenId);
        return true;
    }

    //approve to spend SPECIFIED tokens
    function approve(address _operator, uint _tokeId)public returns (bool){
        address owner = tokenOwner[_tokeId];
        require(owner != _operator," can not approve self");
        require(owner ==msg.sender,"only the owner himselg can approve");

        tokenApproval[_tokeId] = _operator;
        emit approvedToken(msg.sender, _operator, _tokeId);
        return  true;

    }

    //APPROVE someone else to spend all your tokens
    function setApproveForAll(address _operator) public {
        require(msg.sender != _operator,"Enter another address that can act as your proxy");
        approveOperator[msg.sender][_operator] = true;
        
        emit approval(msg.sender, _operator, true);
        

    }

    //to check is the operator is approved for all the tokens
    function isApprovedForAll(address _operator, address _owner) public view returns (bool){
        return approveOperator[_owner][_operator];
    }

   
    //clear approval
    function clearApproval(uint tokenid) public {

        address owner = tokenOwner[tokenid];
        require(owner ==msg.sender,"only the owner can clear the approval");
        if(tokenApproval[tokenid] != address(0)){
            tokenApproval[tokenid] = address(0);
        }
    }
}

