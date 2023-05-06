//
//  NetworkManager.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getUserProfile(completion: @escaping (UserProfile) -> Void) {
        let url = "https://api.spotify.com/v1/me"
        AuthManager.shared.withValidToken { token in
            print("Token\(token)")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: UserProfile.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getNewReleases(completion: @escaping (NewReleases) -> Void) {
        let url = "https://api.spotify.com/v1/browse/new-releases"

        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: NewReleases.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getAlbumDetail(id: String, completion: @escaping (DetailedAlbum) -> Void) {
        let url = "https://api.spotify.com/v1/albums/\(id)"

        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: DetailedAlbum.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    
    func getFeaturePlaylist(completion: @escaping (FeaturePlaylist) -> Void) {
        let url = "https://api.spotify.com/v1/browse/featured-playlists"
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: FeaturePlaylist.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getDetailedPlaylist(id: String, completion: @escaping (Playlists) -> Void) {
        let url = "https://api.spotify.com/v1/playlists/\(id)/tracks"
        
        AuthManager.shared.withValidToken { token in
            print("Token\(token)")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: Playlists.self) { response in
                let result = response.result
                print(result)
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getCurrentUserPlaylists(completion: @escaping (LibraryPlaylist) -> Void) {
        let url = "https://api.spotify.com/v1/me/playlists"
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: LibraryPlaylist.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getUserSavedAlbum(completion: @escaping (LibraryAlbums) -> Void) {
        let url = "https://api.spotify.com/v1/me/albums"
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: LibraryAlbums.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func saveAlbum(album: DetailedAlbum, completion: @escaping (LibraryAlbums) -> Void) {
        let url = "https://api.spotify.com/v1/me/albums"
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            let parameters: Parameters = [
                "ids": ["\(album.id!)"]
            ]
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        print("Album added successfully!")
                    case let .failure(error):
                        print("Error adding album: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        let url = "https://api.spotify.com/v1/me"
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: UserProfile.self) { response in
                let result = response.result
                switch result {
                case .success(let profile):
                    let urlString = "https://api.spotify.com/v1/users/\(profile.id!)/playlists"
                    
                        let parameters: [String: Any] = ["name": name]
                        
                        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                            .validate(statusCode: 200..<300)
                            .responseDecodable(of: PlaylistItems.self) { response in
                                switch response.result {
                                case .success(let playlist):
                                    completion(true)
                                case .failure(let error):
                                    print(error.localizedDescription)
                                    completion(false)
                                }
                            }
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func addTrackToPlaylist(track: AudioTracks, playlist: PlaylistItems, completion: @escaping (Bool) -> Void) {
        let urlString = "https://api.spotify.com/v1/playlists/\(playlist.id!)/tracks"
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token), .contentType("application/json")]
            let parameters = [
                "uris": [
                "spotify:track:\(track.id!)"
                ]
            ]
            
            AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success:
                        completion(true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
        }
    }
    
    
    func getRecommendations(genres: Set<String>, completion: @escaping (Recommendations) -> Void) {
        let seeds = genres.joined(separator: ",")
        let url = "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=\(seeds)"
        
        AuthManager.shared.withValidToken { token in
//            print("Token\(token)")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: Recommendations.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getRecommendedGenres(completion: @escaping (RecommendedGenres) -> Void) {
        let url = "https://api.spotify.com/v1/recommendations/available-genre-seeds"
        
        AuthManager.shared.withValidToken { token in
//            print("Token\(token)")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: RecommendedGenres.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    func getRecommendedTracks(completion: @escaping (AudioTracks) -> Void) {
        let url = "https://api.spotify.com/v1/recommendations/available-genre-seeds"
        
        AuthManager.shared.withValidToken { token in
            print("Token\(token)")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: AudioTracks.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getCategories(completion: @escaping (CategoryResponse) -> Void) {
        let url = "https://api.spotify.com/v1/browse/categories"

        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: CategoryResponse.self) { response in
                let result = response.result

                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    func getCategoriesPlaylist(id: String, completion: @escaping (CategoryPlaylist) -> Void) {
        let url = "https://api.spotify.com/v1/browse/categories/\(id)/playlists"

        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: CategoryPlaylist.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }
    
    func getSearch(query: String, completion: @escaping (SearchResultResponse) -> Void) {
        let url = "https://api.spotify.com/v1/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers).responseDecodable(of: SearchResultResponse.self) { response in
                let result = response.result
                switch result {
                case .success(let type):
                    completion(type)
                case .failure(let error):
                    print(String(describing: error))
                }
            
            }
        }
    }

}
