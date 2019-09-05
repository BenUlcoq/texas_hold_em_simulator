# Terminal Application - Multiplayer Texas Hold ‘ Em Simulator
Created by Ben Ulcoq for Coder Academy’s FastTrack Bootcamp Term One Assignment Two.

# Purpose and Scope
Texas Hold ‘Em Simulator is a multi user application aimed at providing an environment for players to hone their skills and challenge one another to games of heads-up Texas Hold ‘Em Poker.  The application simulates the flow of a poker game by having users choose what actions to perform within the game (fold, raise, call or check ) when it is their turn. Once the hand being played reaches its conclusion, a winner is determined and the chip counts for each player are adjusted if necessary. 

The application is aimed at people who are wishing to practice poker without having to put money. This means the application will solve the problem of players risking monetary loss while still learning the game.

A user can start a game with any number of players (up to 9 total). Then, those who wish to play will take turns interacting with the application, choosing what action to take depending on their cards.

The application was built for Assignment Two of Term One at the Coder Academy Fast Track Bootcamp in Brisbane. In order to satisfy the requirements of the task, the program aimed to implement ‘Don’t Repeat Yourself’ (DRY) programming practices, object-oriented code structure, test-driven development, source-control and project planning and management.

## Motivation
Outside of satisfying the requirements of the assignment, there were a number of factors that played into the decision making process and motivation for choosing to build this application. 

During the brainstorming process, there were a number of different application ideas that I considered working on. Initially, I explored the concept of creating copies of existing games as there were a number of possibilities that would satisfy the requirements of the task, while still being complex enough that the programming would be interesting and challenging. Tic-Tac-Toe, Connect Four, Checkers and Snake are some of the ideas that were considered.

Ultimately, I chose not to go down this route as I had little personal interest in the projects. After some further brainstorming I came to the idea of creating a blackjack simulator. The application would satisfy the requirements of the task and I found the project interesting on a personal level. 

Finally, I decided to settle on the Texas Hold ‘Em Simulator. The application would satisfy the requirements of the task, I had significantly more personal interest in the project and the logic behind the game would be far more complex. This meant that I could create a simplistic version of the game and then continue to learn and grow the project beyond the timeframe of the assignment.

## Features and Functionality
#### A Round of Poker
The core of Texas Hold ‘Em Simulator is an engine that runs a  loop which repeats for each hand that is played. Within that loop, there are various pathways for the engine to follow depending on user input as well as adjusting chip stack values and the pot value as needed.


##### The Deck and Dealing Cards
Once play begins, a `@cards`array is generated containing every card in a deck of playing cards. The array is generated by looping through a `@ranks`array containing each card rank (2,3,4…King,Ace) and looping through a `@suits` array containing each suit (Spades, Clubs, Diamonds and Hearts). For each possible combination, a string is generated and stored in the `@cards`array.

The array is shuffled before a loop initiates, giving a player the top card of the deck (`@cards[0]`) until all players have two cards. For each card dealt, the value is deleted from the array so that the same card is not dealt twice. Each player has a `@hole_cards` array which the cards they are dealt are added to. 

##### Winning Chips
Once the cards have been dealt, the `@stage_of_play` is checked along with the number of players to see whether a winner needs to be determined at this point. If a winner needs to be determined, the hand comparison is made using the Ruby-Poker gem functionality and `@chip_stack` values are adjusted depending on the outcome. If a winner does not need to be determined, the engine checks whose turn it is to perform an action.

##### Performing Actions
During play, if it is the user’s turn, they can decide on what action to take with their hand.  If the input given by the user is not valid, it will request the input again. Depending on the valid input, the engine will adjust the player’s `@chip stack`, the player’s `@current_bet`’and the `@pot_size`variables or the `@folded` boolean as necessary.  

The engine then checks the status of the hand again, whose turn it is (if necessary) and the action input. This loops until the engine sees that a winner needs to be determined - either when the betting has finished on the river (`stage_of_play = 4`) or there is only 1 player left in the hand `player_positions length = 1`. The players who have not folded when the winner is checked have their hands ranked using Ruby-Poker and the winner is determined. Dependent on the winner(s)(Dependent on the  `@max_winnings` variable), `@chip_stack` variables are adjusted.

The engine then restarts and loops until a winner is determined or there is only one player remaining.

#### User Experience and Interaction Design

When the application is launched, the user is greeted with a home screen from which they can exit, read the rules of the game or start playing. Depending on the user’s selection, a new screen will be displayed.
Whenever the user has the ability to input a command into the application, a prompt indicating to the user that they are expected to interact with application will be displayed. All interactions will be via keyboard input, and the message will also let the user know of each of the options available to them at any given time to ensure navigation and interaction with the program is clear and user-friendly.

Once the user has moved through the menu to start play, a final prompt will relay the game information (number of players, blinds and chips) to the user and allow them to exit if need be or proceed to play. If they proceed, the players will be dealt cards, which will be displayed to them when it is their turn, during which they can choose an action.

The majority of the user’s interaction with the application will come from performing actions relative to the game such as ‘fold’ or ’raise’. The user will be able to perform these actions by entering in ‘fold’, ‘F’ or ‘f’ for fold and the equivalent values for (R)aise, (C)heck and (C)all (Check and Call are mutually exclusive). 

At any stage, if the user inputs a command that cannot be interpreted by the application, it will return another prompt and ask the user for a valid choice, displaying each option again.

## Implementation Plan
### Planning and Prioritisation
Before coding could begin, a comprehensive development plan was created to give direction to the development process. 

Once the application idea was finalised and scoped appropriately, a flow diagram was completed as a starting point for not only figuring out a rudimentary version of the logic and code structure, but also as a proof of concept to ensure that the idea had merit and was achievable. 

From here, the features, functionality and user experience were taken from a concept and blocked out clearly. This provided an excellent foundation for initial planning of the code structure. Test Driven Development techniques were to be observed throughout the development process, and as such the planning needed to reflect this.

In order to ensure that the development of the application ran smoothly, Trello, a project management application was used. Trello allows for individual user stories to be tracked and to have a checklist of goals for each user story, allowing for an easy way to ensure TDD was being used, and effectively solving the problem of time-management given the short timeframe allowed for development. Without Trello, the program could certainly still have been created, but the quality would likely be severely lacking and as such, much harder to build on in the future. The tracking of user stories as an implementation technique allowed for agile development if the initially conceived code structure was found to be ineffective during development.

### Initial Code Structure
The initially conceived structure for this particular application was made up of four key components.  These included:

#### The Application Interface
* `poker.rb`
* The point for starting the game, containing the methods for outputting data to the terminal interface.

#### The Engine
* `engine.rb`
* A module containing the main container for flow control, logic and calculations relating to the progression of the game.

#### The Table
* `table.rb` A class used to keep track and store all pieces of data needed to effectively manage the flow of a poker game.
* `@deck`an array representing the deck of cards containing all 52 playing cards.
* `@Big_blind_value`  an integer representing the value of the big blind.
* `@Small_blind_value` an integer representing the value of the small blind.
* `@player_positions` an array generated based on the number of players which is used to track blinds and player action, this is set using command line arguments.
* `@pot_size` an integer indicating the amount of chips currently in the pot.
* `@table_current_bet` an integer indicating the highest current bet at the table.
* `@table_cards` an array containing the cards currently dealt as community cards in the hand.
* `@stage_of_play` an integer value indicating the stage of play (pre-flop, flop, turn or river.)
* `@action` an integer value used to track which player needs to choose an action.

#### The Players
* `player.rb` A class used to represent each player at the table and to track and store the pieces of data relevant to each player.
* `@chip_stack`  an integer indicating the number of chips available for the player to bet with.
* `@player_position` an integer indicating the player’s position at the table.
* `@hole_cards` an array containing the cards that have been dealt to the player.
* `@player_current_bet` an integer indicating how much the player has bet for this round of action.
* `@folded` a boolean value determining whether the player is still in the hand.
* `@best_hand` an array containing the strongest 5-card combination based on the players `@hole_cards` and the Table’s `@table_cards`.
* `@max_winnings` an integer used to track the maximum amount of chips a player can win in any given hand.
* `@player_name` a string containing the player’s name, passed via command line argument when running the application.

### Ruby Gems
Colorize used for UI improvement in the form of coloured text.
Ruby Poker used for hand strength comparison.
Artii used for word art.
Random Data used to generate random names when not supplied.
Launchy used for opening external windows and links.

## Deviation from the Implementation Plan and Agile Development
During the development process, a number of issues were encountered regarding viability, efficiency and complexity of the code structure that needed to be addressed.
As outlined in the second Development log, there were significant issues related to class structure which were significantly limiting the efficiency of both development and the MVP itself. These issues led to a severe hinderance in the fulfilment of the previously established user stories. To solve this, the class structure was simplified so that the table and engine classes were combined into the poker class. 

On top of this, during the test-driven development process it was apparent that some further minor adjustments were needed in order to improve code quality and the flow control. A number of variables were changed, removed or added to streamline the application as outlined below.

* `@deck` was turned into its own class to allow for exstensibility for future applications.
* `@action` was modified to be a boolean 'acted' to track whether a player had already acted within the hand.
* `@active_players` was an array created to track players who had not folded their hands - allowing for more efficient calculations during the flow of the game.
* `@player_position` was uneccessary after the implementation of @active_players.

Upon further code reviews and testing, additional restructuring occurred, as outlined in the development log. In sumamry, the code strutured was refactored to be similar to the original plan, but the files and classes were much more streamlined and had much clearer purposes. A number of variable and flow control changes were also adjusted as needed. As the program became more complex, test driven development became far more difficult due to inexperience. In order to keep the project moving forward in the short timeframe, the development approach was modified to incorporate more rigorous manual testing. This certainly had negative effects on the code base which may have led to more hassle than necessary. Final code review and refactoring was able to resolve the issues after some rigorous manual testing eventually identified problems.

However, despite the deviations outlined above, the final product is extremely close to what was originally envisioned and the development can be considered a success.

###  Testing
Throughout most of the development process, test driven development techniques were observed to ensure that the application was coded in an effective, efficient manner, both in terms of development and the code structure. Test driven development also allows for agile development by choosing a clear end-goal (the test) for a feature, which would be related to a user story, meaning that the initial concept for that features code structure can be updated during development if requried.

As outlined above, the development technique strayed slightly from the test driven development principles as the program became more complex. This was done due to time constraints and being unfamiliar with testing techniques. Overall, the quality suffered before refactoring and also made the process of refactoring more difficult.


## Instructions for Use
See the help file!

## Accessibility
Given the simple nature of the application, there was very little room for accessibility to be an issue. However, it is still an important aspect to consider when planning the development of any application. The WCAG 2.1 ‘Guidelines at a Glance’  provides an overview of the ways in which applications should be made accessible for all users.

Having consulted the guidelines, it was found that timing was an aspect of accessibility that the application was not adhering to initially. The application was initially going to simulate a ‘zoom’ game in which severe time constraints are placed on the user for each action. Although the guidelines allow for exceptions when the time limit is essential, the application was meant to be used as a learning and practicing tool regardless and the arbitrary choice to simulate ‘zoom’ games was not in line with this goal. As such, any ideas of the implementation of a time-limit were thrown out.

## Ethical and Legal Considerations
Given the simplistic nature of the program, there were no clear issues with regards to the ethical or social consequences of developing this application.

However, it can be argued that Texas Hold ‘Em and Poker in general is a form of gambling. Therefore, the rules and regulations surrounding gambling needed to be consulted to ensure that, legally, the application was within specifications. After reviewing Queensland responsible gambling Code of Practice, it was determined that there were no laws being broken. The game does not have any form of monetary risk, with all value being won or lost self-contained within the game and reset upon the termination of the application. As such, the application did not involve gambling and was within specification.



