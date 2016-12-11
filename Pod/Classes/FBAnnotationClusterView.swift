//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

open class FBAnnotationClusterView: MKAnnotationView {

	var count = 0

	open var fontSize: CGFloat = 12

	var imageName = "clusterSmall"
	var selectedImageName = "clusterSmall"
    var selectedBeforeImageName = "btn_bubble_grey"
	var loadExternalImage: Bool = false

	open var borderWidth: CGFloat = 3

	open var countLabel: UILabel? = nil

    var smallRange: Range<Int> = 0..<6
	var mediumRange: Range<Int> = 6..<16

	open var annotationCluster = FBAnnotationCluster()

	open var pressed: Bool = false {
		didSet {
			let imageName = self.pressed ? self.selectedImageName : self.imageName
			self.image = UIImage(named: imageName)
		}
	}
	open var pressedToGrayColor: Bool = false {
		didSet {
            let imageName = self.pressedToGrayColor ? self.selectedImageName : self.selectedBeforeImageName
			self.image = UIImage(named: imageName)
		}
	}

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

		backgroundColor = UIColor.clear
		setupLabel()
		setTheCount(count)
	}

//	required public init(frame: CGRect) {
//		super.init(frame: frame)
//
//	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func setupLabel() {
		countLabel = UILabel(frame: bounds)

		if let countLabel = countLabel {
			countLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			countLabel.textAlignment = .center
			countLabel.backgroundColor = UIColor.clear
			countLabel.textColor = UIColor.white
			countLabel.adjustsFontSizeToFitWidth = true
			countLabel.minimumScaleFactor = 2
			countLabel.numberOfLines = 1
			countLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
			countLabel.baselineAdjustment = .alignCenters
			addSubview(countLabel)
		}

	}

	func setTheCount(_ localCount: Int) {
		count = localCount;

		countLabel?.text = "\(localCount)"
		countLabel?.text = "9+"
		setNeedsLayout()
	}

	override open var isSelected: Bool {
		didSet {
//			let imageName = self.selected ? self.selectedImageName : self.imageName
//			self.image = UIImage(named: imageName)
//			self.setNeedsLayout()
		}
	}

	override open func layoutSubviews() {

		// Images are faster than using drawRect:

		let imageAsset = UIImage(named: imageName, in: (!loadExternalImage) ? Bundle(for: FBAnnotationClusterView.self) : nil, compatibleWith: nil)

		// UIImage(named: imageName)!

		countLabel?.frame = self.bounds
		image = imageAsset
		centerOffset = CGPoint.zero

		// adds a white border around the green circle
		layer.borderColor = UIColor.white.cgColor
		layer.borderWidth = borderWidth
		layer.cornerRadius = self.bounds.size.width / 2

	}

}

open class FBAnnotationClusterViewOptions: NSObject {
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
