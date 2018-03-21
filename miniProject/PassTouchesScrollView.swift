//
//  PassTouchesScrollView.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 20/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
protocol PassTouchesScrollViewDelegate {
    func touchBegan()
    func touchMoved()
}
class PassTouchesScrollView: UIScrollView {
    var delegatePass : PassTouchesScrollViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // Notify it's delegate about touched
        self.delegatePass?.touchBegan()
        
        if self.isDragging == true {
            self.next?.touchesBegan(touches as! Set<UITouch>, with: event)
        } else {
            super.touchesBegan(touches as! Set<UITouch>, with: event)
        }
        
    }
    
     func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)  {
        
        // Notify it's delegate about touched
        self.delegatePass?.touchMoved()
        
        if self.isDragging == true {
            self.next?.touchesMoved(touches as! Set<UITouch>, with: event)
        } else {
            super.touchesMoved(touches as! Set<UITouch>, with: event)
        }
    }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


