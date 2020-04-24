Extension { #name : #Class }

{ #category : #'*Reflectivity-Field-Watchpoints' }
Class >> link: aMetaLink toVariableNamed: vName option: accessStrategy [
	^ self link: aMetaLink toSlotNamed: vName option: accessStrategy
]

{ #category : #'*Reflectivity-Field-Watchpoints' }
Class >> newBreakpointForVariable: aVariableName [
	^ VariableBreakpoint
		newBreakpointForVariable: aVariableName
		inClass: self
]
