"
I have instvar accesses and I have a super class with variables that I access
"
Class {
	#name : #FieldWatchpointMockSubclass,
	#superclass : #FieldWatchpointMockClass,
	#instVars : [
		'v2'
	],
	#category : #'Reflectivity-Field-Watchpoints'
}

{ #category : #initialize }
FieldWatchpointMockSubclass >> initialize [
	super initialize.
	v2 := 0
]

{ #category : #accessing }
FieldWatchpointMockSubclass >> instVarReads [
	^v1 + v2
]

{ #category : #accessing }
FieldWatchpointMockSubclass >> instVarWrites [
	v1 := 4.
	v2 := 2
]

{ #category : #accessing }
FieldWatchpointMockSubclass >> v2 [
	^ v2
]

{ #category : #accessing }
FieldWatchpointMockSubclass >> v2: anObject [
	v2 := anObject
]
