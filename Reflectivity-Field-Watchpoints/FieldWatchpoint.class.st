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

{ #category : #private }
FieldWatchpoint class >> allSlotNamesFor: aClass [
	^ aClass allSlots collect: [ :s | s name ]
]

{ #category : #private }
FieldWatchpoint class >> newWatchPointForVariable: aVariableName inClass: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (OrderedCollection with: aVariableName)
]

{ #category : #private }
FieldWatchpoint class >> newWatchPointInClass: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (self allSlotNamesFor: aClass)
]

{ #category : #API }
FieldWatchpoint class >> watchVariable: aVariableName in: aClass [
	^ (self newWatchPointForVariable: aVariableName inClass: aClass)
		install
]

{ #category : #'API - object-centric' }
FieldWatchpoint class >> watchVariable: aVariableName inObject: anObject [
	^ (self newWatchPointForVariable: aVariableName inClass: anObject class)
		scopeTo: anObject;
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariableReads: aVariableName in: aClass [
	^ (self newWatchPointForVariable: aVariableName inClass: aClass)
		accessStrategy: #read;
		install
]

{ #category : #'API - object-centric' }
FieldWatchpoint class >> watchVariableReads: aVariableName inObject: anObject [
	^ (self newWatchPointForVariable: aVariableName inClass: anObject class)
		accessStrategy: #read;
		scopeTo: anObject;
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariableWrites: aVariableName in: aClass [
	^ (self newWatchPointForVariable: aVariableName inClass: aClass)
		accessStrategy: #write;
		install
]

{ #category : #'API - object-centric' }
FieldWatchpoint class >> watchVariableWrites: aVariableName inObject: anObject [
	^ (self newWatchPointForVariable: aVariableName inClass: anObject class)
		accessStrategy: #write;
		scopeTo: anObject;
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariablesIn: aClass [
	^ (self newWatchPointInClass: aClass) install
]

{ #category : #'API - object-centric' }
FieldWatchpoint class >> watchVariablesInObject: anObject [
	^ (self newWatchPointInClass: anObject class)
		scopeTo: anObject;
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariablesReadsIn: aClass [
	^ (self newWatchPointInClass: aClass)
		accessStrategy: #read;
		install
]

{ #category : #'API - object-centric' }
FieldWatchpoint class >> watchVariablesReadsInObject: anObject [
	^ (self newWatchPointInClass: anObject class)
		accessStrategy: #read;
		scopeTo: anObject;
		install
]

{ #category : #API }
FieldWatchpoint class >> watchVariablesWritesIn: aClass [
	^ (self newWatchPointInClass: aClass)
		accessStrategy: #write;
		install
]

{ #category : #'API - object-centric' }
FieldWatchpoint class >> watchVariablesWritesInObject: anObject [
	^ (self newWatchPointInClass: anObject class)
		accessStrategy: #write;
		scopeTo: anObject;
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
