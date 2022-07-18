Class {
	#name : #MGComponentStep,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'creationsAndDeletions'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #accessing }
MGComponentStep >> creationsAndDeletions [

	^ creationsAndDeletions
]

{ #category : #initialization }
MGComponentStep >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	creationsAndDeletions := OrderedCollection new
]

{ #category : #accessing }
MGComponentStep >> mementos [

	^ mementos
]

{ #category : #initialization }
MGComponentStep >> save: aComponentMemento [

	mementos add: aComponentMemento 
]

{ #category : #initialization }
MGComponentStep >> saveCreationOrDeletionOf: aComponentMemento [

	creationsAndDeletions add: aComponentMemento
]
