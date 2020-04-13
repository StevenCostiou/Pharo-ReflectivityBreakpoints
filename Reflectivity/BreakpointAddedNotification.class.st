"
A trivial breakpoint added notification. 
"
Class {
	#name : #BreakpointAddedNotification,
	#superclass : #BreakpointNotification,
	#category : #'Reflectivity-Breakpoints'
}

{ #category : #visiting }
BreakpointAddedNotification >> acceptVisitor: v [
	v breakpointAdded: breakpoint
]
