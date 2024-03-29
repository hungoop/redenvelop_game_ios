//
//  UploadImageViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/1/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class UploadImageViewController: BaseViewController {
    
    private func setMarginStackView(sView:UIView, top:CGFloat, left:CGFloat, bottom:CGFloat, right:CGFloat) {
        if #available(iOS 11.0, *) {
            sView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: top,
                                                                     leading: left,
                                                                     bottom: bottom,
                                                                     trailing: right)
        } else {
            
            sView.layoutMargins = UIEdgeInsets(top: top,
                                               left: left,
                                               bottom: bottom,
                                               right: right);
        }
        
        if (sView is UIStackView){
            (sView as! UIStackView).isLayoutMarginsRelativeArrangement = true
        }
        
    }
    
    enum Constants {
        static let imageSize: CGFloat = 500
    }
    
    
    @IBOutlet weak var contraintAvatartDefHolder: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var galaryButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var usernoLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var avatarDefHolder: UIStackView!
    
    
    private func getStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        //view.distribution =  UIStackView.Distribution.//.fill
        view.distribution =  UIStackView.Distribution.equalSpacing
        return view
    }
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker =  UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private var uploadImage: UIImage? = nil
    var didUploadImage: (UIImage)->Void = {_ in}
    
    init() {
        super.init(nibName: "UploadImageViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateViews()
        
        //avatarDefHolder.addSubview(containerStackView)
        avatarDefHolder.translatesAutoresizingMaskIntoConstraints = false
        //avatarDefHolder.axis = .horizontal
        initAvatarDef()
    }
    
    func initAvatarDef() {
        
        let stackView1 = getStackView()
        avatarDefHolder.addSubview(stackView1)

        //let itemHeight = view.frame.width / 6
        
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: avatarDefHolder.topAnchor),
            stackView1.leftAnchor.constraint(equalTo: avatarDefHolder.leftAnchor),
            stackView1.rightAnchor.constraint(equalTo: avatarDefHolder.rightAnchor),
            stackView1.heightAnchor.constraint(equalToConstant: CONST_GUI.heightAvatarDef())
        ])
        
        setMarginStackView(sView: stackView1, top: CONST_GUI.marginLRAvatarDef(), left: CONST_GUI.marginLRAvatarDef(), bottom: CONST_GUI.marginTopBottonLobby(), right: CONST_GUI.marginLRAvatarDef())
        
        for i in 1...5 {
            let nameImg:String = "avatar_def_\(i)"
            let image = UIImageView().forAutolayout()
            image.image = UIImage(named: nameImg)
            image.contentMode = .scaleAspectFit
            
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: CONST_GUI.heightAvatarDef() - 20),
                //image.heightAnchor.constraint(equalTo: image.widthAnchor)
            ])
            
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping(recognizer:)))
            singleTap.numberOfTapsRequired = 1
            
            image.addGestureRecognizer(singleTap)
            image.isUserInteractionEnabled = true
            
            stackView1.addArrangedSubview(image)
        }
        
        avatarDefHolder.addSubview(stackView1)
        
        let stackView2 = getStackView()
        avatarDefHolder.addSubview(stackView2)
        
        NSLayoutConstraint.activate([
            stackView2.leftAnchor.constraint(equalTo: avatarDefHolder.leftAnchor),
            stackView2.rightAnchor.constraint(equalTo: avatarDefHolder.rightAnchor),
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor),
            stackView2.heightAnchor.constraint(equalToConstant: CONST_GUI.heightAvatarDef()),
        ])
        
        setMarginStackView(sView: stackView2, top: CONST_GUI.marginTopBottonLobby(), left: CONST_GUI.marginLRAvatarDef(), bottom: CONST_GUI.marginLRAvatarDef(), right: CONST_GUI.marginLRAvatarDef())
        
        for i in 6...10 {
            let nameImg:String = "avatar_def_\(i)"
            let image = UIImageView().forAutolayout()
            image.image = UIImage(named: nameImg)
            image.contentMode = .scaleAspectFit
            
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: CONST_GUI.heightAvatarDef() - 20)
                //image.heightAnchor.constraint(equalToConstant: itemHeight - 20)
            ])
            
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping(recognizer:)))
            singleTap.numberOfTapsRequired = 1
            
            image.addGestureRecognizer(singleTap)
            image.isUserInteractionEnabled = true
            
            stackView2.addArrangedSubview(image)
        }
        
        contraintAvatartDefHolder.constant = CONST_GUI.heightAvatarDef() * 2
        
        print("----- \(CONST_GUI.heightAvatarDef()) -----")
        
    }
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        print("image clicked \(recognizer)")

        avatarImageView.image = (recognizer.view as? UIImageView)?.image
        uploadImage = (recognizer.view as? UIImageView)?.image
    }
    
    func setupViews (){
        setTitle(title: "个人资料图片")
        
        cameraButton.imageView?.contentMode = .scaleAspectFit
        galaryButton.imageView?.contentMode = .scaleAspectFit
        
        //backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        
        confirmButton.rounded()
        exitButton.rounded()
        exitButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    }
    
    func updateViews(){
        guard let userno = RedEnvelopComponent.shared.userno else { return }
        usernoLabel.text = userno
        
        if let imgString = ImageManager.shared.getImage(userno: userno) {
            if let data = Data(base64Encoded: imgString, options: []) {
                avatarImageView.image = UIImage(data: data)
            }
        } else {
            guard let user = RedEnvelopComponent.shared.user else { return }
            UserAPIClient.getUserImages(ticket: user.ticket, usernos: [userno]) {[weak self] (data, _) in
                guard let _data = data else { return }
                for json in _data {
                    let userno = json["userno"].stringValue
                    let imgString = json["img"].stringValue
                    if let data = Data(base64Encoded: imgString, options: []) {
                        self?.avatarImageView.image = UIImage(data: data)
                        ImageManager.shared.saveImage(userno: userno, image: imgString)
                    }
                }
            }
            
        }
        
    }
    
    override func backPressed(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        super.backPressed(sender)
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func galaryPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func confirmPressed(_ sender: Any) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        guard let userno = RedEnvelopComponent.shared.userno else { return }
        guard let image = uploadImage else { return }
        
        guard let resizedImage = resizeImage(image: image, targetSize: CGSize(width: Constants.imageSize, height: Constants.imageSize)) else {return}
        
        let imageBase64 = ImageManager.convertImageToBase64(image: resizedImage)
        showLoadingView()
        UserAPIClient.uploadImage(ticket: user.ticket, userno: userno, img: imageBase64) { [weak self] (success, error) in
            self?.hideLoadingView()
            if success {
                ImageManager.shared.saveImage(userno: userno, image: imageBase64)
                self?.didUploadImage(resizedImage)
                self?.dismiss(animated: true, completion: nil)
            }else {
                if let message = error {
                    self?.showAlertMessage(message: message)
                }
            }
        }
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UploadImageViewController {
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
extension UploadImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        if let editImage = info[.editedImage] as? UIImage{
            uploadImage = editImage
        }else {
            uploadImage = info[.originalImage] as? UIImage
        }
        avatarImageView.image = uploadImage
    }
}



