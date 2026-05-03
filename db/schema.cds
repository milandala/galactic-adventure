using {cuid} from '@sap/cds/common';

namespace galactic;

entity Spacefarers : cuid {
    @mandatory
    name                    : String;
    stardustCollection      : Integer;
    wormholeNavigationSkill : Integer;
    originPlanet            : Association to Planets;
    spacesuitColor          : String;

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
