Class {
	#name : 'EmLoggingAccessorTest',
	#superclass : 'TestCase',
	#category : 'EmLibraryToolsTests'
}

{ #category : 'Not categorized' }
EmLoggingAccessorTest >> testInstallRestore [

	self deny: EmLibrary default operationsInterface isLoggingAccessor.
	EmLoggingAccessor install.
	self assert: EmLibrary default operationsInterface isLoggingAccessor.
	EmLibrary default resetOperationsInterface.
	self deny: EmLibrary default operationsInterface isLoggingAccessor.
]

{ #category : 'Not categorized' }
EmLoggingAccessorTest >> testLogChanges [

	| app accessor |
	accessor := EmLoggingAccessor install.
	app := Application
		create: #XDisposableTestApp
		with: (Array with: Kernel).
	
	self assert: accessor changelog notEmpty.
	
	EmInterface current removeApplications: (Array with: app).
	
	Application purgeFromLibrary: #XDisposableTestApp.

]
