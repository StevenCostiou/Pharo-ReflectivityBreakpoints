"
Examples for RF
"
Class {
	#name : #ReflectivityExamples,
	#superclass : #Object,
	#instVars : [
		'ivar',
		'tag'
	],
	#classVars : [
		'ClassVar',
		'singleton'
	],
	#category : #'Reflectivity-Tests'
}

{ #category : #options }
ReflectivityExamples class >> exampleMethodWithMetaLinkOptionsViaClass [
	<sampleInstance>
	^ 2 + 3
]

{ #category : #options }
ReflectivityExamples class >> metaLinkOptions [
	^{
	#exampleMethodWithMetaLinkOptionsViaClass -> #( + optionCompileOnLinkInstallation)
	}
]

{ #category : #initialization }
ReflectivityExamples >> compileTemporaryMethods [
	self class compile: 'methodToBeRemoved ^nil'.
	self class compile: 'methodToBeModified ^nil'.
	self class compile: 'stubMethod ^nil'
]

{ #category : #examples }
ReflectivityExamples >> exampleArray [
	^ {3}
]

{ #category : #examples }
ReflectivityExamples >> exampleAssignment [
	| temp |
	temp := (1 + 2).
	^temp
]

{ #category : #examples }
ReflectivityExamples >> exampleAssignmentClassVar [
	ClassVar := (1 + 2).
	^ClassVar
]

{ #category : #examples }
ReflectivityExamples >> exampleAssignmentIvar [
	ivar := (1 + 2).
	^ivar
]

{ #category : #examples }
ReflectivityExamples >> exampleAssignmentIvar: anObject [
	ivar := anObject.
	^ivar
]

{ #category : #examples }
ReflectivityExamples >> exampleBlock [
	^ [2 + 3] value 
]

{ #category : #examples }
ReflectivityExamples >> exampleBlockNoValue [
	^ [2 + 3]
]

{ #category : #examples }
ReflectivityExamples >> exampleBlockWithArg [
	^ [:a | a + 3] value: 2 
]

{ #category : #examples }
ReflectivityExamples >> exampleCascade [
	^1 sin; yourself
]

{ #category : #examples }
ReflectivityExamples >> exampleClassVarRead [
	^ClassVar
]

{ #category : #examples }
ReflectivityExamples >> exampleGlobalRead [
	^GlobalForTesting
]

{ #category : #examples }
ReflectivityExamples >> exampleIfTrueIfFalse [

	| t |
	t := false.
	t ifTrue: [ self bar ] ifFalse: [ 'hello' ].
	^ 5 
]

{ #category : #examples }
ReflectivityExamples >> exampleIvarRead [
	^ivar
]

{ #category : #examples }
ReflectivityExamples >> exampleLazyInit [
	^ singleton ifNil: [singleton := self new initialize]
]

{ #category : #examples }
ReflectivityExamples >> exampleLiteral [
	^ 2
]

{ #category : #examples }
ReflectivityExamples >> exampleLiteralArray [
	^ #(1)
]

{ #category : #examples }
ReflectivityExamples >> exampleMessageSend [
	self tagExec: #yes
]

{ #category : #examples }
ReflectivityExamples >> exampleMethod [

	^ 2 + 3
]

{ #category : #examples }
ReflectivityExamples >> exampleMethod2 [

	2 + 3
]

{ #category : #examples }
ReflectivityExamples >> exampleMethodMultipleSites [
	self trace: Object new.
	^ 2 + 3
]

{ #category : #examples }
ReflectivityExamples >> exampleMethodWithMetaLinkOptions [
	<metaLinkOptions: #( +optionCompileOnLinkInstallation)>
	^ 2 + 3
]

{ #category : #examples }
ReflectivityExamples >> examplePrimitiveMethod [
	"returns image path"
	<primitive: 121>
	^ 2 + 3
]

{ #category : #examples }
ReflectivityExamples >> exampleSelf [
	self
]

{ #category : #examples }
ReflectivityExamples >> exampleSendNoReturn [
	"just an example method that calls a mutation outside of a assignment or return node.
(needed for before link test with receiver reification"

	| collection |
	collection := OrderedCollection newFrom: {3 . 4}.
	collection removeAt:1.
]

{ #category : #examples }
ReflectivityExamples >> exampleSendTwoArgs [
	^ Array with: 1 with: 2
]

{ #category : #examples }
ReflectivityExamples >> exampleTwoSends [
	3 + 4.
	^ 2 + 3
]

{ #category : #examples }
ReflectivityExamples >> exampleWithArg: anArg [
	^ 2 + anArg
]

{ #category : #initialization }
ReflectivityExamples >> initialize [
	ivar := 33.
	ClassVar := #AClassVar.
	self removeTemporaryMethods.
	self compileTemporaryMethods
]

{ #category : #'as yet unclassified' }
ReflectivityExamples >> methodToBeModified [ ^nil
]

{ #category : #'as yet unclassified' }
ReflectivityExamples >> methodToBeRemoved [ ^nil
]

{ #category : #initialization }
ReflectivityExamples >> removeTemporaryMethods [
	
	self class removeSelector: #methodToBeRemoved.
	self class removeSelector: #methodToBeModified.
	self class removeSelector: #stubMethod
]

{ #category : #'as yet unclassified' }
ReflectivityExamples >> stubMethod [ ^nil
]

{ #category : #tagging }
ReflectivityExamples >> tag [
	^tag
]

{ #category : #tagging }
ReflectivityExamples >> tagExec: anObject [
	tag := anObject
]