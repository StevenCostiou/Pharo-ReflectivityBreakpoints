Extension { #name : #CompiledMethod }

{ #category : #'*Reflectivity-Field-Watchpoints' }
CompiledMethod >> link: aMetaLink toVariableNamed: vName option: accessStrategy [
	^ self methodClass
		link: aMetaLink
		toTemporaryNamed: vName
		inMethod: self
		option: accessStrategy
]

{ #category : #'*Reflectivity-Field-Watchpoints' }
CompiledMethod >> newBreakpointForVariable: aVariableName [
	^ (self tempNames includes: aVariableName)
		ifTrue: [ VariableBreakpoint
				newBreakpointForVariable: aVariableName
				forMethod: self ]
		ifFalse: [ self flag: 'inst var breakpoint in this method' ]
]