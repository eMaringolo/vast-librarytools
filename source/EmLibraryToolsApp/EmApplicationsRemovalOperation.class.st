Class {
	#name : 'EmApplicationsRemovalOperation',
	#superclass : 'EmEventsOperation',
	#category : 'EmLibraryToolsApp'
}

{ #category : 'accessing',
  #vaVisibility : 'private' }
EmApplicationsRemovalOperation >> applications [
	^(self events collect: [:each |  Smalltalk classAt: each identifier ]) asSet
]

{ #category : 'operations' }
EmApplicationsRemovalOperation >> execute: aBoolean [

	"Executes the removal of receiver."

	EmClassDevelopment imageBuilder removeApplications: self applications.
	aBoolean ifTrue: [self purge]
]

{ #category : 'operations' }
EmApplicationsRemovalOperation >> mergeWith: anotherOperation [

	anotherOperation events do: [:anEvent | self events add: anEvent]
]

{ #category : 'testing' }
EmApplicationsRemovalOperation >> mustBeMergedWith: anEmEventOperation [

	^anEmEventOperation class = self class
]

{ #category : 'operations',
  #vaVisibility : 'private' }
EmApplicationsRemovalOperation >> purge [
	self events do:
		[:ev | 
			ev partsRecordClass purge: ev identifier at: ev timeStamp.
			ev isApplication 
				ifTrue: 
					[EmLibraryCache current flushEntriesForApplicationNamed: ev identifier]
				ifFalse: 
					[EmLibraryCache current flushEntriesForSubApplicationNamed: ev identifier]]
]

{ #category : 'initializing',
  #vaVisibility : 'private' }
EmApplicationsRemovalOperation >> setEvent: anEmEvent [

	super setEvent: anEmEvent.
	events add: anEmEvent
]
