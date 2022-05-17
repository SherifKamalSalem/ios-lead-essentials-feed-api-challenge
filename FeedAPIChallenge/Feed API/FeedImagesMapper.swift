//
//  FeedImagesMapper.swift
//  FeedAPIChallenge
//
//  Created by sherif kamal on 25/06/2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedImagesMapper {
	
	private struct Root: Decodable {
		let items: [Image]
		var feedImages: [FeedImage] {
			items.map({ $0.item })
		}
	}

	private struct Image: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL

		var item: FeedImage {
			return FeedImage(id: image_id, description: image_desc, location: image_loc, url: image_url)
		}
	}
	
	private init() {  }

	private static var ok_200: Int { return 200 }

	static func map(_ data: Data, _ response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == ok_200,
		      let items = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(items.feedImages)
	}
}
