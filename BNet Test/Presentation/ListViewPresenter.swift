//
//  ListViewPresenter.swift
//  BNet Test
//
//  Created by Georgy on 19.01.2024.
//

import Foundation

// MARK: - Protocol

protocol ListViewPresenter {
    
}

// MARK: - State
enum ListViewState {
    case initial, loading, failed(Error), data([CellFillElement])
}

