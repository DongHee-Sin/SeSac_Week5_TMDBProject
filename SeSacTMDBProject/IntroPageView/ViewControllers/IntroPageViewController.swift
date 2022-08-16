//
//  IntroPageViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/16.
//

import UIKit

class IntroPageViewController: UIPageViewController {

    // ViewController List
    var pageViewControllerList: [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        
        configureInitialUI()
    }
    
    
    func configureInitialUI() {
        self.delegate = self
        self.dataSource = self
        
        guard let firstVC = pageViewControllerList.first else { return }
        self.setViewControllers([firstVC], direction: .forward, animated: true)
    }
    

    func createPageViewController() {
        guard let vc1 = storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController else { return }
        guard let vc2 = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
        guard let vc3 = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController else { return }
        
        pageViewControllerList = [vc1, vc2, vc3]
    }
}



extension IntroPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // 현재 Page 기준, 앞에 오는 VC 반환 (nil을 반환하면 스크롤 불가)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewcontrollerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewcontrollerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    
    // 현재 Page 기준, 뒤에 오는 VC 반환 (nil을 반환하면 스크롤 불가)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewcontrollerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewcontrollerIndex + 1
        
        return nextIndex < pageViewControllerList.count ? pageViewControllerList[nextIndex] : nil
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = self.viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        
        return index
    }
    
}
