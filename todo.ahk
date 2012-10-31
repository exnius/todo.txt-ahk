; todo.ahk: An AutoHotKey GUI for working with todo.txt files.

; Copyright 2010 Jason Diamond

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Include Anchor.ahk
#Include LVCustomColors.ahk

INI_FILE_NAME := "todo.ini"
TODO_FILE_NAME := "todo.txt"
DONE_FILE_NAME := "done.txt"
ICON_FILE_NAME := "todo.ico"

SCRIPT_HOTKEY := GetConfig("UI","ScriptHotkey","#t")

TODO_PATH := GetPath("todo", TODO_FILE_NAME)
DONE_PATH := GetPath("done", DONE_FILE_NAME)
ICON_PATH := A_ScriptDir . "\" . ICON_FILE_NAME

DONE_TEXT_COLOR := GetConfig("UI","DoneTextColor","0xAAAAAA")
DONE_BACK_COLOR := GetConfig("UI","DoneBackColor","0xFFFFFF")

A_TEXT_COLOR := GetConfig("UI","ATextColor","0x000000")
A_BACK_COLOR := GetConfig("UI","ABackColor","0xFFFFFF")

B_TEXT_COLOR := GetConfig("UI","BTextColor","0x000000")
B_BACK_COLOR := GetConfig("UI","BBackColor","0xFFFFFF")

C_TEXT_COLOR := GetConfig("UI","CTextColor","0x000000")
C_BACK_COLOR := GetConfig("UI","CBackColor","0xFFFFFF")

DUE_TEXT_COLOR := GetConfig("UI","DueTextColor","0x000000")
DUE_BACK_COLOR := GetConfig("UI","DueBackColor","0xFFFFFF")

WINDOW_TITLE := "To Do"

; '&' underlines the next letter, enabling the user to press ALT+N to focus on the following text field.
ADD_LABEL := "&New:"
PROJECT_LABEL := "&Project:"
CONTEXT_LABEL := "&Context:"
FILTER_LABEL:= "&Filter:"
DUE_DATE_LABEL := "&Due date:"
ITEMS_LABEL := "&Items:"
FILE_LABEL := "&Task File:"
LINE_NUM_LABEL := "&Line #:"

SUBTASK_CHAR := GetConfig("UI", "SubtaskChar", "_")
; NONE_TEXT := GetConfig("UI", "NoneText", "-")

FILE_LIST := GetConfig("Files","FileList","todo")

CHECK_COLUMN := 1
TEXT_COLUMN := 2
LINE_COLUMN := 3
DUE_DATE_COLUMN := 4
SORT_COLUMN := GetConfig("UI","SortColumn", LINE_COLUMN)

CHECK_HEADER := ""
TEXT_HEADER := "Description"
; PRIORITY_HEADER := "Priority"
LINE_NUMBER_HEADER := "Line #"
DUE_DATE_HEADER := "Due Date"

ADD_BUTTON_TEXT := "Add"
ARCHIVE_BUTTON_TEXT := "Archive"
SUBTASK_CHECK_TEXT := "&Show Subtasks"

LONG_CONTROL_WIDTH := 570
SHORT_CONTROL_WIDTH := 250
TEXT_WIDTH := 50
LIST_WIDTH := LONG_CONTROL_WIDTH + TEXT_WIDTH
LIST_HEIGHT := 500
LINE_NUM_WIDTH := 50

UPDATE_PROMPT := "What do you want to change ""`%text`%"" to?"
DELETE_PROMPT := "Are you sure you want to delete ""`%text`%""?"

CONTROL_FONT := GetConfig("UI","GuiFont","San Serif")
FONT_SIZE := GetConfig("UI","FontSize","9")

DISPLAY_SUBTASKS := GetConfig("UI","DisplaySubtasks","1")

; Set icon.
Menu TRAY, Icon, %ICON_PATH%


; Define the GUI.
Gui +Resize
Gui, Font, s8, Tahoma
; Line 1 in GUI
Gui Add, Text, w%TEXT_WIDTH% x10 Section, %ADD_LABEL%
Gui Add, Edit, ys vNewItem W%LONG_CONTROL_WIDTH%
; Line 2 in GUI
Gui Add, Text, w%TEXT_WIDTH% x10 Section, %PROJECT_LABEL%
Gui Add, ComboBox, ys vProject W%SHORT_CONTROL_WIDTH%
Gui Add, Text, ys w%TEXT_WIDTH%, %CONTEXT_LABEL%
Gui Add, ComboBox, ys vContext W%SHORT_CONTROL_WIDTH%
; Line 3 in GUI
Gui Add, Text, w%TEXT_WIDTH% x10 Section, %DUE_DATE_LABEL%
Gui Add, DateTime, ys vDueDate ChooseNone W%SHORT_CONTROL_WIDTH%, yyyy-MM-dd
Gui Add, Text, w%TEXT_WIDTH% ys, %LINE_NUM_LABEL%
Gui Add, Edit,  ys W%LINE_NUM_WIDTH% Number
Gui Add, UpDown, vLineNumber Range0-9999
; Line 4 in GUI
Gui Add, Text, w%TEXT_WIDTH% x10 Section, %FILTER_LABEL%
Gui Add, Edit, vFilter gFilter ys W%LONG_CONTROL_WIDTH%

Gui Add, Text, w1 x1 Section,
; Set font.
Gui, font, s%FONT_SIZE%, %CONTROL_FONT%
Gui Add, ListView, vItems gItems AltSubmit -Multi ys Checked H%LIST_HEIGHT% W%LIST_WIDTH%, %CHECK_HEADER%|%TEXT_HEADER%|%LINE_NUMBER_HEADER%|%DUE_DATE_HEADER%
Gui, font, s8, Tahoma

Gui Add, Button, vAdd gAdd Default Section, %ADD_BUTTON_TEXT%
Gui Add, Button, gArchive ys, %ARCHIVE_BUTTON_TEXT%
Gui Add, CheckBox, Checked%DISPLAY_SUBTASKS% gShowSubtask vShowSubtask ys, %SUBTASK_CHECK_TEXT%

; Fix sorting in columns with numbers.
LV_ModifyCol(LINE_COLUMN , "Logical")
LV_ModifyCol(DUE_DATE_COLUMN , "Logical")

; Define the right-click menu in the listview.
Menu ItemMenu, Add, Update, MenuHandler
Menu ItemMenu, Add, Delete, MenuHandler

; Define the priority submenu.
Menu, Priority, Add, (A), MenuHandler
Menu, Priority, Add, (B), MenuHandler
Menu, Priority, Add, (C), MenuHandler
Menu, Priority, Add, None, MenuHandler

; Define the priority submenu in the context menu.
Menu, ItemMenu, Add, Priority, :Priority

; Define the script in the menubar.
Menu, Script, Add, Reload, MenuHandler
Menu, Script, Add, Exit, MenuHandler

; Define the window submenu in the menubar.
StringSplit, FileList, FILE_LIST, |
Loop, %FileList0%
{
Menu, Window, Add, % "&" . A_Index . ": " . FileList%A_Index%, MenuHandler
}

; Define the file menu.
Menu, File, Add, Options, MenuHandler
Menu, File, Add, Edit, MenuHandler

; Define the menubar.
Menu, MenuBar, Add, Script, :Script
Menu, MenuBar, Add, File, :File
Menu, MenuBar, Add, Window, :Window

; Create the menubar.
Gui, Menu, MenuBar

; Get values from ini file for options Gui.
CLOSE_AFTER_ADDING := GetConfig("UI","CloseAfterAdding","0")
DISPLAY_SUBTASKS := GetConfig("UI","DisplaySubtasks","1")
TIME_STAMP := GetConfig("UI","TimeStamp","1")
SORT_COLUMN := GetConfig("UI","SortColumn","4")
GUI_FONT := GetConfig("UI","GuiFont","San Serif")
FONT_SIZE := GetConfig("UI","FontSize","9")

COL_1_WIDTH := 250
COL_2_WIDTH := 150
BUTTON_WIDTH := 50

ADD_WIN := 0

StringUpper, SCRIPT_HOTKEY, SCRIPT_HOTKEY

IfInString, SCRIPT_HOTKEY, #
{
    ADD_WIN := 1
    StringReplace, SCRIPT_HOTKEY, SCRIPT_HOTKEY, #, , All
}

; Define options Gui.
Gui, 2:Add, Text, R2 , Options: (See .ini file for more options)
Gui, 2:Add, CheckBox, vCloseAfterAdding Checked%CLOSE_AFTER_ADDING% W%COL_1_WIDTH%, Close Gui after adding item.
Gui, 2:Add, CheckBox, vDisplaySubtasks Checked%DISPLAY_SUBTASKS%, Display subtasks by default.
Gui, 2:Add, CheckBox, vTimeStamp Checked%TIME_STAMP%, Add time to date stamp when item is done.
Gui, 2:Add, Text, Section, Set hotkey to run the script.
Gui, 2:Add, Text, ,
Gui, 2:Add, Text, , Set column to sort list view by.
Gui, 2:Add, Text, , Set character to denote subtasks.
Gui, 2:Add, Text, , Set Gui font.
Gui, 2:Add, Text, , Set Gui font size.
Gui, 2:Add, Hotkey, vScriptHotkey ys W%COL_2_WIDTH%, %SCRIPT_HOTKEY%
Gui, 2:Add, CheckBox, vAddWin W%COL_2_WIDTH% Checked%ADD_WIN%, Add Win key to hotkey.
Gui, 2:Add, Edit, W%COL_2_WIDTH%,
Gui, 2:Add, UpDown, vSortColumn Range2-4, %SORT_COLUMN%
Gui, 2:Add, Edit, vSubtaskChar Limit1 W%COL_2_WIDTH%, %SUBTASK_CHAR%
Gui, 2:Add, Edit, vGuiFont W%COL_2_WIDTH%, %GUI_FONT%
Gui, 2:Add, Edit, W%COL_2_WIDTH%,
Gui, 2:Add, UpDown, vFontSize , %FONT_SIZE%

Gui, 2:Add, Button, gOK Section Default W%BUTTON_WIDTH%, OK
Gui, 2:Add, Button, gCancel ys W%BUTTON_WIDTH%, Cancel

; Show gui.
Gui Show,, %WINDOW_TITLE%
GuiControl Focus, NewItem
GuiControlGet Filter

ReadFile(Filter, true)

If (ADD_WIN = 1) {
    SCRIPT_HOTKEY := "#" . SCRIPT_HOTKEY
}

StringLower, SCRIPT_HOTKEY, SCRIPT_HOTKEY

; Win+T is the default hotkey.
Hotkey, %SCRIPT_HOTKEY%, ShowGui, On

Return

; Handle when cancel is clicked or when the ESCAPE key is pressed for the options Gui.
2GuiEscape:
Cancel:
Gui, 2:Hide
Return

; Handle when OK is pressed.
OK:
    Gui, 2:Submit

    If (AddWin = 1) {
        ScriptHotkey := "#" . ScriptHotkey
    }

    StringLower, ScriptHotkey, ScriptHotkey

    WriteConfig("UI", "CloseAfterAdding", CloseAfterAdding)
    WriteConfig("UI", "DisplaySubtasks", DisplaySubtasks)
    WriteConfig("UI", "TimeStamp", TimeStamp)
    WriteConfig("UI", "SortColumn", SortColumn)
    WriteConfig("UI", "SubtaskChar", SubtaskChar)
    WriteConfig("UI", "GuiFont", GuiFont)
    WriteConfig("UI", "FontSize", FontSize)
    WriteConfig("UI", "ScriptHotkey", ScriptHotkey)
Reload

ShowGui:
    Gui Show,, %WINDOW_TITLE%

    GuiControl Focus, NewItem
    GuiControlGet Filter

    ReadFile(Filter, true)

Return

; Handle when the OK button is clicked or the ENTER key is pressed.
Add:
	GuiControlGet, ActiveControl, FocusV

	; If {ENTER} is pressed while the list view is active, update item.
	If (ActiveControl = "Items") {
		UpdateItem(LV_GetNext())
		Return
	}

    Gui Submit, NoHide

    If (DueDate <> "") {
        FormatTime, DueDate, %DueDate%, yyyy-MM-dd
    }

    If (Project <> "") {
        NewItem := NewItem . " " . Project
    }

    If (Context <> "") {
        NewItem := NewItem . " " . Context
    }

    AddItem(NewItem, DueDate, LineNumber)

    ; Clear the NewItem edit box.
    GuiControl ,, NewItem,

    ; Find if close after adding option is true.
    If (GetConfig("UI", "CloseAfterAdding", "1"))
        Gui Cancel
    Else
        FilterItems()
Return

; Handle when the Archive button is clicked.
Archive:
    ArchiveItems()
Return

; Handle when the filter box changes.
Filter:
    FilterItems()
Return

; Handle listview events.
Items:
	; Get the line number of the selected row.
	lineNumber := LV_GetNext()
	
    ; Handle when an item is checked or unchecked.
    If (A_GuiEvent = "I") {
        If (InStr(ErrorLevel, "C", true))
            CheckItem(A_EventInfo, true)
        Else If (InStr(ErrorLevel, "c", true))
            CheckItem(A_EventInfo, false)
    }

    ; Handle when an item is double clicked.
    Else If (A_GuiEvent = "DoubleClick") {
		If (lineNumber != 0) {
			UpdateItem(lineNumber)
		}
	}

	; Handle when an item is right-clicked.
	Else If (A_GuiEvent = "RightClick") {
		If (lineNumber != 0) {
			Menu ItemMenu, Show
		}
	}

	Else If (A_GuiEvent = "K") {
		If (lineNumber != 0) {
			; Delete item when {DELETE} is pressed.
			If (A_EventInfo = 46) {
					DeleteItem(lineNumber)
			}
			
			; Show context menu when {APPSKEY} is pressed.
			Else If (A_EventInfo = 93) {
				Menu ItemMenu, Show
			}
			
			; Update priority when {A}, {B}, or {C} is pressed.
			Else If (A_EventInfo >= 65 And A_EventInfo <= 67) {
				newPriority := "(" . Chr(A_EventInfo) . ")"
				
				GetPartsFromRow(lineNumber, text, date)
				RegExMatch(text, "^\([ABC]\)", priorityPart)
				
				; Toggle priority if it is the same as the pressed key.
				If (newPriority = priorityPart) {
					UpdatePriority("", lineNumber)
				} Else {
					UpdatePriority(newPriority, lineNumber)
				}
				LV_Modify(lineNumber, "select focus")
			}
		}
    }
Return

; Handle when an item is selected in the context menu.
MenuHandler:
    If (A_ThisMenu = "ItemMenu" Or A_ThisMenu = "Priority") {
        rowNumber := LV_GetNext()
        item := A_ThisMenuItem
        If (item = "Update")
            UpdateItem(rowNumber)
        Else If (item = "Delete")
            DeleteItem(rowNumber)
        Else
            UpdatePriority(item, rowNumber)
    }
    Else If (A_ThisMenu = "Script") {
        If (A_ThisMenuItem = "Reload")
            Reload
        Else If (A_ThisMenuItem = "Exit")
            ExitApp
    }
    Else If (A_ThisMenu = "Window") {
        StringTrimLeft, item, A_ThisMenuItem, 3
        TODO_PATH := GetPath(item, item)
        FilterItems()
    }
    Else If (A_ThisMenu = "File") {
        If (A_ThisMenuItem = "Options") {
            Gui, 2:Show,, Options
        }
        Else If (A_ThisMenuItem = "Edit") {
            Run, %TODO_PATH%
        }
    }
Return

; Handle when the X is clicked or when the ESCAPE key is pressed.
GuiClose:
GuiEscape:
    Gui Cancel
Return

; Handle when the GUI is resized.
GuiSize:
    ; Resize controls relative to the window.
    Anchor("NewItem", "w")
    Anchor("Context", "w")
    Anchor("Filter", "w")
    Anchor("Items", "wh")
    Anchor("Add", "y")
    Anchor("Archive", "y")
    Anchor("ShowSubtask", "y")
Return

; Handle when the "show subtask" checkbox changes.
ShowSubtask:
    FilterItems()
Return


; Filters the items displayed in the list view.
FilterItems() {
    GuiControlGet Filter
    ReadFile(Filter, false)
}

; Read the todo.txt file into the GUI.
; Filters items based on the filter field.
ReadFile(filter, refreshFilter) {
    Global TODO_PATH
    Global SORT_COLUMN
    Global TEXT_COLUMN
    Global SUBTASK_CHAR
    Global LINE_COLUMN

	Global A_TEXT_COLOR
	Global A_BACK_COLOR
	Global B_TEXT_COLOR
	Global B_BACK_COLOR
	Global C_TEXT_COLOR
	Global C_BACK_COLOR
	Global DUE_TEXT_COLOR
	Global DUE_BACK_COLOR
    Global DONE_TEXT_COLOR
    Global DONE_BACK_COLOR

    GuiControlGet ShowSubtask

    ; Clear the combo boxes.
    GuiControl ,, Context, ||
    GuiControl ,, Project, ||
    ; Use these variables to keep track of what contexts and projects have been added.
    contextsAdded := "|"
    projectsAdded := "|"

    ; Disable notifications for checking and unchecking while the list is populated.
    GuiControl, -AltSubmit, Items

    lineNumber := 0

    ; Active color change and disable redraw.
    LV_Change(1, 1, 1, LINE_COLUMN)
    GuiControl, -Redraw, Items

    If (refreshFilter) {
        filter := ""
    }

    ; Clear the list view.
    LV_Delete()

    ; Escape subtask char if needed for use in RegExMatch.
    If (RegExMatch(SUBTASK_CHAR, "^[\\[.*?+{|()^$]$")) {
		subtaskChar := "\" . SUBTASK_CHAR
    }
    Else {
		subtaskChar := SUBTASK_CHAR
    }

    ; Read file one line at a time.
    Loop Read, %TODO_PATH%
    {
        line := TrimWhitespace(A_LoopReadLine)

        If (line <> "") {
            lineNumber := lineNumber + 1

            ; Text part includes priority; priorityPart is here so we can change the row color accordingly.
            ParseLine(line, donePart, textPart, priorityPart, datePart)

            ; Copy textPart so we can remove the contexts one at a time.
            textPartTemp := textPart

            ; Find contexts to add to combo boxes.
            While (RegExMatch(textPartTemp, "@\S+", contextPart)) {

                StringReplace, textPartTemp, textPartTemp, %contextPart%

                If (contextPart <> "") {
                    If (InStr(contextsAdded, "|" . contextPart . "|") = 0) {
                        contextsAdded := contextsAdded . contextPart . "|"
                    }
                }
            }

            ; Find projects to add to combo boxes.
            RegExMatch(textPart, "\+\S+", projectPart)

            If (projectPart <> "") {
                If (InStr(projectsAdded, "|" . projectPart . "|") = 0) {
                    projectsAdded := projectsAdded . projectPart . "|"
                }
            }

			If (ShowSubtask Or Not RegExMatch(textPart, "^\s*" . subtaskChar . ".*")) {

                If (filter <> "") {
                    IfInString, line, %filter%
                    {
                        AddItemToList(donePart, textPart, datePart, lineNumber)
                    }
                } Else {
                    AddItemToList(donePart, textPart, datePart, lineNumber)
                }
                ; Change color of row according to priority.
                LV_SetColor(lineNumber, 0x000000, 0xFFFFFF)
                If (priorityPart = "(A)") {
                    LV_SetColor(lineNumber, A_TEXT_COLOR, A_BACK_COLOR)
                }
                Else If (priorityPart = "(B)") {
                    LV_SetColor(lineNumber, B_TEXT_COLOR, B_BACK_COLOR)
                }
                Else If (priorityPart = "(C)") {
                    LV_SetColor(lineNumber, C_TEXT_COLOR, C_BACK_COLOR)
                }

				; Highlight task if it is due today (or overdue).
                If (RegExMatch(datePart, "^due:(\d\d\d\d)-(\d\d)-(\d\d)$", dateSection)
                And (dateSection3 <= A_DD And dateSection2 <= A_MM And dateSection1 <= A_YYYY
                Or dateSection2 < A_MM And dateSection1 <= A_YYYY
                Or dateSection1 < A_YYYY))
                {
                    LV_SetColor(lineNumber, DUE_TEXT_COLOR, DUE_BACK_COLOR)
                }
                if (donePart <> "")
                {
                    LV_SetColor(lineNumber, DONE_TEXT_COLOR, DONE_BACK_COLOR)
                }
            }
        }
    }
    ; Re-select the values that were previously selected.
    GuiControl ChooseString, Filter, %filter%

    ; Add the projects and contexts that were found.
    GuiControl ,, Context, %contextsAdded%
    GuiControl ,, Project, %projectsAdded%

    ; Re-enable notifications for handling checking and unchecking.
    GuiControl, +AltSubmit, Items

    ; Re-enable redraw.
    GuiControl, +Redraw, Items

    ; Sort list
    LV_ModifyCol(SORT_COLUMN, "Sort")

    ; Resize columns in list view to fit their contents.
    LV_ModifyCol()
}

; Add an item to the list view.
AddItemToList(donePart, textPart, ByRef datePart, lineNumber) {
    If (donePart <> "") {
        LV_Insert(1, "Check", "", textPart, lineNumber, datePart)
    }
    Else {
        LV_Insert(1, "", "", textPart, lineNumber, datePart)
    }
}

; Generic function for updating items in todo.txt.
; "action" is name of function to invoke for matching items.
; Function must have this signature:
; 	MyAction(data, ByRef donePart, ByRef textPart, ByRef datePart)
; Function can return true to increment returned count.
; "data" is any value that "action" might need.
; Only lines that match "text" invoke "action".
; "text" can be "*" to invoke the action on all items.
; Returns the count of times "action" returned true.
UpdateFile(action, data, text, date) {
    Global TODO_PATH
    Global TODO_FILE_NAME
    Global tempPath

    count := 0
    tempPath := A_Temp . "\" . TODO_FILE_NAME . ".tmp"

    FileDelete tempPath

    Loop Read, %TODO_PATH%
    {
        line := TrimWhitespace(A_LoopReadLine)

        If (line <> "") {
            ; Text part includes priority; priorityPart is unused.
            ParseLine(line, donePart, textPart, priorityPart, datePart)

            If ((text = "*") Or (textPart = text)) {
                If (%action%(data, donePart, textPart, datePart))
                    count := count + 1
            }

            line := MakeLine(donePart, textPart, datePart)

            If (line <> "") {
                FileAppend %line%`n, %tempPath%
            }
        }
    }

    FileMove %tempPath%, %TODO_PATH%, 1
    FileDelete tempPath

    Return count
}

; Parse a line from todo.txt.
ParseLine(line, ByRef donePart, ByRef textPart, ByRef priorityPart, ByRef datePart) {
    RegExMatch(line, "^(x \d\d\d\d-\d\d-\d\d(?: \d?\d:\d\d)? )?(\([A-Z]\))?(.*?)(\sdue:\d\d\d\d-[0-1]\d-[0-3]\d)?$", linePart)

    donePart := TrimWhitespace(linePart1)
    priorityPart := TrimWhitespace(linePart2)
    textPart := TrimWhitespace(linePart3)
    textPart := priorityPart <> "" ? priorityPart . " " . textPart : textPart
    datePart := TrimWhitespace(linePart4)
}

; Put a parsed line back together for writing to todo.txt.
MakeLine(ByRef donePart, ByRef textPart, ByRef datePart) {
    Global SUBTASK_CHAR

    line := textPart
    If (donePart <> "") {
        line := donePart . " " . line
    }
    If (datePart <> "") {
        line := line . " " . datePart
    }
    Return line
}

; Add an item to todo.txt.
AddItem(NewItem, DueDate, LineNumber) {
    Global TODO_PATH
    Global AddCount

    AddCount := 0

    NewItem := TrimWhitespace(NewItem)

    NewItem := CorrectOrder(NewItem, DueDate)

    If (NewItem <> "" And LineNumber = 0) {
        FileAppend %NewItem%`n, %TODO_PATH%
    } Else If (LineNumber <> 0) {
        UpdateFile("AddItemAction", NewItem, "*", "")
    }

    GuiControl, Text, LineNumber, 0
    GuiControl, , DueDate,

    FilterItems()
}

; Action for add item.
AddItemAction(NewItem, ByRef donePart, ByRef textPart, ByRef datePart) {
    Global tempPath
    Global AddCount
    GuiControlGet LineNumber

    AddCount += 1
    If (AddCount = LineNumber + 1 And NewItem <> "") {
        FileAppend %NewItem%`n, %tempPath%
    }
}

; Check or uncheck an item in todo.txt.
CheckItem(rowNumber, checked) {
    Global LINE_COLUMN

    GetPartsFromRow(rowNumber, text, date)

    UpdateFile("CheckItemAction", checked, text, date)
	; Get line number so we can change the color on the correct row.
    LV_GetText(lineNumber, rowNumber, LINE_COLUMN)

	HighlightLine(lineNumber, checked)
}

; Action for CheckItem.
CheckItemAction(checked, ByRef donePart, ByRef textPart, ByRef datePart) {
    If (checked) {
        ;RegExMatch(textPart, "(\([A-Z]\) )?(.*)",prioTemp)
        ;textPart := prioTemp2
        If (donePart = "") {
            If (GetConfig("UI", "TimeStamp", "1")) {
                FormatTime, donePart, , 'x 'yyyy-MM-dd HH:mm
            }
            Else {
                FormatTime, donePart, , 'x 'yyyy-MM-dd
            }
        }
    }
    Else {
        donePart := ""
    }
}

; Change the text of an item.
UpdateItem(rowNumber) {
    Global UPDATE_PROMPT

	If (! rowNumber) {
		Return
	}
	
    GetPartsFromRow(rowNumber, text, date)

    StringReplace prompt, UPDATE_PROMPT, `%text`%, %text%
    task := task = "" ? text : task . " " . text
    task := task = "" ? date : task . " " . date
    task := TrimWhitespace(task)

    InputBox newText, Update Item, %prompt%,,,,,,,, %task%

    If ErrorLevel
        Return

    newText := TrimWhitespace(newText)

    datePart := ""
    newText := CorrectOrder(newText, datePart)

    UpdateFile("UpdateItemAction", newText, text, date)
    FilterItems()
}

; Action for UpdateItem.
UpdateItemAction(newText, ByRef donePart, ByRef textPart, ByRef datePart) {
    blankDone := ""

    ; Pass in blankDone and blankPriority because we want to retain the value of donePart and priorityPart is useless.
    ParseLine(newText, blankDone, textPart, priorityPart, datePart)
}

; Changes the priority of an item when it is selected from the menu.
UpdatePriority(newPriority, rowNumber) {
    GetPartsFromRow(rowNumber, text, date)

    If (newPriority = "None") {
        newPriority := ""
    }

    UpdateFile("UpdatePriorityAction", newPriority, text, datePart)
    FilterItems()
}

; Action for UpdatePriority.
UpdatePriorityAction(newPriority, ByRef donePart, ByRef textPart, ByRef datePart) {
    textPart := RegExReplace(textPart, "^\([A-Z]\)", newPriority, replacementCount)

    If (replacementCount = 0 And newPriority != "") {
        textPart := newPriority . " " . textPart
    }
}

; Delete an item.
DeleteItem(rowNumber) {
    Global DELETE_PROMPT

	If (! rowNumber) {
		Return
	}
	
    GetPartsFromRow(rowNumber, text, date)

    StringReplace prompt, DELETE_PROMPT, `%text`%, %text%
    MsgBox 4,, %prompt%

    IfMsgBox No
        Return

    UpdateFile("DeleteItemAction", 0, text, date)
    FilterItems()
}

; Action for DeleteItem.
DeleteItemAction(data, ByRef donePart, ByRef textPart, ByRef datePart) {
    donePart := ""
    textPart := ""
    datePart := ""
}

; Archive an item.
ArchiveItems() {
	count := UpdateFile("ArchiveItemsAction", 0, "*", "")
	FilterItems()
	MsgBox Archived %count% items!
}

; Action for ArchiveItems.
ArchiveItemsAction(data, ByRef donePart, ByRef textPart, ByRef datePart) {
	Global DONE_PATH

	If (donePart <> "") {

		line := MakeLine(donePart, textPart, datePart)
		FileAppend %line%`n, %DONE_PATH%
		DeleteItemAction(data, donePart, textPart, datePart)

		Return true
	}
}

; Gets the text and date for the specified row.
GetPartsFromRow(rowNumber, ByRef text, ByRef date) {
    Global TEXT_COLUMN
    Global DUE_DATE_COLUMN
    Global NONE_TEXT

    LV_GetText(text, rowNumber, TEXT_COLUMN)
    LV_GetText(date, rowNumber, DUE_DATE_COLUMN)
}

; Change the color of the row according to its done status, due date, or priority.
HighlightLine(rowNumber, isRowChecked) {
    Global LINE_COLUMN
	Global DONE_TEXT_COLOR
    Global DONE_BACK_COLOR
	Global A_TEXT_COLOR
	Global A_BACK_COLOR
	Global B_TEXT_COLOR
	Global B_BACK_COLOR
	Global C_TEXT_COLOR
	Global C_BACK_COLOR
	Global DUE_TEXT_COLOR
	Global DUE_BACK_COLOR

	GetPartsFromRow(rowNumber, textPart, datePart)

	RegExMatch(textPart, "^\([A-Z]\)", priorityPart)

	; Get line number so we can change the color on the correct row.
    ; LV_GetText(lineNumber, rowNumber, LINE_COLUMN)

	; MsgBox %rowNumber% %lineNumber%
	lineNumber := rowNumber

	; Highlight task if it is done.
	If (isRowChecked) {
		LV_SetColor(lineNumber, DONE_TEXT_COLOR, DONE_BACK_COLOR)
	}

	; Highlight task if it is due today (or overdue).
	Else If (RegExMatch(datePart, "^due:(\d\d\d\d)-(\d\d)-(\d\d)$", dateSection)
	And (dateSection3 <= A_DD And dateSection2 <= A_MM And dateSection1 <= A_YYYY
	Or dateSection2 < A_MM And dateSection1 <= A_YYYY
	Or dateSection1 < A_YYYY)) {
		LV_SetColor(lineNumber, DUE_TEXT_COLOR, DUE_BACK_COLOR)
	}

	; Highlight task according to priority.
	Else If (priorityPart = "(A)") {
		LV_SetColor(lineNumber, A_TEXT_COLOR, A_BACK_COLOR)
	}
	Else If (priorityPart = "(B)") {
		LV_SetColor(lineNumber, B_TEXT_COLOR, B_BACK_COLOR)
	}
	Else If (priorityPart = "(C)") {
		LV_SetColor(lineNumber, C_TEXT_COLOR, C_BACK_COLOR)
	} Else {
		LV_SetColor(lineNumber, 0x000000, 0xFFFFFF)
	}
}

; Correct order of context, project, priority, and due date for writing to todo.txt if needed.
CorrectOrder(ByRef NewItem, ByRef DueDate) {
    Order := GetConfig("UI", "Order", "")

    StringSplit, taskArray, NewItem, %A_Space%,

    Loop, %taskArray0%
    {
        element := taskArray%A_Index%
        element := TrimWhitespace(element)

        dateRegEx := "(((\d\d\d\d-)?[0-1]?\d-[0-3]?\d)|tod|today|tom|tomorrow|mon|tue|wed|thu|fri|sat|sun|(mon|tues|wednes|thurs|fri|satur|sun)day)$"
        If (element <> "") {
            If (RegExMatch(element, "^@")) {
                context := "" ? element : context . " " . element
            }
            Else If (RegExMatch(element, "^\+")) {
                StringTrimLeft, element, element, 1
                project := "" ? element : element . " " . project
            }
            Else If (RegExMatch(element, "^\([A-Z]\)$")) {
                If (priority = "")
                    priority := element
            }
            Else If (RegExMatch(element, "^" . dateRegEx)) {
                DueDate := ParseDate(element)
                If (DueDate = False) {
                    DueDate := ""
                    name := name . " " . element
                }
            }
            Else If (RegExMatch(element, "due:\d\d\d\d-\d\d-\d\d")) {
                DueDate := "" ? element : DueDate . " " . element
            }
            Else {
                name := "" ? element : name . " " . element
                If (RegExMatch(DueDate, "^\d\d\d\d-\d\d-\d\d$")) {
                    DueDate := "due:" . DueDate
                }
            }
        }
    }
    If (project <> "") {
        project = +%project%
    }

    ; If Order is blank, NewItem will not be changed.
    If (Order <> "") {
        Order := "|" . Order

        StringReplace, Order, Order, |project, %A_Space%%project%, All
        StringReplace, Order, Order, |name, %A_Space%%name%, All
        StringReplace, Order, Order, |context, %A_Space%%context%, All
        Order := RegExReplace(Order, " +", " ")

        Order := TrimWhitespace(Order)

        Order := Order <> "" ? " " . Order : Order
        DueDate := DueDate <> "" ? " " . TrimWhitespace(DueDate) : DueDate

        NewItem := priority . Order . DueDate

    } Else {
        ; Update date part
        DueDate := DueDate <> "" ? " " . TrimWhitespace(DueDate) : DueDate
        NewItem := RegExReplace(NewItem, dateRegEx, DueDate, replacementCount)

    }

    NewItem := TrimWhitespace(NewItem)
    Return NewItem
}

; Properly format date string to write to todo.txt.
ParseDate(ByRef date) {
    date := TrimWhitespace(date)

    MonthArray01 := 31
    MonthArray02 := 28
    MonthArray03 := 31
    MonthArray04 := 30
    MonthArray05 := 31
    MonthArray06 := 30
    MonthArray07 := 31
    MonthArray08 := 31
    MonthArray09 := 30
    MonthArray10 := 31
    MonthArray11 := 30
    MonthArray12 := 31

    If (date = "") {
        Return False
    }
    ; due:YYYY-MM-DD
    Else If (RegExMatch(date, "^due:\d\d\d\d-\d\d-\d\d$")) {
        Return date
    }
    ; YYYY-MM-DD
    Else If (RegExMatch(date, "^\d\d\d\d-\d\d-\d\d$")) {
        Return "due:" . date
    }
    ; YYYY-M-D
    Else If (RegExMatch(date, "^(\d\d\d\d)-([0-1]?\d)-([0-3]?\d)$", datePart)) {
        datePart2 += 0 ; Remove leading zero.
        datePart3 += 0
        datePart2 := datePart2 < 10 ? "0" . datePart2 : datePart2 ;Add leading zero.
        datePart3 := datePart3 < 10 ? "0" . datePart3 : datePart3

        If (datePart2 > 13 Or datePart3 > MonthArray%datePart2%) {
            Return False
        }
        date := datePart1 . "-" . datePart2 . "-" . datePart3
        Return "due:" . date
    }
    Else If (date = "tod" Or date = "today") {
        date := A_YYYY . "-" . A_MM . "-" . A_DD
        Return "due:" . date
    }
    Else If (date = "tom" Or date = "tomorrow") {
        datePart1 := A_YYYY
        datePart2 := A_MM
        datePart3 := A_DD + 1

        If (datePart3 > MonthArray%datePart2%) {
            datePart3 -= (MonthArray%datePart2%)
            datePart2 += 1
        }
        If (datePart2 >= 13) {
            datePart1 += 1
            datePart2 -= 12
        }
        datePart2 += 0 ; Remove leading zero.
        datePart2 := datePart2 < 10 ? "0" . datePart2 : datePart2
        datePart3 := datePart3 < 10 ? "0" . datePart3 : datePart3
        date := datePart1 . "-" . datePart2 . "-" . datePart3
        Return "due:" . date
    }
    ; M-D
    Else If (RegExMatch(date, "^(\d?\d)-(\d?\d)$", datePart)) {
        datePart1 += 0 ; Remove leading zero.
        datePart2 += 0 ; Remove leading zero.
        datePart1 := datePart1 < 10 ? "0" . datePart1 : datePart1
        datePart2 := datePart2 < 10 ? "0" . datePart2 : datePart2

        If (datePart1 > 13 Or datePart2 > MonthArray%datePart1%)
            Return False

        date := A_YYYY . "-" . datePart1 . "-" . datePart2
        Return "due:" . date
    }
    Else If (RegExMatch(date, "^(mon|tue|wed|thu|fri|sat|sun)|(mon|tues|wednes|thurs|fri|satur|sun)day$")) {
        DayArraysun := 1
        DayArraymon := 2
        DayArraytue := 3
        DayArraytues := 3
        DayArraywed := 4
        DayArraywednes := 4
        DayArraythu := 5
        DayArraythurs := 5
        DayArrayfri := 6
        DayArraysat := 7
        DayArraysater := 7
        DayArraysunday := 1
        DayArraymonday := 2
        DayArraytuesday := 3
        DayArraywednesday := 4
        DayArraythursday := 5
        DayArrayfriday := 6
        DayArraysaturday := 7

        datePart1 := A_YYYY
        datePart2 := A_MM
        datePart3 := A_DD

        WeekDay := DayArray%date%

        If (A_WDay < WeekDay) {
            datePart3 := datePart3 + (WeekDay - A_WDay)
        }
        Else If (A_WDay = WeekDay) {
            datePart3 += 7
        }
        Else If (A_WDay > WeekDay) {
            datePart3 := datePart3 + 7 - (A_WDay - WeekDay)
        }

        month := MonthArray%datePart2%

        If (datePart3 > month) {
            datePart3 := datePart3 - month
            datePart2 += 1
        }
        If (datePart2 > 12) {
            datePart1 += 1
            datePart2 -= 12
        }

        datePart2 += 0 ; Remove leading zero.
        datePart3 += 0 ; Remove leading zero.
        datePart2 := datePart2 < 10 ? "0" . datePart2 : datePart2
        datePart3 := datePart3 < 10 ? "0" . datePart3 : datePart3

        date := datePart1 . "-" . datePart2 . "-" . datePart3
        Return "due:" . date
    }
    ; D-M-YYYY
    Else If (RegExMatch(date, "^([0-3]?\d)-([0-1]?\d)-(\d\d\d\d)$", datePart)) {
        If (datePart1 > 13 Or datePart2 > MonthArray%datePart1%)
            Return False

        datePart1 += 0 ; Remove leading zero.
        datePart2 += 0 ; Remove leading zero.
        datePart1 := datePart1 < 10 ? "0" . datePart1 : datePart1
        datePart2 := datePart2 < 10 ? "0" . datePart2 : datePart2

        date := datePart3 . "-" . datePart1 . "-" . datePart2
        Return "due:" . date
    }
    ; YYYY-MM-DD
    Else {
        RegExMatch(date, "^(\d\d\d\d)-(\d\d)-(\d\d)$", dateParts)
        If (datePart3 > MonthArray%datePart2% Or datePart2 > 12)
            Return False
        Return "due:" . date
    }
    Return date
}

; Remove whitespace from the beginning and end of the string.
TrimWhitespace(str) {
    Return RegExReplace(str, "(^\s+)|(\s+$)")
}

GetPath(key, default) {
    folder := GetConfig("Files", "Folder", A_ScriptDir)
    folder := ExpandEnvironmentStrings(folder)

    If (!InStr(default, ".txt", true)) {
        default := default . ".txt"
    }

    value := GetConfig("Files", key, TrimWhitespace(default))
    value := ExpandEnvironmentStrings(value)

    If (IsAbsolute(value))
        Return value

    Return folder . "\" . value
}

; Read ini file.
GetConfig(section, key, default) {
    Global INI_FILE_NAME
    IniRead value, %A_ScriptDir%\%INI_FILE_NAME%, %section%, %key%, %default%
    return value
}

; Write to ini file.
WriteConfig(section, key, value) {
    Global INI_FILE_NAME
    IniWrite, %value%, %A_ScriptDir%\%INI_FILE_NAME%, %section%, %key%
    Return
}

ExpandEnvironmentStrings(str) {
    VarSetCapacity(dest, 2000)
    DllCall("ExpandEnvironmentStrings", "str", str, "str", dest, int, 1999, "Cdecl int")
    Return dest
}

IsAbsolute(path) {
    Return RegExMatch(path, "(^[a-zA-Z]:\\)|(^\\\\)") > 0
}