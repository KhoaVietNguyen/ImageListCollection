//
//  PageViewController.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 14/6/24.
//

import Foundation
import UIKit

protocol CustomPageViewControllerDelegate: AnyObject {
    func pageViewController(pageViewController: CustomPageViewController, didUpdatePageIndex index: Int)
}

class CustomPageViewController: UIPageViewController {
    weak var customDelegate: CustomPageViewControllerDelegate?
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let initialViewController = controllers.first {
            scrollToViewController(viewController: initialViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = controllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    
    private func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
           let index = controllers.firstIndex(of: firstViewController) {
            customDelegate?.pageViewController(pageViewController: self, didUpdatePageIndex: index)
        }
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { _ in
                            self.notifyTutorialDelegateOfNewIndex()
                           })
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = controllerIndex - 1
        if previousIndex >= 0 {
            return controllers[previousIndex]
        }
        return nil
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = controllerIndex + 1
        if nextIndex < controllers.count {
            return controllers[nextIndex]
        }
        return nil
    }
}

extension CustomPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController,
                            didFinishAnimating _: Bool,
                            previousViewControllers _: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
        if !completed { return }
        DispatchQueue.main.async(execute: {
            self.dataSource = nil
            self.dataSource = self
        })
    }
}
