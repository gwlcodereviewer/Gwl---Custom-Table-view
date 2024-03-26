//
//  OptionListView.swift
//  OptionListInSwiftUI
//
//  Created by GWL on 23/01/24.
//

import SwiftUI
struct PopupListModel: Equatable {
    var name: String = ""
    var id: Int = .zero
    var value: String = ""
}
struct OptionListView: View {
    @ObservedObject var viewModel: OptionListViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        if viewModel.isShow {
            ZStack {
                VStack {
                    VStack(alignment: .leading, spacing: 0.5) {
                        HStack(alignment: .center) {
                            // Heading label
                            Text(viewModel.popUpHeadingName)
                                .font(Font.largeTitle).bold()
                                .foregroundColor(Color.black)
                                .padding(.leading, 16)
                            Spacer()
                            Button {
                                // Cross Button
                                viewModel.didClose(false, nil, [])
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image("PopupCross")
                                    .frame(width: 28, height: 28)
                            }.padding(.trailing, 16)
                        }.padding(.top, 25)
                    }
                    // SearchBar
                    if viewModel.isShowSearchBar {
                        HStack {
                            HStack(spacing: 5) {
                                Image("SearchGray")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(
                                        viewModel.isFocusForSearchBar ?
                                        Color(UIColor.black) :
                                            Color(UIColor.gray)
                                    )
                                ZStack {
                                    // Placeholder Text
                                    HStack {
                                        if viewModel.searchText.isEmpty {
                                            Text("Search")
                                                .foregroundColor(Color(UIColor.gray))
                                        }
                                        Spacer()
                                    }
                                    LegacyTextField(
                                        text: $viewModel.searchText,
                                        isFirstResponder: $viewModel.isFocus,
                                        isSecured: .constant(false)
                                    )
                                    .onChange(
                                        of: viewModel.searchText,
                                        perform: { _ in
                                            !viewModel.searchText.isEmpty ?
                                            viewModel.filterList() :
                                            viewModel.resetFilter()
                                        }
                                    ).onTapGesture {
                                        viewModel.isFocus = true
                                        viewModel.isFocusForSearchBar = true
                                    }
                                    HStack {
                                        Spacer()
                                        // Close Button
                                        if !viewModel.searchText.isEmpty {
                                            Button(action: {
                                                viewModel.searchText = ""
                                                viewModel.resetFilter()
                                            }, label: {
                                                Image("Close")
                                                    .resizable()
                                                    .frame(
                                                        width: 16,
                                                        height: 16,
                                                        alignment: .center
                                                    )
                                            })
                                        }
                                    }
                                }
                            }.frame(height: 45)
                                .padding(.horizontal, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            viewModel.searchText.isEmpty ? Color.gray : Color.blue,
                                            lineWidth: 1
                                        )
                                )
                                .padding(.horizontal, 20)
                        }.padding(.bottom, 10)
                    }
                    ScrollView {
                        if viewModel.mainList.isEmpty {
                            // No Record Found Label
                            HStack {
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("No Record Found.")
                                        .font(Font.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                            }.frame(height: 30)
                                .background(Color.white)
                                .cornerRadius(12)
                                .listRowBackground(Color.clear)
                                .listRowInsets(.init())
                        } else {
                            ForEach(
                                viewModel.mainList,
                                id: \.id) { item in
                                    VStack {
                                        Button {
                                            // Perform Selection Logic
                                            if viewModel.isForSingleSelection && !viewModel.isForCheckBox {
                                                viewModel.isSingleSelected = true
                                            }
                                            if viewModel.isForCheckBox {
                                                if viewModel.tempSelectedOptions.contains(where: { $0.id == item.id }) {
                                                    let index = viewModel.tempSelectedOptions.firstIndex(
                                                        where: { $0.id == item.id }
                                                    )
                                                    viewModel.tempSelectedOptions.remove(at: index ?? .zero)
                                                } else {
                                                    if !viewModel.isForMultiSelection {
                                                        viewModel.tempSelectedOptions.removeAll()
                                                    }
                                                    viewModel.tempSelectedOptions.append(item)
                                                }
                                            } else {
                                                viewModel.tempSelectedOptions.removeAll()
                                                viewModel.tempSelectedOptions.append(item)
                                            }
                                            viewModel.isChanges = !viewModel.tempSelectedOptions.isEmpty
                                            hideKeyboard()
                                        } label: {
                                            HStack {
                                                // Options label
                                                Text(item.name)
                                                    .lineSpacing(5)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(height: 35)
                                                    .font(Font.title3)
                                                    .foregroundColor(viewModel.getTextForegroundColor(
                                                        listRecords: item)
                                                    )
                                                    .padding(.leading, 30)
                                                Spacer()
                                                if !viewModel.isForSingleSelection {
                                                    Image(viewModel.getImageName(listRecords: item))
                                                        .frame(width: 20,
                                                               height: 20)
                                                        .padding(.trailing, 30)
                                                }
                                            }.background(viewModel.isSingleSelected ? viewModel.getBackgroundColor(listRecords: item) : Color.clear)
                                                .padding(.bottom, 3)
                                        }
                                    }
                                }
                        }
                    }
                    HStack(spacing: 16) {
                        // Cancel Button
                        CustomButton(
                            text: "Cancel",
                            action: {
                                // Navigate Back
                                viewModel.didClose(false, nil, [])
                                presentationMode.wrappedValue.dismiss()
                            }, height: 37,
                            radius: 8,
                            isTextButton: true
                        )
                        // Apply Button
                        CustomButton(
                            text: "Apply",
                            action: {
                                guard let selectedData = viewModel.tempSelectedOptions.first else {
                                    viewModel.didClose(true, nil, [])
                                    presentationMode.wrappedValue.dismiss()
                                    return
                                }
                                let multipleSelectedData = viewModel.tempSelectedOptions
                                viewModel.didClose(
                                    true,
                                    selectedData,
                                    multipleSelectedData
                                )
                                print(selectedData)
                                print(multipleSelectedData)
                                presentationMode.wrappedValue.dismiss()
                            },
                            height: 37,
                            horizontalPadding: .zero,
                            radius: 8,
                            isDisabled: !viewModel.isChanges
                        )
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                }.background(Color.white)
            }
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 40)
            .background(Color.black.opacity(0.3))
            .ignoresSafeArea(.container)
            .onAppear {
                viewModel.isChanges = false
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}
