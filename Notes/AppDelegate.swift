//
//  AppDelegate.swift
//  Notes
//
//  Created by andrey on 2019-07-03.
//  Copyright © 2019 andrey. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dbName: String = "DBNote"
    var container: NSPersistentContainer!

    func createContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: dbName)
        container.loadPersistentStores(completionHandler: {_, error in
            guard error == nil else {
                fatalError("Failed to load store")
            }
            DispatchQueue.main.async { completion(container) }
        })
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        /*let log = Log()
        log.info("Application launched.")

        #if DEBUG
            log.debug("Debug information output.")
        #elseif DARKMODE
            log.info("Launched in dark mode.")
        #endif*/


        let mainController = UITabBarController()

        createContainer { container in
            self.container = container
            let noteListViewController = NoteListViewController(/*dbNoteContainer: container*/)
            let notesNavController = UINavigationController(rootViewController: noteListViewController)
            let galleryViewController = GalleryViewController()
            let galleryNavController = UINavigationController(rootViewController: galleryViewController)

            let notePresenter = NotePresenter(dbNoteContainer: container)
            noteListViewController.notePresenter = notePresenter
            
            notesNavController.tabBarItem = UITabBarItem(
                title: "Notes",
                image: UIImage(named: "tab_bar_icon/icon_note"),
                selectedImage: nil
            )
            galleryNavController.tabBarItem = UITabBarItem(
                title: "Gallery",
                image: UIImage(named: "tab_bar_icon/icon_photo"),
                selectedImage: nil
            )
            mainController.viewControllers = [notesNavController, galleryNavController]
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

