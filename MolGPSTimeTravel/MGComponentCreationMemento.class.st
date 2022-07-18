Class {
	#name : #MGComponentCreationMemento,
	#superclass : #MGComponentMemento,
	#category : #MolGPSTimeTravel
}

{ #category : #'undo - undo' }
MGComponentCreationMemento >> redo [

	(MolUtils
		 instanceOf: self componentClass
		 named: self componentName) ifNil: [ 
		self componentClass start: self componentName ]
]

{ #category : #'undo - undo' }
MGComponentCreationMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MGComponentCreationMemento >> undo [

		(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNotNil: [ self componentClass stop: self componentName ]
]
