import UIKit

class AlignedLeftFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        let sectionsToAdd = NSMutableIndexSet()
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        var leftMargin : CGFloat = 0.0
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                let referenceAttributesSet = layoutAttributesSet
                
                if (referenceAttributesSet.frame.origin.x == self.sectionInset.left) {
                    leftMargin = self.sectionInset.left
                }
                else {
                    var newLeftAlignedFrame = referenceAttributesSet.frame
                    newLeftAlignedFrame.origin.x = leftMargin
                    referenceAttributesSet.frame = newLeftAlignedFrame
                }
                
                leftMargin += referenceAttributesSet.frame.size.width + 10
                newLayoutAttributes.append(referenceAttributesSet)
                
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
                
            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
            }
        }
        
        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)
            
            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                newLayoutAttributes.append(sectionAttributes)
            }
        }
        
        return newLayoutAttributes
    }
}
