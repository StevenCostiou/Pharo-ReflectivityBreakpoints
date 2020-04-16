"
I'm just a class with inst var and accesses to it
"
Class {
	#name : #FieldWatchpointMockClass,
	#superclass : #Object,
	#instVars : [
		'v1'
	],
	#category : #'Reflectivity-Field-Watchpoints'
}

{ #category : #initialization }
FieldWatchpointMockClass >> initialize [
	v1 := 0
]

{ #category : #accessing }
FieldWatchpointMockClass >> v1 [
	^ v1
]

{ #category : #accessing }
FieldWatchpointMockClass >> v1: anObject [
	v1 := anObject
]
