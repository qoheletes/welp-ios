import ProjectDescription

extension TargetDependency {
  public static func feature(
    target: Module.Feature,
    type: TargetType = .sources,
  ) -> TargetDependency {
    .project(
      target: target.targetName(type: type),
      path: .relativeToFeature(target.rawValue),
    )
  }

  public static func domain(
    target: Module.Domain,
    type: TargetType = .sources,
  ) -> TargetDependency {
    .project(
      target: target.targetName(type: type),
      path: .relativeToDomain(target.rawValue),
    )
  }

  public static func data(
    target: Module.Data,
    type: TargetType = .sources,
  ) -> TargetDependency {
    .project(
      target: target.targetName(type: type),
      path: .relativeToData(target.rawValue),
    )
  }

  public static func core(
    target: Module.Core,
    type: TargetType = .sources,
  ) -> TargetDependency {
    .project(
      target: target.targetName(type: type),
      path: .relativeToCore(target.rawValue),
    )
  }

  public static func shared(
    target: Module.Shared,
    type: TargetType = .sources,
  ) -> TargetDependency {
    .project(
      target: target.targetName(type: type),
      path: .relativeToShared(target.rawValue),
    )
  }
}
