import MapKit

extension MKMapView {
    func setDefaultMapRect(byUnioningUserLocation unionUserLocation: Bool = false, edgePadding: UIEdgeInsets, animated: Bool = false) {
        var zoomRect: MKMapRect = MKMapRectNull

        let pointRectWidth: Double = 25000.0
        let pointRectHeight = pointRectWidth

        for annotation in annotations {
            if !unionUserLocation && annotation is MKUserLocation { continue }
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(
                annotationPoint.x - pointRectWidth / 2,
                annotationPoint.y - pointRectHeight / 2,
                pointRectWidth,
                pointRectHeight
            )
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }

        setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: animated)
    }
}
