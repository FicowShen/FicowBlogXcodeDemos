import UIKit
import SnapKit

public class FicowPodEntry {

    public static func hello() {
        let demoView = UIView()
        demoView.snp.makeConstraints { $0.size.equalTo(1) } // use dependency lib SnapKit
        print("Hello from FicowPod!") // should see the output in console if this method was called
    }
}
