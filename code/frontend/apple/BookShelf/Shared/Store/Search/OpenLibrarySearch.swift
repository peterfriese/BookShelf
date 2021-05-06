//
//  BookSearchStore.swift
//  BookShelf
//
//  Created by Peter Friese on 06.05.21.
//

import Foundation
import Combine

class OpenLibrarySearch: ObservableObject {
  @Published var searchTerm: String = ""
  @Published var searchResult = [Book]()
  @Published var isLoading = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    $searchTerm
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .flatMap { searchTerm in
        self.searchBooks(searchTerm: searchTerm)
      }
      .assign(to: &$searchResult)
  }
  
  func searchBooks(searchTerm: String) -> AnyPublisher<[Book], Never> {
    let escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let url = URL(string: "https://openlibrary.org/search.json?q=\(escapedSearchTerm)")!
    self.isLoading = !searchTerm.isEmpty // don;t show progress indicator when the searchterm is empty
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: OpenLibrarySearchResult.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: { response in
        self.isLoading = false
      })
      .compactMap { result in
        result.books?.compactMap { book in
          Book(from: book)
        }
      }
      .catch { _ in
        Just(self.searchResult)
      }
      .eraseToAnyPublisher()
  }
}
