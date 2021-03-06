import GraphQL

public final class Input<RootType : Keyable, Context, InputObjectType : Decodable & Keyable> : Component<RootType, Context> {
    let name: String?
    let fields: [InputFieldComponent<InputObjectType, InputObjectType.Keys, Context>]
    
    override func update(builder: SchemaBuilder) throws {
        let inputObjectType = try GraphQLInputObjectType(
            name: name ?? Reflection.name(for: InputObjectType.self),
            description: description,
            fields: fields(provider: builder)
        )
        
        try builder.map(InputObjectType.self, to: inputObjectType)
    }
    
    func fields(provider: TypeProvider) throws -> InputObjectConfigFieldMap {
        var map: InputObjectConfigFieldMap = [:]
        
        for field in fields {
            let (name, field) = try field.field(provider: provider)
            map[name] = field
        }
        
        return map
    }
    
    init(
        type: InputObjectType.Type,
        name: String?,
        fields: [InputFieldComponent<InputObjectType, InputObjectType.Keys, Context>]
    ) {
        self.name = name
        self.fields = fields
    }
}
