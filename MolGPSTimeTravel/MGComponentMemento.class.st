Class {
	#name : #MGComponentMemento,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #accessing }
MGComponentMemento >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MGComponentMemento >> componentName [

	^ componentName
]

{ #category : #'undo - undo' }
MGComponentMemento >> redo [
]

{ #category : #accessing }
MGComponentMemento >> restoreValues [
 | instance |
	instance := (MolUtils instanceOf: componentClass named: componentName) .
	instance ifNotNil: [ instance restoreFrom: self. ]
]

{ #category : #actions }
MGComponentMemento >> save: aComponent [
]

{ #category : #'undo - undo' }
MGComponentMemento >> undo [

	
]
