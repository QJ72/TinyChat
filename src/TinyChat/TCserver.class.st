Class {
	#name : #TCserver,
	#superclass : #Object,
	#instVars : [
		'teapotServer',
		'messagesQueue'
	],
	#category : #'TinyChat-Server'
}

{ #category : #public }
TCserver class >> startOn: aPortNumber [
	^self new
		initializePort: aPortNumber;
		registerRoutes;
		registerErrorHandlers;
		yourself
]

{ #category : #registering }
TCserver class >> stopAll [
	self allInstancesDo: #stop
]

{ #category : #adding }
TCserver >> addMessage: aRequest [
	messagesQueue add: (TCMessage from: (aRequest at: #sender) text:
	(aRequest at: #text)).
]

{ #category : #initialization }
TCserver >> initialize [
	super initialize.
	messagesQueue := TCMessageQueue new
]

{ #category : #initialization }
TCserver >> initializePort: anInteger [
	teapotServer := Teapot configure: { 
	#defaultOutput -> #text.
	#port -> anInteger.
	#debudMode -> true 
	}.
	teapotServer start.
]

{ #category : #'public protocol' }
TCserver >> messageCount [
	^ messagesQueue size
]

{ #category : #'as yet unclassified' }
TCserver >> messagesFrom: request [
	^ messagesQueue formattedMessagesFrom: (request at: #id)
]

{ #category : #'as yet unclassified' }
TCserver >> registerErrorHandlers [
	teapotServer
		exception: KeyNotFound -> (TeaResponse notFound body: 'No such
		message')
]

{ #category : #'as yet unclassified' }
TCserver >> registerRoutes [
	teapotServer
		GET: '/messages/count' -> (Send message: #messageCount to: self);
		GET: '/messages/<id:IsInteger>' -> (Send message: #messagesFrom: to: self);
		POST: '/messages/add' -> (Send message: #addMessage: to: self)
]

{ #category : #accessing }
TCserver >> stop [
	teapotServer stop.
	messagesQueue reset.
]
