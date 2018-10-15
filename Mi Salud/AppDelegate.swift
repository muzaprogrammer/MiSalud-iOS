//
//  AppDelegate.swift
//  Mi Salud
//
//  Created by ITMED on 6/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let URLs : Uris = Uris()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var objUsuario : Usuario!
        if(UsuariosEntity.shared.queryCount()! > 0){
            if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
            {
                for eachuser in usuarios{
                    objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
                }
            }
            
            let postString = "email=\(objUsuario.correoElectronico ?? "")&password=\(objUsuario.contrasenia ?? "")"
            let url = URL(string: URLs.url_validar_usuario())!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"//
            request.httpBody = postString.data(using: .utf8)
            
            var done = false
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("solicitud fallida \(String(describing: error))")//manejamos el error
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Usuario.self, from: data)
                    DispatchQueue.main.async {
                        if(response.mensaje == "success"){
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
                            let mainMenuController = storyboard.instantiateViewController(withIdentifier: "MainMenuNavigation")
                            self.window?.rootViewController = mainMenuController
                            self.window?.makeKeyAndVisible()
                        }else{
                            UsuariosEntity.shared.deleteUsuarios()
                        }
                    }
                } catch let parseError {
                    //handle error
                    print("error parsing: \(parseError)")
                    let responseString = String(data: data, encoding: .utf8)
                    print("response : \(String(describing: responseString))")
                    UsuariosEntity.shared.deleteUsuarios()
                }
                done = true
            }
            task.resume()
            
            repeat{
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
            }while !done
        }
        // Override point for customization after application launch.
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

