"
Commands to install a variable breakpoint on the selected variable in the source code.
If the variable is a temporary, installs the variable breakpoint on all variable nodes refering to that variable name in the method.
If the variable is an intance variable, installs the breakpoint on all methods using the variable.
"
Class {
	#name : #ClyBreakOnWriteCommand,
	#superclass : #SycVariableCommand,
	#category : #'Reflectivity-Field-Watchpoints-Extensions'
}

{ #category : #activation }
ClyBreakOnWriteCommand class >> fullBrowserMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation
		byItemOf: ClyDebuggingMenuGroup
		for: ClyVariableContextOfFullBrowser
]

{ #category : #activation }
ClyBreakOnWriteCommand class >> sourceCodeMenuActivation [
	<classAnnotation>
	^ SycSourceCodeMenuActivation
		byItemOf: ClyQueryMenuGroup
		for: ClySourceCodeContext
]

{ #category : #execution }
ClyBreakOnWriteCommand >> defaultMenuIconName [
	^#smallDebug
]

{ #category : #execution }
ClyBreakOnWriteCommand >> defaultMenuItemName [
	^'Break on write'
]

{ #category : #execution }
ClyBreakOnWriteCommand >> execute [
	variables last inspect
]
