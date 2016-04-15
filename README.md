
This sample describes how to upload file to iCloud.and then see those uploaded files 

This is a rough sample 

STEPS:

To use iCloud, you need to set up some Entitlements that gives your app access to the iCloud directory

 enable iCloud from target—>capabilities
 
Which will show some error if the app has no valid provision profile.

The first step is to visit the iOS Developer Center and go to the iOS Provisioning Portal. Click App IDs in the sidebar and then New App ID. Create an App ID for your app.

Note that iCloud is not enabled by default – you have to configure it. To do so, simply click the Configure button, check the checkbox for Enable for iCloud, and click Done

Next you need to create a provisioning profile for your App ID. Click the Provisioning tab, click New Profile, and select the appropriate information.

Next, you need to set up your Xcode project to use this provisioning profile. Click your project in the Project Navigator, select the  target, and go to the Build Settings tab. Search for code sign, and set the code signing identity to your new provisioning profile.

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



