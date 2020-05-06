Class {
	#name : #BaselineOfPharoReflectivityBreakpoints,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoReflectivityBreakpoints
}

{ #category : #baselines }
BaselineOfPharoReflectivityBreakpoints >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'Reflectivity';
				package: 'Reflectivity-Field-Watchpoints'
					with: [ spec requires: #('Reflectivity') ];
				package: 'Reflectivity-Field-Watchpoints-Extensions'
					with: [ spec requires: #('Reflectivity-Field-Watchpoints') ];
				package: 'Reflectivity-Tests'
					with: [ spec requires: #('Reflectivity' 'Reflectivity-Field-Watchpoints') ];
				package: 'Reflectivity-Tools-Tests'
					with: [ spec requires: #('Reflectivity-Tests') ] ]
]
