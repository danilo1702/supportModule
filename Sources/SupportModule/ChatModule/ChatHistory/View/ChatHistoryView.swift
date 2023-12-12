//
//  ChatHistoryView.swift
//
//
//  Created by Danilo Hernandez on 27/11/23.
//

import SwiftUI
import FirebaseAuth

struct ChatHistoryView: AppNavigator {
    
    @State var goToChat: Bool = false
    @StateObject var viewModel = ChatHistoryViewModel()
    @State var toUUID: String = ""
    
    var body: some View {
                NavigationView{
                    ScrollView{
                        VStack {
                            ForEach(viewModel.historyMessages, id: \.uniqueId) { message in
                                VStack{
                                    CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
                                        toUUID =  (message.toUUID ?? "" ==  Auth.auth().currentUser?.uid ? message.fromUUID ?? "" : message.toUUID ?? "")
                                        navigator.pushToView(view: ChatView(toUUID: toUUID))
                                        //goToChat.toggle()
                                        
                                    }
                                }
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                viewModel.gettingChatHistory()
                            }
                        }
                        
//                        NavigationLink(isActive: $goToChat, destination: {
//                            ChatView(toUUID: toUUID)
//                        }, label: {
//                            EmptyView()
//                        })
                        
                        
                }
                }
    }
}

#Preview {
    ChatHistoryView()
}

public protocol AppNavigator: View {
    // In view you want use navigator, the view must be implement [AppNavigator]
    // It should be implement in the main screen
}

// MARK: - Shared value
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
        //viewController.addLogoutButton()
        nav?.pushViewController(viewController, animated: animated ?? true)
    }
    
    public func pushToViewVoucher<T: View>(view: T, animated: Bool? = nil, completion: (() -> ())? = nil) {
        let nav = NavigationManager.getCurrentNavigationController()
        
       let viewController =   UIHostingController(rootView: view)
        
        //viewController.addCloseButton(completion: { completion?() })
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
