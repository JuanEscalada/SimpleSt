Class {
	#name : 'BaselineOfSimpleSt',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSimpleSt',
	#package : 'BaselineOfSimpleSt'
}

{ #category : 'baselines' }
BaselineOfSimpleSt >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self
			setUpDependencies: spec;
			setUpGroups: spec.
		spec group: 'default' with: #( 'Development' ) ]
]

{ #category : 'baselines' }
BaselineOfSimpleSt >> setUpDependencies: spec [

	
]

{ #category : 'baselines' }
BaselineOfSimpleSt >> setUpGroups: spec [

	spec
		package: 'SimpleSt' with: [  ];
		package: 'SimpleSt-Tests' with: [ spec requires: #( 'SimpleSt' ) ].
	spec
		group: 'Deployment' with: #( 'SimpleSt' );
		group: 'Development' with: #( 'SimpleSt-Tests' )
]
