//
//  ViewController.swift
//  peeking-cards
//
//  Created by Burhan Shakir on 15/09/2020.
//  Copyright © 2020 Burhan Shakir. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "card-cell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CardsCollectionFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }


}

