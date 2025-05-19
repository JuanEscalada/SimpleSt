"
I'm a Simple JSON Writer to use in minimal applications where complex behavior is not needed.
"
Class {
	#name : 'SimpleStJSONWriter',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'SimpleSt-Base',
	#package : 'SimpleSt',
	#tag : 'Base'
}

{ #category : 'instance creation' }
SimpleStJSONWriter class >> on: aStream [

	^ self new initializeOn: aStream
]

{ #category : 'writing' }
SimpleStJSONWriter class >> toString: anObject [

	^ String streamContents: [ :stream |
		  (self on: stream) write: anObject ]
]

{ #category : 'private - accessing' }
SimpleStJSONWriter >> escapedCharacterStrings [

	^ self escapedCharactersWithReplacements collect: [ :association |
		  association key asString ]
]

{ #category : 'private - accessing' }
SimpleStJSONWriter >> escapedCharactersWithReplacements [

	^ OrderedCollection new
		  add: $\ -> '\\';
		  add: $" -> '\"';
		  add: $/ -> '\/';
		  add: Character backspace -> '\b';
		  add: Character tab -> '\t';
		  add: Character cr -> '\r';
		  add: Character lf -> '\n';
		  add: Character newPage -> '\f';
		  yourself
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> if: anObject isBooleanDo: aBlock [

	[
	anObject
		ifTrue: aBlock
		ifFalse: aBlock ]
		on: MessageNotUnderstood
		do: [ :signal | signal return ]
]

{ #category : 'initialization' }
SimpleStJSONWriter >> initializeOn: aStream [

	stream := aStream
]

{ #category : 'writing' }
SimpleStJSONWriter >> write: anObject [

	self write: anObject to: stream
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> write: anObject to: aStream [

	anObject isDictionary ifTrue: [ ^self writeDictionary: anObject to: aStream ].
	anObject isCharacter ifTrue: [ ^self writeString: anObject asString to: aStream ].
	anObject isString ifTrue: [ ^self writeString: anObject to: aStream ].
	anObject isCollection ifTrue: [ ^self writeCollection: anObject to: aStream ].
	anObject isInteger ifTrue: [ ^self writeNumber: anObject to: aStream ].
	anObject isFloat ifTrue: [ ^self writeNumber: anObject to: aStream ].
	self if: anObject isBooleanDo: [ ^self writeBoolean: anObject to: aStream ].
	anObject ifNil: [ ^self writeNil: anObject to: aStream ].
	
	self error: 'Unexpected Object, was not a Collection, Dictionary, Integer, Float, String, Boolean or nil.'
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> writeBoolean: aBoolean to: aStream [

	aStream nextPutAll: (aBoolean
			 ifTrue: [ 'true' ]
			 ifFalse: [ 'false' ])
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> writeCollection: aCollection to: aStream [

	aStream nextPut: $[.
	aCollection 
		do: [ :each | self write: each to: aStream ] 
		separatedBy: [aStream nextPut: $,].	
	aStream nextPut: $].
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> writeDictionary: aDictionary to: aStream [

	aStream nextPut: ${.
	aDictionary keysAndValuesDo: [ :key :value |
		key isString ifFalse: [ self error: 'JSON keys must be strings' ].

		self write: key to: aStream.
		aStream nextPut: $:.
		self write: value to: aStream.
		aStream nextPut: $, ].
	aStream nextPut: $}
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> writeNil: aNil to: aStream [

	aStream nextPutAll: 'null'
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> writeNumber: aNumber to: aStream [

	aStream print: aNumber
]

{ #category : 'private - writing' }
SimpleStJSONWriter >> writeString: aString to: aStream [

	| escapedString |
	escapedString := String streamContents: [ :escapedStream |
		                 aString do: [ :character |
			                 escapedStream nextPutAll:
				                 (self escapedCharactersWithReplacements
					                  detect: [ :association |
					                  association key = character ]
					                  ifFound: [ :association | association value ]
					                  ifNone: [ character asString ]) ] ].


	aStream nextPut: $".
	aStream nextPutAll: escapedString.
	aStream nextPut: $"
]
