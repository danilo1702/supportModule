//
//  ChatViewModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine
import SwiftUI

class ChatViewModel: ObservableObject {
    let dbFirestore = Firestore.firestore()
    var supportInfo: MessageModel
    var toUUID: String
    @Published var messages: [MessageModel] = []
    @Published var count: Int = 0
    
    public init(supportInfo: MessageModel) {
        let fromUUID = Auth.auth().currentUser?.uid
        let toUUID = fromUUID != nil ? fromUUID == supportInfo.fromUUID ? supportInfo.toUUID : supportInfo.fromUUID : ""
        self.supportInfo = supportInfo
        self.toUUID = toUUID
    }
    
    func fetchingMessages() {
        
        
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        
        let reference = dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .order(by: FirebaseConstants.timestamp)
        
        reference.addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, error == nil else { return }
            
            documentSnapshot.documentChanges.forEach { change in
                if change.type == .added {
                    
                
                    if let cm = try? change.document.data(as: MessageModel.self) {
                        self.messages.append(cm)
                        print("Appending chatMessage in Chat")
                    }else {
                        print("Error decoding *//*-/*-*-/-*/-/**-/*-/")
                    }
                }
            }
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }

    func tryThis(text: String) {
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))
        let senderReference = dbFirestore.collection(FirebaseConstants.lastMessages)
           .document("\(fromUUID)")
            .collection(FirebaseConstants.messages)
            .document("\(toUUID)")
        
        let receiverReference = dbFirestore.collection(FirebaseConstants.lastMessages)
           .document("\(toUUID)")
            .collection(FirebaseConstants.messages)
            .document("\(fromUUID)")
        
        let bath = dbFirestore.batch()
        
        bath.setData(["message": text,"fromUUID": "\(fromUUID)" ,"toUUID": "\(toUUID)", "fromName": UIDevice.modelName, "timestamp": date], forDocument: senderReference)
        bath.setData(["message": text,"fromUUID": "\(fromUUID)","toUUID": "\(toUUID)", "fromName": UIDevice.modelName, "timestamp": date], forDocument: receiverReference)
        bath.commit { error in
            if error == nil {
            print("Guardado")
            } else {
                print("error saving \(String(describing: error))")
            }
        }
    }
    
    func sendMessage(message: String) {
        
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))
        let referenceSender = dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .document()
        
        let message = ["message": message, "fromUUID": fromUUID, "toUUID": toUUID, "timestamp": date, "fromName": UIDevice.modelName] as [String: Any]
        referenceSender.setData(message) { error in
            if error != nil {
                print("Errro sending de message ")
                return
            }
        }
        
        let referenceReceiver = dbFirestore.collection(FirebaseConstants.messages)
            .document(toUUID)
            .collection(fromUUID)
            .document()
        referenceReceiver.setData(message) { error in
            if error != nil {
                print("Error saving the message receiver")
                return
            }
            print(message)
        }
        DispatchQueue.main.async {
            self.count += 1
           
            //self.saveLastMessage(toUUID: self.toUUID,fromUUID: fromUUID, message: message)
        }
    }
    
    func saveLastMessage(toUUID: String, fromUUID: String, message: [String: Any]) {
        
        let senderReference = dbFirestore.collection(FirebaseConstants.lastMessages)
           .document(fromUUID)
            .collection(FirebaseConstants.messages)
            .document(toUUID)
            
        
        
      
        let receiverReference = dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(toUUID)
            .collection(FirebaseConstants.messages)
            .document(fromUUID)


        let batch = dbFirestore.batch()
        
        batch.setData(message, forDocument: senderReference)
        batch.setData(message, forDocument: receiverReference)
        
       
        batch.commit { error in
            if let error = error {
                print("Error saving last message: \(error.localizedDescription)")
            } else {
                print("Last message saved successfully")
            }
        }


    }
}



public protocol AppNavigator: View {
    // In view you want use navigator, the view must be implement [AppNavigator]
    // It should be implement in the main screen
}
extension AppNavigator {
    public var navigator: NavigationManager {
        return NavigationManager.shared
    }
}

extension EnvironmentValues {
    public var navigator: NavigationManager {
        return NavigationManager.shared
    }
}

// MARK: - Enum
public enum PopPositionType {
    case first, last
}

// MARK: - Router Manager
public struct NavigationManager {
    fileprivate static let shared = NavigationManager()
    
    private init() {}
    
    var navigation: UINavigationController? {
        NavigationManager.getCurrentNavigationController()
    }
    
    public func changeRootView<T: View>(rootView: T, setNavigation: Bool = false) {
        let windows = UIApplication.shared.currentKeyWindow
        if setNavigation {
            windows?.rootViewController = UINavigationController(rootViewController: UIHostingController(rootView: rootView))
        }else{
            windows?.rootViewController = UIHostingController(rootView: rootView)
        }
        windows?.makeKeyAndVisible()
    }
      
    public func presentView<T: View>(view: T, transitionStyle: UIModalTransitionStyle? = nil, presentStyle: UIModalPresentationStyle? = nil, animated: Bool? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        let controller = UIHostingController(rootView: view)
        controller.modalTransitionStyle = transitionStyle ?? .coverVertical
        controller.modalPresentationStyle = presentStyle ?? .fullScreen
        nav?.present(controller, animated: animated ?? true, completion: nil)
    }
    
    public func pushToView<T: View>(view: T, animated: Bool? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.backButtonTitle = ""
        nav?.pushViewController(viewController, animated: animated ?? true)
    }
    
    public func pushToViewVoucher<T: View>(view: T, animated: Bool? = nil, completion: (() -> ())? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        
       let viewController =   UIHostingController(rootView: view)
        
        
        nav?.pushViewController(viewController, animated: animated ?? true)
    }
    
    public func pop(animated: Bool? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        nav?.popViewController(animated: animated ?? true)
    }
    
    public func dismiss(animated: Bool? = nil, completion: (() -> Void)? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        nav?.dismiss(animated: animated ?? true, completion: completion)
    }
    
    public func popToView<T: View>(_ typeOfView: T.Type, animated: Bool? = nil, inPosition: PopPositionType? = .last) {
        let nav = NavigationManager.getCurrentNavigationController()
        
        switch inPosition {
        case .last:
            if let vc = nav?.viewControllers.last(where: { $0 is UIHostingController<T> }) {
                nav?.popToViewController(vc, animated: animated ?? true)
            }
        case .first:
            if let vc = nav?.viewControllers.first(where: { $0 is UIHostingController<T> }) {
                nav?.popToViewController(vc, animated: animated ?? true)
            }
        default:
            break
        }
    }
    
    public func popToView(_ view: Int) {
        let nav = NavigationManager.getCurrentNavigationController()
        let viewControllers: [UIViewController] = nav?.viewControllers as? [UIViewController] ?? []
        nav?.popToViewController(viewControllers[viewControllers.count - view], animated: true)
    }
    
    public func popToviewClass(ofClass: AnyClass, animated: Bool = true) {
        let nav = NavigationManager.getCurrentNavigationController()
        if let vc = nav?.viewControllers.last(where: { $0.isKind(of: ofClass)  }) {
            nav?.popToViewController(vc, animated: animated)
        }
    }
    
    public func popToRootView(animated: Bool? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        nav?.popToRootViewController(animated: animated ?? true)
    }
    
    private static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
          return nil
        }

        if let navigationController = viewController as? UINavigationController {
          return navigationController
        }

        for childViewController in viewController.children {
          return findNavigationController(viewController: childViewController)
        }

        return nil
    }
    
    private static func getCurrentNavigationController() -> UINavigationController? {
        let _ = findNavigationController(viewController: UIApplication.shared.currentKeyWindow?.rootViewController)
        return UIApplication.getTopViewController()?.navigationController
    }
}



extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.currentKeyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
