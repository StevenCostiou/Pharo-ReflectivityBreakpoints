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
		do: [
			"Packages"
			spec
				package: 'Reflectivity';
				package: 'Reflectivity-Tests' with: [ spec requires: #('Reflectivity') ];
				package: 'Reflectivity-Tools-Tests' with: [ spec requires: #('Reflectivity-Tests') ];
				package: 'Reflectivity-Field-Watchpoints' with: [ spec requires: #('Reflectivity') ].
			"Groups"
			spec
				group: 'Core' with: #('Reflectivity' 'Reflectivity-Tests' 'Reflectivity-Tools-Tests' 'Reflectivity-Field-Watchpoints') ].
]
