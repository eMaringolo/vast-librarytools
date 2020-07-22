Class {
	#name : 'EmLibrarySnapshotTest',
	#superclass : 'TestCase',
	#instVars : [
		'snapshot',
		'restoreOnTearDown'
	],
	#category : 'EmLibraryToolsTests'
}

{ #category : 'Not categorized' }
EmLibrarySnapshotTest >> disableRestoreOnTearDown [
	restoreOnTearDown := false
]

{ #category : 'Running' }
EmLibrarySnapshotTest >> setUp [

	super setUp.
	restoreOnTearDown := true.
	snapshot := EmLibrarySnapshot now startLogging.
]

{ #category : 'Running' }
EmLibrarySnapshotTest >> tearDown [
	super tearDown.
	
	restoreOnTearDown ifTrue: [snapshot restore]
]

{ #category : 'Not categorized' }
EmLibrarySnapshotTest >> testAddRemoveApplication [

	| app |
	app := Application
		create: #XDisposableTestApp
		with: (Array with: Kernel).
	
	self assert: app shadows notEmpty.
	
	self assert: (System image loadedApplications includes: app).
	EmInterface current removeApplications: (Array with: app).
	self deny: (System image loadedApplications includes: app).
	
		
	Application purgeFromLibrary: #XDisposableTestApp.
	
	
	

	
]

{ #category : 'Not categorized' }
EmLibrarySnapshotTest >> testAddRemoveNewApplication [
	| app |
	self disableRestoreOnTearDown.
	app := Application create: #XTearDownDisposableTestApp
				with: (Array with: Kernel).
	self assert: app shadows notEmpty.
	self assert: (System image loadedApplications includes: app).
	snapshot restore.
	self deny: (System image loadedApplications includes: app).
	
]

{ #category : 'Not categorized' }
EmLibrarySnapshotTest >> testInstallLoggingAccessor [

	snapshot startLogging.
	
	self assert: EmLibrary default operationsInterface class equals: EmLoggingAccessor.

	snapshot stopLogging.

	self assert: EmLibrary default operationsInterface class equals: EmStandardAccessor.
	

	
]
