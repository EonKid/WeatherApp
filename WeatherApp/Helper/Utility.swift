//
//  Utility.swift
//  attpioneers_native_ios
//
//  Created by Narayan Singh, Dhruv on 01/03/20.
//  Copyright © 2020 Narayan Singh, Dhruv. All rights reserved.
//

import UIKit



class Utility: NSObject {
    
    //Singleton class
    //MARK: - Properties
    static let shared = Utility()
        
    private override init() {
        debugPrint("Utility - init")
    }
    
    var appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    var appColor  = UIColor(red: 78/255.0, green: 172/255.0, blue: 227/255.0, alpha: 1)
    let reachability = try! Reachability()
    
    func saveToUserDefault(_ key: String, _ value: String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getObjectFromUserDefault(_ key: String) -> String?{
        return UserDefaults.standard.string(forKey: key)
    }
    
    func displayStatusCodeAlert(_ userMessage: String){
        let alertController = UIAlertController (title: "", message: userMessage, preferredStyle: .alert)

           
            let cancelAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(cancelAction)
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow!.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func getUIStoryBoard(name: String) -> UIStoryboard{
        return UIStoryboard.init(name: name, bundle: nil)
    }
    
    func showActivityIndicator(){
       
    }
    
    func closeActivityIndicator(){
       
    }
    

    
    
    func isReachable() -> Bool{
        var isConnected = false
        
        do {
            let reachability = try! Reachability()
            if reachability.isReachable {
                isConnected = true
            }else{
                isConnected = false
            }
        } catch {
            print("Unable to start notifier")
        }
        debugPrint("connection status: \(isConnected)")
        return isConnected
    }
    

    func openSettingApp(){
        let alertController = UIAlertController (title: "Please check your internet connection", message: "Go to Settings?", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        debugPrint("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow!.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        debugPrint("Utility - deinit")
    }
    
}
