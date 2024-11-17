**This is a repository that contains several mini projects on Solidity.**



**Todo-List**

  This is a simple program implementing a to-do list.

  _Functions_:

  - Add a new task to the list with a name, description and a boolean variable responsible for the task status (completed or not).
  - Change the task name.
  - Function for getting information about the current task.
  - Change the task status.
  - All functions are available only to the owner, using modifier `onlyOwner`.


**Iteratable Mapping**

  As is known, mappings cannot be traversed in a cycle, they have no length. In order to more conveniently interact with mappings, an auxiliary program was written that implements the following functions:
  
  - Function for setting mapping values;
  - Length (determines the length of the mapping);
  - Function for obtaining a key by index;
  - Function for obtaining all mapping values;




**English Auction**

  Classic English auction.
  
  Initially, the goods have a certain value, then the auction participants make bids and the participant who made the highest bid wins.


  

**Dutch Auction**

Unlike a traditional auction, a maximum price is initially set (`startingPrice`), and if there are no buyers for this price, the price is reduced by set amount (`discountRate`).

 - `getPrice` function returns the current price for an item.

 - `buy` function allows user to buy an item.


**Staking**

There are two types of tokens: staking token (the token that will be credited to the contract account) and rewarding token (reward for accrual of staking tokens).
The user deposits a staking token and receives a percentage reward in rewarding tokens.

The main logic of the program is contained in `StakingAlg.sol`. The reward is recalculated in blocks so as not to count each time from the moment the smart contract is created.

Note: project should contain `ERC20.sol`, `IERC20.sol`, `IERC20Metadata.sol`.

**Timelock**

This contract implements the ability to postpone a transaction for some time and execute it when a certain time comes. This is necessary, for example, to be able to analyze the transaction and make sure that it is not malicious. Another example of use: let's say you have an ERC20 token and someone from your team wants to perform a mint, for this they can postpone this transaction so that other members of your team can review and possibly refuse this transaction.
