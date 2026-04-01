import EnvironmentPlugin
import ProjectDescription

let workspace = Workspace(
  name: environment.name,
  projects: [
    "Projects/**"
  ],
)
