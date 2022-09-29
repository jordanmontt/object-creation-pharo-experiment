Class {
	#name : #MpObjectAllocationProfilerHandler,
	#superclass : #MpHandler,
	#instVars : [
		'allocations',
		'classesToAvoid'
	],
	#category : #MethodProxiesSebas
}

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	returnValue class = self classToRegister ifTrue: [
		allocations add: (self contextThatCreatesTheColor: thisContext) -> returnValue ].
	^ returnValue
]

{ #category : #accessing }
MpObjectAllocationProfilerHandler >> allocations [

	^ allocations
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> classToRegister [

	^ self subclassResponsibility
]

{ #category : #evaluating }
MpObjectAllocationProfilerHandler >> contextThatCreatesTheColor: aContext [

	"(classToAvoid includes: aContext sender methodClass) ifFalse: [ 
	^ aContext sender methodClass ].
	^ self classThatCreatesTheColor: aContext sender"

	| sender |
	sender := aContext sender.
	[ classesToAvoid includes: sender methodClass ] whileTrue: [ 
		sender := sender sender ].
	^ sender
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> customClassesToAvoid [

	^ self subclassResponsibility
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> defaultClassesToAvoid [

	^{ 
		MpColorAllocationProfilerHandler.
		MpMethodProxy.
		BlockClosure.
		FullBlockClosure.
		CompiledBlock }
]

{ #category : #initialization }
MpObjectAllocationProfilerHandler >> initialize [

	super initialize.
	allocations := OrderedCollection new.
	classesToAvoid := self defaultClassesToAvoid , self customClassesToAvoid
]