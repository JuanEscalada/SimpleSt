"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestSimpleSt',
	#superclass : 'PackageManifest',
	#category : 'SimpleSt-Manifest',
	#package : 'SimpleSt',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestSimpleSt class >> ruleReNotOptimizedIfRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#SimpleSt)) #'2024-12-15T17:13:19.973+01:00') )
]

{ #category : 'code-critics' }
ManifestSimpleSt class >> ruleReturnsIfTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#SimpleSt)) #'2025-05-19T00:41:08.089-03:00') )
]
