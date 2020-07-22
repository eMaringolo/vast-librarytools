Class {
	#name : 'EmApplicationCreatedEvent',
	#superclass : 'EmSubApplicationCreatedEvent',
	#category : 'EmLibraryToolsApp'
}

{ #category : 'Not categorized' }
EmApplicationCreatedEvent >> revert: aBoolean [

	"Applies the neccesary changes in order to rever the event defined by receiver.
	 If aBoolean is true, also purges the changes from the Library (if applicable)."
	
	| app |
	app := Smalltalk classAt: self identifier.
	EmClassDevelopment imageBuilder removeApplications: (Set with: app).
	aBoolean ifTrue: [
		(app partsRecordClass purge: self identifier at: self timeStamp).
		app isApplication
			ifTrue: [EmLibraryCache current flushEntriesForApplicationNamed: self identifier]
			ifFalse: [EmLibraryCache current flushEntriesForSubApplicationNamed: self identifier].
		]
]
