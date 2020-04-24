"
I break on all accesses to selected target variable in the source code
"
Class {
	#name : #ClyBreakOnVarReadsCommand,
	#superclass : #ClyVariableBreakpointCommand,
	#category : #'Reflectivity-Field-Watchpoints-Extensions'
}

{ #category : #accessing }
ClyBreakOnVarReadsCommand >> defaultMenuItemName [
	^'Break on reads to ', sourceNode name
]

{ #category : #execution }
ClyBreakOnVarReadsCommand >> installVariableBreakpointOn: aVariableName in: methodOrClass [
	VariableBreakpoint watchVariableReads: sourceNode name in: methodOrClass
]
