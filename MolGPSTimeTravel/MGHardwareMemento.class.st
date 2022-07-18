Class {
	#name : #MGHardwareMemento,
	#superclass : #MGComponentMemento,
	#category : #MolGPSTimeTravel
}

{ #category : #'undo - undo' }
MGHardwareMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MGHardwareMemento >> save: anHardware [

	componentClass := anHardware class.
	componentName := anHardware componentName.
]

{ #category : #'undo - undo' }
MGHardwareMemento >> undo [

	self restoreValues
]
