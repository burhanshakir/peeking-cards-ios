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
    private var currentSelectedIndex = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CardsCollectionFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        let flowLayout = collectionView.collectionViewLayout as! CardsCollectionFlowLayout
        let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let selectedIndex = round((offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing)
        let selectedIndexPath = IndexPath(row: Int(selectedIndex), section: 0)
        
        flowLayout.collectionView!.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        
        if currentSelectedIndex != selectedIndexPath.row {
            let previousSelectedIndex = IndexPath(row: Int(currentSelectedIndex), section: 0)
            let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndex)
            let nextSelectedCell = collectionView.cellForItem(at: selectedIndexPath)
            
            currentSelectedIndex = selectedIndexPath.row
            
            previousSelectedCell?.transformToStandard()
            nextSelectedCell?.transformToLarge()
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
