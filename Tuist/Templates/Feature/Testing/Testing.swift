import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A template for Testing target",
  attributes: [
    nameAttribute
  ],
  items: [
    .file(
      path: "Projects/Feature/\(nameAttribute)/Testing/Sources/\(nameAttribute)Testing.swift",
      templatePath: "Testing.stencil",
    )
  ],
)
