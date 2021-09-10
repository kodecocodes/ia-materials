/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class ResultArray: Codable {
  var resultCount = 0
  var results = [SearchResult]()
}

private let typeForKind = [
  "album": NSLocalizedString(
    "Album",
    comment: "Localized kind: Album"),
  "audiobook": NSLocalizedString(
    "Audio Book",
    comment: "Localized kind: Audio Book"),
  "book": NSLocalizedString(
    "Book",
    comment: "Localized kind: Book"),
  "ebook": NSLocalizedString(
    "E-Book",
    comment: "Localized kind: E-Book"),
  "feature-movie": NSLocalizedString(
    "Movie",
    comment: "Localized kind: Feature Movie"),
  "music-video": NSLocalizedString(
    "Music Video",
    comment: "Localized kind: Music Video"),
  "podcast": NSLocalizedString(
    "Podcast",
    comment: "Localized kind: Podcast"),
  "software": NSLocalizedString(
    "App",
    comment: "Localized kind: Software"),
  "song": NSLocalizedString(
    "Song",
    comment: "Localized kind: Song"),
  "tv-episode": NSLocalizedString(
    "TV Episode",
    comment: "Localized kind: TV Episode")
]

class SearchResult: Codable, CustomStringConvertible {
  var artistName: String? = ""
  var trackName: String? = ""
  var kind: String? = ""
  var trackPrice: Double? = 0.0
  var currency = ""
  var imageSmall = ""
  var imageLarge = ""
  var trackViewUrl: String?
  var collectionName: String?
  var collectionViewUrl: String?
  var collectionPrice: Double?
  var itemPrice: Double?
  var itemGenre: String?
  var bookGenre: [String]?

  enum CodingKeys: String, CodingKey {
    case imageSmall = "artworkUrl60"
    case imageLarge = "artworkUrl100"
    case itemGenre = "primaryGenreName"
    case bookGenre = "genres"
    case itemPrice = "price"
    case kind, artistName, currency
    case trackName, trackPrice, trackViewUrl
    case collectionName, collectionViewUrl, collectionPrice
  }

  var name: String {
    return trackName ?? collectionName ?? ""
  }

  var storeURL: String {
    return trackViewUrl ?? collectionViewUrl ?? ""
  }

  var price: Double {
    return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
  }

  var genre: String {
    if let genre = itemGenre {
      return genre
    } else if let genres = bookGenre {
      return genres.joined(separator: ", ")
    }
    return ""
  }

  var type: String {
    let kind = self.kind ?? "audiobook"
    return typeForKind[kind] ?? kind
  }

  var artist: String {
    return artistName ?? ""
  }

  var description: String {
    return "\nResult - Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
  }
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
