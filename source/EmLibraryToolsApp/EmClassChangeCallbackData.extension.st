Extension {
	#name : 'EmClassChangeCallbackData'
}

{ #category : '*EmLibraryToolsApp',
 #vaCategories : ['EM-Internal'] }
EmClassChangeCallbackData >> asEmEvent [

	| class |

	(self changeType bitAnd: EMCDirectDefinitionChange) = EMCDirectDefinitionChange
		ifTrue: [ "We ignore this direct changes." ^nil].
	(self changeType bitAnd: EMCAdded) == EMCAdded
		ifTrue: [
			class := (Smalltalk classAt: className).
			^((EmClassCreatedEvent
				identifier: className
				timeStamp: (class timeStampIn: (Smalltalk classAt: applicationName)))
					applicationName: applicationName)].
	(self changeType bitAnd: EMCRemoved) == EMCRemoved
		ifTrue: [
			^((EmClassRemovedEvent identifier: self className timeStamp: EmTimeStamp undefined)
				applicationName: self applicationName)].

	(self changeType bitAnd: EMCChanged) == EMCChanged
		ifTrue: [

			"^((EmClassChangedEvent identifier: self selector timeStamp: methodTs
							className: self className applicationName: self applicationName)
								instanceLevel: self instanceLevel)."
			].
	^nil
]
