// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Simple Royalty Profit Sharing Contract
contract SimpleDonationContract is Ownable {
    using SafeMath for uint256;
    
    address creatorWallet;
    address donationWallet;
    
    string donatingTo;

    uint256 creatorPercentage = 50;

    uint256 creatorBalance = 0;
    uint256 donationBalance = 0;

    uint256 dustCheck = 0;
    uint256 dustCollectedAt = 50;

    constructor(address _creatorWallet, address _donationWallet){
        creatorWallet = _creatorWallet;
        donationWallet = _donationWallet;
        
    }

    event Received(address, uint);
    event Claimed(uint, uint);
    event PayoutInfoUnlocked();
    event PayoutInfoChanged(address, address, string);

    receive() external payable {
        split(msg.value);
    }

    fallback() external payable {
        split(msg.value);
    }

    function split(uint256 _amount) private {
        uint256 forCreator = _amount.mul(creatorPercentage).div(100);
        uint256 forDonation = _amount.sub(forCreator);
        creatorBalance = forCreator;
        donationBalance = forDonation;
        dustCheck = dustCheck.add(1);

        emit Received(msg.sender, msg.value);

    }

    function claim() external onlyOwner{
        uint256 creatorAmount = creatorBalance;
        require(creatorAmount > 0, 'Nothing To Claim');
        (bool creatorSent, bytes memory creatorData) = creatorWallet.call{value: creatorAmount}("");
        require(creatorSent, "Failed to send Ether");

        uint256 donationAmount = donationBalance;
        require(donationAmount > 0, 'Nothing To Claim');
        (bool donationSent, bytes memory donationData) = donationWallet.call{value: donationAmount}("");
        require(donationSent, "Failed to send Ether");

        // Prep Dust to be claimed on next claim call
        if (dustCheck > dustCollectedAt){
            uint256 contractBalance = address(this).balance;
            if (contractBalance > 0 ){
                split(contractBalance);
            }
            dustCheck = 0;
        }

        emit Claimed(creatorAmount, donationAmount);
    }

    function setPayoutInfo(address _creatorWallet, address _donationWallet, string memory _donatingTo) external onlyOwner{
        creatorWallet = _creatorWallet;
        donationWallet = _donationWallet;
        donatingTo = _donatingTo;

        emit PayoutInfoChanged(_creatorWallet, _donationWallet, _donatingTo);

    }

    function checkBalances() external view onlyOwner returns (uint256, uint256){  
        return(creatorBalance, donationBalance);

    }

}
