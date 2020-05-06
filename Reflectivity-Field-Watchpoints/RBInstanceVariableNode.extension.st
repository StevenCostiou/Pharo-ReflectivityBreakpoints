Extension { #name : #RBInstanceVariableNode }

{ #category : #'*Reflectivity-Field-Watchpoints' }
RBInstanceVariableNode >> variableValueInContext: aContext [
	|receiver|
	receiver := aContext receiver.
	^(receiver class slotNamed: self name) read: receiver
]
