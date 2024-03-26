//
//  OptionListViewModel.swift
//  OptionListInSwiftUI
//
//  Created by GWL on 23/01/24.
//

import Foundation
import SwiftUI
class OptionListViewModel: ObservableObject {
    @Published var popUpHeadingName: String = "Select Option"
    @Published var isShow: Bool = false
    @Published var isFocusForSearchBar: Bool = false
    @Published var searchText: String = ""
    @Published var isFocus: Bool = false
    @Published var pickerList: [PopupListModel] = []
    @Published var isChanges: Bool = false
    @Published var isForCheckBox: Bool = false
    @Published var isForMultiSelection: Bool = false
    @Published var isForSingleSelection: Bool = false
    @Published var isShowSearchBar: Bool = false
    var isSingleSelected: Bool = false
    @Published var tempSelectedOptions: [PopupListModel]
    @Published var mainList: [PopupListModel] = []
    var didClose: ( _ isSubmit: Bool,
                    _ selectedOptions: PopupListModel?,
                    _ multipleSelectedData: [PopupListModel]) -> Void
    init(
        show: Bool = false,
        popUpHeadingName: String,
        isShowSearchBar: Bool = false,
        selectedOptions: Binding<[PopupListModel]>,
        isForCheckBox: Bool = false,
        isForMultiSelection: Bool = false,
        isForSingleSelection: Bool = false,
        pickerList: [PopupListModel],
        didClose: @escaping (
            _ isSubmit: Bool,
            _ selectedOptions: PopupListModel?,
            _ multipleSelectedData: [PopupListModel]
        ) -> Void
    ) {
        self.isShow = show
        self.didClose = didClose
        self.pickerList = pickerList
        mainList = pickerList
        self.isForCheckBox = isForCheckBox
        self.isForMultiSelection = isForMultiSelection
        self.isForSingleSelection = isForSingleSelection
        tempSelectedOptions = selectedOptions.wrappedValue
        self.popUpHeadingName = popUpHeadingName
        isSingleSelected = isForSingleSelection && !isForCheckBox
        self.isShowSearchBar = isShowSearchBar
    }
    // reset filter
    func resetFilter() {
        mainList = pickerList
    }
    // filtered data
    func filterList() {
        mainList = pickerList.filter { obj in
            return obj.name.lowercased().contains(searchText.lowercased())
        }
    }
    // Get Image name for radio and check box buttons
    func getImageName(listRecords: PopupListModel) -> String {
        var imageName: String = ""
        imageName = isForCheckBox ?
        isOptionSelected(isSelected: tempSelectedOptions.contains(
            where: { $0.id == listRecords.id })
        ) : tempSelectedOptions.first?.id == listRecords.id ?
        "RadioSelected" : "RadioUncheckGray"
        return imageName
    }
    // For checkbox (selected/unselected)
    func isOptionSelected(isSelected: Bool) -> String {
        return isSelected ? "CheckedBox" : "UncheckBox"
    }
    // Get text foreground colour
    func getTextForegroundColor(listRecords: PopupListModel) -> Color {
        var foregroundColor: Color?
        var isContains: Bool = false
        if isForCheckBox {
            isContains = tempSelectedOptions.contains(where: { $0.id == listRecords.id })
            return isContains ?
            Color(.black) :
            Color(.gray)
        } else {
            foregroundColor = tempSelectedOptions.first?.id == listRecords.id ?
            isSingleSelected ? Color.white : Color(.black) :
            !(searchText.isEmpty) ?
            Color(.black) :
            Color(.gray)
        }
        return foregroundColor ?? Color.red
    }
    // Get Background colour for single selection
    func getBackgroundColor(listRecords: PopupListModel) -> Color {
        var isContains: Bool = false
        isContains = tempSelectedOptions.contains(where: { $0.id == listRecords.id })
        return isContains ?
        Color(.blue) :
        Color(.clear)
    }
}
