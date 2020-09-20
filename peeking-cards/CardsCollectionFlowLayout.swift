//
//  CardsCollectionFlowLayout.swift
//  peeking-cards
//
//  Created by Burhan Shakir on 20/09/2020.
//  Copyright © 2020 Burhan Shakir. All rights reserved.
//

import UIKit

class CardsCollectionFlowLayout: UICollectionViewFlowLayout {
    private let itemHeight = 150
    private let itemWidth = 225
    
    // The is called to tell the collection view layout object to update the current layout.
    // Layout updates occur the first time the collection view presents its content and whenever the layout is invalidated.

    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let peekingItemWidth = itemSize.width / 10
        let horizontalInsets = (collectionView.frame.size.width - itemSize.width) / 2
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
        minimumLineSpacing = horizontalInsets - peekingItemWidth
    }
    
}
