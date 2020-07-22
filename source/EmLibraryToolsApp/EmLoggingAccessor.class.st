Class {
	#name : 'EmLoggingAccessor',
	#superclass : 'EmStandardAccessor',
	#instVars : [
		'accessor',
		'snapshot',
		'changelog'
	],
	#category : 'EmLibraryToolsApp'
}

{ #category : 'Not categorized' }
EmLoggingAccessor class >> install [

	^self installInto: EmLibrary default
]

{ #category : 'Not categorized' }
EmLoggingAccessor class >> installInto: anEmLibrary [

	^(self new)
		installInto: anEmLibrary;
		yourself
]

{ #category : 'Not categorized' }
EmLoggingAccessor class >> new [

	^self basicNew initialize
]

{ #category : 'logging' }
EmLoggingAccessor >> applicationAddInitialApplicationFor: appOrSub named: versionName [
		"Create the initial edition for appOrSub in the library."
	
	| event |
	super applicationAddInitialApplicationFor: appOrSub named: versionName.
	((appOrSub isApplication ifTrue: [EmApplicationCreatedEvent] ifFalse: [EmSubApplicationCreatedEvent]) identifier: appOrSub name timeStamp: appOrSub shadows first timeStamp).
	event := appOrSub isApplication
		ifTrue: [EmApplicationCreatedEvent identifier: appOrSub name timeStamp: appOrSub shadows first timeStamp]
		ifFalse: [
		 (EmSubApplicationCreatedEvent identifier: appOrSub name timeStamp: appOrSub shadows first timeStamp)
			parentIdentifier: appOrSub parent;
			yourself ].
	self notifyEvent: event.
]

{ #category : 'logging' }
EmLoggingAccessor >> applicationAddInitialClassFor: appOrSub class: aClass [
		"Create the initial edition for className to appOrSub in the library."
		
	super applicationAddInitialClassFor: appOrSub class: aClass.
	self addEvent: (EmClassCreatedEvent className: aClass name type: #defined in: appOrSub)
]

{ #category : 'logging' }
EmLoggingAccessor >> applicationAddPrerequisiteFor: appOrSub prereqName: aName toExpr: expr ifUnable: exit [
	
	
	super applicationAddPrerequisiteFor: appOrSub
	prereqName: aName
	toExpr: expr
	ifUnable: [
		exit value.
		^self].
	
	self addEvent: ((appOrSub isApplication 
				ifTrue: [EmApplicationPrerequisitesChangedEvent]
				ifFalse: [EmSubApplicationPrerequisitesChangedEvent])
					for: appOrSub expression: expr prereqName: aName)
]

{ #category : 'logging' }
EmLoggingAccessor >> applicationInsertClassNameFor: appOrSub className: className type: classType ifUnable: exitBlock [

	"Attempt to reserve aClassName in appOrSub.
	 Exit if appOrSub can not be modified or the current
	 user is not allowed to add a class."

	appOrSub updateEdition: [:editionRecord |
		editionRecord insertClassName: className type: classType ifUnable: [^exitBlock value]].

	"self log: (EmClassCreatedEvent identifier: className type: classType in: appOrSub)"
]

{ #category : 'logging' }
EmLoggingAccessor >> applicationNewEditionFor: appOrSub ifUnable: exit [

		"Create a new edition for appOrSub in the library."

	
	super applicationNewEditionFor: appOrSub ifUnable: [exit value. ^self].
	self addEvent: (EmApplicationEditionCreatedEvent identifier: appOrSub timeStamp: appOrSub timeStamp)
]

{ #category : 'operations' }
EmLoggingAccessor >> installInto: anEmLibrary [

	anEmLibrary operationsInterface == self ifFalse: [
		anEmLibrary operationsInterface: self
	]
]

{ #category : 'testing' }
EmLoggingAccessor >> isLoggingAccessor [

	^true
]

{ #category : 'logging' }
EmLoggingAccessor >> notifyEvent: anEmEvent [

	self monitor addEvent: anEmEvent
]

{ #category : 'operations' }
EmLoggingAccessor >> restore: anEmLibrary [

	anEmLibrary resetOperationsInterface
]

{ #category : 'initializing',
  #vaVisibility : 'private' }
EmLoggingAccessor >> setAccessor: anEmStandardAccessor [

	accessor := anEmStandardAccessor
]
