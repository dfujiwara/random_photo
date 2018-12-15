//
//  PhotoViewControllerSpec.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import Quick
import Nimble
@testable import RandomPhoto

class PhotoViewControllerSpec: QuickSpec {
    override func spec() {
        describe("PhotoViewController") {
            var viewController: PhotoViewController!
            beforeEach {
                viewController = PhotoViewController()
                expect(viewController.view).notTo(beNil())
            }
            it("has image view set up") {
                expect(viewController.imageView.contentMode) == .scaleAspectFill
            }
        }
    }
}
