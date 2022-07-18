Trait {
	#name : #TMGTimeTravelType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolGPSTimeTravel
}

{ #category : #'accessing - events' }
TMGTimeTravelType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMGTimeTravelEvents }
]

{ #category : #'accessing - services' }
TMGTimeTravelType classSide >> providedComponentServices [

	<componentContract>
	^ { TMGTimeTravelServices }
]
