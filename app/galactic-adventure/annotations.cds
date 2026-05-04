annotate CosmicService.Spacefarers with @(


    UI.HeaderInfo               : {
        TypeName      : 'Spacefarer',
        TypeNamePlural: 'Spacefarers',
    },

    UI.LineItem                 : [
        {
            Value: name,
            Label: 'Name'
        },
        {
            Value: stardustCollection,
            Label: 'Stardust Collection'
        },
        {
            Value: spacesuitColor,
            Label: 'Spacesuit Color'
        },
        {
            Value: originPlanet_code,
            Label: 'Origin Planet'
        },
    ],

    UI.SelectionFields          : [
        stardustCollection,
        spacesuitColor
    ],

    UI.FieldGroup #CosmicDetails: {
        Label: 'Cosmic Details',
        Data : [
            {
                Value: name,
                Label: 'Name'
            },
            {
                Value: stardustCollection,
                Label: 'Stardust Collection'
            },
            {
                Value: spacesuitColor,
                Label: 'Spacesuit Color'
            },
            {
                Value: wormholeNavigationSkill,
                Label: 'Wormhole Skill'
            },
            {
                Value: originPlanet_code,
                Label: 'Origin Planet'
            },

            {
                Value: department_ID,
                Label: 'Department'
            },
        ]
    },

    UI.Facets                   : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Cosmic Details',
        Target: '@UI.FieldGroup#CosmicDetails'
    }]


);

annotate CosmicService.Spacefarers with {
    originPlanet   @Core.Immutable;

    department     @Common.ValueList: {
        CollectionPath: 'Departments',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: department_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'role'
            }
        ]
    };
    department_ID  @Common.Text: department.name  @UI.TextArrangement: #TextOnly;
}
