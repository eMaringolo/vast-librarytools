Class {
	#name : 'EmPluggableOperation',
	#superclass : 'EmMonitorOperation',
	#instVars : [
		'valuable'
	],
	#category : 'EmLibraryToolsApp'
}

{ #category : 'instance-creation' }
EmPluggableOperation class >> for: anEvent action: aBlock [

	^(self for: anEvent)
		setValuable: aBlock;
		yourself
]

{ #category : 'operations' }
EmPluggableOperation >> execute: aBoolean [

	^self valuable cull: self event
]

{ #category : 'initializing',
  #vaVisibility : 'private' }
EmPluggableOperation >> setValuable: aBlock [

	valuable := aBlock
]

{ #category : 'accessing' }
EmPluggableOperation >> valuable [

	^valuable
]
