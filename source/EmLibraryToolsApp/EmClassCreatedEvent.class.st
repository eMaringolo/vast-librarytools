Class {
	#name : 'EmClassCreatedEvent',
	#superclass : 'EmClassEvent',
	#category : 'EmLibraryToolsApp'
}

{ #category : 'Not categorized' }
EmClassCreatedEvent class >> identifier: aSymbol type: classType in: appOrSub [
	"Enter the new method definition below and click 'Resume'."
	
	^self identifier: aSymbol timeStamp: ((Smalltalk classAt: aSymbol) timeStampIn: appOrSub) 
]

{ #category : 'Not categorized' }
EmClassCreatedEvent >> addToMonitor: anEmMonitor [

	(anEmMonitor lastEventForClass: self identifier type: self class)
		ifNil: [self basicAddToMonitor: anEmMonitor]
		ifNotNil: [:pastEvent | pastEvent updateFrom: self]


]

{ #category : 'Not categorized' }
EmClassCreatedEvent >> revert: aBoolean [

	"Applies the neccesary changes in order to rever the event defined by receiver.
	 If aBoolean is true, also purges the changes from the Library (if applicable)."

	(Smalltalk classAt: self identifier) deleteFrom: self application.
]

{ #category : 'Not categorized' }
EmClassCreatedEvent >> updateFrom: anEmClassCreatedEvent [


	self 
		setTimeStamp: anEmClassCreatedEvent timeStamp;
		applicationName: anEmClassCreatedEvent applicationName.
	self ownerIsApp: (Smalltalk classAt: self applicationName) isApplication
		
]
