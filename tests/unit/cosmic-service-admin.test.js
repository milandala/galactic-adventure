const cds = require("@sap/cds");

cds.test(process.cwd());

describe("CosmicServiceAdmin", () => {
  let srv;

  beforeAll(async () => {
    srv = await cds.connect.to("CosmicServiceAdmin");
  });

  const adminUser = {
    user: new cds.User.Privileged({ id: "admin", roles: ["admin"] }),
  };

  it("Admin reads spacefarers from all planets", async () => {
    const result = await srv.tx(adminUser, (tx) => tx.read("Spacefarers"));
    expect(result.length).toBeGreaterThan(0);
    const planets = [...new Set(result.map((s) => s.originPlanet_code))];
    expect(planets.length).toBeGreaterThan(1);
  });

  it("Admin can create a spacefarer for EARTH", async () => {
    const newSpacefarer = {
      name: "EarthFarer",
      stardustCollection: 5,
      wormholeNavigationSkill: 5,
      spacesuitColor_code: "BLUE",
      originPlanet_code: "EARTH",
    };

    await expect(
      srv.tx(adminUser, (tx) =>
        tx.create("Spacefarers").entries(newSpacefarer),
      ),
    ).resolves.toBeDefined();
  });

  it("Admin can create a spacefarer for MARS", async () => {
    const newSpacefarer = {
      name: "MarsFarer",
      stardustCollection: 5,
      wormholeNavigationSkill: 5,
      spacesuitColor_code: "RED",
      originPlanet_code: "MARS",
    };

    await expect(
      srv.tx(adminUser, (tx) =>
        tx.create("Spacefarers").entries(newSpacefarer),
      ),
    ).resolves.toBeDefined();
  });

  it("Before handler enhances stardustCollection and wormholeNavigationSkill", async () => {
    const initialSkillLevel = 5;
    const newSpacefarer = {
      name: "EnhancedFarer",
      stardustCollection: initialSkillLevel,
      wormholeNavigationSkill: initialSkillLevel,
      spacesuitColor_code: "BLUE",
      originPlanet_code: "EARTH",
    };

    await srv.tx(adminUser, (tx) =>
      tx.create("Spacefarers").entries(newSpacefarer),
    );

    const result = await srv.tx(adminUser, (tx) =>
      tx.read("Spacefarers").where({ name: "EnhancedFarer" }),
    );

    expect(result[0].stardustCollection).toBeGreaterThan(initialSkillLevel);
    expect(result[0].wormholeNavigationSkill).toBeGreaterThan(
      initialSkillLevel,
    );
  });

  it("Before handler rejects spacefarer with negative stardustCollection", async () => {
    const invalidSpacefarer = {
      name: "BadFarer",
      stardustCollection: -1,
      wormholeNavigationSkill: 5,
      spacesuitColor_code: "RED",
      originPlanet_code: "EARTH",
    };

    await expect(
      srv.tx(adminUser, (tx) =>
        tx.create("Spacefarers").entries(invalidSpacefarer),
      ),
    ).rejects.toThrow();
  });

  it("Before handler rejects spacefarer with negative wormholeNavigationSkill", async () => {
    const invalidSpacefarer = {
      name: "BadFarer2",
      stardustCollection: 10,
      wormholeNavigationSkill: -1,
      spacesuitColor_code: "GREEN",
      originPlanet_code: "EARTH",
    };

    await expect(
      srv.tx(adminUser, (tx) =>
        tx.create("Spacefarers").entries(invalidSpacefarer),
      ),
    ).rejects.toThrow();
  });

  it("Admin can update any spacefarer regardless of planet", async () => {
    const marsSpacefarers = await srv.tx(adminUser, (tx) =>
      tx.read("Spacefarers").where({ originPlanet_code: "MARS" }),
    );
    expect(marsSpacefarers.length).toBeGreaterThan(0);

    const target = marsSpacefarers[0];
    await expect(
      srv.tx(adminUser, (tx) =>
        tx
          .update("Spacefarers")
          .set({ name: "UpdatedByAdmin" })
          .set({ stardustCollection: target.stardustCollection })
          .set({ wormholeNavigationSkill: target.wormholeNavigationSkill })
          .where({ ID: target.ID }),
      ),
    ).resolves.toBeDefined();
  });

  it("Admin can delete any spacefarer regardless of planet", async () => {
    const newSpacefarer = {
      name: "ToBeDeleted",
      stardustCollection: 5,
      wormholeNavigationSkill: 5,
      spacesuitColor_code: "BLUE",
      originPlanet_code: "MARS",
    };

    const created = await srv.tx(adminUser, (tx) =>
      tx.create("Spacefarers").entries(newSpacefarer),
    );

    await expect(
      srv.tx(adminUser, (tx) =>
        tx.delete("Spacefarers").where({ ID: created.ID }),
      ),
    ).resolves.toBeDefined();
  });
});
