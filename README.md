﻿
# Todo.txt-ahk #

An AutoHotKey GUI for working with todo.txt files.

The original AHK script came from jdiamond ([https://github.com/jdiamond/todo.txt-ahk](https://github.com/jdiamond/todo.txt-ahk)) and has been forked here with a number of modifications.

For information about todo.txt files, see [http://todotxt.com/](http://todotxt.com/).

This script tries to be compatible with todo.txt files produced by the todo.sh script found here: [https://github.com/ginatrapani/todo.txt-cli](https://github.com/ginatrapani/todo.txt-cli).

##Features:
* Supports priorities in the form (A-Z).
* Supports due dates in the form **due:YYYY-MM-DD**.
* Supports sub-tasks. (They can be shown or hidden) NOTE: Subtasks may not support projects or contexts.
* Priorities can be added by right-clicking on todo item and selecting the priority.
* Can change GUI font in ini file.
* Can add time, date stamp to done items.
* Due dates can be added as part of the todo item.
* Script will highlight items that are due today. (Configured in the todo.ini file)
* When an item is added, the script puts the priority, project, context, and name in a certain order (Configurable) regardless of how they are entered.
* Items can be added anywhere in the todo.txt file by changing the line number control.
* Color can be added to prioritized items (Configured in the todo.ini file)
* Sort by line number or priority (default configured in the todo.ini file)
* Double-click todo item to edit or update it.
* Supports multiple todo files. (Configured in the todo.ini file)

## Installation:
To use this, you need to be running Windows with AutoHotKey installed. Just double-click todo.ahk to start the script. You should see a greencheck mark in your system tray which tells you that it's running.

By default, it expects the todo.txt file to be in the same folder as the script. You can change this by reading todo.ini.example and following its instructions.

The hotkey is Win+T. Hit the hotkey and the GUI will appear. Your focus will be in the text box that lets you add new items. Type in your item and hit ENTER to save it. The GUI will disappear.

## Description:
The GUI contains a Filter box. As you type text in the filter box, the list of items will only show items containing that text. You can use this to filter by project (+project), context (@context), priority ((A-Z)), due date (due:YYYY-MM-DD), or done (x ).

You can check and uncheck items in the list. This marks them as done or not done in the todo.txt file with a date stamp.

You can click the Archive button to move the checked items to a done.txt file.

Multiple todo files are supported. Configure the file(s) in todo.ini then select the file to view from the window menu.

You can add a due date by appending "YYYY-MM-DD, MM-DD, today (or tod), tomorrow (or tom), mon (or monday), tue, wed, etc." to the end of the todo item. 

### Example 1:

Adding 

`Thing I need to do tom` 

will be entered in todo.txt as:

    `Thing i need to do due:YYYY-MM-DD`
(where date is tomorrow's date)

### Example 2:
Adding

`Another thing I need to do 5-02`

will be entered as:

	`Another thing I need to do due:YYYY-05-02`

### Example 3:
The script will put the elements (priority, project, context, and name) in order. 

Adding

`(A) +task @whatever Thing I need to do`

will be entered as:

	`(A) Thing I need to do +task @whatever`

The order of the project, context, and name is configurable.

You can double-click items to edit them or add a due date.

You can also right-click items in the list. This allows you to update their descriptions, add a priority (A, B, or C) or delete them.

You can specify text and background colors to display for prioritized items (see todo.ini file) and items that are due today.

You can add sub-tasks by prepending a configurable prefix character "_" or "-" to the todo item.  It can be inserted to an existing item by specifying which line number to insert it after.

Sub-tasks can be shown or hidden by selecting the check box.

A number of options can be configured by editing them from the Options dialog in the file menu.

## Acknowledgements
* Thanks to jdiamond for his original script that was used as a starting point for this project: [https://github.com/jdiamond/todo.txt-ahk](https://github.com/jdiamond/todo.txt-ahk)
* List color AHK functions (LVCustomColors.ahk) obtained from the [Autohotkey forums](http://www.autohotkey.com/forum/topic54200.html)
* The checkmark icon came from here: [http://www.iconspedia.com/icon/checkmark-12-20.html](http://www.iconspedia.com/icon/checkmark-12-20.html)

This project started as an opportunity for my 14-year-old son, ~D~ to get a chance to learn some programming.  I've only consulted with him--he's done all of the programming on this endeavor. I want to give him the credit for this useful tool that I'm using on a daily basis.  Thanks, ~D~!!
