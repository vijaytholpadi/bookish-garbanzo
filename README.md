Documentation
==
___
#### Introduction
The SWAG committee is looking for a way to track who has which book from their library. This App looks to solve that requirement in a simple way.
___
#### Requirements
Target device needs to be running iOS 8 or higher.
___
#### Architecture details
##### External Libraries (managed using Cocoapods):
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)

##### View controllers:
- **SLBooksListViewController** -> Shows the list of all the books in the system. This is embedded in a UINavigationController as SLBooksDetailViewController will be pushed on this on item selection.
- **SLBookDetailViewController** -> Shows all the details of a particular book and provides a provision to the user to checkout the particular book in his/her name. This screen also provides a share functionality to share the book using native sharing in iOS.
- **SLOnboardBookViewController** -> Allows the user to onboard/Add a book to the system.
    * Mandatory fields: *Title, Author*
	* Optional fields: *Publisher, Categories*

##### Networking:
Uses a Obj-C based custom wrapper on top of AFNetworking written by me - **VTNetwokingHelper**
____
#### Architectural decisions taken
- The **SLOnboardBookViewController** is just a *UIViewController* with a faked Navigation Bar as it does not see a need to have its own navigation stack as there is no expection to have further views pushed from there.
- **SLOnboardBookViewController** uses *Protocol-Delegate* design pattern to refresh the data in the **SLBookListViewController** only if a book has been added.
___
#### Possible enhancements
- Store data in *Core data*, if the data becomes bigger and needs to be persisted
- Improve UI with *Custom UIViewController transitions*
- Verbose commenting to use the code documentation power of Swift.
___
#### Known issues
- ~~The checkout screen accepts empty name to checkout~~ - Fixed.
-  In **SLBookListViewController** instead removing the deleted object from local datasource we are fetching the updated list. Need to write an extension to remove particular object from local datasource array as it does not support it out of the box.
___