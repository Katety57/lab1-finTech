//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by  User on 16.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    // MARK: - Core Data Persistent Conatainer
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "TinkoffChat")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
}
