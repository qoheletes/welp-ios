import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A template for Tests target",
  attributes: [
    nameAttribute
  ],
  items: [
    .file(
      path: "Projects/Feature/\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
      templatePath: "Tests.stencil",
    )
  ],
)
