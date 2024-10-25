// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


import {ProposalVote} from "./Proposal.sol";


contract ProposalContractFactory{
    struct DeployedContractInfo{
        address deployer;
        address deployedContract;
        string contractName;
    }

    mapping (address=> DeployedContractInfo[]) allUserDeployedContracts;

    DeployedContractInfo[] allContracts;


    function deployClaimFaucet(string memory _name) external returns (address contractAddress_){
        require(msg.sender != address(0), "Zero Address not allowed ");

        address _address = address(new ProposalVote());

        contractAddress_ = _address;



        DeployedContractInfo memory _deployedContract;

        _deployedContract.deployer = msg.sender;
        _deployedContract.deployedContract = _address;
        _deployedContract.contractName = _name;
        
        allUserDeployedContracts[msg.sender].push(_deployedContract);

        allContracts.push(_deployedContract);
    }

    function getAllContractDeployed() public  view returns (DeployedContractInfo[] memory){
        return allContracts;
    }

    function getUserDeployedContracts() public view returns (DeployedContractInfo[] memory){
        return allUserDeployedContracts[msg.sender];
    }

    function getUserDeployedContractByIndex(uint _index) external view returns (address deployer_, address deployedContract_, string memory name_){
        require(_index < allUserDeployedContracts[msg.sender].length, "Index not found");
        DeployedContractInfo memory _deployedContract = allUserDeployedContracts[msg.sender][_index];

        deployer_=_deployedContract.deployer;
        deployedContract_=_deployedContract.deployedContract;
        name_=_deployedContract.contractName;
    }

  function getUserDeployedContractByName(string memory _contractName) public  view returns ( address contractAddress_, string memory name_) {
    require(bytes(_contractName).length > 0, "Empty Name not allowed");

   
    for (uint i = allUserDeployedContracts[msg.sender].length; i > 0; i--) {
        DeployedContractInfo memory deployedContract = allUserDeployedContracts[msg.sender][i - 1];
        
       
        if (keccak256(bytes(deployedContract.contractName)) == keccak256(bytes(_contractName))) {
            contractAddress_ = deployedContract.deployedContract;
            name_ = deployedContract.contractName;
            return ( contractAddress_, name_);
        }
    }
    
    revert("Contract with the given name not found");
}


    function getLengthOfDeployedContracts() public  view returns (uint256){
        uint256 lens = allContracts.length;
        return lens;
    }

    function createProposal(address _contractAddress, string memory _title, string memory _desc, uint16 _quorum)public returns (string memory ){
        require(_contractAddress != address(0),"Invalid Proposal Vote Contract");
        ProposalVote(_contractAddress).createProposal(_title,_desc, _quorum);
        return _title;
    }

    function voteOnAProposal(address _contractAddress, uint8 _index ) public returns(bool){
        require(_contractAddress != address(0),"Invalid Proposal Vote Contract");
        ProposalVote(_contractAddress).voteOnProposal(_index, msg.sender);
        return true;
    }

    function getAllProposalFromAContract(address _contractAddress) public view {
        require(_contractAddress != address(0),"Invalid Proposal Vote Contract");
        ProposalVote(_contractAddress).getAllProposals();
        
    }

    function getAProposalFromAContract(address _contractAddress, uint8 _index) public view  {
        require(_contractAddress != address(0),"Invalid Proposal Vote Contract");
        ProposalVote(_contractAddress).getProposal(_index);
    }

  
}