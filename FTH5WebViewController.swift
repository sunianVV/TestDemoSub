//
//  FTH5WebViewController.swift
//  FaceTalk
//
//  Created by WSN on 2021/10/9.
//

import UIKit

class FTH5WebViewController: H5WebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        options.showTitleBar = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        options.gestureBack = false

        if (navigationController?.responds(to: #selector(getter: navigationController?.interactivePopGestureRecognizer))) != nil {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

//        if self.navigationController?.responds(to: #selector(interactivePopGestureRecognizer)) {
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
//        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
}
