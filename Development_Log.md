# Development Log
## Texas Hold ‘Em Simulator Development Update #1 (03/19) - Development Plan Complete
Date and Time: September 3rd 2019 - 9:00am
Timeframe: On Track
Adaptations and Deviations: No deviations to report.

The development plan for Texas Hold ‘Em Simulator has been completed. 
A flow diagram was created to help with figuring out a rudimentary version of the logic and code structure. The flow diagram also helped to serve as a proof of concept, ensuring that the application idea had merit and was achievable. Features, functionality and user experience have been clearly planned to allow for an initial plan regarding code structure using test driven development. A Trello board for project management has been created with user stories, timeframes and checklists for each story to ensure that test driven development is being used throughout the development process.  The development  process will now begin.

##  Texas Hold ‘Em Simulator Development Update #2 (03/19) - Initial Functionality Development
Date and Time: September 3rd 2019 - 4:00pm
Timeframe: On Track
Adaptations and Deviations: Significant deviation from the initial code structure has taken place. The Table and Engine class have been removed and the functionality has been adopted by the Poker class. A Deck class has been created for handling card related functionality.

The initial functionality of the MVP has been implemented. Poker games can be initialised, deck classes are initialised within the game, Player classes are initialised and allocated a position within the game. Deck functionality has been implemented including the ability to deal player hole cards along with community cards at each stage of the game. Test Driven Development has been observed throughout the process, with a number of tests being written to test individual functions and features.

##  Texas Hold ‘Em Simulator Development Update #3 (04/19) - Flow of Play and Betting Development
Date and Time: September 4th 2019 - 9:30am
Timeframe: On Track
Adaptations and Deviations: No deviations to report.

The flow of play, including betting functionality has been implemented.
Users are now prompted for input when it is their turn to act in the current hand. Users can now choose to fold, call, raise or check as required. Error handling has been implemented for all user input. Betting and bet tracking, player chip counts, pot sizing and player action tracking have all been implemented. Game flow now behaves correctly, with pre-flop, flop, turn and river management implemented.
The largest challenge of this implementation was the logic tracking game flow and game stages. There are a significant number of nested flow control structures which proved difficult to track and implement at stages. The test-unit gem proved integral in tracking errors and unexpected behaviour within the flow of the game.

##  Texas Hold ‘Em Simulator Development Update #4 (05/19) - Implementation of Interface Management
Date and Time: September 4th 2019 - 10:00pm
Timeframe: On Track
Adaptations and Deviations: Implementation of Interface management via the Interface class.

After the logic behind the MVP was initially finalised, development turned to improving user experience and interface design. To make improvements to the interface development process, both in terms of efficiency of development and final-product efficiency, the code structure needed to be adjusted. Currently, the poker class was handling all logic, interface output and flow control. Introducing a new interface class allowed for the majority of the output handling to be transferred away from the poker class. This meant more complex output could be created, tracked and developed more efficiently. It had the added bonus of improving the structure of the poker class to improve development handling. 

##  Texas Hold ‘Em Simulator Development Update #5 (05/19) - Test Driven Development and Improved application launching
Date and Time: September 5th 2019 - 10:00am
Timeframe: Minor Features and Documentation Overdue
Adaptations and Deviations: A main file has been created for more elegant handling over the launching of the application using command line arguments. Test driven development processes have been adjusted.

Further changes have been made to the class structure to allow for cleaner launching of the application for in-depth testing and final functionality purposes. A main.rb file was created that will be used for handling command line arguments and passing them correctly to the poker class. As the application and code structure has become more complex, the inexperience with test driven development has become apparent. Testing parts of the program that are nested deep within the flow control of the code is currently unachievable and will require further research. As a substitue measure, manual testing has been conducted exploring various pathways within the applcation to ensure data handling, logic and error handling is working as expected.

##  Texas Hold ‘Em Simulator Development Update #4 (05/19) - Implementation of Interface Management
Date and Time: September 5th 2019 - 1:00pm
Timeframe: Documentation Overdue
Adaptations and Deviations: No deviations to report.






