"
I am a breakpoint installed on one or more instance variables of a class or of an object.
"
Class {
	#name : #FieldWatchpoint,
	#superclass : #Breakpoint,
	#instVars : [
		'targetClass',
		'targetInstance',
		'targetVariableNames',
		'accessStrategy',
		'isInstalled'
	],
	#category : #'Reflectivity-Field-Watchpoints'
}

{ #category : #API }
FieldWatchpoint class >> watch: aClass [
]

{ #category : #API }
FieldWatchpoint class >> watch: aVariableName in: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (OrderedCollection with: aVariableName);
		install
]

{ #category : #accessing }
FieldWatchpoint >> accessStrategy [
	^ accessStrategy
]

{ #category : #accessing }
FieldWatchpoint >> accessStrategy: anObject [
	accessStrategy := anObject
]

{ #category : #initialize }
FieldWatchpoint >> initialize [
	super initialize.
	accessStrategy := #all.
	targetVariableNames := OrderedCollection new
]

{ #category : #install }
FieldWatchpoint >> install [
	self isInstalled
		ifTrue: [ ^ self ].
	targetVariableNames
		do: [ :vName | 
			targetClass
				link: self link
				toSlotNamed: vName
				option: self accessStrategy ].
	isInstalled := true.
	self class addBreakpoint: self
]

{ #category : #testing }
FieldWatchpoint >> isInstalled [
	^isInstalled
]

{ #category : #testing }
FieldWatchpoint >> isWatchpoint [
	^true
]

{ #category : #install }
FieldWatchpoint >> remove [
	targetInstance := nil.
	isInstalled := false.
	super remove
]

{ #category : #accessing }
FieldWatchpoint >> targetClass [
	^ targetClass
]

{ #category : #accessing }
FieldWatchpoint >> targetClass: anObject [
	targetClass := anObject
]

{ #category : #accessing }
FieldWatchpoint >> targetInstance [
	^ targetInstance
]

{ #category : #accessing }
FieldWatchpoint >> targetInstance: anObject [
	targetInstance := anObject
]

{ #category : #accessing }
FieldWatchpoint >> targetVariableNames [
	^ targetVariableNames
]

{ #category : #accessing }
FieldWatchpoint >> targetVariableNames: anObject [
	targetVariableNames := anObject
]
