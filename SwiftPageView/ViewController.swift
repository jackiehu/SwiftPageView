//
//  ViewController.swift
//  SwiftPageView
//
//  Created by iOS on 2021/3/8.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var pageControl : AdvancedPageControlView = {
        let p = AdvancedPageControlView()
        p.drawer = JumpDrawer()
        p.backgroundColor = .orange
        return p
    }()
    
    lazy var banner: PageView = {
        let banner = PageView()
        banner.dataSource = self
        banner.delegate = self
        banner.automaticSlidingInterval = 3
        banner.registerCell(LabelViewCell.self)
        banner.registerCell(CollectionViewCell.self)
        banner.backgroundColor = .cyan
        banner.interitemSpacing = 10
        banner.itemSize = CGSize(width: 200, height: 100)
        return banner
    }()
    
    
    lazy var codePageControl: JXPageControlJump = {
        let pageControl = JXPageControlJump()
        // JXPageControlType: default property
        pageControl.currentPage = 0
        pageControl.progress = 0.0
        pageControl.hidesForSinglePage = false
        pageControl.inactiveColor = UIColor.white
        pageControl.activeColor = UIColor.red
        pageControl.inactiveSize = CGSize(width: 10, height: 10)
        pageControl.activeSize = CGSize(width: 20, height: 10)
        pageControl.columnSpacing = 10
        pageControl.contentAlignment = JXPageControlAlignment(.center,
                                                              .center)
        pageControl.contentMode = .center
        pageControl.isInactiveHollow = false
        pageControl.isActiveHollow = false
        pageControl.isAnimation  = true

        return pageControl
    }()

    
    var array : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SwiftPageView"
        
        view.addSubview(banner)
        banner.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(100)
            m.left.right.equalToSuperview()
            m.height.equalTo(200)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(300)
            m.left.right.equalToSuperview()
            m.height.equalTo(50)
        }
        
        view.addSubview(codePageControl)
        codePageControl.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(270)
            m.left.right.equalToSuperview()
            m.height.equalTo(30)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.array = ["1","2","3","4","5","6"]
            self.banner.reloadData()
            self.codePageControl.numberOfPages = self.array?.count ?? 0
            self.pageControl.numberOfPages = self.array?.count ?? 0
        }
    }
}

extension ViewController:  PageViewDataSource, PageViewDelegate {
    
    func numberOfItems(in pageView: PageView) -> Int {
        guard let aa = array else {
            return 0
        }
        return aa.count
    }

    func pageView(_ pageView: PageView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row > 1{
            let cell: CollectionViewCell = pageView.dequeueReusableCell(CollectionViewCell.self, indexPath: indexPath)
            
            if let name = array?[indexPath.row] {
                cell.imageView.image = UIImage(named: name)
                cell.titleLab.text = name
            }
            
            cell.imageView.layer.cornerRadius = 10
            
            return cell
        }else{
            
            let cell: LabelViewCell = pageView.dequeueReusableCell(LabelViewCell.self, indexPath: indexPath)
            
            if let name = array?[indexPath.row] {
                cell.titleLab.text = name + "点击跳转到更多样式"
            }

            return cell
        }

    }
    
    func pageView(_ pageView: PageView, didSelectItemAt index: Int) {
        print("点击了\(index)")
        if index == 0 {
            let vc = BasicExampleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if index == 1 {
            let vc = TransformerExampleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func pageView(_ pageView: PageView, didScrollToItemAt index: Int) {
        print("滚动到了\(index)")
    }
    
    func pageViewDidScroll(_ pageView: PageView, scrollProgress: CGFloat) {
        codePageControl.progress = scrollProgress

        pageControl.setPage(Int(scrollProgress))
    }

}

