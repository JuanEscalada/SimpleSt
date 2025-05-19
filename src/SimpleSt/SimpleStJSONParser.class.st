"
Class: SimpleStJSONParser
                                                                                                    
I'm a Simple JSON Parser to use in minimal applications where complex behavior is not needed.
"
Class {
	#name : 'SimpleStJSONParser',
	#superclass : 'Object',
	#instVars : [
		'input',
		'index'
	],
	#category : 'SimpleSt-Base',
	#package : 'SimpleSt',
	#tag : 'Base'
}

{ #category : 'instance creation' }
SimpleStJSONParser class >> on: aStreamOrString [

  ^ self new initializeOn: aStreamOrString
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> hasUnescapedQuoteAt: anIndex [

  | backslashCounter backslashIndex |
  backslashCounter := 0.
  backslashIndex := anIndex - 1.
  [ backslashIndex > 0 and: [ ( input at: backslashIndex ) = $\ ] ] whileTrue: [
      backslashCounter := backslashCounter + 1.
      backslashIndex := backslashIndex - 1
    ].
  ^ backslashCounter even
]

{ #category : 'initialization' }
SimpleStJSONParser >> initializeOn: aStreamOrString [

	input := aStreamOrString.
	index := 1
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> nextChar [

  index := index + 1.
  ^ input at: index - 1
]

{ #category : 'parsing' }
SimpleStJSONParser >> parse [

  ^ self parseElement
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> parseArray [

  | result |
  result := OrderedCollection new.
  self nextChar. "consume ["
  self skipSeparators.
  [ self peekChar ~= $] ] whileTrue: [
      result add: self parseElement.
      self skipSeparators.
      self peekChar = $, ifTrue: [
          self nextChar.
          self skipSeparators
        ]
    ].
  self nextChar. "consume ]"
  ^ result asArray
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> parseElement [

  | char |
  self skipSeparators.
  char := self peekChar.
  char = ${ ifTrue: [ ^ self parseObject ].
  char = $[ ifTrue: [ ^ self parseArray ].
  char = $" ifTrue: [ ^ self parseString ].
  ( '0123456789-' includes: char ) ifTrue: [ ^ self parseNumber ].
  ( input copyFrom: index to: index + 3 ) = 'null' ifTrue: [
      index := index + 4.
      ^ nil
    ].
  ( input copyFrom: index to: index + 3 ) = 'true' ifTrue: [
      index := index + 4.
      ^ true
    ].
  ( input copyFrom: index to: index + 4 ) = 'false' ifTrue: [
      index := index + 5.
      ^ false
    ].
  ( input copyFrom: index to: index + 8 ) = 'undefined' ifTrue: [
      index := index + 9.
      ^ nil
    ].
  self error: 'Unexpected character: ' , char asString
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> parseNumber [

  | result |
  result := String streamContents: [ :stream |
                [
                  self peekChar notNil and: [
                      self peekChar isDigit or: [
                          { $. . $- } anySatisfy: [ :subchar | subchar = self peekChar ] ] ]
                ] whileTrue: [ stream nextPutAll: self nextChar asString ]
              ].
  ^ ( result includes: $. )
      ifTrue: [ result asNumber ]
      ifFalse: [ result asInteger ]
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> parseObject [

  | result |
  result := Dictionary new.
  self nextChar. "consume {"
  self skipSeparators.
  [ self peekChar ~= $} ] whileTrue: [
      | key value |
      key := self parseString.
      self skipSeparators.
      self nextChar. "consume :"
      self skipSeparators.
      value := self parseElement.
      result at: key put: value.
      self skipSeparators.
      self peekChar = $, ifTrue: [
          self nextChar.
          self skipSeparators
        ]
    ].
  self nextChar. "consume }"
  ^ result
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> parseString [

  ^ String streamContents: [ :stream |
        | char |
        self nextChar. "consume opening quote"
        [
          char := self nextChar.
          char = $\
            ifTrue: [
                char := self nextChar.
                char = $" ifTrue: [ stream nextPut: $" ].
                char = $\ ifTrue: [ stream nextPut: $\ ].
                char = $/ ifTrue: [ stream nextPut: $/ ].
                char = $b ifTrue: [ stream nextPut: Character backspace ].
                char = $f ifTrue: [ stream nextPut: Character newPage ].
                char = $n ifTrue: [ stream nextPut: Character lf ].
                char = $r ifTrue: [ stream nextPut: Character cr ].
                char = $t ifTrue: [ stream nextPut: Character tab ].
                char = $u ifTrue: [
                    | hex unicodeChar |
                    hex := input copyFrom: index to: index + 3.
                    index := index + 4.
                    unicodeChar := ( Integer readFrom: hex radix: 16 ) asCharacter.
                    stream nextPut: unicodeChar
                  ]
              ]
            ifFalse: [ char ~= $" ifTrue: [ stream nextPut: char ] ].
          char = $" and: [ self hasUnescapedQuoteAt: index - 1 ]
        ] whileFalse
      ]
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> peekChar [

  ^ index <= input size ifTrue: [ input at: index ]
]

{ #category : 'private - parsing' }
SimpleStJSONParser >> skipSeparators [

  [ index <= input size and: [ ( input at: index ) isSeparator ] ] whileTrue: [ index := index + 1 ]
]
