struct RaywenderlichCourse: Decodable, Equatable {
    let data: [Data]

    struct Data: Decodable, Equatable {
        let attributes: Attributes
    }

    struct Attributes: Decodable, Equatable {
        let name: String
    }
}
