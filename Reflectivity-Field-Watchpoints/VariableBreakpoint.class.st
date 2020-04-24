"
I am a breakpoint installed on one or more instance variables of a class or of an object.
"
Class {
	#name : #VariableBreakpoint,
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
VariableBreakpoint class >> allSlotNamesFor: aClass [
	^ aClass allSlots collect: [ :s | s name ]
]

{ #category : #private }
VariableBreakpoint class >> newBreakpointForVariable: aVariableName inClass: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (OrderedCollection with: aVariableName)
]

{ #category : #private }
VariableBreakpoint class >> newWatchPointInClass: aClass [
	^ self new
		targetClass: aClass;
		targetVariableNames: (self allSlotNamesFor: aClass)
]

{ #category : #API }
VariableBreakpoint class >> watchVariable: aVariableName in: aClass [
	^ (self newBreakpointForVariable: aVariableName inClass: aClass)
		install
]

{ #category : #'API - object-centric' }
VariableBreakpoint class >> watchVariable: aVariableName inObject: anObject [
	^ (self newBreakpointForVariable: aVariableName inClass: anObject class)
		scopeTo: anObject;
		install
]

{ #category : #API }
VariableBreakpoint class >> watchVariableReads: aVariableName in: aClass [
	^ (self newBreakpointForVariable: aVariableName inClass: aClass)
		accessStrategy: #read;
		install
]

{ #category : #'API - object-centric' }
VariableBreakpoint class >> watchVariableReads: aVariableName inObject: anObject [
	^ (self newBreakpointForVariable: aVariableName inClass: anObject class)
		accessStrategy: #read;
		scopeTo: anObject;
		install
]

{ #category : #API }
VariableBreakpoint class >> watchVariableWrites: aVariableName in: aClass [
	^ (self newBreakpointForVariable: aVariableName inClass: aClass)
		accessStrategy: #write;
		install
]

{ #category : #'API - object-centric' }
VariableBreakpoint class >> watchVariableWrites: aVariableName inObject: anObject [
	^ (self newBreakpointForVariable: aVariableName inClass: anObject class)
		accessStrategy: #write;
		scopeTo: anObject;
		install
]

{ #category : #API }
VariableBreakpoint class >> watchVariablesIn: aClass [
	^ (self newWatchPointInClass: aClass) install
]

{ #category : #'API - object-centric' }
VariableBreakpoint class >> watchVariablesInObject: anObject [
	^ (self newWatchPointInClass: anObject class)
		scopeTo: anObject;
		install
]

{ #category : #API }
VariableBreakpoint class >> watchVariablesReadsIn: aClass [
	^ (self newWatchPointInClass: aClass)
		accessStrategy: #read;
		install
]

{ #category : #'API - object-centric' }
VariableBreakpoint class >> watchVariablesReadsInObject: anObject [
	^ (self newWatchPointInClass: anObject class)
		accessStrategy: #read;
		scopeTo: anObject;
		install
]

{ #category : #API }
VariableBreakpoint class >> watchVariablesWritesIn: aClass [
	^ (self newWatchPointInClass: aClass)
		accessStrategy: #write;
		install
]

{ #category : #'API - object-centric' }
VariableBreakpoint class >> watchVariablesWritesInObject: anObject [
	^ (self newWatchPointInClass: anObject class)
		accessStrategy: #write;
		scopeTo: anObject;
		install
]

{ #category : #accessing }
VariableBreakpoint >> accessStrategy [
	^ accessStrategy
]

{ #category : #accessing }
VariableBreakpoint >> accessStrategy: anObject [
	accessStrategy := anObject
]

{ #category : #initialize }
VariableBreakpoint >> initialize [
	super initialize.
	accessStrategy := #all.
	targetVariableNames := OrderedCollection new.
	isInstalled := false
]

{ #category : #install }
VariableBreakpoint >> install [
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
VariableBreakpoint >> isInstalled [
	^isInstalled
]

{ #category : #testing }
VariableBreakpoint >> isWatchpoint [
	^true
]

{ #category : #install }
VariableBreakpoint >> remove [
	super remove.
	targetInstance := nil.
	isInstalled := false
]

{ #category : #api }
VariableBreakpoint >> scopeTo: anInstance [
	self targetInstance: anInstance.
	self condition: [ :ctx | ctx receiver == targetInstance ]
]

{ #category : #accessing }
VariableBreakpoint >> targetClass [
	^ targetClass
]

{ #category : #accessing }
VariableBreakpoint >> targetClass: anObject [
	targetClass := anObject
]

{ #category : #accessing }
VariableBreakpoint >> targetInstance [
	^ targetInstance
]

{ #category : #accessing }
VariableBreakpoint >> targetInstance: anObject [
	targetInstance := anObject
]

{ #category : #accessing }
VariableBreakpoint >> targetVariableNames [
	^ targetVariableNames
]

{ #category : #accessing }
VariableBreakpoint >> targetVariableNames: anObject [
	targetVariableNames := anObject
]
