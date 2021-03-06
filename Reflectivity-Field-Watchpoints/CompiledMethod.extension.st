Extension { #name : #CompiledMethod }

{ #category : #'*Reflectivity-Field-Watchpoints' }
CompiledMethod >> link: aMetaLink toVariableNamed: vName option: accessStrategy [
	^ self methodClass
		link: aMetaLink
		toTemporaryNamed: vName
		inMethod: self selector
		option: accessStrategy
]

{ #category : #'*Reflectivity-Field-Watchpoints' }
CompiledMethod >> newBreakpointForVariable: aVariableName [
	^ (self tempNames includes: aVariableName)
		ifTrue: [ VariableBreakpoint
				newBreakpointForVariable: aVariableName
				forMethod: self ]
		ifFalse: [ VariableBreakpoint
				newBreakpointForVariable: aVariableName
				inClass: self methodClass ]
]
