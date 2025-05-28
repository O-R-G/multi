# multi

v1.0.3

--

Make a local xcodebuild commandline environment

--

1. list schemes, targets

		xcodebuild -list -project projectname.xcodeproj

2. get device list

		xcrun simctl list devices available	

3. get $BUNDLEID ($BUNDLEPATH specific to local)

		mdls -name kMDItemCFBundleIdentifier -r $BUNDLEPATH
		
4. edit _build-schemename with values (one file per scheme)

		SCHEME=
		DEVICEID=
		DESTINATION=
		BUNDLEPATH=
		BUNDLEID=
    
5. make executable

		chmod +x _build-schemename

6. run

		./_build-schemename

--

Other useful xcodebuild commands

--

start simulator 

	/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator -CurrentDeviceUDID $DEVICEID; 

build

	xcodebuild -scheme $SCHEME -destination $DESTINATION build

build, stop, install, run

	xcodebuild -scheme $SCHEME build
	xcrun simctl terminate $DEVICEID $BUNDLEID
	xcrun simctl install $DEVICEID $BUNDLEPATH
	xcrun simctl launch $DEVICEID $BUNDLEID
	
--
	
