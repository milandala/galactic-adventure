annotate CosmicServiceAdmin.Departments with @(

    UI.HeaderInfo                   : {
        TypeName      : 'Department',
        TypeNamePlural: 'Departments'
    },

    UI.LineItem                     : [
        {Value: name},
        {Value: role}
    ],

    UI.SelectionFields              : [
        name,
        role
    ],

    UI.FieldGroup #DepartmentDetails: {
        Label: 'Department Details',
        Data : [
            {Value: name},
            {Value: role}
        ]
    },

    UI.Facets                       : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Department Details',
        Target: '@UI.FieldGroup#DepartmentDetails'
    }]
);

annotate CosmicServiceAdmin.Departments with @(Capabilities: {NavigationRestrictions: {
    $Type               : 'Capabilities.NavigationRestrictionsType',
    RestrictedProperties: [{
        $Type             : 'Capabilities.NavigationPropertyRestriction',
        NavigationProperty: DraftAdministrativeData,
        FilterRestrictions: {
            $Type     : 'Capabilities.FilterRestrictionsType',
            Filterable: false,
        },
    }, ],
}, });
