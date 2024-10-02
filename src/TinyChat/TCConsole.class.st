Class {
	#name : #TCConsole,
	#superclass : #ComposableModel,
	#instVars : [
		'chat',
		'list',
		'input'
	],
	#category : #'TinyChat-client'
}

{ #category : #specs }
TCConsole class >> defaultSpec [ 
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :c |
			c add: #list; add: #input height: 30 ]; yourself
]

{ #category : #utilities }
TCConsole >> attach: aTinyChat [
	| windowChat |
	windowChat := self new chat: aTinyChat.
	windowChat openWithSpec whenClosedDo: [ aTinyChat disconnect ].
	^ windowChat
]

{ #category : #accessing }
TCConsole >> chat: anObject [ 
	chat := anObject 
]

{ #category : #comparing }
TCConsole >> initializeWidgets [
list := ListModel new.
input := TextInputFieldModel new
ghostText: 'Type your message here...';
enabled: true;
acceptBlock: [ :string |
chat send: string.
input text: '' ].
self focusOrder add: input.
]

{ #category : #accessing }
TCConsole >> input [ 
	^ input
]

{ #category : #accessing }
TCConsole >> list [ 
	^ list
]

{ #category : #printing }
TCConsole >> print: aCollectionOfMessages [
list items: (aCollectionOfMessages collect: [ :m | m printString
])
]

{ #category : #api }
TCConsole >> title [ 
	^ 'TinyChat'
]
