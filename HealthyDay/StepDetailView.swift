//
//  StepDetailView.swift
//  HealthyDay
//
//  Created by Group 5 (MJD, NL, CP) on 10/8/16.
//  Copyright © 2016 San Jose State University. All rights reserved.
//

import UIKit

class StepDetailView: UIView {

    var stepLineChart : StepLineChart!
    
    internal var stepCountsData = [Int](){
        didSet{
            initMaxStepCount()
            initStepLineChart()
            initCenterGradientLayer()
            initMaxStepCountLabel()
        }
    }
    fileprivate var viewSize = CGSize()
    fileprivate var currentIndex = 0
    private var targetCount = 10000
    private var maxStepCount = 0
    private let centerGradientLayer = CAGradientLayer()
    private var spliteLines = [CALayer]()
    private var maxStepCountLabel = UILabel()
    private var dateLabel = UILabel()
    private var trendencyLabel = UILabel()
    private var imformationTitleLabel = [ImformationTitle]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        initDateLabel()
        initTrendencyLabel()
        initSplitLines()
        initImformationTitleLabel()
    }
    
    private func initDateLabel() {
        dateLabel.frame = CGRect(x: frame.width * 0.1, y: frame.height * 1.3 / 15, width: frame.width * 0.25, height: frame.height * 1.5 / 15)
        dateLabel.text = "Today"
        dateLabel.textColor = UIColor.lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 14/320*frame.width)
        dateLabel.textAlignment = .center
        addSubview(dateLabel)
    }
    
    private func initTrendencyLabel() {
        trendencyLabel.frame = CGRect(x: frame.width * 0.65, y: frame.height * 1.3 / 15, width: frame.width * 0.25, height: frame.height * 1.5 / 15)
        trendencyLabel.text = "Trending"
        trendencyLabel.textColor = rgbColor(red: 0x22, green: 0xC8, blue: 0x19, alpha: 1)
        trendencyLabel.font = UIFont.systemFont(ofSize: 14/320*frame.width)
        trendencyLabel.textAlignment = .center
        addSubview(trendencyLabel)
    }
    
    
    private func initMaxStepCount() {
        let stepCount = stepCountsData.max()
        if stepCountsData.isEmpty == true {
            maxStepCount = targetCount
        } else {
            maxStepCount = max(stepCount!, targetCount)
        }
    }
    
    private func initStepLineChart() {
        let totalDataCount = stepCountsData.count
        let lineChartColumn = totalDataCount == 0 ? 7 : totalDataCount + 6
        let lineChartWidth = CGFloat(lineChartColumn) * frame.width * 0.143
        viewSize = CGSize(width: frame.width / 7, height: frame.height)
        stepLineChart = StepLineChart(frame: CGRect(x: 0, y: frame.height * 2.5 / 15.0, width: frame.width, height: frame.height*0.3), stepCountsData: stepCountsData, maxStepCount: maxStepCount)
        stepLineChart.contentSize = CGSize(width: lineChartWidth, height: 0)
        stepLineChart.contentOffset = CGPoint(x: lineChartWidth - frame.width, y: 0)
        stepLineChart.layer.zPosition = 1
        stepLineChart.delegate = self
        addSubview(stepLineChart)
    }
    
    private func initCenterGradientLayer() {
        guard centerGradientLayer.superlayer == nil else {return}
        centerGradientLayer.frame = CGRect(x: frame.width * 3 / 7, y: frame.height * 3.5 / 15.0, width: frame.width / 7, height: frame.height * 3.5 / 15.0)
        centerGradientLayer.colors = [theme.lightLineChartColor.cgColor, theme.thickLineChartColor.cgColor]
        centerGradientLayer.zPosition = 2
        layer.addSublayer(centerGradientLayer)
    }
    
    private func initMaxStepCountLabel() {
        maxStepCountLabel.frame = CGRect(x: frame.width * 0.03, y: frame.height * 2.9 / 15, width: frame.width / 11, height: frame.height * 0.5 / 15)
        maxStepCountLabel.text = "\(maxStepCount)"
        maxStepCountLabel.textAlignment = .center
        maxStepCountLabel.textColor = UIColor.black
        maxStepCountLabel.layer.zPosition = 2
        maxStepCountLabel.adjustsFontSizeToFitWidth = true
        addSubview(maxStepCountLabel)
    }
    
    private func initSplitLines() {
        spliteLines.append(SplitLine(from: CGPoint(x: frame.width * 0.03,y: frame.height * 3.4 / 15),to: CGPoint(x: frame.width * 0.97,y: frame.height * 3.4 / 15), layerWidthIsThin: true, isHorizen: true))
        spliteLines.append(SplitLine(from: CGPoint(x: frame.width * 0.03,y: frame.height * 6.0 / 15),to: CGPoint(x: frame.width * 0.97,y: frame.height * 6.0 / 15), layerWidthIsThin: true, isHorizen: true))
        spliteLines.append(SplitLine(from: CGPoint(x: frame.width * 0.05,y: frame.height * 9.5 / 15),to: CGPoint(x: frame.width * 0.95,y: frame.height * 9.5 / 15), layerWidthIsThin: true, isHorizen: true))
        spliteLines.append(SplitLine(from: CGPoint(x: frame.width * 0.05,y: frame.height * 11.0 / 15),to: CGPoint(x: frame.width * 0.95,y: frame.height * 11.0 / 15), layerWidthIsThin: true, isHorizen: true))
        spliteLines.append(SplitLine(from: CGPoint(x: frame.width * 0.05,y: frame.height * 12.5 / 15),to: CGPoint(x: frame.width * 0.95,y: frame.height * 12.5 / 15), layerWidthIsThin: true, isHorizen: true))
        spliteLines.append(SplitLine(from: CGPoint(x: frame.width / 2,y: frame.height * 7.5 / 15),to: CGPoint(x: frame.width / 2,y: frame.height * 12.5 / 15), layerWidthIsThin: true, isHorizen: false))
        spliteLines.append(SplitLine(from: CGPoint(x: 0,y: frame.height * 7.0 / 15),to: CGPoint(x: frame.width,y: frame.height * 7.0 / 15), layerWidthIsThin: false, isHorizen: true))
        for index in 0..<spliteLines.count {
            layer.addSublayer(spliteLines[index])
        }
    }
    
    private func initImformationTitleLabel() {
        imformationTitleLabel.append(ImformationTitle(frame: CGRect(x: frame.width * 0.05, y: frame.height * 7.65 / 15, width: frame.width * 0.2 , height: frame.height * 0.5 / 15), text: "Total Steps", isLight: false))
        imformationTitleLabel.append(ImformationTitle(frame: CGRect(x: frame.width * 0.6, y: frame.height * 7.65 / 15, width: frame.width * 0.2, height: frame.height * 0.5 / 15), text: "Total Kilometerss", isLight: false))
        imformationTitleLabel.append(ImformationTitle(frame: CGRect(x: frame.width * 0.05, y: frame.height * 9.65 / 15, width: frame.width * 0.2, height: frame.height * 0.5 / 15), text: "Run Time", isLight: true))
        imformationTitleLabel.append(ImformationTitle(frame: CGRect(x: frame.width * 0.6, y: frame.height * 9.65 / 15, width: frame.width * 0.2, height: frame.height * 0.5 / 15), text: "Calories Used", isLight: true))
        imformationTitleLabel.append(ImformationTitle(frame: CGRect(x: frame.width * 0.05, y: frame.height * 11.15 / 15, width: frame.width * 0.2, height: frame.height * 0.5 / 15), text: "Time", isLight: true))
        for index in 0..<imformationTitleLabel.count {
            addSubview(imformationTitleLabel[index])
        }
    }
    
    fileprivate func hideStepEverydayViewLabel(index: Int, alpha: CGFloat){
        guard stepLineChart.stepEverydayViews[index].stepLabel.alpha != alpha else {return}
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {[unowned self] in
            self.stepLineChart.stepEverydayViews[index].stepLabel.alpha = alpha
            }, completion: nil)
    }
    
    fileprivate func changeDateLabel(currentIndex: Int) {
        let currentDate = Date()
        if currentIndex == stepCountsData.count + 2 {
            dateLabel.text = "Today"
        } else if currentIndex == stepCountsData.count + 1 {
            dateLabel.text = "Yesterday"
        } else {
            let dateDescription = Date(timeInterval: 24*3600*Double(currentIndex - 2 - stepCountsData.count), since: currentDate).formatDescription()
            let range = dateDescription.index(dateDescription.startIndex, offsetBy: 5)..<dateDescription.index(dateDescription.startIndex, offsetBy: 10)
            let text = dateDescription.substring(with: range)
            dateLabel.text = text
        }
    }
}

extension StepDetailView: UIScrollViewDelegate {
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCenterX = stepLineChart.currentCenter().x
        currentIndex = Int(round((currentCenterX - viewSize.width / 2) / viewSize.width))
        guard currentIndex >= 3 && currentIndex - 2 <= stepLineChart.stepEverydayViews.count else {return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 0)
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            stepLineChart.setContentOffset(stepLineChart.contentOffsetForIndex(currentIndex), animated: true)
            changeDateLabel(currentIndex: currentIndex)
        }
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stepLineChart.setContentOffset(stepLineChart.contentOffsetForIndex(currentIndex), animated: true)
        guard currentIndex >= 3 && currentIndex - 2 <= stepLineChart.stepEverydayViews.count else {return}
        guard stepLineChart.contentOffset.x == 0 || stepLineChart.contentOffset.x - (stepLineChart.contentSize.width - frame.width) == 0 else{return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 1)
        changeDateLabel(currentIndex: currentIndex)
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard currentIndex >= 3 && currentIndex - 2 <= stepLineChart.stepEverydayViews.count else {return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 1)
        changeDateLabel(currentIndex: currentIndex)
    }
}

internal class SplitLine: CALayer {
    private var width = CGFloat()
    private var height = CGFloat()
    private var layerWidth = CGFloat()
    private var layerColor = UIColor()
    
    init(from: CGPoint, to: CGPoint, layerWidthIsThin: Bool, isHorizen: Bool) {
        super.init()
        if layerWidthIsThin {
            layerWidth = 1
            layerColor = theme.lightSplitLineColor
        } else {
            layerWidth = 23
            layerColor = theme.thickSplitLineColor
        }
        if isHorizen {
            width = to.x - from.x
            height = layerWidth
        } else {
            width = layerWidth
            height = to.y - from.y
        }
        self.frame = CGRect(x: from.x, y: from.y, width: width, height: height)
        self.backgroundColor = layerColor.cgColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal class ImformationTitle: UILabel {
    
    init(frame: CGRect, text: String, isLight: Bool) {
        super.init(frame: frame)
        self.text = text
        self.font = UIFont(name: "DINCondensed-Bold", size: 16)
        if isLight {
            self.textColor = rgbColor(red: 0xCB, green: 0xCB, blue: 0xCB, alpha: 1)
        } else {
            self.textColor = rgbColor(red: 0x2E, green: 0x2E, blue: 0x2E, alpha: 1)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
