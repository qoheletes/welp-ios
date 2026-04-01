import ProjectDescription

// MARK: - ProjectEnvironment

public struct ProjectEnvironment {
  public let name: String
  public let organizationName: String
  public let deploymentTargets: DeploymentTargets
  public let destination: Set<Destination>
  public let baseSetting: SettingsDictionary
}

public let environment = ProjectEnvironment(
  name: "Welp",
  organizationName: "com.welp",
  deploymentTargets: .iOS("18.0"),
  destination: .iOS,
  baseSetting: [:],
)
