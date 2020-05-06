Extension { #name : #RBVariableNode }

{ #category : #'*Reflectivity-Field-Watchpoints' }
RBVariableNode >> variableValueInContext: aContext [
	^ aContext tempNamed: self name
]
