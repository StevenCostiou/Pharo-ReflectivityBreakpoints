"
I break on all accesses to selected target variable in the source code
"
Class {
	#name : #ClyBreakOnVarWritesCommand,
	#superclass : #ClyVariableBreakpointCommand,
	#category : #'Reflectivity-Field-Watchpoints-Extensions'
}

{ #category : #accessing }
ClyBreakOnVarWritesCommand >> defaultMenuItemName [
	^'Break on writes to ', sourceNode name
]

{ #category : #execution }
ClyBreakOnVarWritesCommand >> installVariableBreakpointOn: aVariableName in: methodOrClass [
	VariableBreakpoint watchVariableWrites: sourceNode name in: methodOrClass
]
