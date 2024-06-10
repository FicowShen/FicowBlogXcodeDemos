import UIKit
import SnapKit
import MessengerTransport

public class FicowPodEntry {

    public static func hello() {
        let demoView = UIView()
        demoView.snp.makeConstraints { $0.size.equalTo(1) } // use dependency lib SnapKit

        let sdk = MessengerTransportSDK(configuration: .init(deploymentId: "", domain: "", logging: true, reconnectionTimeoutInSeconds: 690))
        print(sdk.description)

        print("Hello from FicowPod!") // should see the output in console if this method was called
    }
}
