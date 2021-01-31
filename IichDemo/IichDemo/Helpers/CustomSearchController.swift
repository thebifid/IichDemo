//
//  CustomSearchController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 30.01.2021.
//

import UIKit

class CustomSearchController: UISearchController {
    // Mark this property as lazy to defer initialization until
    // the searchBar property is called.
    private lazy var customSearchBar = SearchBar()

    // Override this property to return your custom implementation.
    override var searchBar: UISearchBar { customSearchBar }
}
