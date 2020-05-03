//
//  RegionCollectionViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/08.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol RegionCollectionViewCellDelegate: class {
    func didTapRegionButton(cell: RegionCollectionViewCell)
}

class RegionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var regionButton: UIButton!
    @IBAction func didTapRegionButton(_ sender: Any) {
        delegate?.didTapRegionButton(cell: self)
    }
    
    weak var delegate: RegionCollectionViewCellDelegate?
    
    var model: RegionViewModel! {
        didSet {
            regionButton.setTitle(model.region, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.regionButton.layer.cornerRadius = 10
    }

}
