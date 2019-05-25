//
//  ViewController.swift
//  OnboardingTutorial
//
//  Created by Kanishka on 20/05/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit


var onboard0 = Onboard(image: "swiftImage", title: "Swift is fun", info: "Coding in swift language is really fun. Swift is a protocol-oriented programming language. This language was announced by Apple in 2014 during World wide developer conference. ")

var onboard1 = Onboard(image: "a-person-coding", title: "Used in iOS Development", info: "Swift is mainly using for iOS development. there are lot of libraries and frameworks out there which can be used for iOS Development")

var onboard2 = Onboard(image: "mac-with-code", title: "Still evolving", info: "Swift is still evolving with new feature added to it now and then.")

var onboards = [onboard0, onboard1, onboard2]


class OnboardingController: UIViewController {

    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var nextButton : UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var image : UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StylizingUIElements()
        configureContent(onboard0)
        backButton.isHidden = true
        print(pageControl.currentPage)
}
    
    
    @objc func decrementPage(){
        switch pageControl.currentPage {
        case 0:
            backButton.isHidden = true
        case 1:
             configureContent(onboard0)
            backButton.isHidden = false
            pageControl.currentPage -= 1
        case 2:
            configureContent(onboard1)
            pageControl.currentPage -= 1
        default:
            return
        print(pageControl.currentPage)
    }
    }
    
    @objc func incrementPage(){
    
       let currentPage = pageControl.currentPage
    
        switch currentPage {
        case 0:
            configureContent(onboard1)
            pageControl.currentPage += 1
        case  1:
            configureContent(onboard2)
            pageControl.currentPage += 1
            backButton.isHidden = false
        case 2:
            isLastPage(true)
        default : return
        }
        print(pageControl.currentPage)
    }

    func StylizingUIElements(){
        
        //editing page control
        pageControl.tintColor = .gray
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.numberOfPages = onboards.count
        
        //editing the scroll view
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(3), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
//        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        scrollView.delegate = self as! UIScrollViewDelegate
        
        //editing some properties of images
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        
        //adding target to the button
        nextButton.addTarget(self, action: #selector(incrementPage), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(decrementPage), for: .touchUpInside)
    }

}


extension OnboardingController : UIScrollViewDelegate{
    
    func configureContent(_ data: Onboard){
        image.image = UIImage(named: data.image)
        label.numberOfLines = -1
        let titleColor : UIColor = .black
        let infoColor : UIColor = .gray
        //using NSMutableAttributeString
        let attributeOfTitle : [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 25, weight: .bold),
            .foregroundColor: titleColor]
        
        let attributeOfInfo : [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 23, weight: .semibold),
            .foregroundColor : infoColor ]
        
        let attributedText = NSMutableAttributedString(string: data.title, attributes: attributeOfTitle)
        
        let info = NSAttributedString(string: "\n \n \n \(data.info)", attributes: attributeOfInfo)
        attributedText.append(info)
        
        label.textAlignment = .center
        label.attributedText = attributedText
    }
    
    func isLastPage(_ bool: Bool){
        self.configureContent(onboard2)
        backButton.isHidden = false
        switch bool {
        case true:
               nextButton.addTarget(self, action: #selector(goToMainView), for: .touchUpInside)
                pageControl.currentPage = 2
        case false:
            self.view.addSubview(backButton)
            nextButton.addTarget(self, action: #selector(incrementPage), for: .touchUpInside)
        }
        
    }
    
    @objc func goToMainView(){
        self.performSegue(withIdentifier: "MainController", sender: self)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //the following calculates at what page you are in
        var currentPage = scrollView.contentOffset.x / scrollView.frame.width
        
        switch currentPage {
        case 0:
            configureContent(onboard0)
            backButton.isHidden = true
            pageControl.currentPage = 0
        case 1:
            configureContent(onboard1)
            backButton.isHidden = false
            nextButton.isHidden = false
            pageControl.currentPage =  1
        case 2:
            configureContent(onboard2)
            isLastPage(true)
        default :
            return
        }
    }
}
