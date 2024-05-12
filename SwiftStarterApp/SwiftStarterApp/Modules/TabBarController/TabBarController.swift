//
//  TabBarController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/7/23.
//

import UIKit

// MARK: - TabBarController

class TabBarController: UITabBarController {
    // MARK: - Local Enum

    enum Tab: Int {
        case home = 0
        case menu = 1
        case search = 2
        case profile = 3
        case settings = 4
    }

    // MARK: - init

    convenience init(selectedTab: Tab) {
        self.init()
        self.selectedTabIndex = selectedTab
    }

    private var selectedTabIndex: Tab = .home
    private var homeNVC, menuNVC, searchNVC, profilNVC, settingNVC: UINavigationController?

    private let homeButton = UITabBarItem(title: LocalizedKey.Home.localized(), image: UIImage(systemName: "house.fill"), selectedImage: nil)
    private let menuButton = UITabBarItem(title: LocalizedKey.Menu.localized(), image: UIImage(systemName: "line.3.horizontal.circle.fill"), selectedImage: nil)
    private let searchButton = UITabBarItem(title: LocalizedKey.Search.localized(), image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
    private var profileButton = UITabBarItem(title: LocalizedKey.Profile.localized(), image: UIImage(systemName: "person.circle.fill"), selectedImage: nil)
    private let settingButton = UITabBarItem(title: LocalizedKey.Settings.localized(), image: UIImage(systemName: "gearshape.fill"), selectedImage: nil)

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        self.setupTabs()

        self.setRtoLUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = selectedTabIndex.rawValue
    }

    func setupTabs() {
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .red
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .white

       //  self.homeNVC = UINavigationController(rootViewController: UserListViewController.instantiate(appStoryboard: .main))

        self.homeNVC = UINavigationController(rootViewController: HomeViewController.instantiate(appStoryboard: .tabs))
        self.menuNVC = UINavigationController(rootViewController: MenuViewController.instantiate(appStoryboard: .tabs))
        self.searchNVC = UINavigationController(rootViewController: SearchViewController.instantiate(appStoryboard: .tabs))
        self.profilNVC = UINavigationController(rootViewController: ProfileViewController.instantiate(appStoryboard: .tabs))
        self.settingNVC = UINavigationController(rootViewController: SettingsViewController.instantiate(appStoryboard: .tabs))

        homeNVC?.tabBarItem = homeButton
        menuNVC?.tabBarItem = menuButton
        searchNVC?.tabBarItem = searchButton
        profilNVC?.tabBarItem = profileButton
        settingNVC?.tabBarItem = settingButton

        self.setViewControllers([homeNVC!, menuNVC!, searchNVC!, profilNVC!, settingNVC!], animated: false)
    }
    
    private func setRtoLUI() {
        let prefferedLanguage = Localize.currentLanguage()
        if prefferedLanguage == Language.arebic.code {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    private func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers?.firstIndex(of: viewController) ?? 0
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        selectedTabIndex = Tab(rawValue: indexOfViewController(viewController)) ?? .menu
        return true
    }
}
