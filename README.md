# SimpleDonationContract
A Simple Royalty Profit Sharing Donation Contract 

1. Deploy
2. call setPayoutInfo(address _creatorWallet, address _donationWallet string _donatingTo)
  (creatorPercentage defaults to 50(%))
3. Set the deployed contracts address as your royalty recieving wallet
4. call claim() when it makes sense gas cost wise (call checkBalance() to view available)

# TheGivingBlock

To donate to a cause on TheGivingBlock.com, you need to first go through the steps to get a reciever address. A reciever address can be reused, so you only need to do this once

1. Go to the charity of your choice
2. Select the Token for the chain you deploy this to, amount displayed doesnt matter unless you want to recieve a receipt
3. Click continue
4. Select donate anon if you want, or fill out the info to recieve a reciept
5. Click continue
6. Copy address given
7. Call setPayoutInfo(yourPublicWalletAddress, addressGiven, creatorPercentage, shortDescOfCharity(as a way to know which contract you deply donates where))
