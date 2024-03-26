//
//  TextlListView.swift
//  OptionListInSwiftUI
//
//  Created by GWL on 24/01/24.
//

import SwiftUI

struct TextlListView: View {
    @State var isShowOptionList = false
    @State var mainList: [PopupListModel] = [
        PopupListModel(
            name: "He/Him",
            id: 1,
            value: "He/Him"
        ),
        PopupListModel(
            name: "She/Her",
            id: 2,
            value: "She/Her"
        ),
        PopupListModel(
            name: "They/Them",
            id: 3,
            value: "They/Them"
        ),
        PopupListModel(
            name: "Other",
            id: 4,
            value: "Other"
        )
    ]
    @State var selectedOptions = ""
    @State var selectedOptionArray = [PopupListModel]()
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Text(selectedOptions.isEmpty ? "Result" : selectedOptions)
                Button("OptionList", action: {
                    // To Show “OptionListView” we need to toggle isShowOptionList = ture on button tap”.
                    isShowOptionList = true
                })
            }
            // We can call option view like this.....
            OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: "Select Gender",
                    isShowSearchBar: false,
                    selectedOptions: $selectedOptionArray,
                    isForCheckBox: false,
                    isForMultiSelection: false,
                    isForSingleSelection: true,
                    pickerList: mainList,
                    didClose: { isSubmit, _, selectedOption in
                        // To Hide “OptionListView” we need to toggle isShowOptionList = false after completion”.
                        isShowOptionList = false
                        if isSubmit {
                            selectedOptions = selectedOption.map {
                                String($0.value.trimmingCharacters(in: .whitespaces))
                            }.joined(separator: ", ")
                            selectedOptionArray = selectedOption
                        }
                    }
                )
            )
        }
    }
}

struct TextlListView_Previews: PreviewProvider {
    static var previews: some View {
        TextlListView()
    }
}
