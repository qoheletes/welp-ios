import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A template for Feature",
  attributes: [
    nameAttribute
  ],
  items: [
    // MARK: - Project

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Project.swift",
      templatePath: "Project.stencil",
    ),

    // MARK: - Scene

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Sources/Presentatin/\(nameAttribute)ViewController.swift",
      templatePath: "Sources/Implement.stencil",
    ),

    // MARK: - Coordinator

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Sources/Coodinator/\(nameAttribute)Coordinator.swift",
      templatePath: "Sources/CoordinatorTemplate.stencil",
    ),

    // MARK: - Router

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Sources/Router/\(nameAttribute)Router.swift",
      templatePath: "Sources/Router.stencil",
    ),

    // MARK: - Assembly

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Sources/Assembly/\(nameAttribute)Assembly.swift",
      templatePath: "Sources/Assembly.stencil",
    ),

    // MARK: - Demo

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Demo/Sources/AppDelegate.swift",
      templatePath: "Demo/Demo.stencil",
    ),

    // MARK: - Interface

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Interface/\(nameAttribute)Factory.swift",
      templatePath: "Interface/Interface.stencil",
    ),

    // MARK: - Testing

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Testing/Mock\(nameAttribute)Repository.swift",
      templatePath: "Testing/Testing.stencil",
    ),

    // MARK: - Tests

    .file(
      path: "Projects/Feature/\(nameAttribute)Feature/Tests/\(nameAttribute)Tests.swift",
      templatePath: "Tests/Tests.stencil",
    ),
  ],
)
