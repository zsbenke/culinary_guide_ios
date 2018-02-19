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
                let rightMargin = leftMargin + referenceAttributesSet.frame.width
                
                if referenceAttributesSet.frame.origin.x == self.sectionInset.left ||
                   rightMargin > (UIScreen.main.bounds.width - self.sectionInset.right) {
                    leftMargin = self.sectionInset.left
                    referenceAttributesSet.frame.origin.x = self.sectionInset.left
                } else {
                    var newLeftAlignedFrame = referenceAttributesSet.frame
                    newLeftAlignedFrame.origin.x = leftMargin
                    referenceAttributesSet.frame = newLeftAlignedFrame
                }

                leftMargin += referenceAttributesSet.frame.size.width + 16
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
