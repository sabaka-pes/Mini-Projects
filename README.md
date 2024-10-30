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
