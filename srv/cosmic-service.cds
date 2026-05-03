using {galactic as db} from '../db/schema';

service CosmicService @(requires: 'authenticated-user') {

  @restrict: [{
    grant: [
      'CREATE',
      'READ',
      'UPDATE',
      'DELETE'
    ],
    where: 'originPlanet.code = $user.planetCode'
  }]
  entity Spacefarers as projection on db.Spacefarers;

  entity Departments as projection on db.Departments;
  entity Positions   as projection on db.Positions;
  entity Planets     as projection on db.Planets;

}
