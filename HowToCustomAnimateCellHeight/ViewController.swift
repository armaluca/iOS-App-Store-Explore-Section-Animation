//
//  ViewController.swift
//  HowToCustomAnimateCellHeight
//
//  Created by luca silvestro on 25/07/15.
//  Copyright (c) 2015 luca silvestro. All rights reserved.
//  luca.silvestro@gmail.com

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var selectedCellIndexPath:NSIndexPath?
    var visibleCells:NSMutableArray = NSMutableArray.new()
    var detailVC:DetailViewController?
    var sectionTitles:[String]?
    var titleView = UIView()
    var titleLabel = UILabel()
    var isNavigationBarCollapsed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitles = ["Books", "Business", "Catalogues", "Entertainment", "Finance", "Food & Drink", "Games", "Health & Fitness", "Kids", "Lifestyle", "Medical", "Music", "Navigation", "News", "Newsstand", "Photo & video", "Productivity","Reference", "Social Networking"]
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        setupUI()
    }
    
    func setupUI(){
        func setupNavUI(){
            let widthTitleView:CGFloat = 150.0
            let originYTitleView = (CGRectGetWidth(view.bounds) - widthTitleView) / 2
            titleView = UIView(frame: CGRectMake(originYTitleView, 0.0, widthTitleView, self.navigationController!.navigationBar.frame.size.height))
            self.navigationController?.navigationBar.addSubview(titleView)
            
            titleLabel.text = "Explore"
            titleLabel.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(titleView.frame), CGRectGetHeight(titleView.frame))
            titleLabel.font = UIFont.systemFontOfSize(16.0)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
            titleLabel.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin
            titleView.addSubview(titleLabel)
        }
        setupNavUI()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Identifier") as! TableViewCell
        cell.title?.text = sectionTitles![indexPath.row]
        cell.contentView.backgroundColor = UIColor.lightGrayColor()
        cell.headerView.backgroundColor = UIColor.whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitles!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* If didselect a row and there's already an expanded cell collapse it */
        if let unwrap_selectedCellIndexPath = selectedCellIndexPath {
            toggleCell(unwrap_selectedCellIndexPath, wantsToExpand: false)
        }
        /* Expand the cell */
        else {
                selectedCellIndexPath = indexPath
                toggleCell(indexPath, wantsToExpand: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedCellIndexPath?.row {
            return self.tableview.frame.size.height
        }
        else {
            return tableview.estimatedRowHeight
        }
    }
    
    func toggleCell(indexPath:NSIndexPath, wantsToExpand:Bool) {
        toggleNavigationBar(!isNavigationBarCollapsed)
        if wantsToExpand {
            if detailVC == nil {
                detailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as? DetailViewController
                detailVC?.title = sectionTitles![selectedCellIndexPath!.row]
            }
            addChildViewController(detailVC!)
            detailVC?.didMoveToParentViewController(self)
            var rectSelectedRow = tableview.rectForRowAtIndexPath(selectedCellIndexPath!)
            detailVC?.view.frame = CGRectMake(CGRectGetMinX(rectSelectedRow), CGRectGetMinY(rectSelectedRow) + 64.0, CGRectGetWidth(rectSelectedRow), CGRectGetHeight(rectSelectedRow))
            detailVC?.dismissIcon.alpha = 0.0
            detailVC?.titleLabel.alpha = 0.0
            detailVC?.opacityView.alpha = 1.0
            detailVC?.view.clipsToBounds = true
            detailVC?.buttonCLickedCompletion = {Void in
            self.toggleCell(self.selectedCellIndexPath!, wantsToExpand: false)
            }
            view.addSubview(detailVC!.view)
            UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                for item in self.tableview.visibleCells() {
                    var cell = item as! UITableViewCell
                    var cellIndexPath = self.tableview.indexPathForCell(cell)
                    /* move down the cells below selected one */
                    if cellIndexPath!.row > indexPath.row {
                        var frame:CGRect = cell.frame
                        frame.origin.y += self.tableview.frame.size.height - self.tableview.estimatedRowHeight * CGFloat(indexPath.row) - self.tableview.estimatedRowHeight - 64.0
                        cell.frame = frame
                    }
                    /* move up the cells above selected one (included selected one) */
                    else {
                        var frame = cell.frame
                        frame.origin.y -= self.tableview.estimatedRowHeight * CGFloat(indexPath.row) + 64.0 - 42.0
                        cell.frame = frame
                    }
                    
                    /* add the cells to visibleCells array*/
                    self.visibleCells.addObject(cellIndexPath!)
                }
                /* move up even the frame of detailVC*/
                var frame = self.detailVC!.view.frame
                //frame.origin.y -= self.tableview.estimatedRowHeight * CGFloat(indexPath.row)
                frame.size.height = frame.size.height - 44.0
                self.detailVC?.headerView.backgroundColor = UIColor.clearColor()
                self.detailVC!.view.frame = frame
                /* animate alpha detailVC label and button and opacity */
                self.detailVC?.dismissIcon.alpha = 1.0
                self.detailVC?.titleLabel.alpha = 1.0
                self.detailVC?.fakeCellLabel.alpha = 0.0
                self.detailVC?.opacityView.alpha = 0.0
                /* expand selected cell */
                var cellSelected = self.tableview.cellForRowAtIndexPath(indexPath)
                var frameCellExpanded = cellSelected!.frame
                frameCellExpanded.size.height = self.tableview.frame.size.height - 44.0
                cellSelected?.frame = frameCellExpanded
                frameCellExpanded.origin.y += 64.0
                self.detailVC!.view.frame = frameCellExpanded
                return
                }) {
                    (isFinished) -> Void in
                    return
            }
        }
        else{
            UIView.animateWithDuration(0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                for item in self.visibleCells {
                    var cell = self.tableview.cellForRowAtIndexPath(item as! NSIndexPath) as! TableViewCell
                    var cellIndexPath = self.tableview.indexPathForCell(cell)
                    /* move up the cells below selected one */
                    if cellIndexPath!.row > indexPath.row {
                        var frame:CGRect = cell.frame
                        frame.origin.y -= self.tableview.frame.size.height - self.tableview.estimatedRowHeight * CGFloat(indexPath.row) - self.tableview.estimatedRowHeight - 64.0
                        cell.frame = frame
                    }
                        /* move down the cells above selected one (included selected one) */
                    else {
                        var frame = cell.frame
                        frame.origin.y += self.tableview.estimatedRowHeight * CGFloat(indexPath.row) + 22.0
                        cell.frame = frame
                    }
                }
                
                /* move up even the frame of detailVC*/
                var frame = self.detailVC!.view.frame
                frame.origin.y += self.tableview.estimatedRowHeight * CGFloat(indexPath.row)
                self.detailVC!.view.frame = frame
                self.detailVC?.headerView.backgroundColor = UIColor.whiteColor()
                /* animate alpha detailVC label and button and opacity */
                self.detailVC?.dismissIcon.alpha = 0.0
                self.detailVC?.titleLabel.alpha = 0.0
                self.detailVC?.fakeCellLabel.alpha = 1.0
                self.detailVC?.opacityView.alpha = 1.0
                /* collapse selected cell */
                var cellSelected = self.tableview.cellForRowAtIndexPath(indexPath)
                var frameCellExpanded = cellSelected!.frame
                frameCellExpanded.size.height = 44.0
                cellSelected?.frame = frameCellExpanded
                frameCellExpanded.origin.y += 64.0
                self.detailVC!.view.frame = frameCellExpanded
                self.detailVC?.opacityView.layer.borderColor = UIColor.yellowColor().CGColor
                self.detailVC?.opacityView.layer.borderWidth = 2.0

                return
                }) {
                    (isFinished) -> Void in
                    self.tableview.reloadData()
                    self.selectedCellIndexPath = nil
                    self.visibleCells.removeAllObjects()
                    ((self.childViewControllers[0] as! UIViewController).view).removeFromSuperview()
                    self.childViewControllers[0].removeFromParentViewController()
                    self.detailVC = nil
                    
                    return
            }
        }
    }
    
    func animateNavbar(#isExpanding:Bool){
        UIView.animateWithDuration(2, animations: { () -> Void in
            var frame:CGRect? = self.navigationController?.navigationBar.frame
            var frameTitle = self.navigationItem.titleView?.bounds
            var trans:CGPoint = CGPointZero
            
            if isExpanding {
                    frame?.size.height = frame!.size.height*2
                    frameTitle?.size.height = 44.0
                    frameTitle?.size.width  = 150.0
                    trans = CGPoint(x: 2, y: 2)
            }
            else {
                    frame?.size.height = frame!.size.height/2
                    frameTitle?.size.height = frame!.size.height
                    frameTitle?.size.width = 150.0/2
                    trans = CGPoint(x: 0.5, y: 0.5)
            }
            self.navigationItem.titleView?.transform = CGAffineTransformScale(self.navigationItem.titleView!.transform, trans.x, trans.y);
            self.navigationItem.titleView?.transform = CGAffineTransformTranslate(self.navigationItem.titleView!.transform, self.navigationController!.navigationBar.frame.size.width / 2, 0.0);
            self.navigationItem.titleView?.bounds = frameTitle!
            self.navigationController?.navigationBar.frame = frame!
        })
    }
    
    func toggleNavigationBar(hasToCollapse: Bool){
        var frame:CGRect? = self.navigationController?.navigationBar.frame
        var frameTitle = titleView.frame
        var scaleFactor = frame!.size.height / 44.0
        var frameSizeHeightBeforeUpdate = frame!.size.height
        
        if hasToCollapse {
            titleLabel.transform = CGAffineTransformScale(titleLabel.transform, 1.0, 1.0)
            [UIView .animateWithDuration(0.4, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                frame?.size.height = 22.0
                frameTitle.size.height = 22.0
                frameTitle.origin.y = 0
                self.navigationController?.navigationBar.frame = frame!
                self.titleView.frame = frameTitle
                self.titleLabel.transform = CGAffineTransformScale(self.titleLabel.transform, 22.0 / frameSizeHeightBeforeUpdate, 22.0 / frameSizeHeightBeforeUpdate)
                }, completion: { (completed) -> Void in
                    self.isNavigationBarCollapsed = true
            })];
        }
        
        if !hasToCollapse {
            [UIView .animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                frame?.size.height = 44.0
                frameTitle.size.height = 44.0
                frameTitle.origin.y = 0
                self.navigationController?.navigationBar.frame = frame!
                self.titleView.frame = frameTitle
                self.titleLabel.transform = CGAffineTransformScale(self.titleLabel.transform, 44.0 / frameSizeHeightBeforeUpdate, 44.0 / frameSizeHeightBeforeUpdate)
                }, completion: { (completed) -> Void in
                    self.isNavigationBarCollapsed = false
            })];
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}

