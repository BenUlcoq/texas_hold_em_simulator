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

##  Texas Hold ‘Em Simulator Development Update #3 (03/19) - Flow of Play and Betting Development
Date and Time: September 4th 2019 - 9:30am
Timeframe: On Track
Adaptations and Deviations: No deviations to report.

The flow of play, including betting functionality has been implemented.
Users are now prompted for input when it is their turn to act in the current hand. Users can now choose to fold, call, raise or check as required. Error handling has been implemented for all user input. Betting and bet tracking, player chip counts, pot sizing and player action tracking have all been implemented. Game flow now behaves correctly, with pre-flop, flop, turn and river management implemented.
The largest challenge of this implementation was the logic tracking game flow and game stages. There are a significant number of nested flow control structures which proved difficult to track and implement at stages. The test-unit gem proved integral in tracking errors and unexpected behaviour within the flow of the game.


