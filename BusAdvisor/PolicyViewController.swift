//
//  policyViewController.swift
//  Demo1
//
//  Created by Yiting Wang on 20/04/2018.
//  Copyright © 2018 COMP208. All rights reserved.
//

import UIKit

class PolicyViewController: UIViewController {

	
	@IBOutlet var textField: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let content = """
Privacy Policy\
			COMP208 Group21 from University of Liverpool build the BusAdvisor app as a free app. This SERVICE is provided by COMP208 Group21 from University of Liverpool at no cost and is intended for use as is.
			This page is used to inform application users regarding our policies with the collection, use and disclosure of Personal Information if anyone decided to use our Service.
			If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.
			The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at BusAdvisor unless otherwise defined in this Privacy Policy.
			Information Collection and Use
			For a better experience, while using our Service, we may require you to provide us with certain personally information, including but not limited to Li Ju, Qiyao Zuo, Joshua Brown, Yiting Wang, Weiyi Zhang. The information that I request is retained on your device and is not collected by us in any way.
			The app does use third party services that may collect information used to identify you.
			Log Data
			We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (may through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol address, device name, operating system version, location, location record, the configuration of the app when utilizing our Service, and other statistics.
		Location information
		This app required your location data to provide specific functionality. Two ways will be used to collect location data. We may receive data directly from your mobile device when your permit app to access your location. We may receive location data from cell tower or Wi-Fi hotspot information.
		Links to Other Sites
		This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.
			Security
			We value you trust in providing us your Personal Information, thus we are striving to use acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.
			Changes to This Privacy Policy
			We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.
		Children\
		Our app will comply with the Children's Online Privacy Protection Act(COPPA). These Services do not address anyone under the age of 13. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.
		Advertisement
		Advertisement services collect some sort of personally identifiable information as a rule of thumb to make sure they are able to track the effectiveness of their ads or to increase their reach and impact. If you have any issues, please contact us so that we will be able to do necessary actions.
		Contact Us
		If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact us. Please email zwy.tt.liv@gmail.com.
		References:
		https://app-privacy-policy-generator.firebaseapp.com/#
		https://www.iubenda.com/blog/privacy-policy-admob/
		http://www.docracy.com/6516/mobile-privacy-policy-ad-sponsored-apps-
"""
		
		textField.text = NSLocalizedString(content, comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
