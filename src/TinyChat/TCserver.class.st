Class {
	#name : #TCserver,
	#superclass : #Object,
	#instVars : [
		'teapotServer',
		'messagesQueue'
	],
	#category : #'TinyChat-Server'
}

{ #category : #initialization }
TCserver >> initializePort: anInteger [
	teapotServer := Teapot configure: { 
	#defaultOutput -> #text.
	#port -> anInteger.
	#debudMode -> true 
	}.
	teapotServer start.
]

{ #category : #'as yet unclassified' }
TCserver >> registerRoutes [
	teapotServer 
		GET: '/messages/count' -> (Send message: #messagesCount to: self);
		GET: '/messages/<id:IsInteger>' -> (Send message: #messagesFrom: to: self);
		POST: '/messages/add' -> (Send message: #addMessage: to: self)
]
