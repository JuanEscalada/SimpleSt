Class {
	#name : 'SimpleStJSONWriterTest',
	#superclass : 'TestCase',
	#category : 'SimpleSt-Tests',
	#package : 'SimpleSt-Tests'
}

{ #category : 'tests' }
SimpleStJSONWriterTest >> especialReplacementCharacters [
	"Necesary as JSON replacement for these characters is not direct."

	^ OrderedCollection new
		  add: $\;
		  add: $";
		  add: $/;
		  add: Character backspace;
		  add: Character tab;
		  add: Character cr;
		  add: Character lf;
		  add: Character newPage;
		  yourself
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsAllCasesCombined [

	| combinedCases |
	combinedCases := Dictionary new
		                 at: 'number' put: 17;
		                 at: 'col'
		                 put: #( 17 12 5 6 $h 'sdrawkcabsihtgnidearerauoY' );
		                 at: 'bool' put: true;
		                 at: 'null' put: nil;
		                 yourself.
	self
		assert: (SimpleStJSONWriter toString: combinedCases)
		equals:
		'{"col":[17,12,5,6,"h","sdrawkcabsihtgnidearerauoY"],"bool":true,"null":null,"number":17,}'
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsBooleanConversion [

	self assert: (SimpleStJSONWriter toString: true) equals: 'true'.
	self assert: (SimpleStJSONWriter toString: false) equals: 'false'
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsCollectionToListConversion [
	"Only tested for Array, OrderedCollection and Set"

	| collection |
	collection := #(  ).
	self assert: (SimpleStJSONWriter toString: collection) equals: '[]'.

	collection := #( 1 ).
	self assert: (SimpleStJSONWriter toString: collection) equals: '[1]'.

	collection := #( 1 2 3 ).
	self
		assert: (SimpleStJSONWriter toString: collection)
		equals: '[1,2,3]'.


	collection := OrderedCollection new.
	self assert: (SimpleStJSONWriter toString: collection) equals: '[]'.

	collection := OrderedCollection new
		              add: 1;
		              yourself.
	self assert: (SimpleStJSONWriter toString: collection) equals: '[1]'.

	collection := OrderedCollection new
		              add: 1;
		              add: 2;
		              add: 3;
		              yourself.
	self
		assert: (SimpleStJSONWriter toString: collection)
		equals: '[1,2,3]'.


	collection := Set new.
	self assert: (SimpleStJSONWriter toString: collection) equals: '[]'.

	collection := Set new
		              add: 1;
		              yourself.
	self assert: (SimpleStJSONWriter toString: collection) equals: '[1]'.

	collection := Set new
		              add: 1;
		              add: 2;
		              add: 3;
		              yourself.
	[
	self
		assert: (SimpleStJSONWriter toString: collection)
		equals: '[1,2,3]' ]
		on: TestFailure
		do: [ :signal | "One can not guarantee order on hashed collections, so this might fail"
			signal return: true ]
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsCommonCharacterToStringConversion [

	| characters |
	characters := String streamContents: [ :stream |
		              Character allByteCharacters do: [ :character |
			              (self especialReplacementCharacters includes:
				               character) ifFalse: [
				              stream nextPutAll: character asString ] ] ].

	characters do: [ :character |
		self
			assert: (SimpleStJSONWriter toString: character)
			equals: ('"<1s>"' expandMacrosWith: character asString) ]
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsDictionaryToMapConversion [

	| dictionary |
	dictionary := Dictionary new.
	self assert: (SimpleStJSONWriter toString: dictionary) equals: '{}'.

	dictionary := Dictionary new
		              at: 'a' put: 1;
		              yourself.
	self
		assert: (SimpleStJSONWriter toString: dictionary)
		equals: '{"a":1,}'.

	dictionary := Dictionary new
		              at: 'a' put: 1;
		              at: 'b' put: 2;
		              at: 'c' put: 3;
		              at: 'd' put: 4;
		              yourself.
	[
	self
		assert: (SimpleStJSONWriter toString: dictionary)
		equals: '{"a":1,"b":2,"c":3,"d":4,}' ]
		on: TestFailure
		do: [ :signal | "One can not guarantee Key order on dictionaries, so this might fail"
			signal return: true ]
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsEscapedCharactersToStringConvertion [

	| escapedCharacter |
	escapedCharacter := $\.
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\\"'.
	escapedCharacter := $".
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\""'.
	escapedCharacter := $/.
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\/"'.
	escapedCharacter := Character backspace.
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\b"'.
	escapedCharacter := Character tab.
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\t"'.
	escapedCharacter := Character cr.
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\r"'.
	escapedCharacter := Character lf.
	self
		assert: (SimpleStJSONWriter toString: escapedCharacter)
		equals: '"\n"'
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsFloatConversion [

	0.1 to: 655391.1 do: [ :float |
		self
			assert: (SimpleStJSONWriter toString: float)
			equals: float asString ]
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsIntegerConversion [

	0 to: 65539 do: [ :integer |
		self
			assert: (SimpleStJSONWriter toString: integer)
			equals: integer asString ]
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsNilToNullConversion [

	self assert: (SimpleStJSONWriter toString: nil) equals: 'null'
]

{ #category : 'tests' }
SimpleStJSONWriterTest >> testVerifyWriterSupportsStringConversion [
	"Characters null, value: 1 (SOH) and value: 2 (STX) can not be written or copied so we need to do this workaround."

	self
		assert: (SimpleStJSONWriter toString: Character allByteCharacters)
		equals:
			'"' , Character null asString , (Character value: 1) asString
			, (Character value: 2) asString
			,
			'\b\t\n\f\r !\"#$%&''()*+,-.\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"'
]
