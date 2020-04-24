"
I am menu group to arrange together all metalink related commands (breakpoints, counters, watchpoints)
"
Class {
	#name : #ClyDebuggingMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #'Reflectivity-Field-Watchpoints-Pharo8-Compatibility'
}

{ #category : #testing }
ClyDebuggingMenuGroup >> isInlined [
	^true
]

{ #category : #accessing }
ClyDebuggingMenuGroup >> order [
	^1.5
]
