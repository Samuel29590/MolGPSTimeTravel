Class {
	#name : #MGComponentDeletionMemento,
	#superclass : #MGComponentMemento,
	#category : #MolGPSTimeTravel
}

{ #category : #'undo - undo' }
MGComponentDeletionMemento >> redo [
	
	(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNotNil: [ self componentClass stop: self componentName ]
]

{ #category : #actions }
MGComponentDeletionMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName.
]

{ #category : #'undo - undo' }
MGComponentDeletionMemento >> undo [
	(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNil: [ self componentClass start: self componentName ]
]
