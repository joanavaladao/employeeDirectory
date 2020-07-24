# Employee Directory

This is an Employee Directory App. When the user enters the app for the first time, it reads the empty file from the server. When you press the refresh button (left button at toolbar), it brings the full list of employees. The list is persisted in CoreData.
There's a search bar on top of the screen. When the user types there, it brings the registers that have the name or the team starting with the search key the user added.

## Other functionalities
It is possible to choose to order by name or by the team (right button on the toolbar). Initially, it's ordered by name. If the user changes it to order by the team, the app will "remember" the selection, and keep ordering by the team.
Another functionality added is a simple pie chart (middle button on the toolbar) that displays the employee type.

## Build Tools and Version
To develop this app, I used Xcode 11.5 and Swift 5, with iOS 13.

## Dependencies:
To develop the chart, I used the framework Charts (https://github.com/danielgindi/Charts/).
I used icons from "icons" (https://icons8.com/icons). 
For the list of employees screen, I used the design of Pet Friends (material available on https://www.raywenderlich.com/) as inspiration (but the code is entirely mine).

## Device focus
I used the iPhone 11 as a testing device during my development, but I tested on an iPad too.
