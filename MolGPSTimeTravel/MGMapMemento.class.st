Class {
	#name : #MGMapMemento,
	#superclass : #MGComponentMemento,
	#category : #MolGPSTimeTravel
}

{ #category : #'undo - undo' }
MGMapMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MGMapMemento >> save: aMap [

	componentClass := aMap class.
	componentName := aMap componentName
]

{ #category : #'undo - undo' }
MGMapMemento >> undo [

	self restoreValues
]
