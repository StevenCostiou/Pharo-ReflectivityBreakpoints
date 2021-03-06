"
Commands to install a breakpoint on the selected variable accesses from the vars view in Calypso
"
Class {
	#name : #ClyBreakOnAccessCommand,
	#superclass : #ClyBreakOnVariableCommand,
	#category : #'Reflectivity-Field-Watchpoints-Extensions'
}

{ #category : #execution }
ClyBreakOnAccessCommand >> breakOn: variable [
	VariableBreakpoint
		watchVariable: variable name
		in: variable definingClass
]

{ #category : #execution }
ClyBreakOnAccessCommand >> defaultMenuItemName [
	^'Break on access'
]
