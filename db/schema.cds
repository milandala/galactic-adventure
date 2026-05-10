using {cuid} from '@sap/cds/common';

namespace galactic;

entity Spacefarers : cuid {
    name                    : String @mandatory;
    stardustCollection      : Integer;
    wormholeNavigationSkill : Integer;
    originPlanet            : Association to Planets;
    spacesuitColor          : Association to SpacesuitColors;

    department              : Association to Departments;
    position                : Association to Positions;
}

entity Departments : cuid {
    name : String;
    role : String;
}

entity Positions : cuid {
    name         : String;
    gravityLevel : Integer;
}

entity Planets {
    key code        : String;
        name        : String;
        dangerLevel : Integer;
}

entity SpacesuitColors {
    key code : String;
        name : String;
}
