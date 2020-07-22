Class {
	#name : 'EmMonitor',
	#superclass : 'Object',
	#instVars : [
		'snapshot',
		'events',
		'logging'
	],
	#classVars : [
		'Default'
	],
	#pools : [
		'EmConstants'
	],
	#category : 'EmLibraryToolsApp'
}

{ #category : 'Not categorized' }
EmMonitor class >> default [

	^Default ifNil: [Default := self new initialize]
]

{ #category : 'logging' }
EmMonitor >> addEvent: anEmEvent [

	(self events isEmpty or: [anEmEvent ~= self events last]) ifTrue: [
		anEmEvent addToMonitor: self
	]
]

{ #category : 'logging' }
EmMonitor >> basicAddEvent: anEmEvent [

	
	self events add: anEmEvent
	
]

{ #category : 'callbacks',
  #vaVisibility : 'private' }
EmMonitor >> classChanged: aMethod clientData: anObject callData: callData [

	callData asEmEvent ifNotNil: [:event | self addEvent: event ]
	
]

{ #category : 'operations' }
EmMonitor >> disableDuring: aBlock [

	| previousLogging |

	previousLogging := logging.
	[
		self removeCallbacks.
		logging := false.
		aBlock value]
			ensure: [
				previousLogging
					ifTrue: [
						self initializeCallbacks.
						logging := previousLogging]]
]

{ #category : 'accessing' }
EmMonitor >> events [

	^events
]

{ #category : 'initializing',
  #vaVisibility : 'private' }
EmMonitor >> initialize [

	super initialize.
	logging := false
]

{ #category : 'callbacks',
  #vaVisibility : 'private' }
EmMonitor >> initializeCallbacks [

	System callbackInterface 
		addCallback: EmNmethodChangedCallback
		receiver: self 
		selector: #methodChanged:clientData:callData:
		clientData: nil.
	
	System callbackInterface 
		addCallback: EmNclassChangedCallback
		receiver: self 
		selector: #classChanged:clientData:callData:
		clientData: nil.
	
		
]

{ #category : 'lookup' }
EmMonitor >> lastEventForClass: aSymbol [

	
	self events reverseDo: [:each | 
		each identifier = aSymbol ifTrue: [^each]
	].
	^nil
]

{ #category : 'lookup' }
EmMonitor >> lastEventForClass: aSymbol type: anEmEventClass [

	self events reverseDo: [:each |
		(each identifier = aSymbol and: [each class = anEmEventClass]) ifTrue: [^each]].
	^nil
]

{ #category : 'lookup' }
EmMonitor >> lastTimeStampOfClass: className in: appName [

	^(self lastEventForClass: className)
		ifNil: [self snapshot timeStampAt: appName in: appName]
		ifNotNil: [:event | event timeStamp]
]

{ #category : 'callbacks',
  #vaVisibility : 'private' }
EmMonitor >> methodChanged: source clientData: anObject callData: callData [

	"callData asEmEvent ifNotNil: [:event | self log: event ]"
	
]

{ #category : 'printing' }
EmMonitor >> printOn: aStream [
	
	super printOn: aStream.
	aStream nextPut: $[.
	aStream 
		nextPutAll: self events size printString.
	aStream nextPut: $]
	
]

{ #category : 'initializing',
  #vaVisibility : 'private' }
EmMonitor >> release [

	super release.
	self removeCallbacks
]

{ #category : 'callbacks' }
EmMonitor >> removeCallbacks [

	System callbackInterface 
	removeCallback: EmNmethodChangedCallback
	receiver: self
	selector: #methodChanged:clientData:callData:
	clientData: nil.
	
	System callbackInterface 
		removeCallback: EmNclassChangedCallback
		receiver: self 
		selector: #classChanged:clientData:callData:
		clientData: nil.
	
		
]

{ #category : 'logging' }
EmMonitor >> removeEvent: anEmEvent [

	
	self events remove: anEmEvent
]

{ #category : 'lookup' }
EmMonitor >> reverseDetect: aBlock ifNone: notFoundBlock [
	
	self events reverseDo: [:each |
		(aBlock value: each) ifTrue: [^each]
	].
	^notFoundBlock value
]

{ #category : 'operations' }
EmMonitor >> revert [

	self revert: false
]

{ #category : 'operations' }
EmMonitor >> revert: aBoolean [
	"Reverts the events of receiver.
	 If aBoolean is true, also purge editions from library (when applicable)."

	self disableDuring: [
		self events copy reverseDo: [:event |
			event revert: aBoolean.
			self events remove: event]]
]

{ #category : 'accessing' }
EmMonitor >> snapshot [

	^snapshot
]

{ #category : 'operations' }
EmMonitor >> start [
	self removeCallbacks.
	events := OrderedCollection new.
	snapshot := EmLibrarySnapshot take.
	self startLogging
]

{ #category : 'operations',
  #vaVisibility : 'private' }
EmMonitor >> startLogging [
	logging := true.
	EmLoggingAccessor install.
	self initializeCallbacks
]

{ #category : 'operations' }
EmMonitor >> stop [
	self stopLogging
]

{ #category : 'operations',
  #vaVisibility : 'private' }
EmMonitor >> stopLogging [
	self removeCallbacks.
	EmLibrary default resetOperationsInterface.
	logging := false
]