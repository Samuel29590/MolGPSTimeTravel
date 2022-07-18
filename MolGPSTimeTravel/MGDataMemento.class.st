Class {
	#name : #MGDataMemento,
	#superclass : #MGComponentMemento,
	#instVars : [
		'accuracy'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #accessing }
MGDataMemento >> getAccuracy [

	^ accuracy 
]

{ #category : #'undo - undo' }
MGDataMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MGDataMemento >> save: aData [

	componentClass := aData class.
	componentName := aData componentName.

	accuracy := aData accuracy.
]

{ #category : #'undo - undo' }
MGDataMemento >> undo [

	self restoreValues
]
