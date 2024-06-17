//
//  ImageViewController.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import UIKit

class ImageViewController: UIViewController, CustomPageViewControllerDelegate {
    
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnReload: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    var viewModel = ImageViewModel()
    
    private var pageViewController: CustomPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        self.configPageView()
    }
    
    private func configPageView() {
        pageViewController = CustomPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.customDelegate = self
        
        for i in 0 ..< self.viewModel.pageNumber {
            let vc = PageViewController()
            vc.data = self.viewModel.arrImagePerPage[i]
            pageViewController.controllers.append(vc)
        }
        
        self.pageView.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leadingAnchor.constraint(equalTo: self.pageView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: self.pageView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: self.btnReload.bottomAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: self.pageView.bottomAnchor).isActive = true
    }
    
    func setupUI(){
        // setup activityIndicator...
        self.activityIndicator.color = .systemBlue
        self.view.addSubview(self.activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.activityIndicator.backgroundColor = .black.withAlphaComponent(0.6)
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        //let rows = Int(floor((self.pageView.frame.height - Int.totalHorizontalSpacing) / (self.pageView.frame.width / CGFloat(Int.PAGE_COLUMN))))
        //Int.PAGE_MAX_COUNT = rows * .PAGE_COLUMN
        self.pageControl.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
    }
    
    func setupData(){
        self.viewModel.mockDataDefault()
        self.viewModel.parseImageDatePerPage()
        self.pageControl.numberOfPages = self.viewModel.pageNumber
    }
    
    func pageViewController(pageViewController: CustomPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    @IBAction func actionPageController(_ sender: UIPageControl) {
        let page: Int = sender.currentPage
        self.pageViewController.setViewControllers([self.pageViewController.controllers[page]], direction: .forward, animated: false, completion: nil)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        self.viewModel.addNewData()
        if self.pageViewController.controllers.count < self.viewModel.pageNumber {
            //add new page
            let vc = PageViewController()
            vc.data = self.viewModel.arrImagePerPage.last!
            self.pageViewController.controllers.append(vc)
            self.pageViewController.setViewControllers([self.pageViewController.controllers.last!], direction: .forward, animated: true, completion: nil)
        } else {
            //add new item
            if self.viewModel.pageNumber - 1 > self.pageControl.currentPage {
                self.btnAdd.isUserInteractionEnabled = false
                self.pageViewController.setViewControllers([self.pageViewController.controllers.last!], direction: .forward, animated: true, completion: { _ in
                    let vcPage : PageViewController = self.pageViewController.controllers.last! as! PageViewController
                    vcPage.data = self.viewModel.arrImagePerPage.last!
                    self.btnAdd.isUserInteractionEnabled = true
                })
            } else {
                let vcPage : PageViewController = self.pageViewController.controllers.last! as! PageViewController
                vcPage.data = self.viewModel.arrImagePerPage.last!
            }
        }
        self.pageControl.numberOfPages = self.viewModel.pageNumber
        self.pageControl.currentPage = self.viewModel.pageNumber - 1
    }
        
    @IBAction func actionReloadAll(_ sender: Any) {
        self.viewModel.clearMockData()
        self.viewModel.mockDataDefault()
        self.pageViewController.controllers.removeAll()
        self.pageViewController.setViewControllers([UIViewController()], direction: .forward, animated: true, completion: nil)
        self.activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.pageViewController.controllers.removeAll()
            self.viewModel.parseImageDatePerPage()
            for i in 0 ..< self.viewModel.pageNumber {
                let vc = PageViewController()
                vc.data = self.viewModel.arrImagePerPage[i]
                self.pageViewController.controllers.append(vc)
            }
            
            self.pageViewController.setViewControllers([self.pageViewController.controllers.first!], direction: .forward, animated: true, completion: { _ in
                self.activityIndicator.stopAnimating()
                self.pageControl.numberOfPages = self.viewModel.pageNumber
                self.pageControl.currentPage = 0
            })
        }
    }
}

