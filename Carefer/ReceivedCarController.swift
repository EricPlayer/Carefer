//
//  ReceivedCarController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/3/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit

class ReceivedCarController : MoveShopReceiveCarBaseController
{
    @IBOutlet weak var problemTextView : UITextView!
    @IBOutlet weak var problemContainer : UIView!
    
    override var isMovedShop: Bool {
        get {
            return false;
        }
    }
    
    override var textFields: [UITextField] {
        return super.textFields;
    }
    
    override var parameters: [String : Any] {
        get {
            var params = [String : Any]();
            params["orderServiceType"] = "receivedCar";
            params["comment"] = self.problemTextView.text ?? "";
            self.addCommonParameters(params: &params);
            return params;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.getDescription(url: Constants.kGetReceivedCarDescriptionUrl);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "ReceivedCar Screen")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    override func updateAppearance()
    {
        super.updateAppearance();
        self.problemContainer.backgroundColor = UIColor.clear;
        self.problemTextView.backgroundColor = UIColor.clear;
        //self.problemTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        self.updateAllTextFieldsAppearance();
        self.updateTextViewApparance();
    }
    
    func updateTextViewApparance()
    {
        self.problemTextView.layer.cornerRadius = 3.0;
        self.problemTextView.layer.borderWidth = 1.0;
        if self.problemTextView.isFirstResponder {
            self.problemTextView.layer.borderColor = UIColor.orange.cgColor;
        } else {
            self.problemTextView.layer.borderColor = UIColor.lightGray.cgColor;
        }
    }
    
    override func keyboardWillShowNotificaiton(notification: NSNotification) {
        super.keyboardWillShowNotificaiton(notification: notification);
        if self.view.frame.width == 320 {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true);
        } else {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true);
        }
    }
    
    override func resignTextField()
    {
        super.resignTextField();
        if self.problemTextView.isFirstResponder {
            problemTextView.resignFirstResponder();
            if let insets = self.contentInsets {
                self.scrollView.contentInset = insets;
            }
        }
    }
    
    override func didSelectModle(modle: PopupModle) {
        super.didSelectModle(modle: modle);
        updateOrderButtonState();
    }
    
    override func didSelectBrand(brand: PopupModle) {
        super.didSelectBrand(brand: brand);
        updateOrderButtonState();
    }
    
    func updateOrderButtonState()
    {
        let description = self.problemTextView.text;
        if let _ = self.carBrand, let _ = self.carModle, let comment = description, comment.characters.count > -1 {
            self.orderButton.isEnabled = true;
            self.orderButton.isSelected = true;
        } else {
            self.orderButton.isEnabled = false;
            self.orderButton.isSelected = false;
        }
    }
}

extension ReceivedCarController : UITextViewDelegate
{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true;
    }
    
    func textView(textView: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.updateOrderButtonState();
        return true;
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        self.updateOrderButtonState();
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.updateTextViewApparance();
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.updateTextViewApparance();
        }
    }
}
