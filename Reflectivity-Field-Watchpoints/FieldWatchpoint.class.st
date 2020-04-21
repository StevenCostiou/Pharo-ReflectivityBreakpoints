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
FieldWatchpoint class >> allSlotNamesFor: aClass [
	^ aClass allSlots collect: [ :s | s name ]
]

{ #category : #API }
FieldWatchpoint class >> watchVariable: aVariableName in: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (OrderedCollection with: aVariableName);
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariableReads: aVariableName in: aClass [
	^ self new
		targetClass: aClass;
		accessStrategy: #read;
		targetVariableNames: (OrderedCollection with: aVariableName);
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariableWrites: aVariableName in: aClass [
	^ self new
		targetClass: aClass;
		accessStrategy: #write;
		targetVariableNames: (OrderedCollection with: aVariableName);
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariablesIn: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (self allSlotNamesFor: aClass);
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariablesReadsIn: aClass [
	^ self new
		targetClass: aClass;
		accessStrategy: #read;
		targetVariableNames: (self allSlotNamesFor: aClass);
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariablesWritesIn: aClass [
	^ self new
		targetClass: aClass;
		accessStrategy: #write;
		targetVariableNames: (self allSlotNamesFor: aClass);
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
	targetVariableNames := OrderedCollection new.
	isInstalled := false
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
	super remove.
	targetInstance := nil.
	isInstalled := false
]

{ #category : #api }
FieldWatchpoint >> scopeTo: anInstance [
	self targetInstance: anInstance.
	self condition: [ :ctx | ctx receiver == targetInstance ]
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
