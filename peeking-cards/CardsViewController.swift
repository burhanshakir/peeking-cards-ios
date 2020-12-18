//
//  CardsViewController.swift
//  peeking-cards
//
//  Created by Burhan Shakir on 15/09/2020.
//  Copyright © 2020 Burhan Shakir. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "card-cell"
    private let noOfCards = 3
    
    private var currentSelectedIndex = 0 {
        didSet {
            updateSelectedCardIndicator()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CardsCollectionFlowLayout()
        
        showIndicatorView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if currentSelectedIndex == indexPath.row {
            cell.transformToLarge()
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentCell = collectionView.cellForItem(at: IndexPath(row: Int(currentSelectedIndex), section: 0))
        currentCell?.transformToStandard()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard scrollView == collectionView else {
            return
        }
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        let flowLayout = collectionView.collectionViewLayout as! CardsCollectionFlowLayout
        let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let horizontalVelocity = velocity.x
        
        var selectedIndex = currentSelectedIndex
        
        switch horizontalVelocity {
        // On swiping
        case _ where horizontalVelocity > 0 :
            selectedIndex = currentSelectedIndex + 1
        case _ where horizontalVelocity < 0:
            selectedIndex = currentSelectedIndex - 1
            
        // On dragging
        case _ where horizontalVelocity == 0:
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            
            selectedIndex = Int(roundedIndex)
        default:
            print("Incorrect velocity for collection view")
        }
        
        let safeIndex = max(0, min(selectedIndex, noOfCards - 1))
        let selectedIndexPath = IndexPath(row: safeIndex, section: 0)
        
        flowLayout.collectionView!.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        
        let previousSelectedIndex = IndexPath(row: Int(currentSelectedIndex), section: 0)
        let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndex)
        let nextSelectedCell = collectionView.cellForItem(at: selectedIndexPath)
        
        currentSelectedIndex = selectedIndexPath.row
        
        previousSelectedCell?.transformToStandard()
        nextSelectedCell?.transformToLarge()
    }
    
    func showIndicatorView() {
        
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0..<noOfCards {
            let dot = UIImageView(image: UIImage(systemName: "circle.fill"))
            
            dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
            dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
            dot.image = dot.image!.withRenderingMode(.alwaysTemplate)
            dot.tintColor = UIColor.lightGray
            dot.tag = index + 1
            
            if index == currentSelectedIndex {
                dot.tintColor = UIColor.darkGray
            }
            stackView.addArrangedSubview(dot)
        }
        
        indicatorView.subviews.forEach({ $0.removeFromSuperview() })
        indicatorView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor).isActive = true
    }
    
    func updateSelectedCardIndicator() {
        for index in 0...noOfCards - 1 {
            let selectedIndicator: UIImageView? = indicatorView.viewWithTag(index + 1) as? UIImageView
            selectedIndicator?.tintColor = index == currentSelectedIndex ? UIColor.darkGray: UIColor.lightGray
        }
    }
    
}

extension UICollectionViewCell {
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func transformToStandard() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
    
}
