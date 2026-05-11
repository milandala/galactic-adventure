using {galactic as db} from '../db/schema';

@requires: 'authenticated-user'
service CosmicService {

  @restrict       : [{
    grant: [
      'READ',
      'CREATE',
      'UPDATE',
      'DELETE'
    ],
    where: 'originPlanet.code = $user.planetCode'
  }]
  @cds.query.limit: {
    default: 10,
    max    : 20
  }
  @odata.draft.enabled
  entity Spacefarers     as projection on db.Spacefarers;

  @readonly
  entity Departments     as projection on db.Departments;

  @readonly
  entity Positions       as projection on db.Positions;

  @readonly
  entity Planets         as projection on db.Planets;

  @readonly
  entity SpacesuitColors as projection on db.SpacesuitColors;
}
