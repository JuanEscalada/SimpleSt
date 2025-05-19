Class {
	#name : 'SimpleStJSONParserTest',
	#superclass : 'TestCase',
	#category : 'SimpleSt-Tests',
	#package : 'SimpleSt-Tests'
}

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsAllCasesCombined [

  | parseResult expectedResult |
  parseResult := ( SimpleStJSONParser on:
                     '{"col":[17,12,5,6,"h","sdrawkcabsihtgnidearerauoY"],"bool":true,"undefined":undefined,"null":null,"number":17,}' )
                   parse.

  expectedResult := Dictionary new
                      at: 'number' put: 17;
                      at: 'col' put: #( 17 12 5 6 'h' 'sdrawkcabsihtgnidearerauoY' );
                      at: 'bool' put: true;
                      at: 'undefined' put: nil;
                      at: 'null' put: nil;
                      yourself.
  self assertCollection: parseResult hasSameElements: expectedResult
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsBooleanConversion [

  self assert: ( SimpleStJSONParser on: 'true' ) parse equals: true.
  self assert: ( SimpleStJSONParser on: 'false' ) parse equals: false
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsFloatConversion [

  0.1 to: 655391.1 do: [ :float |
    self assert: ( SimpleStJSONParser on: float asString ) parse equals: float ]
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsIntegerConversion [

  0 to: 65539 do: [ :integer |
    self assert: ( SimpleStJSONParser on: integer asString ) parse equals: integer ]
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsListToArrayConversion [
  "With or without unnecesary separators."

  self assert: ( SimpleStJSONParser on: '[]' ) parse equals: #(  ).
  self assert: ( SimpleStJSONParser on: '[   ] ' ) parse equals: #(  ).

  self assert: ( SimpleStJSONParser on: '[1]' ) parse equals: #( 1 ).
  self assert: ( SimpleStJSONParser on: ' [1  ]' ) parse equals: #( 1 ).

  self assert: ( SimpleStJSONParser on: '[1,2,3]' ) parse equals: #( 1 2 3 ).
  self assert: ( SimpleStJSONParser on: '[1 ,2 , 3]' ) parse equals: #( 1 2 3 )
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsObjectToDictionaryConversion [

  self assert: ( SimpleStJSONParser on: '{}' ) parse equals: Dictionary new.

  self assert: ( SimpleStJSONParser on: '{"a":1,}' ) parse equals: ( Dictionary new
        at: 'a' put: 1;
        yourself ).

  self
    assert: ( SimpleStJSONParser on: '{"a":1,"b":2,"c":3,"d":4,}' ) parse
    equals: ( Dictionary new
          at: 'a' put: 1;
          at: 'b' put: 2;
          at: 'c' put: 3;
          at: 'd' put: 4;
          yourself )
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsStringConversion [
	"Characters null, value: 1 (SOH) and value: 2 (STX) can not be written or copied so we need to do this workaround."

	self
		assert: (SimpleStJSONParser on: ('"' , Character null asString , (Character value: 1) asString
			, (Character value: 2) asString
			,
			'\b\t\n\f\r !\"#$%&''()*+,-.\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"')) parse
		equals: Character allByteCharacters
			
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyParserSupportsStringToEscapedCharactersConvertion [

  self assert: ( SimpleStJSONParser on: '"\\"' ) parse equals: '\'.
  self assert: ( SimpleStJSONParser on: '"\\\\"' ) parse equals: '\\'.
  self assert: ( SimpleStJSONParser on: '"\""' ) parse equals: '"'.
  self assert: ( SimpleStJSONParser on: '"\\\""' ) parse equals: '\"'.
  self assert: ( SimpleStJSONParser on: '"\/"' ) parse equals: '/'.
  self assert: ( SimpleStJSONParser on: '"\b"' ) parse equals: Character backspace asString.
  self assert: ( SimpleStJSONParser on: '"\t"' ) parse equals: Character tab asString.
  self assert: ( SimpleStJSONParser on: '"\r"' ) parse equals: Character cr asString.
  self assert: ( SimpleStJSONParser on: '"\n"' ) parse equals: Character lf asString.
  "Unicode Hex Character Examples of Pharo supported Cases."
  self assert: ( SimpleStJSONParser on: '"\u03BB"' ) parse equals: 'λ'.
  self assert: ( SimpleStJSONParser on: '"\u00E1"' ) parse equals: 'á'.
  self assert: ( SimpleStJSONParser on: '"\u20AC"' ) parse equals: '€'
]

{ #category : 'tests' }
SimpleStJSONParserTest >> testVerifyWriterSupportsNullAndUndefinedToNilConversion [

  self assert: ( SimpleStJSONParser on: 'null' ) parse equals: nil.
  self assert: ( SimpleStJSONParser on: 'undefined' ) parse equals: nil
]
