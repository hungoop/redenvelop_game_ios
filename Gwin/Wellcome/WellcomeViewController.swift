//
//  WellcomeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class WellcomeViewController: BaseViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle(title: AppText.Titles.wellcome)
        hideBackButton()
        setupViews()
        
        getAppVresion()
    }
    
    func checkAndAutoLogin() {
        if UserDefaultManager.sharedInstance().autoLogin() {
            guard let userno = UserDefaultManager.sharedInstance().loginInfoUserName() else {return}
            guard let password = UserDefaultManager.sharedInstance().loginInfoPassword() else {return}
            
            showLoadingView()
            UserAPIClient.login(accountNo: userno, password: password) {[weak self] (user, message) in
                guard let `this` = self else { return }
                this.hideLoadingView()
                if let `user` = user {
                    RedEnvelopComponent.shared.userno = userno
                    RedEnvelopComponent.shared.user = user
                    if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.setHomeAsRootViewControlelr()
                    }
                }
            }
        }
    }
    
    func getAppVresion() {
        UserAPIClient.appVersion(ticket: "") { (newVersion, urlDownload) in
            RedEnvelopComponent.shared.newVersion = newVersion
            RedEnvelopComponent.shared.urlDownload = urlDownload
            
            guard let urlDownload = urlDownload, let newVersion = newVersion else { return }
            
            print("newVersion : \(newVersion) - urlDownload \(urlDownload)")
            
            if(self.isUpdateNewversion()){
                //update new
                let appURLDownload = "itms-services://?action=download-manifest&url=\(urlDownload)"
                self.showAppUpdateAlert(force: true, appURL: appURLDownload)
            } else{
                self.checkAndAutoLogin()
            }
            
        }
    }
    
    func isUpdateNewversion() -> Bool {
        guard let versionCode = RedEnvelopComponent.shared.newVersion else {
            return false
        }
        
        if let currAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if versionCode.compare(currAppVersion, options: .numeric) == .orderedDescending {
                print("\(versionCode) server version is newer \(currAppVersion)")
                
                return true
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupViews() {
        loginButton.rounded()
        loginButton.applyGradient(withColours: [UIColor(hexString: "D7566A"), UIColor(hexString: "e75f48")], gradientOrientation: .horizontal)
        registerButton.rounded()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let router = LoginBuilder().build(withListener: nil)
        self.navigationController?.pushViewController(router.viewController, animated: true)
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: .main)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc fileprivate func showAppUpdateAlert(force: Bool, appURL: String) {
        let alertController = UIAlertController(title: "新版本",
                                                message: "你想更换新版本吗?",
                                                preferredStyle: .alert)
        
        if !force {
            let notNowButton = UIAlertAction(title: "取消", style: .default)
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "确认", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: appURL) else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            
            let delaySeconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
                exit(0);
            }
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}

