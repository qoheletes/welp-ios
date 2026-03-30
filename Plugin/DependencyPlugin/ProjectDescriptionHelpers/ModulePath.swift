import ProjectDescription

extension ProjectDescription.Path {
  public static func relativeToFeature(_ path: String) -> Self {
    .relativeToRoot("Projects/Feature/\(path)")
  }

  public static func relativeToDomain(_ path: String) -> Self {
    .relativeToRoot("Projects/Domain/\(path)")
  }

  public static func relativeToData(_ path: String) -> Self {
    .relativeToRoot("Projects/Data/\(path)")
  }

  public static func relativeToCore(_ path: String) -> Self {
    .relativeToRoot("Projects/Core/\(path)")
  }

  public static func relativeToShared(_ path: String) -> Self {
    .relativeToRoot("Projects/Shared/\(path)")
  }
}
