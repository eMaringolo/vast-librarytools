Class {
	#name : 'EmClassRemovedEvent',
	#superclass : 'EmClassEvent',
	#category : 'EmLibraryToolsApp'
}

{ #category : 'Not categorized' }
EmClassRemovedEvent >> addToMonitor: anEmMonitor [

	(anEmMonitor lastEventForClass: self identifier)
		ifNil: [
			self timeStamp isNil
				ifTrue: [
					(anEmMonitor lastTimeStampOfClass: self identifier in: (self applicationName))
						ifNotNil: [:ts |
							self setTimeStamp: ts.
							anEmMonitor addEvent: self]]
				ifFalse: [anEmMonitor basicAddEvent: self]]
		ifNotNil: [:pastEvent |
			self updateFrom: pastEvent.

			anEmMonitor basicAddEvent: self]
]

{ #category : 'Not categorized' }
EmClassRemovedEvent >> revert: aBoolean [

	EmImageBuilder loadClasses:
		(Array with: (self application classEditionNamed: self identifier at: self timeStamp))
]

{ #category : 'Not categorized' }
EmClassRemovedEvent >> updateFrom: anEmClassCreatedEvent [


	self setTimeStamp: anEmClassCreatedEvent timeStamp.
	self ownerIsApp: anEmClassCreatedEvent ownerIsApp.
]
