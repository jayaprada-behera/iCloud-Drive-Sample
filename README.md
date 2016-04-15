
This sample describes how to upload file to iCloud.and then see those uploaded files 

This is a rough sample 

STEPS:

Create a entitlements file 

 enable iCloud from target—>capabilities
 
Which will show some error if the app has no valid provision profile.

add below code

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.icloud-container-identifiers</key>
	<array>
        <string>iCloud.com.virinchi.EmptyProject</string><!-- this is copied from developer .apple .com
                                                          when you will entitle your app for icloud-->
	</array>
	<key>com.apple.developer.icloud-services</key>
	<array>
		<string>CloudDocuments</string>
	</array>
	<key>com.apple.developer.ubiquity-container-identifiers</key>
	<array>
		<string>iCloud.com.virinchi.EmptyProject</string>
	</array>
</dict>
</plist>



