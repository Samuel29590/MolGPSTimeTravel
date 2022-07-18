Class {
	#name : #MolGPSHardware,
	#superclass : #Object,
	#traits : 'MolComponentImpl + MolGPSData + MolGPSDataServices + TMGTimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + MolGPSData classTrait + MolGPSDataServices classTrait + TMGTimeTravelEvents classTrait',
	#instVars : [
		'sendCurrentPositionThread'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #'life cycle' }
MolGPSHardware >> componentActivate [

	"Start a thread to simulate sending of a fixed geo position each 2 seconds"

	self getTMGTimeTravelEventsSubscriber subscribe: self.
	
	sendCurrentPositionThread := [ 
	                             [ true ] whileTrue: [ 
		                             (Delay forSeconds: 1) wait.

		                             self getTMGTimeTravelServicesProvider
			                             isRestoring ifFalse: [ 
			                             self getMolGPSDataEventsNotifier 
				                             currentPositionChanged: 1 @ 1.

			                             self getTMGTimeTravelServicesProvider
				                             saveTheSystem ] ] ] forkAt:
		                             Processor userBackgroundPriority
]

{ #category : #'life cycle' }
MolGPSHardware >> componentInitialize [

	
	"Recording the creation of a component."

	self getTMGTimeTravelServicesProvider creationOf: self.
]

{ #category : #'life cycle' }
MolGPSHardware >> componentPassivate [
	
	self getTMGTimeTravelEventsSubscriber unsubscribe: self.
	
	sendCurrentPositionThread ifNotNil: [ :e | e terminate ].
	sendCurrentPositionThread := nil
]

{ #category : #'life cycle' }
MolGPSHardware >> componentRemove [

	"Recording the deletion of a component."

	self getTMGTimeTravelServicesProvider deletionOf: self
	
]

{ #category : #services }
MolGPSHardware >> getAccuracyRadiusInMeters [
	"Get and return the accuracy of the GPS depending quality of signal and quantity of connected satellites"
	
	"convert precision in feet to meters"
	^(self precision * 0.3048)
]

{ #category : #'component accessing' }
MolGPSHardware >> getMolGPSDataEventsNotifier [
	^self eventsNotifiers at: MolGPSDataEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: MolGPSDataEvents name: nil].
]

{ #category : #'component accessing' }
MolGPSHardware >> getTMGTimeTravelEventsSubscriber [
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
MolGPSHardware >> getTMGTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMGTimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMGTimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'GPS hardware existing API' }
MolGPSHardware >> precision [

	"Return GPS hardware precision (in feet)"

	^3
]

{ #category : #events }
MolGPSHardware >> saveForTimeTravel [

	| memento |
	memento := MGHardwareMemento new.

	self getTMGTimeTravelServicesProvider save: (memento save: self)
]
