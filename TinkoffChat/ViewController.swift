//
//  ViewController.swift
//  TinkoffChat
//
//  Created by  User on 16.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var turnOffLog: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        turnOffLog = delegate.turnOffLog
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if turnOffLog == false {
            print("View is from <Disappeared> or <Disappearing> to <Appearing>: \(#function)\n")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if turnOffLog == false {
            print("View is from <Appearing> to <Appeared>: \(#function)\n")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if turnOffLog == false {
            print("View is from <Appearing> to <Appeared>, goes between <viewWillAppear> and <viewDidAppear>: \(#function)\n")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if turnOffLog == false {
            print("View is from <Appearing> to <Appeared>, goes between <viewWillAppear> and <viewDidAppear>: \(#function)\n")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if turnOffLog == false {
            print("View is from <Appearing> or <Appeared> to <Disappearing>: \(#function)\n")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if turnOffLog == false {
            print("View is from <Disappearing> to <Disappeared>: \(#function)\n")
        }
    }


}

