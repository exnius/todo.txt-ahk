#Todo.txt-ahk:
An AutoHotKey GUI for working with todo.txt files.

The original AHK script came from jdiamond ([https://github.com/jdiamond/todo.txt-ahk](https://github.com/jdiamond/todo.txt-ahk)) and has been forked here with  a number of modifications.

For information about todo.txt files, see [http://todotxt.com/](http://todotxt.com/).

This script tries to be compatible with todo.txt files produced by the todo.sh script found here: [https://github.com/ginatrapani/todo.txt-cli](https://github.com/ginatrapani/todo.txt-cli).

##Features:
* Can change GUI font in ini file
* Can add time, date stamp to done items
* Supports due dates in the form {due: YYYY-MM-DD}
* Due dates can be added as part of the todo item 
* Priorities can be added by right-clicking on todo item and selecting the priority
* Color can be added to prioritized items (Configured in the todo.ini file)
* Sort by line number or priority (default configured in the todo.ini file)
* Double-click todo item to edit or update it
* Support for sub-tasks (can be shown or hidden)
* Support for multiple todo files (Configured in the todo.ini file)

## Installation
To use this, you need to be running Windows with AutoHotKey installed. Just double-click todo.ahk to start the script. You should see a greencheck mark in your system tray which tells you that it's running.

By default, it expects the todo.txt file to be in the same folder as the script. You can change this by reading todo.ini.example and following its instructions.

The hotkey is Win+T. Hit the hotkey and the GUI will appear. Your focus will be in the text box that lets you add new items. Type in your item and hit ENTER to save it. The GUI
will disappear.

## Description
The GUI contains a Filter box. As you type text in the filter box, the list of items will show only containing that filter. You can use this to filter by project (+Proj1) or context (@context).

You can check and uncheck items in the list. This marks them as done or not in
the todo.txt file.

You can click the Archive button to move the checked items to a done.txt file.

You can add a due date by appending "today (or tod), tomorrow (or tom), mon, tues, wed, etc." to the end of the todo item. Example:
Adding "Thing i need to do tom" will be entered in todo.txt as:
      Thing i need to do {due: YYYY-MM-DD} (where date is tomorrow's date)

You can double-click items to edit them or add a due date.

You can also right-click items in the list. This allows you to update their
descriptions, add a priority (A, B, or C) or delete them.

You can specify text and background colors to display for prioritized items (see todo.ini file) and due items.

You can add sub-tasks by prepending a configurable prefix character "_" or "-" to the todo item.  It can be inserted to an existing item by specifying which line number to insert it after.

Sub-tasks can be shown or hidden by selecting the check box.

A number of options can be configured by editing them from the Options dialog in the menu.

## Acknowledgements
* Thanks to jdiamond for his original script that was used as a starting point for this project: [https://github.com/jdiamond/todo.txt-ahk](https://github.com/jdiamond/todo.txt-ahk)
* List color AHK functions (LVCustomColors.ahk) obtained from the [Autohotkey forums](http://www.autohotkey.com/forum/topic54200.html)
* The checkmark icon came from here: [http://www.iconspedia.com/icon/checkmark-12-20.html](http://www.iconspedia.com/icon/checkmark-12-20.html)
