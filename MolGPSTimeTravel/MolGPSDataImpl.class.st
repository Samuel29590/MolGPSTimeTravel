Class {
	#name : #MolGPSDataImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'MolGPSData + MolGPSDataServices + TMGTimeTravelEvents',
	#classTraits : 'MolGPSData classTrait + MolGPSDataServices classTrait + TMGTimeTravelEvents classTrait',
	#instVars : [
		'accuracy',
		'sendCurrentPositionThread'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #accessing }
MolGPSDataImpl >> accuracy [

	^ accuracy
]

{ #category : #accessing }
MolGPSDataImpl >> accuracy: anObject [

	accuracy := anObject
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentActivate [

	"Start a thread to simulate sending of the geo position each seconds and accuracy precision"

	self getTMGTimeTravelEventsSubscriber subscribe: self.

	sendCurrentPositionThread := [ 
	                             [ true ] whileTrue: [ 
		                             (Delay forMilliseconds: 50) wait.

		                             self getTMGTimeTravelServicesProvider
			                             isRestoring ifFalse: [ 
			                             self getMolGPSDataEventsNotifier 
				                             currentPositionChanged:
				                             self getRandomizedGPSPosition.

			                             self increaseAccuracy.

			                             "save the system for TimeTravel."
			                             self getTMGTimeTravelServicesProvider
				                             saveTheSystem ] ] ] forkAt:
		                             Processor userBackgroundPriority
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentInitialize [

	"Recording the creation of a component."

	self getTMGTimeTravelServicesProvider creationOf: self.

	"Set starting accuracy"

	self accuracy: 1000
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentPassivate [

	self getTMGTimeTravelEventsSubscriber unsubscribe: self.

	sendCurrentPositionThread ifNotNil: [ :e | e terminate ].
	sendCurrentPositionThread := nil
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentRemove [

	"Recording the deletion of a component."

	self getTMGTimeTravelServicesProvider deletionOf: self
]

{ #category : #services }
MolGPSDataImpl >> getAccuracyRadiusInMeters [
	"Get and return the accuracy of the GPS depending quality of signal and quantity of connected satellites"

	^self accuracy 
]

{ #category : #'component accessing' }
MolGPSDataImpl >> getMolGPSDataEventsNotifier [
	^self eventsNotifiers at: MolGPSDataEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: MolGPSDataEvents name: nil].
]

{ #category : #private }
MolGPSDataImpl >> getRandomizedGPSPosition [

	| random |
	random := Random new.
	^ random next @ random next
]

{ #category : #'component accessing' }
MolGPSDataImpl >> getTMGTimeTravelEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMGTimeTravelEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMGTimeTravelEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MolGPSDataImpl >> getTMGTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMGTimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMGTimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #private }
MolGPSDataImpl >> increaseAccuracy [

	| nextAccuracy |
	self accuracy > 1 ifTrue: [
		nextAccuracy := self accuracy - (0.1 * self accuracy). "10% better precision at each times"
		nextAccuracy < 1 ifTrue: [ "stay to 1" nextAccuracy := 1 ].
		self accuracy: nextAccuracy 
	]
]

{ #category : #events }
MolGPSDataImpl >> restoreFrom: aMemento [

		"Restore variables thanks to a memento."

	accuracy  := aMemento getAccuracy.
]

{ #category : #events }
MolGPSDataImpl >> saveForTimeTravel [

	| memento |
	memento := MGDataMemento new.

	self getTMGTimeTravelServicesProvider save: (memento save: self)
]
