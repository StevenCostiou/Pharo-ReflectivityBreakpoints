"
I'm just a class with inst var and accesses to it
"
Class {
	#name : #VariableBreakpointMockClass,
	#superclass : #Object,
	#instVars : [
		'v1'
	],
	#category : #'Reflectivity-Field-Watchpoints'
}

{ #category : #initialization }
VariableBreakpointMockClass >> initialize [
	v1 := 0
]

{ #category : #accessing }
VariableBreakpointMockClass >> v1 [
	^ v1
]

{ #category : #accessing }
VariableBreakpointMockClass >> v1: anObject [
	v1 := anObject
]
