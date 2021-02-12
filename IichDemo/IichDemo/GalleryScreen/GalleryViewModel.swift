//
//  GalleryViewModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 08.02.2021.
//

import Foundation

class GalleryViewModel {
    // MARK: - Private Properties

    // MARK: - Handlers

    // MARK: - Public Properties

    var files: [Attachements] = []

    var scrollToIndex: Int?
    var scrollToIndexPath: IndexPath? {
        guard let item = scrollToIndex else { return nil }
        return IndexPath(item: item, section: 0)
    }

    // MARK: - Init

    init(withFiles files: [Attachements]) {
        self.files = files
    }
}
