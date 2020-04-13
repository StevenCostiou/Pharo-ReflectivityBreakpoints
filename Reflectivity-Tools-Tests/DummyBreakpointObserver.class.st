Class {
	#name : #DummyBreakpointObserver,
	#superclass : #Object,
	#instVars : [
		'tag'
	],
	#category : #'Reflectivity-Tools-Tests'
}

{ #category : #updating }
DummyBreakpointObserver >> update: anAspect [
	tag := anAspect 
]
