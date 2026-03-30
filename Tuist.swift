import ProjectDescription

let tuist = Tuist(
  project: .tuist(plugins: [
    .local(path: .relativeToRoot("Plugin/DependencyPlugin")),
    .local(path: .relativeToRoot("Plugin/EnvironmentPlugin")),
  ])
)
