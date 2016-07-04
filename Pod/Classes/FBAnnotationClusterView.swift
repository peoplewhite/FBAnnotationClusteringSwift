//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

public class FBAnnotationClusterView: MKAnnotationView {

	var count = 0

	public var fontSize: CGFloat = 12

	var imageName = "clusterSmall"
	var selectedImageName = "clusterSmall"
	var loadExternalImage: Bool = false

	public var borderWidth: CGFloat = 3

	public var countLabel: UILabel? = nil

	var smallRange = 0...5
	var mediumRange = 6...15

	public var annotationCluster = FBAnnotationCluster()

	public init(annotation: MKAnnotation?, reuseIdentifier: String?, options: FBAnnotationClusterViewOptions?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

		self.annotationCluster = annotation as! FBAnnotationCluster

		count = self.annotationCluster.annotations.count

		if options != nil {
			smallRange = (options?.smallRange)!
			mediumRange = (options?.mediumRange)!
		}

		// change the size of the cluster image based on number of stories
		switch count {
		case self.smallRange:
			fontSize = 12
			if (options != nil) {
				loadExternalImage = true;
				imageName = (options?.smallClusterImage)!
			}
			else {
				imageName = "clusterSmall"
			}
			borderWidth = 3

		case self.mediumRange:
			fontSize = 13
			if (options != nil) {
				loadExternalImage = true;
				imageName = (options?.mediumClusterImage)!
			}
			else {
				imageName = "clusterMedium"
			}
			borderWidth = 4

		default:
			fontSize = 14
			if (options != nil) {
				loadExternalImage = true;
				imageName = (options?.largeClusterImage)!
			}
			else {
				imageName = "clusterLarge"
			}
			borderWidth = 5

		}

		self.selectedImageName = (options?.selectedClusterImage)!

		backgroundColor = UIColor.clearColor()
		setupLabel()
		setTheCount(count)
	}

	required override public init(frame: CGRect) {
		super.init(frame: frame)

	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func setupLabel() {
		countLabel = UILabel(frame: bounds)

		if let countLabel = countLabel {
			countLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			countLabel.textAlignment = .Center
			countLabel.backgroundColor = UIColor.clearColor()
			countLabel.textColor = UIColor.whiteColor()
			countLabel.adjustsFontSizeToFitWidth = true
			countLabel.minimumScaleFactor = 2
			countLabel.numberOfLines = 1
			countLabel.font = UIFont.boldSystemFontOfSize(fontSize)
			countLabel.baselineAdjustment = .AlignCenters
			addSubview(countLabel)
		}

	}

	func setTheCount(localCount: Int) {
		count = localCount;

		countLabel?.text = "\(localCount)"
		setNeedsLayout()
	}

	override public var selected: Bool {
		didSet {
			let imageName = self.selected ? self.selectedImageName : self.imageName
			self.image = UIImage(named: imageName)
//			self.setNeedsLayout()
		}
	}

	override public func layoutSubviews() {

		// Images are faster than using drawRect:

		let imageAsset = UIImage(named: imageName, inBundle: (!loadExternalImage) ? NSBundle(forClass: FBAnnotationClusterView.self) : nil, compatibleWithTraitCollection: nil)

		// UIImage(named: imageName)!

		countLabel?.frame = self.bounds
		image = imageAsset
		centerOffset = CGPointZero

		// adds a white border around the green circle
		layer.borderColor = UIColor.whiteColor().CGColor
		layer.borderWidth = borderWidth
		layer.cornerRadius = self.bounds.size.width / 2

	}

}

public class FBAnnotationClusterViewOptions: NSObject {
	var smallClusterImage: String
	var mediumClusterImage: String
	var largeClusterImage: String

	var selectedClusterImage: String

	var smallRange: Range<Int>
	var mediumRange: Range<Int>

	public init (selectedClusterImage: String, smallClusterImage: String, mediumClusterImage: String, largeClusterImage: String, smallRange: Range<Int>, mediumRange: Range<Int>) {
		self.selectedClusterImage = selectedClusterImage
		self.smallClusterImage = smallClusterImage;
		self.mediumClusterImage = mediumClusterImage;
		self.largeClusterImage = largeClusterImage;

		self.smallRange = smallRange
		self.mediumRange = mediumRange
	}

}