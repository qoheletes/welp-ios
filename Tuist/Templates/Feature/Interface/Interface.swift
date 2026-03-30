import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A template for Interface target",
  attributes: [
    nameAttribute
  ],
  items: [
    .file(
      path: "Projects/Feature/\(nameAttribute)/Interface/Sources/\(nameAttribute)Interface.swift",
      templatePath: "Interface.stencil",
    )
  ],
)
