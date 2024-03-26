# Gwl---Custom-Table-view

How to use OptionListView:

#Step: 1 
Please execute the following code to show “OptionListView” with the parameter “show flag” set to “true”.
For example:
var isShowOptionList = true
 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: “”,
                    isShowSearchBar: false,
                    selectedOptions: $selectedOptionArray,
                    isForCheckBox: true,
                    isForMultiSelection: false,
                    isForSingleSelection: false,
                    pickerList: mainList,
                    didClose: { _, _, _ in 
                         isShowOptionList = false
                    }
                )
            )

#Step: 2 
You have to pass “Option list Title” with the parameter “popUpHeadingName“.
For example:
let popUpHeadingName: “Select Gender”
 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: false,
                    selectedOptions: $selectedOptionArray,
                    isForCheckBox: true,
                    isForMultiSelection: false,
                    isForSingleSelection: false,
                    pickerList: mainList,
                    didClose: { _, _, _ in 
                         isShowOptionList = false
                    }
                )
            )

#Step: 3 
You have to pass “optionArrayList” with the parameter “selectedOptions“.
For example:
@State var optionArrayList: [PopupListModel] = [
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

 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: false,
                   selectedOptions: $optionArrayList,
                    isForCheckBox: false,
                    isForMultiSelection: false,
                    isForSingleSelection: false,
                    pickerList: mainList,
                     didClose: { _, _, _ in 
                         isShowOptionList = false
                    }
                )
            )
#Step: 4 
If you want the search bar, You have to pass “true” with the parameter “isShowSearchBar“ and won’t then you have pass “false”
For example:
let popUpHeadingName: “Select Gender”
 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: true,
                    selectedOptions: $selectedOptionArray,
                    isForCheckBox: true,
                    isForMultiSelection: false,
                    isForSingleSelection: false,
                    pickerList: mainList,
                    didClose: { _, _, _ in 
                         isShowOptionList = false
                    }
                )
            )

#Step: 5 
If you want the CheckBox option list, you have to pass “true” with the parameter “isForCheckBox“ and “false” with “isForMultiSelection”, “isForSingleSelection”.

 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: false,
                   selectedOptions: $optionArrayList,
                    isForCheckBox: true,
                    isForMultiSelection: false,
                    isForSingleSelection: false,
                    pickerList: mainList,
                     didClose: { isSubmit, _, selectedOption in
                        isShowOptionList = false
                        if isSubmit {
                            selectedOptionArray = selectedOption
                        }
                    }
                )
            )
#Step: 6 
If you want the RadioButton option list, you have to pass “false” with the parameters “isForCheckBox“, “isForMultiSelection” and “isForSingleSelection”.

 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: false,
                   selectedOptions: $optionArrayList,
                    isForCheckBox: false,
                 isForMultiSelection: false,
                 isForSingleSelection: false,
                    pickerList: mainList,
                     didClose: { isSubmit, _, selectedOption in
                        isShowOptionList = false
                        if isSubmit {
                            selectedOptionArray = selectedOption
                        }
                    }
                )
            )

#Step: 7 
If you want the Multiple selection with the checkBox option list, you have to pass “true” with the parameters “isForMultiSelection“ and “isForCheckBox” and “false” with “isForSingleSelection”.

 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: false,
                   selectedOptions: $optionArrayList,
                    isForCheckBox: true,
                    isForMultiSelection: true,
                    isForSingleSelection: false,
                    pickerList: mainList,
                    didClose: { isSubmit, _, selectedOption in
                        isShowOptionList = false
                        if isSubmit {
                            selectedOptionArray = selectedOption
                        }
                    }
                )
            )

#Step: 8 
If you want the single selection option list you have to pass “true” with the parameter “isForSingleSelection“ and “false” with “isForCheckBox”, “isForMultiSelection”.

 OptionListView(
                viewModel: OptionListViewModel(
                    show: isShowOptionList,
                    popUpHeadingName: popUpHeadingName,
                    isShowSearchBar: false,
                   selectedOptions: $optionArrayList,
                    isForCheckBox: false,
                    isForMultiSelection: false,
                    isForSingleSelection: true,
                    pickerList: mainList,
                     didClose: { isSubmit, _, selectedOption in
                        isShowOptionList = false
                        if isSubmit {
                            selectedOptionArray = selectedOption
                        }
                    }
                )
            )



#Sample Code:

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
                    isShowOptionList = true
                })
            }
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



